// Automatic FlutterFlow imports
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:path_provider/path_provider.dart';

Future<void> runBeforeStartChecklist() async {
  final String apiKey =
      "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";
  final FlutterTts flutterTts = FlutterTts();
  final RecorderController recorderController = RecorderController();

  // === [ التعديل الأول: تهيئة مسار الصوت الخاص بـ iOS ] ===
  if (Platform.isIOS) {
    await flutterTts.setSharedInstance(true);
    await flutterTts.setIosAudioCategory(
      IosTextToSpeechAudioCategory
          .playAndRecord, // إجبار النظام على السماح بالمايك والسماعة معاً
      [
        IosTextToSpeechAudioCategoryOptions.allowBluetooth,
        IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
        IosTextToSpeechAudioCategoryOptions.mixWithOthers,
        IosTextToSpeechAudioCategoryOptions
            .defaultToSpeaker // إخراج الصوت من المكبر الرئيسي وليس سماعة الأذن
      ],
      IosTextToSpeechAudioMode.defaultMode,
    );
  }

  // إعدادات الصوت الاحترافية
  await flutterTts.setLanguage("en-US");
  await flutterTts.setSpeechRate(0.45);
  await flutterTts.awaitSpeakCompletion(true); // استنى لما تخلص كلامك خالص

  // === [ التعديل الثاني: التحقق الإجباري من المايك لتهيئة الـ Controller في iOS ] ===
  final hasPermission = await recorderController.checkPermission();
  if (!hasPermission) {
    debugPrint("Microphone permission denied");
    return; // إيقاف الكود لو المايك مش شغال لتجنب الـ Crash
  }

  // قائمة Before Start
  List<Map<String, String>> checklist = [
    {'q': 'PARKING BRAKE', 'a': 'set'},
    {'q': 'TAKE OFF SPEEDS and THRUST', 'a': 'set|checked'},
    {'q': 'WINDOWS', 'a': 'closed'},
    {'q': 'BEACON', 'a': 'on'},
  ];

  // البداية
  await flutterTts.speak("BEFORE START CHECK LIST");

  for (var step in checklist) {
    bool confirmed = false;
    while (!confirmed) {
      // 1. ينطق السؤال ويستنى لما يخلص تماماً
      await flutterTts.speak(step['q']!);

      // 2. فاصـل أمان 800 مللي ثانية (تمت الزيادة قليلاً لتسمح للأيفون بفتح قناة المايك)
      await Future.delayed(const Duration(milliseconds: 800));

      // 3. نجهز ملف التسجيل
      final dir = await getTemporaryDirectory();
      final path =
          '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

      // 4. ابدأ سجل رد المستخدم لمدة 3 ثواني
      await recorderController.record(path: path);
      await Future.delayed(const Duration(seconds: 3));
      final audioPath = await recorderController.stop();

      if (audioPath != null) {
        // === [ التعديل الثالث: التأكد من أن الملف ليس فارغاً (حماية إضافية لـ iOS) ] ===
        final file = File(audioPath);
        if (await file.exists() && await file.length() > 0) {
          // 5. تحليل الصوت باستخدام Groq والقاموس الذكي
          String result = await transcribeWithGroq(audioPath, apiKey);

          // التحقق من الرد (يدعم الردود المتعددة)
          List<String> validAnswers = step['a']!.split('|');
          if (validAnswers.any((ans) => result.contains(ans))) {
            confirmed = true;
            await flutterTts.speak("Checked");
            // فاصل زمني صغير قبل السؤال التالي لمنع تداخل الصوت
            await Future.delayed(const Duration(milliseconds: 500));
          }
        }
      }
    }
  }

  // النهاية - تم التأكد من النص
  await flutterTts.speak("BEFORE START CHECK LIST COMPLETED");
}

Future<String> transcribeWithGroq(String audioPath, String apiKey) async {
  try {
    var request = http.MultipartRequest('POST',
        Uri.parse('https://api.groq.com/openai/v1/audio/transcriptions'));
    request.headers['Authorization'] = 'Bearer $apiKey';
    request.files.add(await http.MultipartFile.fromPath('file', audioPath));
    request.fields['model'] = 'whisper-large-v3';
    request.fields['language'] = 'en';
    request.fields['temperature'] = '0';
    request.fields['prompt'] =
        'Aviation checklist commands: removed, on, nav, both, closed, checked, neutral, on and auto, no blue, off, set.';

    var response = await request.send();
    var responseData = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      String rawText =
          jsonDecode(responseData)['text'].toString().toLowerCase().trim();
      String cleanText = rawText.replaceAll(RegExp(r'[^\w\s]'), '');

      // القاموس الذكي الثابت
      Map<String, List<String>> dictionary = {
        'on and auto': ['on and auto', 'on & auto', 'on auto', 'and auto'],
        'no blue': ['no blue', 'not blue', 'now blue'],
        'removed': ['removed', 'remove', 'removes'],
        'nav': ['nav', 'navigation'],
        'both': ['both', 'boat', 'boss', 'pause'],
        'closed': ['closed', 'close'],
        'checked': ['checked', 'check', 'verified', 'verify'],
        'neutral': ['neutral', 'natural', 'nitro'],
        'off': ['off', 'of', 'half', 'up', 'cough'],
        'set': ['set', 'sit', 'sat', 'said', 'stay'],
        'on': ['on', 'own']
      };

      for (var entry in dictionary.entries) {
        for (var alias in entry.value) {
          if (cleanText.contains(alias)) return entry.key;
        }
      }
      return cleanText;
    }
  } catch (e) {
    debugPrint("Error: $e");
  }
  return "";
}

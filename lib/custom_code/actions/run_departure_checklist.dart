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

Future<void> runDepartureChecklist() async {
  final String apiKey =
      "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";
  final FlutterTts flutterTts = FlutterTts();
  final RecorderController recorderController = RecorderController();

  // إعدادات الصوت الاحترافية
  await flutterTts.setLanguage("en-US");
  await flutterTts.setSpeechRate(0.45);
  await flutterTts.awaitSpeakCompletion(true); // استنى لما تخلص كلامك خالص

  // قائمة المهام لمرحلة DEPARTURE
  List<Map<String, String>> checklist = [
    {'q': 'RUNWAY AND SID', 'a': 'set|checked'},
    {
      'q': 'FLAPS SETTING',
      'a': '1|one|2|two|3|three|set'
    }, // قبول الأرقام والكلمات
    {'q': 'TAKE OFF SPEEDS AND THRUST', 'a': 'set|checked'},
    {'q': 'FCU ALTITUDE', 'a': 'set|checked'},
  ];

  // البداية
  await flutterTts.speak("DEPARTURE CHECK LIST");

  for (var step in checklist) {
    bool confirmed = false;
    while (!confirmed) {
      // 1. ينطق السؤال ويستنى لما يخلص تماماً
      await flutterTts.speak(step['q']!);

      // 2. فاصـل أمان 600 مللي ثانية
      await Future.delayed(const Duration(milliseconds: 600));

      // 3. نجهز ملف التسجيل
      final dir = await getTemporaryDirectory();
      final path =
          '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

      // 4. ابدأ سجل رد المستخدم لمدة 3 ثواني
      await recorderController.record(path: path);
      await Future.delayed(const Duration(seconds: 3));
      final audioPath = await recorderController.stop();

      if (audioPath != null) {
        // 5. تحليل الصوت باستخدام Groq والقاموس الذكي المحدث
        String result = await transcribeWithGroq(audioPath, apiKey);

        // التحقق من الرد (يدعم الردود المتعددة)
        List<String> validAnswers = step['a']!.split('|');
        if (validAnswers.any((ans) => result.contains(ans))) {
          confirmed = true;
          await flutterTts.speak("Checked");
        }
      }
    }
  }

  // النهاية
  await flutterTts.speak("DEPARTURE CHECK LIST COMPLETED");
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
        'Aviation checklist commands: set, checked, one, two, three, 1, 2, 3, removed, on, off.';

    var response = await request.send();
    var responseData = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      String rawText =
          jsonDecode(responseData)['text'].toString().toLowerCase().trim();
      String cleanText = rawText.replaceAll(RegExp(r'[^\w\s]'), '');

      // القاموس الذكي المحدث لدعم الأرقام
      Map<String, List<String>> dictionary = {
        '1': ['1', 'one', 'van', 'won'],
        '2': ['2', 'two', 'to', 'too'],
        '3': ['3', 'three', 'tree'],
        'set': ['set', 'sit', 'sat'],
        'checked': ['checked', 'check', 'verified'],
        'on': ['on', 'own'],
        'off': ['off', 'of'],
        'both': ['both', 'pause']
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

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

Future<void> runApproachChecklist() async {
  final String apiKey =
      "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";
  final FlutterTts flutterTts = FlutterTts();
  final RecorderController recorderController = RecorderController();

  // إعدادات الصوت الاحترافية
  await flutterTts.setLanguage("en-US");
  await flutterTts.setSpeechRate(0.45);
  await flutterTts.awaitSpeakCompletion(true); // استنى لما يخلص كلامه خالص

  // قائمة المهام لمرحلة APPROACH
  List<Map<String, String>> checklist = [
    {'q': 'BARO REFERENCE', 'a': 'set'},
    {'q': 'SEAT BELTS', 'a': 'on'},
    {'q': 'MINIMUM', 'a': 'set|checked'},
    {'q': 'AUTO BRAKE', 'a': 'set|low|medium'}, // قبول الدرجات المختلفة
    {'q': 'ENG MODE SELECTOR', 'a': 'normal|ignition'}, // قبول الحالتين
  ];

  // البداية
  await flutterTts.speak("APPROACH CHECK LIST");

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
  await flutterTts.speak("APPROACH CHECK LIST COMPLETED");
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
        'Aviation checklist commands: set, on, checked, low, medium, normal, ignition, both, off.';

    var response = await request.send();
    var responseData = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      String rawText =
          jsonDecode(responseData)['text'].toString().toLowerCase().trim();
      String cleanText = rawText.replaceAll(RegExp(r'[^\w\s]'), '');

      // القاموس الذكي المحدث لدعم كلمات الـ Approach
      Map<String, List<String>> dictionary = {
        'set': ['set', 'sit', 'sat'],
        'on': ['on', 'own'],
        'checked': ['checked', 'check', 'verified'],
        'low': ['low', 'law', 'lo'],
        'medium': ['medium', 'med', 'mid'],
        'normal': ['normal', 'norm'],
        'ignition': ['ignition', 'ignite', 'egnishon'],
        'both': ['both', 'pause'],
        'off': ['off', 'of']
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

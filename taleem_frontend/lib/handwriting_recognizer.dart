import 'dart:ui';

import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';

class RecognitionOutput {
  final String predicted;
  final double confidence;
  final bool isCorrect;
  final String? error;

  RecognitionOutput({
    required this.predicted,
    required this.confidence,
    required this.isCorrect,
    this.error,
  });

  factory RecognitionOutput.empty(String error) =>
      RecognitionOutput(predicted: '', confidence: 0, isCorrect: false, error: error);
}

class HandwritingRecognizer {
  static final DigitalInkRecognizerModelManager _modelManager =
      DigitalInkRecognizerModelManager();
  static final Map<String, DigitalInkRecognizer> _recognizers = {};
  static final Set<String> _ready = {};

  static Future<void> ensureModel(String languageCode) async {
    if (_ready.contains(languageCode)) return;
    final downloaded = await _modelManager.isModelDownloaded(languageCode);
    if (!downloaded) {
      await _modelManager.downloadModel(languageCode);
    }
    _ready.add(languageCode);
  }

  static DigitalInkRecognizer _recognizerFor(String languageCode) {
    return _recognizers.putIfAbsent(
      languageCode,
      () => DigitalInkRecognizer(languageCode: languageCode),
    );
  }

  static Future<RecognitionOutput> recognize({
    required String languageCode,
    required List<List<Offset>> strokes,
    required List<List<int>> strokeTimes,
    required String target,
  }) async {
    final hasInk = strokes.isNotEmpty && strokes.any((s) => s.length > 4);
    if (!hasInk) {
      return RecognitionOutput.empty('no_ink');
    }

    try {
      await ensureModel(languageCode);
      final recognizer = _recognizerFor(languageCode);

      final ink = Ink();
      for (int i = 0; i < strokes.length; i++) {
        final stroke = Stroke();
        for (int j = 0; j < strokes[i].length; j++) {
          stroke.points.add(StrokePoint(
            x: strokes[i][j].dx,
            y: strokes[i][j].dy,
            t: j < strokeTimes[i].length ? strokeTimes[i][j] : 0,
          ));
        }
        ink.strokes.add(stroke);
      }

      final candidates = await recognizer.recognize(ink);
      if (candidates.isEmpty) {
        return RecognitionOutput.empty('no_candidates');
      }

      final top = candidates.first;
      final predicted = top.text.trim();
      final targetNorm = target.trim().toLowerCase();
      final isCorrect = predicted.toLowerCase() == targetNorm;

      double confidence;
      if (isCorrect) {
        confidence = 0.9;
      } else {
        for (final c in candidates.take(5)) {
          if (c.text.trim().toLowerCase() == targetNorm) {
            return RecognitionOutput(
              predicted: predicted,
              confidence: 0.85,
              isCorrect: true,
            );
          }
        }
        confidence = 0.3;
      }

      return RecognitionOutput(
        predicted: predicted,
        confidence: confidence,
        isCorrect: isCorrect,
      );
    } catch (e) {
      return RecognitionOutput.empty(e.toString());
    }
  }

  static Future<void> disposeAll() async {
    for (final r in _recognizers.values) {
      await r.close();
    }
    _recognizers.clear();
    _ready.clear();
  }
}

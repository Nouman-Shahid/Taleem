import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final FlutterTts _tts = FlutterTts();
  static bool _ready = false;

  /// Lowercased list of language tags the device TTS engine supports
  /// (e.g. 'ur-pk', 'en-us'). Populated once on first use.
  static List<String> _available = const [];

  /// Preferred language tags per app language code, in priority order.
  static const Map<String, List<String>> _candidates = {
    'ur': ['ur-PK', 'ur-IN', 'ur'],
    'en': ['en-US', 'en-GB', 'en'],
  };

  static Future<void> _init() async {
    if (_ready) return;
    await _tts.awaitSpeakCompletion(true);
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);
    try {
      final langs = await _tts.getLanguages;
      if (langs is List) {
        _available =
            langs.map((e) => e.toString().toLowerCase()).toList(growable: false);
      }
    } catch (_) {
      _available = const [];
    }
    _ready = true;
  }

  /// Resolves the best supported language tag for [languageCode].
  /// Returns null when the device has no matching voice installed.
  static String? _resolve(String languageCode) {
    final wants = _candidates[languageCode] ?? _candidates['en']!;
    if (_available.isEmpty) {
      // Engine didn't report a list — optimistically use the first candidate.
      return wants.first;
    }
    for (final tag in wants) {
      final lower = tag.toLowerCase();
      // Exact match, or a regional variant of the base language (e.g. 'ur-pk').
      final hit = _available.firstWhere(
        (a) => a == lower || a.startsWith('$lower-') || a.startsWith('${lower}_'),
        orElse: () => '',
      );
      if (hit.isNotEmpty) return hit;
    }
    return null;
  }

  /// Speaks [text] in the given app language code ('en' or 'ur').
  /// Returns true if a suitable voice was found and speech was started.
  static Future<bool> speak(String text, {String languageCode = 'en'}) async {
    if (text.trim().isEmpty) return false;
    await _init();
    final lang = _resolve(languageCode);
    if (lang == null) {
      debugPrint('[TtsService] No voice installed for "$languageCode". '
          'Available: $_available');
      return false;
    }
    try {
      await _tts.stop();
      await _tts.setLanguage(lang);
      await _tts.speak(text);
      return true;
    } catch (e) {
      debugPrint('[TtsService] speak failed: $e');
      return false;
    }
  }

  /// Whether the device has a voice for the given app language code.
  static Future<bool> isAvailable(String languageCode) async {
    await _init();
    return _resolve(languageCode) != null;
  }

  static Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }
}

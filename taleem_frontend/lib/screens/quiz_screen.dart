import 'dart:math';

import 'package:flutter/material.dart';
import '../handwriting_recognizer.dart';
import '../services/imla_service.dart';
import '../services/progress_service.dart';
import '../state/app_session.dart';
import '../theme.dart';
import '../widgets/result_dialog.dart';
import 'quiz_result_screen.dart';

class QuizScreen extends StatefulWidget {
  final String quizKey;
  final String quizTitle;
  final String mode; // 'drawing' or 'mcq'
  final int questionCount;

  const QuizScreen({
    super.key,
    required this.quizKey,
    required this.quizTitle,
    required this.mode,
    required this.questionCount,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _index = 0;
  int _correctCount = 0;

  late List<String> _drawRound;
  late List<Map<String, dynamic>> _mcqRound;

  final List<List<Offset>> _strokes = [];
  final List<List<int>> _strokeTimes = [];
  int _inkStart = 0;
  bool _isChecking = false;

  int? _selectedOption;
  bool _checked = false;

  static const Map<String, List<String>> _drawPool = {
    'counting': [
      '1','2','3','4','5','6','7','8','9','10',
      '11','12','13','14','15','16','17','18','19','20',
      '21','22','23','24','25',
    ],
    'english_alphabet': [
      'A','B','C','D','E','F','G','H','I','J','K','L','M',
      'N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
    ],
    'urdu_alphabet': [
      'ا','ب','پ','ت','ٹ','ث','ج','چ','ح','خ','د','ڈ','ذ',
      'ر','ڑ','ز','ژ','س','ش','ص','ض','ط','ظ','ع','غ','ف',
    ],
    'english_vowels': ['A', 'E', 'I', 'O', 'U'],
  };

  static final Map<String, List<Map<String, dynamic>>> _mcqPool = {
    'counting': [
      {'visual': '🍎', 'prompt': 'How many apples?', 'options': ['1','2','3','4'], 'answer': 0},
      {'visual': '⭐⭐', 'prompt': 'How many stars?', 'options': ['1','2','3','4'], 'answer': 1},
      {'visual': '🌙🌙🌙', 'prompt': 'How many moons?', 'options': ['2','3','4','5'], 'answer': 1},
      {'visual': '🎈🎈🎈🎈', 'prompt': 'How many balloons?', 'options': ['3','4','5','6'], 'answer': 1},
      {'visual': '🍓🍓🍓🍓🍓', 'prompt': 'How many berries?', 'options': ['4','5','6','7'], 'answer': 1},
      {'visual': '🍌🍌', 'prompt': 'How many bananas?', 'options': ['1','2','3','4'], 'answer': 1},
      {'visual': '🐱🐱🐱', 'prompt': 'How many cats?', 'options': ['2','3','4','5'], 'answer': 1},
      {'visual': '🐶🐶🐶🐶', 'prompt': 'How many dogs?', 'options': ['3','4','5','6'], 'answer': 1},
      {'visual': '🌸🌸🌸🌸🌸🌸', 'prompt': 'How many flowers?', 'options': ['5','6','7','8'], 'answer': 1},
      {'visual': '🍇', 'prompt': 'How many grape clusters?', 'options': ['1','2','3','4'], 'answer': 0},
      {'visual': '⚽⚽', 'prompt': 'How many balls?', 'options': ['1','2','3','4'], 'answer': 1},
      {'visual': '🚗🚗🚗', 'prompt': 'How many cars?', 'options': ['2','3','4','5'], 'answer': 1},
      {'visual': '🦋🦋🦋🦋', 'prompt': 'How many butterflies?', 'options': ['3','4','5','6'], 'answer': 1},
      {'visual': '🍩🍩🍩🍩🍩', 'prompt': 'How many donuts?', 'options': ['4','5','6','7'], 'answer': 1},
      {'visual': null, 'prompt': 'What number comes after 4?', 'options': ['3','5','6','7'], 'answer': 1},
      {'visual': null, 'prompt': 'What number comes before 8?', 'options': ['6','7','9','10'], 'answer': 1},
      {'visual': null, 'prompt': 'Which number is "Five"?', 'options': ['3','4','5','6'], 'answer': 2},
      {'visual': null, 'prompt': 'Which number is "Ten"?', 'options': ['8','9','10','11'], 'answer': 2},
      {'visual': null, 'prompt': '2 + 3 = ?', 'options': ['4','5','6','7'], 'answer': 1},
      {'visual': null, 'prompt': '6 - 2 = ?', 'options': ['3','4','5','6'], 'answer': 1},
      {'visual': null, 'prompt': '1 + 1 = ?', 'options': ['1','2','3','4'], 'answer': 1},
      {'visual': null, 'prompt': '4 + 4 = ?', 'options': ['6','7','8','9'], 'answer': 2},
      {'visual': '🐠🐠🐠🐠🐠🐠🐠', 'prompt': 'How many fish?', 'options': ['5','6','7','8'], 'answer': 2},
      {'visual': '🥭', 'prompt': 'How many mangoes?', 'options': ['1','2','3','4'], 'answer': 0},
      {'visual': '☀️☀️', 'prompt': 'How many suns?', 'options': ['1','2','3','4'], 'answer': 1},
    ],
    'english_alphabet': [
      {'visual': '🍎', 'prompt': 'What is this?', 'options': ['Apple','Banana','Cat','Dog'], 'answer': 0},
      {'visual': '🍌', 'prompt': 'What is this?', 'options': ['Apple','Banana','Cat','Dog'], 'answer': 1},
      {'visual': '🐱', 'prompt': 'What is this?', 'options': ['Apple','Cat','Dog','Elephant'], 'answer': 1},
      {'visual': '🐶', 'prompt': 'What is this?', 'options': ['Banana','Cat','Dog','Elephant'], 'answer': 2},
      {'visual': '🐘', 'prompt': 'What is this?', 'options': ['Cat','Dog','Elephant','Fish'], 'answer': 2},
      {'visual': '🐟', 'prompt': 'What is this?', 'options': ['Dog','Elephant','Fish','Grapes'], 'answer': 2},
      {'visual': '🍇', 'prompt': 'What is this?', 'options': ['Fish','Grapes','Hat','Jug'], 'answer': 1},
      {'visual': '🎩', 'prompt': 'What is this?', 'options': ['Grapes','Hat','Jug','Kite'], 'answer': 1},
      {'visual': '🏺', 'prompt': 'What is this?', 'options': ['Hat','Jug','Kite','Lion'], 'answer': 1},
      {'visual': '🪁', 'prompt': 'What is this?', 'options': ['Jug','Kite','Lion','Mango'], 'answer': 1},
      {'visual': '🦁', 'prompt': 'What is this?', 'options': ['Kite','Lion','Mango','Orange'], 'answer': 1},
      {'visual': '🥭', 'prompt': 'What is this?', 'options': ['Lion','Mango','Orange','Pencil'], 'answer': 1},
      {'visual': '🍊', 'prompt': 'What is this?', 'options': ['Mango','Orange','Pencil','Queen'], 'answer': 1},
      {'visual': '✏️', 'prompt': 'What is this?', 'options': ['Orange','Pencil','Rabbit','Sun'], 'answer': 1},
      {'visual': '👸', 'prompt': 'What is this?', 'options': ['Pencil','Queen','Rabbit','Sun'], 'answer': 1},
      {'visual': '🐰', 'prompt': 'What is this?', 'options': ['Queen','Rabbit','Sun','Tree'], 'answer': 1},
      {'visual': '☀️', 'prompt': 'What is this?', 'options': ['Rabbit','Sun','Tree','Umbrella'], 'answer': 1},
      {'visual': '🌳', 'prompt': 'What is this?', 'options': ['Sun','Tree','Umbrella','Van'], 'answer': 1},
      {'visual': '☂️', 'prompt': 'What is this?', 'options': ['Tree','Umbrella','Van','Watermelon'], 'answer': 1},
      {'visual': '🚐', 'prompt': 'What is this?', 'options': ['Umbrella','Van','Watermelon','Zebra'], 'answer': 1},
      {'visual': '🍉', 'prompt': 'What is this?', 'options': ['Van','Watermelon','Zebra','Apple'], 'answer': 1},
      {'visual': '🦓', 'prompt': 'What is this?', 'options': ['Watermelon','Apple','Zebra','Tree'], 'answer': 2},
      {'visual': '🐴', 'prompt': 'What is this?', 'options': ['Cat','Horse','Lion','Tiger'], 'answer': 1},
      {'visual': '🐯', 'prompt': 'What is this?', 'options': ['Cat','Horse','Lion','Tiger'], 'answer': 3},
      {'visual': '🐮', 'prompt': 'What is this?', 'options': ['Cow','Goat','Sheep','Pig'], 'answer': 0},
    ],
    'urdu_alphabet': [
      {'visual': '🍎', 'prompt': 'یہ کیا ہے؟', 'options': ['سیب','کیلا','بلی','کتا'], 'answer': 0},
      {'visual': '🍌', 'prompt': 'یہ کیا ہے؟', 'options': ['سیب','کیلا','بلی','کتا'], 'answer': 1},
      {'visual': '🐱', 'prompt': 'یہ کیا ہے؟', 'options': ['سیب','کیلا','بلی','کتا'], 'answer': 2},
      {'visual': '🐶', 'prompt': 'یہ کیا ہے؟', 'options': ['سیب','کیلا','بلی','کتا'], 'answer': 3},
      {'visual': '🐘', 'prompt': 'یہ کیا ہے؟', 'options': ['ہاتھی','مچھلی','شیر','گھوڑا'], 'answer': 0},
      {'visual': '🐟', 'prompt': 'یہ کیا ہے؟', 'options': ['ہاتھی','مچھلی','شیر','گھوڑا'], 'answer': 1},
      {'visual': '🦁', 'prompt': 'یہ کیا ہے؟', 'options': ['ہاتھی','مچھلی','شیر','گھوڑا'], 'answer': 2},
      {'visual': '🐴', 'prompt': 'یہ کیا ہے؟', 'options': ['ہاتھی','مچھلی','شیر','گھوڑا'], 'answer': 3},
      {'visual': '🥭', 'prompt': 'یہ کیا ہے؟', 'options': ['آم','انگور','سنترا','تربوز'], 'answer': 0},
      {'visual': '🍇', 'prompt': 'یہ کیا ہے؟', 'options': ['آم','انگور','سنترا','تربوز'], 'answer': 1},
      {'visual': '🍊', 'prompt': 'یہ کیا ہے؟', 'options': ['آم','انگور','سنترا','تربوز'], 'answer': 2},
      {'visual': '🍉', 'prompt': 'یہ کیا ہے؟', 'options': ['آم','انگور','سنترا','تربوز'], 'answer': 3},
      {'visual': '✏️', 'prompt': 'یہ کیا ہے؟', 'options': ['پنسل','کتاب','کرسی','میز'], 'answer': 0},
      {'visual': '📖', 'prompt': 'یہ کیا ہے؟', 'options': ['پنسل','کتاب','کرسی','میز'], 'answer': 1},
      {'visual': '🪑', 'prompt': 'یہ کیا ہے؟', 'options': ['پنسل','کتاب','کرسی','میز'], 'answer': 2},
      {'visual': '🍽️', 'prompt': 'یہ کیا ہے؟', 'options': ['پنسل','کتاب','کرسی','میز'], 'answer': 3},
      {'visual': '🎩', 'prompt': 'یہ کیا ہے؟', 'options': ['ٹوپی','چابی','جوتا','پھول'], 'answer': 0},
      {'visual': '🔑', 'prompt': 'یہ کیا ہے؟', 'options': ['ٹوپی','چابی','جوتا','پھول'], 'answer': 1},
      {'visual': '👟', 'prompt': 'یہ کیا ہے؟', 'options': ['ٹوپی','چابی','جوتا','پھول'], 'answer': 2},
      {'visual': '🌸', 'prompt': 'یہ کیا ہے؟', 'options': ['ٹوپی','چابی','جوتا','پھول'], 'answer': 3},
      {'visual': '🏠', 'prompt': 'یہ کیا ہے؟', 'options': ['گھر','دروازہ','گاڑی','گھڑی'], 'answer': 0},
      {'visual': '🚪', 'prompt': 'یہ کیا ہے؟', 'options': ['گھر','دروازہ','گاڑی','گھڑی'], 'answer': 1},
      {'visual': '🚗', 'prompt': 'یہ کیا ہے؟', 'options': ['گھر','دروازہ','گاڑی','گھڑی'], 'answer': 2},
      {'visual': '🕐', 'prompt': 'یہ کیا ہے؟', 'options': ['گھر','دروازہ','گاڑی','گھڑی'], 'answer': 3},
      {'visual': '🌳', 'prompt': 'یہ کیا ہے؟', 'options': ['درخت','پھول','گائے','بکری'], 'answer': 0},
      {'visual': '🍎', 'prompt': 'سیب کس حرف سے شروع ہوتا ہے؟', 'options': ['س','ب','ک','ا'], 'answer': 0},
      {'visual': '🍌', 'prompt': 'کیلا کس حرف سے شروع ہوتا ہے؟', 'options': ['ک','پ','ب','ت'], 'answer': 0},
      {'visual': '🐱', 'prompt': 'بلی کس حرف سے شروع ہوتا ہے؟', 'options': ['پ','ب','ت','ٹ'], 'answer': 1},
      {'visual': '🐶', 'prompt': 'کتا کس حرف سے شروع ہوتا ہے؟', 'options': ['گ','ک','ج','چ'], 'answer': 1},
      {'visual': '🐘', 'prompt': 'ہاتھی کس حرف سے شروع ہوتا ہے؟', 'options': ['ح','ہ','خ','ع'], 'answer': 1},
      {'visual': '🦁', 'prompt': 'شیر کس حرف سے شروع ہوتا ہے؟', 'options': ['س','ص','ش','ث'], 'answer': 2},
      {'visual': '🥭', 'prompt': 'آم کس حرف سے شروع ہوتا ہے؟', 'options': ['ا','ب','پ','ت'], 'answer': 0},
      {'visual': '🍉', 'prompt': 'تربوز کس حرف سے شروع ہوتا ہے؟', 'options': ['پ','ب','ٹ','ت'], 'answer': 3},
      {'visual': '✏️', 'prompt': 'پنسل کس حرف سے شروع ہوتا ہے؟', 'options': ['ب','پ','ت','ٹ'], 'answer': 1},
      {'visual': '📖', 'prompt': 'کتاب کس حرف سے شروع ہوتا ہے؟', 'options': ['گ','ک','ج','چ'], 'answer': 1},
      {'visual': '🏠', 'prompt': 'گھر کس حرف سے شروع ہوتا ہے؟', 'options': ['ج','چ','گ','ک'], 'answer': 2},
      {'visual': '🌳', 'prompt': 'درخت کس حرف سے شروع ہوتا ہے؟', 'options': ['ڈ','ذ','ر','د'], 'answer': 3},
      {'visual': '🎈', 'prompt': 'غبارہ کس حرف سے شروع ہوتا ہے؟', 'options': ['ف','ق','غ','ع'], 'answer': 2},
      {'visual': '🦜', 'prompt': 'طوطا کس حرف سے شروع ہوتا ہے؟', 'options': ['ت','ٹ','ط','ث'], 'answer': 2},
      {'visual': '🐰', 'prompt': 'خرگوش کس حرف سے شروع ہوتا ہے؟', 'options': ['ک','خ','ح','چ'], 'answer': 1},
      {'visual': '🌙', 'prompt': 'چاند کس حرف سے شروع ہوتا ہے؟', 'options': ['ج','چ','ح','ث'], 'answer': 1},
      {'visual': '🐒', 'prompt': 'بندر کس حرف سے شروع ہوتا ہے؟', 'options': ['پ','ب','ت','ٹ'], 'answer': 1},
      {'visual': '🦋', 'prompt': 'تتلی کس حرف سے شروع ہوتا ہے؟', 'options': ['پ','ب','ت','ٹ'], 'answer': 2},
      {'visual': '🪁', 'prompt': 'پتنگ کس حرف سے شروع ہوتا ہے؟', 'options': ['ب','پ','ت','ٹ'], 'answer': 1},
      {'visual': '✈️', 'prompt': 'جہاز کس حرف سے شروع ہوتا ہے؟', 'options': ['ج','چ','ز','ژ'], 'answer': 0},
      {'visual': '🦒', 'prompt': 'زرافہ کس حرف سے شروع ہوتا ہے؟', 'options': ['ر','ز','ڑ','ژ'], 'answer': 1},
      {'visual': '🍯', 'prompt': 'شہد کس حرف سے شروع ہوتا ہے؟', 'options': ['س','ص','ش','ث'], 'answer': 2},
      {'visual': '🐬', 'prompt': 'ڈالفن کس حرف سے شروع ہوتا ہے؟', 'options': ['د','ڈ','ذ','ر'], 'answer': 1},
      {'visual': '🐐', 'prompt': 'بکری کس حرف سے شروع ہوتا ہے؟', 'options': ['پ','ب','ت','ٹ'], 'answer': 1},
      {'visual': '🥛', 'prompt': 'دودھ کس حرف سے شروع ہوتا ہے؟', 'options': ['ذ','ر','د','ڈ'], 'answer': 2},
      {'visual': '🌸', 'prompt': 'پھول کس حرف سے شروع ہوتا ہے؟', 'options': ['ب','پ','ف','ق'], 'answer': 1},
      {'visual': '🍞', 'prompt': 'روٹی کس حرف سے شروع ہوتا ہے؟', 'options': ['ز','ڑ','ر','ژ'], 'answer': 2},
      {'visual': 'ب', 'prompt': 'ب سے شروع ہونے والی تصویر کون سی ہے؟', 'options': ['🍎','🐱','🎩','🌳'], 'answer': 1, 'picOpts': true},
      {'visual': 'پ', 'prompt': 'پ سے شروع ہونے والی تصویر کون سی ہے؟', 'options': ['✏️','🥭','🦁','🚪'], 'answer': 0, 'picOpts': true},
      {'visual': 'ت', 'prompt': 'ت سے شروع ہونے والی تصویر کون سی ہے؟', 'options': ['🐱','🦜','🍉','🐰'], 'answer': 2, 'picOpts': true},
      {'visual': 'ش', 'prompt': 'ش سے شروع ہونے والی تصویر کون سی ہے؟', 'options': ['🍎','🦁','📖','🎈'], 'answer': 1, 'picOpts': true},
      {'visual': 'ک', 'prompt': 'ک سے شروع ہونے والی تصویر کون سی ہے؟', 'options': ['📖','🦁','🏠','✏️'], 'answer': 0, 'picOpts': true},
      {'visual': 'گ', 'prompt': 'گ سے شروع ہونے والی تصویر کون سی ہے؟', 'options': ['📖','✏️','🏠','🍉'], 'answer': 2, 'picOpts': true},
      {'visual': 'د', 'prompt': 'د سے شروع ہونے والی تصویر کون سی ہے؟', 'options': ['🎩','🚪','🦁','📖'], 'answer': 1, 'picOpts': true},
      {'visual': 'ر', 'prompt': 'ر سے شروع ہونے والی تصویر کون سی ہے؟', 'options': ['🐱','🍎','🍞','🌳'], 'answer': 2, 'picOpts': true},
      {'visual': 'ز', 'prompt': 'ز سے شروع ہونے والی تصویر کون سی ہے؟', 'options': ['🦁','🦒','🍉','🐱'], 'answer': 1, 'picOpts': true},
      {'visual': 'خ', 'prompt': 'خ سے شروع ہونے والی تصویر کون سی ہے؟', 'options': ['🍎','🐱','🐰','🌳'], 'answer': 2, 'picOpts': true},
    ],
    'english_vowels': [
      {'visual': '🍎', 'prompt': 'Apple starts with which vowel?', 'options': ['A','E','I','O'], 'answer': 0},
      {'visual': '🥚', 'prompt': 'Egg starts with which vowel?', 'options': ['A','E','I','U'], 'answer': 1},
      {'visual': '🐘', 'prompt': 'Elephant starts with which vowel?', 'options': ['A','E','I','O'], 'answer': 1},
      {'visual': '🍦', 'prompt': 'Ice Cream starts with which vowel?', 'options': ['A','E','I','O'], 'answer': 2},
      {'visual': '🍊', 'prompt': 'Orange starts with which vowel?', 'options': ['A','E','O','U'], 'answer': 2},
      {'visual': '☂️', 'prompt': 'Umbrella starts with which vowel?', 'options': ['A','E','O','U'], 'answer': 3},
      {'visual': '🐜', 'prompt': 'Ant starts with which vowel?', 'options': ['A','E','I','O'], 'answer': 0},
      {'visual': '🦅', 'prompt': 'Eagle starts with which vowel?', 'options': ['A','E','I','O'], 'answer': 1},
      {'visual': '🦉', 'prompt': 'Owl starts with which vowel?', 'options': ['A','I','O','U'], 'answer': 2},
      {'visual': '🦄', 'prompt': 'Unicorn starts with which vowel?', 'options': ['A','E','O','U'], 'answer': 3},
      {'visual': '🐊', 'prompt': 'Alligator starts with which vowel?', 'options': ['A','E','I','O'], 'answer': 0},
      {'visual': '🐙', 'prompt': 'Octopus starts with which vowel?', 'options': ['A','E','O','U'], 'answer': 2},
      {'visual': '🏝️', 'prompt': 'Island starts with which vowel?', 'options': ['A','E','I','O'], 'answer': 2},
      {'visual': '🌊', 'prompt': 'Ocean starts with which vowel?', 'options': ['A','E','O','U'], 'answer': 2},
      {'visual': null, 'prompt': 'How many vowels are in English?', 'options': ['3','4','5','6'], 'answer': 2},
      {'visual': null, 'prompt': 'Which of these is a vowel?', 'options': ['B','C','A','D'], 'answer': 2},
      {'visual': null, 'prompt': 'Which of these is a vowel?', 'options': ['F','E','G','H'], 'answer': 1},
      {'visual': null, 'prompt': 'Which of these is a vowel?', 'options': ['J','K','I','L'], 'answer': 2},
      {'visual': null, 'prompt': 'Which of these is a vowel?', 'options': ['P','Q','R','O'], 'answer': 3},
      {'visual': null, 'prompt': 'Which of these is a vowel?', 'options': ['S','T','U','V'], 'answer': 2},
      {'visual': null, 'prompt': 'Which word starts with "A"?', 'options': ['Banana','Apple','Mango','Tree'], 'answer': 1},
      {'visual': null, 'prompt': 'Which word starts with "E"?', 'options': ['Dog','Cat','Elephant','Lion'], 'answer': 2},
      {'visual': null, 'prompt': 'Which word starts with "I"?', 'options': ['Rose','Sun','Ink','Moon'], 'answer': 2},
      {'visual': null, 'prompt': 'Which word starts with "O"?', 'options': ['Banana','Orange','Grapes','Mango'], 'answer': 1},
      {'visual': null, 'prompt': 'Which word starts with "U"?', 'options': ['Table','Chair','Door','Umbrella'], 'answer': 3},
      {'visual': 'A', 'prompt': 'Tap the picture that starts with "A"!', 'options': ['🥚','🍎','🍊','☂️'], 'answer': 1, 'picOpts': true},
      {'visual': 'E', 'prompt': 'Tap the picture that starts with "E"!', 'options': ['🍎','🦉','🥚','🦄'], 'answer': 2, 'picOpts': true},
      {'visual': 'I', 'prompt': 'Tap the picture that starts with "I"!', 'options': ['🍊','🐜','☂️','🍦'], 'answer': 3, 'picOpts': true},
      {'visual': 'O', 'prompt': 'Tap the picture that starts with "O"!', 'options': ['🍊','🐜','🥚','🦄'], 'answer': 0, 'picOpts': true},
      {'visual': 'U', 'prompt': 'Tap the picture that starts with "U"!', 'options': ['🍎','🥚','🦉','☂️'], 'answer': 3, 'picOpts': true},
      {'visual': 'A', 'prompt': 'Which picture starts with "A"?', 'options': ['🍦','🐙','🐊','☂️'], 'answer': 2, 'picOpts': true},
      {'visual': 'E', 'prompt': 'Which picture starts with "E"?', 'options': ['🐘','🍊','🛸','🍎'], 'answer': 0, 'picOpts': true},
      {'visual': 'I', 'prompt': 'Which picture starts with "I"?', 'options': ['🐜','🛖','🍊','🦄'], 'answer': 1, 'picOpts': true},
      {'visual': 'O', 'prompt': 'Which picture starts with "O"?', 'options': ['☂️','🍦','🐙','🥚'], 'answer': 2, 'picOpts': true},
      {'visual': 'U', 'prompt': 'Which picture starts with "U"?', 'options': ['🦄','🍊','🐜','🥚'], 'answer': 0, 'picOpts': true},
      {'visual': '🌍', 'prompt': 'Earth starts with which vowel?', 'options': ['A','E','I','O'], 'answer': 1},
      {'visual': '👁️', 'prompt': 'Eye starts with which vowel?', 'options': ['A','E','I','O'], 'answer': 1},
      {'visual': '👂', 'prompt': 'Ear starts with which vowel?', 'options': ['A','E','I','O'], 'answer': 1},
      {'visual': '🧅', 'prompt': 'Onion starts with which vowel?', 'options': ['A','E','O','U'], 'answer': 2},
      {'visual': '🦦', 'prompt': 'Otter starts with which vowel?', 'options': ['A','E','O','U'], 'answer': 2},
      {'visual': '🛖', 'prompt': 'Igloo starts with which vowel?', 'options': ['A','E','I','O'], 'answer': 2},
      {'visual': '🧊', 'prompt': 'Ice starts with which vowel?', 'options': ['A','E','I','O'], 'answer': 2},
      {'visual': '🪓', 'prompt': 'Axe starts with which vowel?', 'options': ['A','E','I','O'], 'answer': 0},
      {'visual': '🪕', 'prompt': 'Ukulele starts with which vowel?', 'options': ['A','E','O','U'], 'answer': 3},
      {'visual': '✉️', 'prompt': 'Envelope starts with which vowel?', 'options': ['A','E','I','O'], 'answer': 1},
      {'visual': '🫒', 'prompt': 'Olive starts with which vowel?', 'options': ['A','E','O','U'], 'answer': 2},
      {'visual': '🐊', 'prompt': 'Alligator starts with which vowel?', 'options': ['A','E','I','O'], 'answer': 0},
    ],
  };

  String get _languageCode => widget.quizKey == 'urdu_alphabet' ? 'ur' : 'en';

  @override
  void initState() {
    super.initState();
    _shuffleAll();
  }

  void _shuffleAll() {
    final rnd = Random();
    final dPool = List<String>.from(_drawPool[widget.quizKey] ?? const []);
    dPool.shuffle(rnd);
    _drawRound = dPool.take(widget.questionCount).toList();

    final mPool = List<Map<String, dynamic>>.from(
        _mcqPool[widget.quizKey] ?? const []);
    mPool.shuffle(rnd);
    _mcqRound = mPool.take(widget.questionCount).toList();
  }

  int get _total =>
      widget.mode == 'drawing' ? _drawRound.length : _mcqRound.length;

  void _clearCanvas() {
    setState(() {
      _strokes.clear();
      _strokeTimes.clear();
    });
  }

  void _onPanStart(DragStartDetails d) {
    if (_strokes.isEmpty) {
      _inkStart = DateTime.now().millisecondsSinceEpoch;
    }
    setState(() {
      _strokes.add([d.localPosition]);
      _strokeTimes.add([DateTime.now().millisecondsSinceEpoch - _inkStart]);
    });
  }

  void _onPanUpdate(DragUpdateDetails d) {
    setState(() {
      _strokes.last = List<Offset>.from(_strokes.last)..add(d.localPosition);
      _strokeTimes.last = List<int>.from(_strokeTimes.last)
        ..add(DateTime.now().millisecondsSinceEpoch - _inkStart);
    });
  }

  Future<void> _logImla({
    required String target,
    required String? predicted,
    required double confidence,
    required bool isCorrect,
  }) async {
    final child = AppSession.instance.currentChild;
    if (child == null) return;
    try {
      await ImlaService.storeAttempt(
        childId: child.id,
        targetLetter: target,
        predictedLetter: predicted,
        confidence: confidence,
        isCorrect: isCorrect,
        language: _languageCode,
      );
    } catch (_) {}
  }

  Future<void> _logMcq({required bool isCorrect}) async {
    final child = AppSession.instance.currentChild;
    if (child == null) return;
    try {
      await ProgressService.log(
        childId: child.id,
        moduleType: 'quiz_${widget.quizKey}',
        score: isCorrect ? 1 : 0,
        total: 1,
      );
    } catch (_) {}
  }

  Future<void> _checkDrawing() async {
    if (_isChecking) return;
    setState(() => _isChecking = true);

    final target = _drawRound[_index];
    final result = await HandwritingRecognizer.recognize(
      languageCode: _languageCode,
      strokes: _strokes,
      strokeTimes: _strokeTimes,
      target: target,
    );

    if (!mounted) return;
    setState(() => _isChecking = false);

    ResultKind kind;
    String? subline;
    if (result.error == 'no_ink') {
      kind = ResultKind.empty;
    } else if (result.error != null) {
      kind = ResultKind.wrong;
      subline = 'Recognition unavailable. Please try again.';
    } else if (result.isCorrect) {
      _correctCount++;
      kind = ResultKind.correct;
    } else {
      kind = ResultKind.wrong;
    }

    if (kind != ResultKind.empty) {
      _logImla(
        target: target,
        predicted: result.predicted.isEmpty ? null : result.predicted,
        confidence: result.error == null ? result.confidence : 0,
        isCorrect: kind == ResultKind.correct,
      );
    }

    await showResultDialog(
      context,
      kind: kind,
      target: target,
      predicted: result.predicted.isEmpty ? null : result.predicted,
      confidence: result.error == null ? result.confidence : null,
      customSubline: subline,
      showRetryButton: kind == ResultKind.wrong,
      onContinue: () {
        if (!mounted) return;
        if (kind == ResultKind.empty) return;
        _next();
      },
      onTryAgain: () {
        if (mounted) _clearCanvas();
      },
    );
  }

  void _selectOption(int i) {
    if (_checked) return;
    setState(() => _selectedOption = i);
  }

  Future<void> _checkMcq() async {
    if (_selectedOption == null || _checked) return;
    final question = _mcqRound[_index];
    final correct = question['answer'] as int;
    final options = question['options'] as List;
    final correctText = options[correct].toString();
    final selectedText = options[_selectedOption!].toString();
    final isCorrect = _selectedOption == correct;
    setState(() {
      _checked = true;
      if (isCorrect) _correctCount++;
    });

    _logMcq(isCorrect: isCorrect);

    await showResultDialog(
      context,
      kind: isCorrect ? ResultKind.correct : ResultKind.wrong,
      target: correctText,
      predicted: selectedText,
      customSubline: isCorrect
          ? 'You picked "$correctText"!'
          : 'Correct answer is "$correctText".',
      onContinue: () {
        if (mounted) _next();
      },
    );
  }

  void _next() {
    if (_index < _total - 1) {
      setState(() {
        _index++;
        _strokes.clear();
        _strokeTimes.clear();
        _selectedOption = null;
        _checked = false;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QuizResultScreen(
            correct: _correctCount,
            total: _total,
            tint: AppColors.cardPurple,
            iconColor: AppColors.brandPurple,
            quizTitle: widget.quizTitle,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.quizTitle,
                style: const TextStyle(
                  color: AppColors.brandPurple,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: AppColors.textSoft(context),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    const TextSpan(text: 'Question '),
                    TextSpan(
                      text: '${_index + 1}',
                      style: const TextStyle(
                        color: AppColors.brandPurple,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextSpan(text: ' of $_total'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: _total == 0 ? 0 : (_index + 1) / _total,
                  minHeight: 8,
                  backgroundColor: AppColors.purple100,
                  valueColor:
                      const AlwaysStoppedAnimation(AppColors.brandPurple),
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: widget.mode == 'drawing'
                    ? _DrawingBody(
                        target: _drawRound.isEmpty ? '' : _drawRound[_index],
                        strokes: _strokes,
                        isChecking: _isChecking,
                        onPanStart: _isChecking ? null : _onPanStart,
                        onPanUpdate: _isChecking ? null : _onPanUpdate,
                      )
                    : _McqBody(
                        question: _mcqRound[_index],
                        selected: _selectedOption,
                        checked: _checked,
                        onSelect: _selectOption,
                      ),
              ),
              const SizedBox(height: 14),
              if (widget.mode == 'drawing')
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: OutlinedButton.icon(
                          onPressed: _isChecking ? null : _clearCanvas,
                          icon: const Icon(Icons.cleaning_services_rounded,
                              size: 18),
                          label: const Text('Clear'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textSoft(context),
                            side: BorderSide(
                                color: AppColors.borderSoft(context),
                                width: 1.5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                            textStyle: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: _isChecking ? null : _checkDrawing,
                          icon: const Icon(Icons.check_rounded, size: 20),
                          label: const Text('Check'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.cardGreen,
                            foregroundColor: AppColors.iconGreen,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                            textStyle: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              if (widget.mode == 'mcq')
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _checked
                        ? _next
                        : (_selectedOption != null ? _checkMcq : null),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedOption != null
                          ? AppColors.brandPurple
                          : AppColors.purple300,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: AppColors.purple200,
                      disabledForegroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                    child: Text(_checked
                        ? (_index < _total - 1 ? 'Next Question' : 'Finish Quiz')
                        : 'Check Answer'),
                  ),
                ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawingBody extends StatelessWidget {
  final String target;
  final List<List<Offset>> strokes;
  final bool isChecking;
  final void Function(DragStartDetails)? onPanStart;
  final void Function(DragUpdateDetails)? onPanUpdate;

  const _DrawingBody({
    required this.target,
    required this.strokes,
    required this.isChecking,
    required this.onPanStart,
    required this.onPanUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: AppColors.cardOrange,
            borderRadius: BorderRadius.circular(18),
          ),
          alignment: Alignment.center,
          child: Text(
            target,
            style: const TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.w800,
              color: AppColors.iconOrange,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.purple100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'AI Check',
            style: TextStyle(
              color: AppColors.purple700,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.cardBg(context),
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: AppColors.borderSoft(context), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.hardEdge,
            child: Stack(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanStart: onPanStart,
                  onPanUpdate: onPanUpdate,
                  child: CustomPaint(
                    painter: _StrokePainter(strokes),
                    size: Size.infinite,
                  ),
                ),
                if (isChecking)
                  Positioned.fill(
                    child: Container(
                      color: AppColors.cardBg(context).withValues(alpha: 0.7),
                      alignment: Alignment.center,
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                              color: AppColors.brandPurple, strokeWidth: 3),
                          SizedBox(height: 12),
                          Text(
                            'Recognizing…',
                            style: TextStyle(
                              color: AppColors.purple700,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _McqBody extends StatelessWidget {
  final Map<String, dynamic> question;
  final int? selected;
  final bool checked;
  final void Function(int) onSelect;

  const _McqBody({
    required this.question,
    required this.selected,
    required this.checked,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final visual = question['visual'] as String?;
    final prompt = question['prompt'] as String;
    final options = question['options'] as List;
    final correct = question['answer'] as int;
    final picOpts = (question['picOpts'] as bool?) ?? false;

    return SingleChildScrollView(
      child: Column(
        children: [
          if (visual != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 22),
              decoration: BoxDecoration(
                color: picOpts ? AppColors.cardPurple : AppColors.cardOrange,
                borderRadius: BorderRadius.circular(18),
              ),
              alignment: Alignment.center,
              child: picOpts
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Find the picture for:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.brandPurple
                                .withValues(alpha: 0.75),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          visual,
                          style: const TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.w900,
                            color: AppColors.brandPurple,
                            height: 1,
                          ),
                        ),
                      ],
                    )
                  : Text(visual,
                      style: const TextStyle(fontSize: 60, height: 1.2)),
            ),
            const SizedBox(height: 14),
          ],
          Text(
            prompt,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.text(context),
            ),
          ),
          const SizedBox(height: 16),
          if (picOpts) ...[
            _PicOptionGrid(
              options: options,
              selected: selected,
              checked: checked,
              correct: correct,
              onSelect: onSelect,
            ),
          ] else
            ...List.generate(options.length, (i) {
            final isSelected = selected == i;
            final isCorrect = checked && i == correct;
            final isWrong = checked && isSelected && i != correct;

            Color bg = AppColors.cardBg(context);
            Color border = AppColors.borderSoft(context);
            Color textColor = AppColors.text(context);
            Widget? trailing;

            if (isCorrect) {
              bg = AppColors.cardGreen;
              border = AppColors.success;
              textColor = AppColors.iconGreen;
              trailing = const Icon(Icons.check_circle_rounded,
                  color: AppColors.success, size: 22);
            } else if (isWrong) {
              bg = const Color(0xFFFEF2F2);
              border = AppColors.error;
              textColor = AppColors.error;
              trailing = const Icon(Icons.cancel_rounded,
                  color: AppColors.error, size: 22);
            } else if (isSelected) {
              bg = AppColors.purple100;
              border = AppColors.brandPurple;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => onSelect(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 120),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: border,
                          width:
                              isSelected || isCorrect || isWrong ? 2 : 1),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: isCorrect
                                ? AppColors.success
                                : isWrong
                                    ? AppColors.error
                                    : isSelected
                                        ? AppColors.brandPurple
                                        : AppColors.cardBg(context),
                            shape: BoxShape.circle,
                            border: Border.all(color: border, width: 1.5),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            String.fromCharCode(65 + i),
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                              color: isSelected || isCorrect || isWrong
                                  ? Colors.white
                                  : AppColors.text(context),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            options[i].toString(),
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                          ),
                        ),
                        ?trailing,
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _PicOptionGrid extends StatelessWidget {
  final List options;
  final int? selected;
  final bool checked;
  final int correct;
  final void Function(int) onSelect;

  const _PicOptionGrid({
    required this.options,
    required this.selected,
    required this.checked,
    required this.correct,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.15,
      children: List.generate(options.length, (i) {
        final isSelected = selected == i;
        final isCorrect = checked && i == correct;
        final isWrong = checked && isSelected && i != correct;

        Color bg = AppColors.cardBg(context);
        Color border = AppColors.borderSoft(context);

        if (isCorrect) {
          bg = AppColors.cardGreen;
          border = AppColors.success;
        } else if (isWrong) {
          bg = const Color(0xFFFEF2F2);
          border = AppColors.error;
        } else if (isSelected) {
          bg = AppColors.purple100;
          border = AppColors.brandPurple;
        }

        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => onSelect(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: border,
                  width: isSelected || isCorrect || isWrong ? 2.5 : 1.5,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      options[i].toString(),
                      style: const TextStyle(fontSize: 52),
                    ),
                  ),
                  if (checked && (isCorrect || isWrong))
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Icon(
                        isCorrect
                            ? Icons.check_circle_rounded
                            : Icons.cancel_rounded,
                        color:
                            isCorrect ? AppColors.success : AppColors.error,
                        size: 22,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _StrokePainter extends CustomPainter {
  final List<List<Offset>> strokes;
  _StrokePainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.brandPurple
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (final stroke in strokes) {
      if (stroke.length < 2) {
        if (stroke.length == 1) {
          canvas.drawCircle(stroke.first, 4,
              Paint()..color = AppColors.brandPurple);
        }
        continue;
      }
      final path = Path()..moveTo(stroke.first.dx, stroke.first.dy);
      for (int i = 1; i < stroke.length; i++) {
        path.lineTo(stroke[i].dx, stroke[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _StrokePainter oldDelegate) => true;
}

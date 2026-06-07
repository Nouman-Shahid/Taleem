<?php

namespace Database\Seeders;

use App\Models\Lesson;
use Illuminate\Database\Seeder;

class LessonSeeder extends Seeder
{
    public function run(): void
    {
        Lesson::query()->delete();

        $this->seedUrduAlphabet();
        $this->seedUrduGinti();
        $this->seedEnglishAlphabet();
        $this->seedEnglishNumbers();
        $this->seedUrduVocab();
        $this->seedImlaSpelling();
        $this->seedEnglishSpelling();
    }

    private function seedUrduAlphabet(): void
    {
        $letters = [
            ['ا', 'alif'], ['ب', 'bay'], ['پ', 'pay'], ['ت', 'tay'], ['ٹ', 'Tay'],
            ['ث', 'say'], ['ج', 'jeem'], ['چ', 'chay'], ['ح', 'hay'], ['خ', 'khay'],
            ['د', 'daal'], ['ڈ', 'Daal'], ['ذ', 'zaal'], ['ر', 'ray'], ['ڑ', 'Ray'],
            ['ز', 'zay'], ['ژ', 'zhay'], ['س', 'seen'], ['ش', 'sheen'], ['ص', 'suad'],
            ['ض', 'zuad'], ['ط', 'toay'], ['ظ', 'zoay'], ['ع', 'ain'], ['غ', 'ghain'],
            ['ف', 'fay'], ['ق', 'qaaf'], ['ک', 'kaaf'], ['گ', 'gaaf'], ['ل', 'laam'],
            ['م', 'meem'], ['ن', 'noon'], ['و', 'wow'], ['ہ', 'choti hay'], ['ء', 'hamza'],
            ['ی', 'yay'], ['ے', 'bari yay'],
        ];

        foreach ($letters as $i => $row) {
            Lesson::create([
                'module_type' => 'urdu_alphabet',
                'display_text' => $row[0],
                'translation' => $row[1],
                'image_url' => null,
                'audio_url' => $this->ttsUrl($row[0], 'ur'),
                'sort_order' => $i + 1,
            ]);
        }
    }

    private function seedUrduGinti(): void
    {
        $words = [
            1 => 'ایک', 2 => 'دو', 3 => 'تین', 4 => 'چار', 5 => 'پانچ',
            6 => 'چھ', 7 => 'سات', 8 => 'آٹھ', 9 => 'نو', 10 => 'دس',
            11 => 'گیارہ', 12 => 'بارہ', 13 => 'تیرہ', 14 => 'چودہ', 15 => 'پندرہ',
            16 => 'سولہ', 17 => 'سترہ', 18 => 'اٹھارہ', 19 => 'انیس', 20 => 'بیس',
        ];

        for ($i = 1; $i <= 100; $i++) {
            $urdu = $words[$i] ?? (string) $i;
            Lesson::create([
                'module_type' => 'urdu_ginti',
                'display_text' => $this->toUrduNumeral($i),
                'translation' => $urdu,
                'image_url' => null,
                'audio_url' => $this->ttsUrl($urdu, 'ur'),
                'sort_order' => $i,
            ]);
        }
    }

    private function seedEnglishAlphabet(): void
    {
        $letters = [
            ['A', 'Apple'], ['B', 'Ball'], ['C', 'Cat'], ['D', 'Dog'],
            ['E', 'Elephant'], ['F', 'Fish'], ['G', 'Grapes'], ['H', 'Hat'],
            ['I', 'Ice cream'], ['J', 'Jug'], ['K', 'Kite'], ['L', 'Lion'],
            ['M', 'Mango'], ['N', 'Nose'], ['O', 'Orange'], ['P', 'Pencil'],
            ['Q', 'Queen'], ['R', 'Rabbit'], ['S', 'Sun'], ['T', 'Tree'],
            ['U', 'Umbrella'], ['V', 'Van'], ['W', 'Watermelon'], ['X', 'Xylophone'],
            ['Y', 'Yak'], ['Z', 'Zebra'],
        ];

        foreach ($letters as $i => $row) {
            Lesson::create([
                'module_type' => 'english_alphabet',
                'display_text' => $row[0],
                'translation' => $row[1],
                'image_url' => $this->imageUrl($row[1]),
                'audio_url' => $this->ttsUrl($row[1], 'en'),
                'sort_order' => $i + 1,
            ]);
        }
    }

    private function seedEnglishNumbers(): void
    {
        $words = [
            1 => 'one', 2 => 'two', 3 => 'three', 4 => 'four', 5 => 'five',
            6 => 'six', 7 => 'seven', 8 => 'eight', 9 => 'nine', 10 => 'ten',
            11 => 'eleven', 12 => 'twelve', 13 => 'thirteen', 14 => 'fourteen', 15 => 'fifteen',
            16 => 'sixteen', 17 => 'seventeen', 18 => 'eighteen', 19 => 'nineteen', 20 => 'twenty',
        ];

        for ($i = 1; $i <= 100; $i++) {
            $en = $words[$i] ?? (string) $i;
            Lesson::create([
                'module_type' => 'english_number',
                'display_text' => (string) $i,
                'translation' => $en,
                'image_url' => null,
                'audio_url' => $this->ttsUrl($en, 'en'),
                'sort_order' => $i,
            ]);
        }
    }

    private function seedUrduVocab(): void
    {
        $vocab = [
            ['شیر', 'lion'], ['ہاتھی', 'elephant'], ['گھوڑا', 'horse'], ['بلی', 'cat'],
            ['کتا', 'dog'], ['گائے', 'cow'], ['بکری', 'goat'], ['مرغی', 'chicken'],
            ['سیب', 'apple'], ['کیلا', 'banana'], ['انگور', 'grapes'], ['آم', 'mango'],
            ['سنترا', 'orange'], ['تربوز', 'watermelon'],
            ['لال', 'red'], ['نیلا', 'blue'], ['ہرا', 'green'], ['پیلا', 'yellow'],
            ['کالا', 'black'], ['سفید', 'white'],
            ['کرسی', 'chair'], ['میز', 'table'], ['کتاب', 'book'], ['پنسل', 'pencil'],
            ['گھر', 'house'], ['دروازہ', 'door'],
        ];

        foreach ($vocab as $i => $row) {
            Lesson::create([
                'module_type' => 'urdu_vocab',
                'display_text' => $row[0],
                'translation' => $row[1],
                'image_url' => $this->imageUrl($row[1]),
                'audio_url' => $this->ttsUrl($row[0], 'ur'),
                'sort_order' => $i + 1,
            ]);
        }
    }

    private function seedImlaSpelling(): void
    {
        $words = [
            ['اسلام', 'Islam'],
            ['نماز', 'Namaz'],
            ['روزہ', 'Roza'],
            ['قرآن', 'Quran'],
            ['حدیث', 'Hadith'],
            ['مسجد', 'Masjid'],
            ['ایمان', 'Imaan'],
            ['زکات', 'Zakat'],
            ['صبر', 'Sabr'],
            ['شکر', 'Shukr'],
            ['وضو', 'Wudu'],
            ['توبہ', 'Taubah'],
            ['اخلاق', 'Akhlaq'],
            ['محبت', 'Mohabbat'],
            ['دوست', 'Dost'],
            ['استاد', 'Ustad'],
            ['کتاب', 'Kitaab'],
            ['قلم', 'Qalam'],
        ];

        foreach ($words as $i => $row) {
            Lesson::create([
                'module_type' => 'imla_spelling',
                'display_text' => $row[0],
                'translation' => $row[1],
                'image_url' => null,
                'audio_url' => $this->ttsUrl($row[0], 'ur'),
                'sort_order' => $i + 1,
            ]);
        }
    }

    private function seedEnglishSpelling(): void
    {
        $words = [
            'Apple', 'Ball', 'Cat', 'Dog', 'Elephant', 'Fish',
            'Grapes', 'Hat', 'Ice', 'Jug', 'Kite', 'Lion',
            'Mango', 'Nose', 'Orange', 'Pencil', 'Queen', 'Rabbit',
        ];

        foreach ($words as $i => $w) {
            Lesson::create([
                'module_type' => 'english_spelling',
                'display_text' => $w,
                'translation' => strtolower($w),
                'image_url' => $this->imageUrl($w),
                'audio_url' => $this->ttsUrl($w, 'en'),
                'sort_order' => $i + 1,
            ]);
        }
    }

    private function imageUrl(string $keyword, int $size = 400): string
    {
        return 'https://source.unsplash.com/' . $size . 'x' . $size . '/?' . urlencode(strtolower($keyword));
    }

    private function ttsUrl(string $text, string $lang = 'en'): string
    {
        return 'https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&tl=' . $lang . '&q=' . urlencode($text);
    }

    private function toUrduNumeral(int $n): string
    {
        $map = ['0' => '۰', '1' => '۱', '2' => '۲', '3' => '۳', '4' => '۴', '5' => '۵', '6' => '۶', '7' => '۷', '8' => '۸', '9' => '۹'];

        return strtr((string) $n, $map);
    }
}

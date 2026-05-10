<?php

namespace Database\Seeders;

use App\Models\Quiz;
use Illuminate\Database\Seeder;

class QuizSeeder extends Seeder
{
    public function run(): void
    {
        Quiz::query()->delete();

        $items = [
            ['animals', 'lion',       'Lion',       ['Lion', 'Tiger', 'Elephant', 'Horse'],   'شیر',     ['شیر', 'چیتا', 'ہاتھی', 'گھوڑا']],
            ['animals', 'tiger',      'Tiger',      ['Tiger', 'Lion', 'Cat', 'Dog'],          'چیتا',    ['چیتا', 'شیر', 'بلی', 'کتا']],
            ['animals', 'elephant',   'Elephant',   ['Cat', 'Elephant', 'Cow', 'Goat'],       'ہاتھی',   ['بلی', 'ہاتھی', 'گائے', 'بکری']],
            ['animals', 'cat',        'Cat',        ['Cat', 'Rabbit', 'Goat', 'Lion'],        'بلی',     ['بلی', 'خرگوش', 'بکری', 'شیر']],
            ['animals', 'dog',        'Dog',        ['Dog', 'Cow', 'Horse', 'Tiger'],         'کتا',     ['کتا', 'گائے', 'گھوڑا', 'چیتا']],
            ['animals', 'horse',      'Horse',      ['Goat', 'Sheep', 'Horse', 'Donkey'],     'گھوڑا',   ['بکری', 'بھیڑ', 'گھوڑا', 'گدھا']],

            ['fruits',  'apple',      'Apple',      ['Apple', 'Banana', 'Mango', 'Orange'],   'سیب',     ['سیب', 'کیلا', 'آم', 'سنترا']],
            ['fruits',  'banana',     'Banana',     ['Grapes', 'Banana', 'Apple', 'Watermelon'], 'کیلا', ['انگور', 'کیلا', 'سیب', 'تربوز']],
            ['fruits',  'mango',      'Mango',      ['Orange', 'Mango', 'Grapes', 'Apple'],   'آم',      ['سنترا', 'آم', 'انگور', 'سیب']],
            ['fruits',  'grapes',     'Grapes',     ['Banana', 'Apple', 'Grapes', 'Mango'],   'انگور',   ['کیلا', 'سیب', 'انگور', 'آم']],
            ['fruits',  'orange',     'Orange',     ['Orange', 'Apple', 'Mango', 'Banana'],   'سنترا',   ['سنترا', 'سیب', 'آم', 'کیلا']],
            ['fruits',  'watermelon', 'Watermelon', ['Watermelon', 'Mango', 'Apple', 'Orange'], 'تربوز', ['تربوز', 'آم', 'سیب', 'سنترا']],

            ['colors',  'red',    'Red',    ['Blue', 'Red', 'Green', 'Yellow'],   'لال',  ['نیلا', 'لال', 'ہرا', 'پیلا']],
            ['colors',  'blue',   'Blue',   ['Blue', 'Black', 'White', 'Red'],    'نیلا', ['نیلا', 'کالا', 'سفید', 'لال']],
            ['colors',  'green',  'Green',  ['Yellow', 'Red', 'Green', 'Blue'],   'ہرا',  ['پیلا', 'لال', 'ہرا', 'نیلا']],
            ['colors',  'yellow', 'Yellow', ['Yellow', 'Green', 'Black', 'White'],'پیلا', ['پیلا', 'ہرا', 'کالا', 'سفید']],
            ['colors',  'black',  'Black',  ['White', 'Black', 'Red', 'Blue'],    'کالا', ['سفید', 'کالا', 'لال', 'نیلا']],
            ['colors',  'white',  'White',  ['White', 'Black', 'Yellow', 'Green'],'سفید', ['سفید', 'کالا', 'پیلا', 'ہرا']],

            ['objects', 'chair',  'Chair',  ['Chair', 'Table', 'Book', 'Pencil'], 'کرسی',   ['کرسی', 'میز', 'کتاب', 'پنسل']],
            ['objects', 'table',  'Table',  ['Door', 'House', 'Table', 'Pencil'], 'میز',    ['دروازہ', 'گھر', 'میز', 'پنسل']],
            ['objects', 'book',   'Book',   ['Pencil', 'Book', 'Table', 'House'], 'کتاب',   ['پنسل', 'کتاب', 'میز', 'گھر']],
            ['objects', 'pencil', 'Pencil', ['Pencil', 'Book', 'Door', 'Chair'],  'پنسل',   ['پنسل', 'کتاب', 'دروازہ', 'کرسی']],
            ['objects', 'house',  'House',  ['Chair', 'House', 'Door', 'Table'],  'گھر',    ['کرسی', 'گھر', 'دروازہ', 'میز']],
            ['objects', 'door',   'Door',   ['Door', 'House', 'Chair', 'Book'],   'دروازہ', ['دروازہ', 'گھر', 'کرسی', 'کتاب']],
        ];

        foreach ($items as $row) {
            [$category, $imageKeyword, $enCorrect, $enOptions, $urCorrect, $urOptions] = $row;
            $imageUrl = $this->imageUrl($imageKeyword);

            Quiz::create([
                'category' => $category,
                'question_image' => $imageUrl,
                'correct_answer' => $enCorrect,
                'options' => $enOptions,
                'language' => 'english',
            ]);

            Quiz::create([
                'category' => $category,
                'question_image' => $imageUrl,
                'correct_answer' => $urCorrect,
                'options' => $urOptions,
                'language' => 'urdu',
            ]);
        }
    }

    private function imageUrl(string $keyword, int $size = 300): string
    {
        return 'https://loremflickr.com/' . $size . '/' . $size . '/' . urlencode(strtolower($keyword));
    }
}

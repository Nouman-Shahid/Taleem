<?php

namespace App\Http\Controllers;

use App\Models\Lesson;
use Illuminate\Http\Request;

class LessonController extends Controller
{
    public function index(Request $request)
    {
        $request->validate([
            'type' => 'nullable|string|in:urdu_alphabet,urdu_ginti,english_alphabet,english_number,urdu_vocab,imla_spelling,english_spelling',
        ]);

        $query = Lesson::query()->orderBy('sort_order');

        if ($request->filled('type')) {
            $query->where('module_type', $request->query('type'));
        }

        return response()->json(['lessons' => $query->get()]);
    }

    public function show($id)
    {
        $lesson = Lesson::findOrFail($id);

        return response()->json(['lesson' => $lesson]);
    }
}

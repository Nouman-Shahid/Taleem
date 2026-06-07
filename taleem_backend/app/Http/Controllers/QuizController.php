<?php

namespace App\Http\Controllers;

use App\Models\Child;
use App\Models\Progress;
use App\Models\Quiz;
use App\Models\QuizAttempt;
use Illuminate\Http\Request;

class QuizController extends Controller
{
    public function index(Request $request)
    {
        $query = Quiz::query();

        if ($request->filled('category')) {
            $query->where('category', $request->query('category'));
        }

        if ($request->filled('language')) {
            $query->where('language', $request->query('language'));
        }

        return response()->json(['quizzes' => $query->get()]);
    }

    public function storeAttempt(Request $request)
    {
        $data = $request->validate([
            'child_id' => 'required|integer|exists:children,id',
            'quiz_id' => 'required|integer|exists:quizzes,id',
            'selected_answer' => 'required|string|max:255',
        ]);

        $child = Child::where('id', $data['child_id'])
            ->where('parent_id', $request->user()->id)
            ->firstOrFail();

        $quiz = Quiz::findOrFail($data['quiz_id']);

        $isCorrect = trim(strtolower($data['selected_answer'])) === trim(strtolower($quiz->correct_answer));

        $attempt = QuizAttempt::create([
            'child_id' => $child->id,
            'quiz_id' => $quiz->id,
            'selected_answer' => $data['selected_answer'],
            'is_correct' => $isCorrect,
        ]);

        Progress::create([
            'child_id' => $child->id,
            'module_type' => 'quiz_' . $quiz->category,
            'lesson_id' => null,
            'score' => $isCorrect ? 1 : 0,
            'total' => 1,
        ]);

        return response()->json([
            'message' => 'Answer submitted',
            'attempt' => $attempt,
            'is_correct' => $isCorrect,
            'correct_answer' => $quiz->correct_answer,
        ], 201);
    }

    public function attemptsByChild(Request $request, $child_id)
    {
        $child = Child::where('id', $child_id)
            ->where('parent_id', $request->user()->id)
            ->firstOrFail();

        $attempts = QuizAttempt::with('quiz')
            ->where('child_id', $child->id)
            ->orderByDesc('id')
            ->get();

        return response()->json(['attempts' => $attempts]);
    }
}

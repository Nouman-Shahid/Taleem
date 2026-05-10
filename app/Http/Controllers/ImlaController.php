<?php

namespace App\Http\Controllers;

use App\Models\Child;
use App\Models\ImlaAttempt;
use App\Models\Progress;
use Illuminate\Http\Request;

class ImlaController extends Controller
{
    public function storeAttempt(Request $request)
    {
        $data = $request->validate([
            'child_id' => 'required|integer|exists:children,id',
            'target_letter' => 'required|string|max:50',
            'predicted_letter' => 'nullable|string|max:50',
            'confidence' => 'nullable|numeric|min:0|max:1',
            'is_correct' => 'required|boolean',
            'language' => 'nullable|string|in:ur,en',
        ]);

        $child = Child::where('id', $data['child_id'])
            ->where('parent_id', $request->user()->id)
            ->firstOrFail();

        $attempt = ImlaAttempt::create([
            'child_id' => $child->id,
            'target_letter' => $data['target_letter'],
            'predicted_letter' => $data['predicted_letter'] ?? null,
            'confidence' => $data['confidence'] ?? 0,
            'is_correct' => $data['is_correct'],
            'stroke_image' => null,
        ]);

        Progress::create([
            'child_id' => $child->id,
            'module_type' => 'imla',
            'lesson_id' => null,
            'score' => $data['is_correct'] ? 1 : 0,
            'total' => 1,
        ]);

        return response()->json([
            'message' => 'Attempt recorded',
            'attempt' => $attempt,
        ], 201);
    }

    public function attemptsByChild(Request $request, $child_id)
    {
        $child = Child::where('id', $child_id)
            ->where('parent_id', $request->user()->id)
            ->firstOrFail();

        $attempts = ImlaAttempt::where('child_id', $child->id)
            ->orderByDesc('id')
            ->get();

        return response()->json(['attempts' => $attempts]);
    }
}

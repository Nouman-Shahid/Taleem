<?php

namespace App\Http\Controllers;

use App\Models\Child;
use App\Models\Progress;
use Illuminate\Http\Request;

class ProgressController extends Controller
{
    public function store(Request $request)
    {
        $data = $request->validate([
            'child_id' => 'required|integer|exists:children,id',
            'module_type' => 'required|string|max:60',
            'score' => 'required|integer|min:0',
            'total' => 'required|integer|min:1',
        ]);

        $child = Child::where('id', $data['child_id'])
            ->where('parent_id', $request->user()->id)
            ->firstOrFail();

        $row = Progress::create([
            'child_id' => $child->id,
            'module_type' => $data['module_type'],
            'lesson_id' => null,
            'score' => $data['score'],
            'total' => $data['total'],
        ]);

        return response()->json([
            'message' => 'Progress recorded',
            'progress' => $row,
        ], 201);
    }

    public function byChild(Request $request, $child_id)
    {
        $child = Child::where('id', $child_id)
            ->where('parent_id', $request->user()->id)
            ->firstOrFail();

        $records = Progress::where('child_id', $child->id)
            ->orderByDesc('id')
            ->get();

        return response()->json([
            'child' => $child,
            'progress' => $records,
        ]);
    }

    public function summary(Request $request, $child_id)
    {
        $child = Child::where('id', $child_id)
            ->where('parent_id', $request->user()->id)
            ->firstOrFail();

        $rows = Progress::where('child_id', $child->id)
            ->selectRaw('module_type, SUM(score) as total_score, SUM(total) as total_attempts, COUNT(*) as activities')
            ->groupBy('module_type')
            ->get();

        $totalScore = (int) $rows->sum('total_score');
        $totalAttempts = (int) $rows->sum('total_attempts');
        $accuracy = $totalAttempts > 0 ? round(($totalScore / $totalAttempts) * 100, 2) : 0;
        $lessonsCompleted = Progress::where('child_id', $child->id)->count();
        $badges = (int) floor($totalScore / 10);

        return response()->json([
            'child' => $child,
            'modules' => $rows,
            'overall' => [
                'total_score' => $totalScore,
                'total_attempts' => $totalAttempts,
                'accuracy_percent' => $accuracy,
                'lessons_completed' => $lessonsCompleted,
                'badges' => $badges,
            ],
        ]);
    }
}

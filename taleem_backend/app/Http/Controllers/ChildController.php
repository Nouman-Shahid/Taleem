<?php

namespace App\Http\Controllers;

use App\Models\Child;
use Illuminate\Http\Request;

class ChildController extends Controller
{
    public function index(Request $request)
    {
        $children = Child::where('parent_id', $request->user()->id)
            ->orderByDesc('id')
            ->get();

        return response()->json(['children' => $children]);
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'name' => 'required|string|max:100',
            'age' => 'required|integer|min:1|max:20',
            'gender' => 'required|string|in:male,female,other',
            'avatar' => 'nullable|string|max:255',
        ]);

        $data['parent_id'] = $request->user()->id;

        $child = Child::create($data);

        return response()->json([
            'message' => 'Child added',
            'child' => $child,
        ], 201);
    }

    public function show(Request $request, $id)
    {
        $child = Child::where('parent_id', $request->user()->id)
            ->where('id', $id)
            ->firstOrFail();

        return response()->json(['child' => $child]);
    }

    public function update(Request $request, $id)
    {
        $child = Child::where('parent_id', $request->user()->id)
            ->where('id', $id)
            ->firstOrFail();

        $data = $request->validate([
            'name' => 'sometimes|required|string|max:100',
            'age' => 'sometimes|required|integer|min:1|max:20',
            'gender' => 'sometimes|required|string|in:male,female,other',
            'avatar' => 'nullable|string|max:255',
        ]);

        $child->update($data);

        return response()->json([
            'message' => 'Child updated',
            'child' => $child,
        ]);
    }

    public function destroy(Request $request, $id)
    {
        $child = Child::where('parent_id', $request->user()->id)
            ->where('id', $id)
            ->firstOrFail();

        $child->delete();

        return response()->json(['message' => 'Child deleted']);
    }
}

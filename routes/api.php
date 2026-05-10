<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\ChildController;
use App\Http\Controllers\ImlaController;
use App\Http\Controllers\LessonController;
use App\Http\Controllers\ProgressController;
use App\Http\Controllers\QuizController;
use Illuminate\Support\Facades\Route;

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/me', [AuthController::class, 'me']);

    Route::get('/children', [ChildController::class, 'index']);
    Route::post('/children', [ChildController::class, 'store']);
    Route::get('/children/{id}', [ChildController::class, 'show']);
    Route::put('/children/{id}', [ChildController::class, 'update']);
    Route::delete('/children/{id}', [ChildController::class, 'destroy']);

    Route::get('/lessons', [LessonController::class, 'index']);
    Route::get('/lessons/{id}', [LessonController::class, 'show']);

    Route::get('/quizzes', [QuizController::class, 'index']);
    Route::post('/quiz-attempts', [QuizController::class, 'storeAttempt']);
    Route::get('/quiz-attempts/child/{child_id}', [QuizController::class, 'attemptsByChild']);

    Route::post('/imla/attempts', [ImlaController::class, 'storeAttempt']);
    Route::get('/imla/attempts/{child_id}', [ImlaController::class, 'attemptsByChild']);

    Route::post('/progress', [ProgressController::class, 'store']);
    Route::get('/progress/{child_id}', [ProgressController::class, 'byChild']);
    Route::get('/progress/{child_id}/summary', [ProgressController::class, 'summary']);
});

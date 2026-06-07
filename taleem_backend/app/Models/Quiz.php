<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Quiz extends Model
{
    protected $fillable = [
        'category',
        'question_image',
        'correct_answer',
        'options',
        'language',
    ];

    protected $casts = [
        'options' => 'array',
    ];

    public function attempts(): HasMany
    {
        return $this->hasMany(QuizAttempt::class);
    }
}

<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Child extends Model
{
    protected $table = 'children';

    protected $fillable = [
        'parent_id',
        'name',
        'age',
        'gender',
        'avatar',
    ];

    public function parent(): BelongsTo
    {
        return $this->belongsTo(User::class, 'parent_id');
    }

    public function quizAttempts(): HasMany
    {
        return $this->hasMany(QuizAttempt::class);
    }

    public function imlaAttempts(): HasMany
    {
        return $this->hasMany(ImlaAttempt::class);
    }

    public function progress(): HasMany
    {
        return $this->hasMany(Progress::class);
    }
}

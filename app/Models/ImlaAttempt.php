<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ImlaAttempt extends Model
{
    protected $fillable = [
        'child_id',
        'target_letter',
        'predicted_letter',
        'confidence',
        'is_correct',
        'stroke_image',
    ];

    protected $casts = [
        'is_correct' => 'boolean',
        'confidence' => 'float',
    ];

    public function child(): BelongsTo
    {
        return $this->belongsTo(Child::class);
    }
}

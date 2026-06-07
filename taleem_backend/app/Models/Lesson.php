<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Lesson extends Model
{
    protected $fillable = [
        'module_type',
        'display_text',
        'translation',
        'image_url',
        'audio_url',
        'sort_order',
    ];
}

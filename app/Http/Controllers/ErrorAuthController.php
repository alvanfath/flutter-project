<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class ErrorAuthController extends Controller
{
    public function errorAuth(){
        return response()->json([
            'message' => 'Sepertinya ada yang salah'
        ], 500);
    }
}

<?php

namespace App\Http\Controllers;

use Carbon\Carbon;
use App\Models\Notes;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

class NotesController extends Controller
{

    public function index(){
        $notes = Notes::with('user')->get();
        return response()->json($notes, 200);
    }
    public function myNotes(){
        $me = Auth::user();
        $notes = Notes::with('user')->where('user_id', $me->id)->get();
        return response()->json($notes, 200);
    }

    public function store(Request $request){
        $me = Auth::user();
        $validator = Validator::make($request->all(), [
            'notes' => 'required'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'errors' => $validator->errors()
            ], 400);
        }
        $notes = new Notes();
        $notes->id = Str::uuid();
        $notes->user_id = $me->id;
        $notes->notes = $request->notes;
        $notes->created_at = Carbon::now();
        $notes->save();

        return response()->json([
            'message' => 'Berhasil Menambah notes'
        ], 200);
    }
}

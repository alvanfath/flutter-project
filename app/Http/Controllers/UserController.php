<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Support\Str;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class UserController extends Controller
{
    public function login(Request $request){
    	$validator = Validator::make($request->all(), [
            'email' => 'required',
            'password' => 'required',
        ],[
            'email.required' => 'Email atau username wajib diisi',
            'password.required' => 'Password wajib diisi'
        ]);
        Log::info("trying to login", ['email' => $request->email, 'password', $request->password]);
        if ($validator->fails()) {
            Log::info("validation error");
            return response()->json($validator->errors(), 422);
        }
        if (! $token = auth()->attempt(['email' => $request->input('email'), 'password' => $request->input('password')])) {
            Log::info("incorrect email or password");
            return response()->json(['error' => 'Autentikasi gagal'], 401);
        }else{
            Log::info("Login success");
            return $this->createNewToken($token);
        }
    }

    public function createNewToken($token){
        return response()->json([
            'access_token' => $token,
            'token_type' => 'bearer',
            'expires_in' => auth()->factory()->getTTL() * 60,
            'user' => auth()->user()
        ]);
    }

    public function userProfile() {
        return response()->json(auth()->user());
    }

    public function logout(Request $request) {
        auth()->logout();
        return response()->json(['message' => 'User successfully signed out']);
    }

    public function register(Request $req){
        $validator = Validator::make($req->all(),[
            'name' => 'required',
            'email' => 'required|unique:users,email',
            'password' => 'required'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'errors' => $validator->errors()
            ], 400);
        }
        $user = new User();
        $user->email = $req->email;
        $user->name = $req->name;
        $user->password = Hash::make($req->password);
        $user->save();
        return response()->json([
            'message' => 'Registrasi Berhasil, silakan login'
        ], 201);
    }

    public function updateProfile(Request $req){
        $me = Auth::user();
        $validator = Validator::make($req->all(),[
            'name' => 'required',
            'email' => 'required|unique:users,email,' .$me->id,
        ]);
        if ($validator->fails()) {
            return response()->json([
                'errors' => $validator->errors()
            ], 400);
        }

        $me->update([
            'name' => $req->name,
            'email' => $req->email
        ]);
        return response()->json([
            'message' => 'Berhasil mengubah profil'
        ], 200);
    }
}

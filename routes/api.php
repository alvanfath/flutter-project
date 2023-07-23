<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserController;
use App\Http\Controllers\NotesController;
use App\Http\Controllers\ErrorAuthController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::post('login', [UserController::class, 'login']);
Route::post('register', [UserController::class, 'register']);
Route::get('error-auth', [ErrorAuthController::class, 'errorAuth'])->name('error-auth');
Route::middleware('auth')->group(function () {
    Route::get('profile', [UserController::class, 'userProfile']);
    Route::get('refresh-token', [UserController::class, 'refresh']);
    Route::post('logout', [UserController::class, 'logout']);
    Route::put('update-profile', [UserController::class, 'updateProfile']);


    //notes
    Route::get('all-notes', [NotesController::class, 'index']);
    Route::get('my-notes', [NotesController::class, 'myNotes']);
    Route::post('store-notes', [NotesController::class, 'store']);
});

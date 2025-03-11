<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('main');
});

Route::get('/books', function () {
    return view('books');
});

Route::get('/authors', function () {
    return view('authors');
});

Route::get('/publishers', function () {
    return view('publishers');
});

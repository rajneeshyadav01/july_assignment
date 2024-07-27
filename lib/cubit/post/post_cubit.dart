import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:july_assignment/res/app_url.dart';


import '../../model/model.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit() : super(PostInitial());

  Future<void> fetchAllPosts() async {
    try {
      emit(PostLoading());
      final response = await http.get(Uri.parse(postApi))
          .timeout(const Duration(seconds: 20));
      if (response.statusCode == 200) {
        final List<PostModel> posts = (json.decode(response.body) as List)
            .map((data) => PostModel.fromJson(data))
            .toList();
        emit(PostLoaded(posts: posts));
      } else {
        emit(PostError(message: 'Failed to fetch posts: ${response.reasonPhrase}'));
      }
    } on SocketException {
      emit(PostError(message: 'No Internet connection'));
    } on TimeoutException {
      emit(PostError(message: 'Request timed out'));
    } catch (e) {
      emit(PostError(message: 'An unknown error occurred'));
    }
  }

  Future<void> fetchPostsByUserId(int userId) async {
    try {
      emit(PostLoading());
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts?userId=$userId'))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final List<PostModel> posts = (json.decode(response.body) as List)
            .map((data) => PostModel.fromJson(data))
            .toList();
        emit(PostLoaded(posts: posts));
      } else {
        emit(PostError(message: 'Failed to fetch posts: ${response.reasonPhrase}'));
      }
    } on SocketException {
      emit(PostError(message: 'No Internet connection'));
    } on TimeoutException {
      emit(PostError(message: 'Request timed out'));
    } catch (e) {
      emit(PostError(message: 'An unknown error occurred'));
    }
  }


  void filterPosts(String query) {
    if (state is PostLoaded) {
      final filteredPosts = (state as PostLoaded).posts
          .where((post) => post.title.contains(query))
          .toList();
      emit(PostLoaded(posts: filteredPosts));
    }
  }
}

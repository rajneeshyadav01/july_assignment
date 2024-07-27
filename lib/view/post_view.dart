import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/post/post_cubit.dart';


class PostPage extends StatelessWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignment'),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) => PostCubit(),
        child: const PostsView(),
      ),
    );
  }
}

class PostsView extends StatefulWidget {
  const PostsView({super.key});

  @override
  _PostsViewState createState() => _PostsViewState();
}

class _PostsViewState extends State<PostsView> {
  final TextEditingController _userIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _userIdController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Enter user ID...',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              final userId = int.tryParse(value);
              if (userId != null) {
                context.read<PostCubit>().fetchPostsByUserId(userId);
              }
            },
          ),
        ),
        Expanded(
          child: BlocBuilder<PostCubit, PostState>(
            builder: (context, state) {
              if (state is PostLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is PostLoaded) {
                return ListView.builder(
                  itemCount: state.posts.length,
                  itemBuilder: (context, index) {
                    final post = state.posts[index];
                    return ListTile(
                      title: Text(post.title),
                      subtitle: Text(post.body),
                    );
                  },
                );
              } else if (state is PostError) {
                return Center(child: Text(state.message));
              } else {
                return const Center(child: Text('No posts found'));
              }
            },
          ),
        ),
      ],
    );
  }
}

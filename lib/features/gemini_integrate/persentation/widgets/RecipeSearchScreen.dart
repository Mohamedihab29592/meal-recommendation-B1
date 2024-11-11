import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/RecipeBloc.dart';
import '../bloc/RecipeEvent.dart';
import '../bloc/RecipeState.dart';
import 'RecipeCard.dart';

class RecipeSearchScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  RecipeSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recipe Finder')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Enter food name'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  context.read<RecipeBloc>().add(FetchRecipesEvent(_controller.text));
                }
              },
              child: const Text('Search'),
            ),
            const SizedBox(height: 10),
            BlocBuilder<RecipeBloc, RecipeState>(
              builder: (context, state) {
                if (state is RecipeLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is RecipeLoaded) {
                  print(state.recipes.length);
                  return Expanded(
                    child: ListView.builder(
                      itemCount: state.recipes.length,
                      itemBuilder: (context, index) {
                        final recipe = state.recipes[index];
                        return RecipeCard(recipe: recipe);
                      },
                    ),
                  );
                } else if (state is RecipeError) {
                  return Center(child: Text(state.message));
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
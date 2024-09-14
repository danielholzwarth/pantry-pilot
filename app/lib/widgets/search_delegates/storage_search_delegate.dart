import 'package:app/bloc/storage_bloc/storage_bloc.dart';
import 'package:app/models/storage.dart';
import 'package:app/widgets/storage_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StorageSearchDelegate extends SearchDelegate {
  ScrollController scrollController = ScrollController();
  StorageBloc storageBloc = StorageBloc();
  String oldQuery = "anything";

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: theme.appBarTheme.copyWith(
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    storageBloc.add(GetStoragesSearch(keyword: query));

    return buildSearchResults(context);
  }

  Widget buildSearchResults(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: BlocBuilder(
          bloc: storageBloc,
          builder: (context, state) {
            if (state is StoragesLoadedSearch) {
              if (state.storages.isNotEmpty) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      for (Storage storage in state.storages)
                        Column(
                          children: [
                            StorageListView(
                              storage: storage,
                              homeStorageBloc: storageBloc,
                              storages: state.storages,
                              isSearch: true,
                              keyword: query,
                            ),
                          ],
                        ),
                      const SizedBox(height: 80),
                    ],
                  ),
                );
              } else {
                return const Center(child: Text("No storages found"));
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

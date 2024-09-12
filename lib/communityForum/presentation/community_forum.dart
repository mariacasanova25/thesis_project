import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thesis_project/communityForum/data/discussions_repository.dart';
import 'package:thesis_project/communityForum/domain/discussion.dart';
import 'package:thesis_project/communityForum/presentation/NewDiscussionButton.dart';
import 'package:thesis_project/communityForum/presentation/discussions_list.dart';

class CommunityForumScreen extends ConsumerStatefulWidget {
  const CommunityForumScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _CommunityForumScreenState();
  }
}

class _CommunityForumScreenState extends ConsumerState<CommunityForumScreen> {
  List<Discussion> _filteredDiscussions = [];
  List<Discussion> _allDiscussions = [];
  bool _isSearchBarVisible = false;
  final TextEditingController _searchController = TextEditingController();

  void _filterDiscussions(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredDiscussions = _allDiscussions;
      });
    } else {
      setState(() {
        _filteredDiscussions = _allDiscussions.where((discussion) {
          final queryLower = query.toLowerCase();
          final nameMatches =
              discussion.name.toLowerCase().contains(queryLower);

          return nameMatches;
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final discussionsAsync = ref.watch(watchDiscussionsProvider);
    return Scaffold(
      appBar: AppBar(
        title: _isSearchBarVisible
            ? TextField(
                controller: _searchController,
                onChanged: (query) => _filterDiscussions(query),
                decoration: InputDecoration(
                  hintText: 'Pesquisar...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.search),
                ),
              )
            : Text(
                "Discussões",
                style: TextStyle(
                  fontSize: 24,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(_isSearchBarVisible ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearchBarVisible = !_isSearchBarVisible;
                if (!_isSearchBarVisible) {
                  _searchController.clear();
                  _filterDiscussions('');
                }
              });
            },
          ),
        ],
      ),
      body: discussionsAsync.when(
        data: (discussions) {
          // Update the discussions list and reset filtered discussions when new data is available
          setState(() {
            _allDiscussions = discussions;
            _filteredDiscussions = discussions;
          });

          if (_filteredDiscussions.isEmpty) {
            return const Center(
              child: Text('Não foram encontradas discussões.'),
            );
          }
          return DiscussionsList(discussions: _filteredDiscussions);
        },
        error: (error, _) => const Center(
          child: Text('Erro ao carregar discussões.'),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: const NewdiscussionButton(),
    );
  }
}

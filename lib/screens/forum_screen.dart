import 'package:flutter/material.dart';

class ForumScreen extends StatelessWidget {
  const ForumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forum'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreatePostDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildForumCategories(),
          const SizedBox(height: 16),
          Expanded(child: _buildForumPosts()),
        ],
      ),
    );
  }

  Widget _buildForumCategories() {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildCategoryChip('All', true),
          _buildCategoryChip('Stocks', false),
          _buildCategoryChip('Mutual Funds', false),
          _buildCategoryChip('F&O', false),
          _buildCategoryChip('Crypto', false),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {},
      ),
    );
  }

  Widget _buildForumPosts() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.forum, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('No forum posts'),
          Text('Start a discussion to engage with the community'),
        ],
      ),
    );
  }

  void _showCreatePostDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Post'),
        content: const Text('Forum post creation coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

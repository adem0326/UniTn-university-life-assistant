import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  String _filter = 'Posts';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        actions: [
          IconButton(
            tooltip: 'Search saved items',
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'Posts', label: Text('Posts')),
              ButtonSegment(value: 'Marketplace', label: Text('Marketplace')),
            ],
            selected: {_filter},
            onSelectionChanged: (value) {
              setState(() => _filter = value.first);
            },
            showSelectedIcon: false,
          ),
          const SizedBox(height: 16),
          if (_filter == 'Posts') ...[
            _SavedPostCard(
              author: 'Elena Rostova',
              university: 'MIT',
              title: 'Simplified Backpropagation through time for LSTM architectures',
              attachment: 'LSTM_Backprop_Notes_v2.pdf',
            ),
            const SizedBox(height: 12),
            _SavedPostCard(
              author: 'Marcus Chen',
              university: 'UC Berkeley',
              title: 'CalHacks frontend and UI/UX teammate search',
              attachment: 'Team brief',
            ),
          ] else ...[
            const _SavedMarketplaceCard(
              title: 'Calculus textbook',
              price: '\$32',
              location: 'Stanford',
              icon: Icons.menu_book_outlined,
            ),
            const SizedBox(height: 12),
            const _SavedMarketplaceCard(
              title: 'Mechanical keyboard',
              price: '\$55',
              location: 'MIT',
              icon: Icons.keyboard_outlined,
            ),
          ],
        ],
      ),
    );
  }
}

class _SavedPostCard extends StatelessWidget {
  const _SavedPostCard({
    required this.author,
    required this.university,
    required this.title,
    required this.attachment,
  });

  final String author;
  final String university;
  final String title;
  final String attachment;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primaryContainer,
                  child: Icon(Icons.person, size: 20, color: AppColors.primary),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        author,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Text(
                        university,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Remove bookmark',
                  onPressed: () {},
                  icon: const Icon(Icons.bookmark, color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(title, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.attach_file, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      attachment,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SavedMarketplaceCard extends StatelessWidget {
  const _SavedMarketplaceCard({
    required this.title,
    required this.price,
    required this.location,
    required this.icon,
  });

  final String title;
  final String price;
  final String location;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Container(
            width: 96,
            height: 96,
            color: AppColors.primaryContainer,
            child: Icon(icon, size: 44, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 6),
                Text(
                  price,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(location, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Remove bookmark',
            onPressed: () {},
            icon: const Icon(Icons.bookmark, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

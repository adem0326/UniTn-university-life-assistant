import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/photo_attachment_picker.dart';
import '../../../messaging/presentation/pages/conversations_page.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  String _category = 'All';
  final Set<int> _saved = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace'),
        actions: [
          IconButton(
            tooltip: 'Search',
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          Text(
            'Student essentials',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 4),
          const Text(
            'Buy and sell with students across campuses',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final category in [
                  'All',
                  'Textbooks',
                  'Electronics',
                  'Furniture',
                  'Services',
                ]) ...[
                  ChoiceChip(
                    label: Text(category),
                    selected: _category == category,
                    onSelected: (_) {
                      setState(() => _category = category);
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.72,
            ),
            itemCount: _items.length,
            itemBuilder: (context, index) {
              final item = _items[index];
              return _MarketplaceCard(
                item: item,
                saved: _saved.contains(index),
                onSave: () {
                  setState(() {
                    if (_saved.contains(index)) {
                      _saved.remove(index);
                    } else {
                      _saved.add(index);
                    }
                  });
                },
                onOpen: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => MarketplaceDetailPage(item: item),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('publish_marketplace_item'),
        onPressed: _openPublishSheet,
        icon: const Icon(Icons.add),
        label: const Text('Sell item'),
      ),
    );
  }

  Future<void> _openPublishSheet() {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const _PublishItemSheet(),
    );
  }
}

class MarketplaceItem {
  const MarketplaceItem({
    required this.title,
    required this.category,
    required this.price,
    required this.location,
    required this.icon,
  });

  final String title;
  final String category;
  final String price;
  final String location;
  final IconData icon;
}

const _items = [
  MarketplaceItem(
    title: 'Calculus textbook',
    category: 'Textbooks',
    price: '\$32',
    location: 'Stanford',
    icon: Icons.menu_book_outlined,
  ),
  MarketplaceItem(
    title: 'Mechanical keyboard',
    category: 'Electronics',
    price: '\$55',
    location: 'MIT',
    icon: Icons.keyboard_outlined,
  ),
  MarketplaceItem(
    title: 'Desk lamp',
    category: 'Furniture',
    price: '\$18',
    location: 'UC Berkeley',
    icon: Icons.lightbulb_outline,
  ),
  MarketplaceItem(
    title: 'Calculus tutoring',
    category: 'Services',
    price: '\$20/hr',
    location: 'Stanford',
    icon: Icons.school_outlined,
  ),
];

class _MarketplaceCard extends StatelessWidget {
  const _MarketplaceCard({
    required this.item,
    required this.saved,
    required this.onSave,
    required this.onOpen,
  });

  final MarketplaceItem item;
  final bool saved;
  final VoidCallback onSave;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: AppColors.primaryContainer,
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        item.icon,
                        size: 52,
                        color: AppColors.primary,
                      ),
                    ),
                    Positioned(
                      right: 6,
                      top: 6,
                      child: IconButton(
                        onPressed: onSave,
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.surface,
                        ),
                        icon: Icon(
                          saved ? Icons.bookmark : Icons.bookmark_border,
                          color: saved ? AppColors.primary : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    item.price,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.location,
                    style: Theme.of(context).textTheme.bodySmall,
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

class MarketplaceDetailPage extends StatelessWidget {
  const MarketplaceDetailPage({super.key, required this.item});

  final MarketplaceItem item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item details'),
        actions: [
          IconButton(
            tooltip: 'Save',
            onPressed: () {},
            icon: const Icon(Icons.bookmark_border),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(item.icon, size: 96, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text(item.title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 6),
          Text(
            item.price,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceSoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: AppColors.primaryContainer,
                  child: Icon(Icons.person, color: AppColors.primary),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Jordan Davis',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'Verified student • ${item.location}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.verified, color: AppColors.primary),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('Description', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text(
            'Well-maintained and ready for a new student owner. Available for pickup on campus. Contact the seller for condition details or meetup arrangements.',
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => ChatPage(
                    name: 'Jordan Davis',
                    subtitle: 'Verified student • ${item.location}',
                  ),
                ),
              );
            },
            icon: const Icon(Icons.chat_bubble_outline),
            label: const Text('Contact seller'),
          ),
        ],
      ),
    );
  }
}

class _PublishItemSheet extends StatefulWidget {
  const _PublishItemSheet();

  @override
  State<_PublishItemSheet> createState() => _PublishItemSheetState();
}

class _PublishItemSheetState extends State<_PublishItemSheet> {
  String _category = 'Textbooks';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Publish item',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  tooltip: 'Close',
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const TextField(
              key: Key('item_title_field'),
              decoration: InputDecoration(labelText: 'Item title'),
            ),
            const SizedBox(height: 12),
            const TextField(
              decoration: InputDecoration(labelText: 'Price', hintText: '\$'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _category,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Category'),
              items: const ['Textbooks', 'Electronics', 'Furniture', 'Services']
                  .map(
                    (value) =>
                        DropdownMenuItem(value: value, child: Text(value)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() => _category = value ?? _category);
              },
            ),
            const SizedBox(height: 12),
            const TextField(
              maxLines: 4,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 16),
            const PhotoAttachmentPicker(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Publish item'),
            ),
          ],
        ),
      ),
    );
  }
}

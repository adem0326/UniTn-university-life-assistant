import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/photo_attachment_picker.dart';
import '../../../messaging/presentation/pages/conversations_page.dart';

class LostAndFoundPage extends StatefulWidget {
  const LostAndFoundPage({super.key});

  @override
  State<LostAndFoundPage> createState() => _LostAndFoundPageState();
}

class _LostAndFoundPageState extends State<LostAndFoundPage> {
  String _filter = 'All';

  List<CampusItem> get _visibleItems {
    if (_filter == 'Lost') {
      return _items.where((item) => item.type == CampusItemType.lost).toList();
    }
    if (_filter == 'Found') {
      return _items.where((item) => item.type == CampusItemType.found).toList();
    }
    return _items;
  }

  @override
  Widget build(BuildContext context) {
    final items = _visibleItems;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lost & Found'),
        actions: [
          IconButton(
            tooltip: 'Search items',
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Text(
            'Help campus items find their way home.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'All', label: Text('All')),
              ButtonSegment(value: 'Lost', label: Text('Lost')),
              ButtonSegment(value: 'Found', label: Text('Found')),
            ],
            selected: {_filter},
            onSelectionChanged: (value) {
              setState(() => _filter = value.first);
            },
            showSelectedIcon: false,
          ),
          const SizedBox(height: 16),
          Text(
            '${items.length} ${items.length == 1 ? 'item' : 'items'} nearby',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 10),
          for (final item in items) ...[
            _CampusItemCard(
              item: item,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => LostFoundDetailPage(item: item),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
          ],
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 48),
              child: Center(child: Text('No items in this category yet.')),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('report_lost_found_item'),
        onPressed: _openReportSheet,
        icon: const Icon(Icons.add),
        label: const Text('Report item'),
      ),
    );
  }

  Future<void> _openReportSheet() {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const _ReportItemSheet(),
    );
  }
}

enum CampusItemType { lost, found }

class CampusItem {
  const CampusItem({
    required this.id,
    required this.type,
    required this.title,
    required this.category,
    required this.location,
    required this.time,
    required this.description,
    required this.icon,
    required this.reporter,
  });

  final int id;
  final CampusItemType type;
  final String title;
  final String category;
  final String location;
  final String time;
  final String description;
  final IconData icon;
  final String reporter;

  String get statusLabel => type == CampusItemType.lost ? 'LOST' : 'FOUND';
}

const _items = [
  CampusItem(
    id: 1,
    type: CampusItemType.lost,
    title: 'Blue water bottle',
    category: 'Personal items',
    location: 'Green Library, 2nd floor',
    time: 'Today • 10:30 AM',
    description: 'A blue insulated bottle with a small white mountain sticker. Last seen near the study tables on the second floor.',
    icon: Icons.water_drop_outlined,
    reporter: 'Alex Morgan',
  ),
  CampusItem(
    id: 2,
    type: CampusItemType.found,
    title: 'Student ID card',
    category: 'Cards & IDs',
    location: 'Main Quad, near the fountain',
    time: 'Today • 9:15 AM',
    description: 'Found a student ID near the fountain. The card is safe with campus lost property; message me with identifying details to arrange pickup.',
    icon: Icons.badge_outlined,
    reporter: 'Jordan Davis',
  ),
  CampusItem(
    id: 3,
    type: CampusItemType.lost,
    title: 'Black wireless earbuds',
    category: 'Electronics',
    location: 'Engineering building, Room 204',
    time: 'Yesterday • 4:45 PM',
    description: 'Black earbuds in a charging case, possibly left in the afternoon lecture room.',
    icon: Icons.headphones_outlined,
    reporter: 'Maya Patel',
  ),
];

class _CampusItemCard extends StatelessWidget {
  const _CampusItemCard({required this.item, required this.onTap});

  final CampusItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isLost = item.type == CampusItemType.lost;
    final statusColor = isLost ? AppColors.danger : AppColors.cyan;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(item.icon, color: AppColors.primary, size: 32),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            item.statusLabel,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        Text(
                          item.category,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 15,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            item.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.time,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

class LostFoundDetailPage extends StatelessWidget {
  const LostFoundDetailPage({super.key, required this.item});

  final CampusItem item;

  @override
  Widget build(BuildContext context) {
    final isLost = item.type == CampusItemType.lost;
    return Scaffold(
      appBar: AppBar(title: const Text('Item details')),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isLost
                      ? AppColors.danger.withValues(alpha: 0.12)
                      : AppColors.cyan.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  item.statusLabel,
                  style: TextStyle(
                    color: isLost ? AppColors.danger : AppColors.cyan,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(item.category),
            ],
          ),
          const SizedBox(height: 10),
          Text(item.title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          _DetailInfoRow(
            icon: Icons.location_on_outlined,
            value: item.location,
          ),
          const SizedBox(height: 8),
          _DetailInfoRow(icon: Icons.access_time, value: item.time),
          const SizedBox(height: 16),
          Text('Description', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 6),
          Text(item.description),
          const SizedBox(height: 18),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(
              backgroundColor: AppColors.primaryContainer,
              child: Icon(Icons.person, color: AppColors.primary),
            ),
            title: Text(item.reporter),
            subtitle: const Text('Student • Community member'),
            trailing: const Icon(
              Icons.verified_outlined,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            key: const Key('contact_item_reporter'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => ChatPage(
                    name: item.reporter,
                    subtitle: 'Lost & Found • ${item.location}',
                  ),
                ),
              );
            },
            icon: const Icon(Icons.chat_bubble_outline),
            label: Text(isLost ? 'I found this item' : 'Contact finder'),
          ),
          if (isLost) ...[
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.place_outlined),
              label: const Text('View location'),
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailInfoRow extends StatelessWidget {
  const _DetailInfoRow({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(child: Text(value)),
      ],
    );
  }
}

class _ReportItemSheet extends StatefulWidget {
  const _ReportItemSheet();

  @override
  State<_ReportItemSheet> createState() => _ReportItemSheetState();
}

class _ReportItemSheetState extends State<_ReportItemSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _type = 'Lost';
  String _category = 'Personal items';

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Report an item',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
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
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'Lost', label: Text('I lost something')),
                  ButtonSegment(
                    value: 'Found',
                    label: Text('I found something'),
                  ),
                ],
                selected: {_type},
                onSelectionChanged: (value) {
                  setState(() => _type = value.first);
                },
                showSelectedIcon: false,
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const Key('lost_found_title_field'),
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Item name'),
                validator: _requiredValidator,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _category,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Category'),
                items:
                    const [
                          'Personal items',
                          'Cards & IDs',
                          'Electronics',
                          'Books & notes',
                          'Clothing',
                          'Other',
                        ]
                        .map(
                          (value) => DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() => _category = value ?? _category);
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Campus location',
                  hintText: 'Building, room, or nearby landmark',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
                validator: _requiredValidator,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Add details that help identify the item',
                ),
              ),
              const SizedBox(height: 12),
              const PhotoAttachmentPicker(),
              const SizedBox(height: 12),
              ElevatedButton(
                key: const Key('submit_lost_found_report'),
                onPressed: _submit,
                child: Text('Publish ${_type.toLowerCase()} report'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop();
  }
}

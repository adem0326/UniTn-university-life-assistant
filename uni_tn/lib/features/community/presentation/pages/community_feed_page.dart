import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../messaging/presentation/pages/conversations_page.dart';

class CommunityFeedPage extends StatefulWidget {
  const CommunityFeedPage({super.key});

  @override
  State<CommunityFeedPage> createState() => _CommunityFeedPageState();
}

class _CommunityFeedPageState extends State<CommunityFeedPage> {
  String _universityFilter = 'All Universities';
  String _feedFilter = 'Trending';
  final Set<int> _likedPosts = {};
  final Set<int> _savedPosts = {};
  final List<String> _createdPosts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'SmartCampus',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text('Community', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  label: 'All Universities',
                  icon: Icons.public,
                  selected: _universityFilter == 'All Universities',
                  onTap: () =>
                      setState(() => _universityFilter = 'All Universities'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Stanford',
                  selected: _universityFilter == 'Stanford',
                  onTap: () => setState(() => _universityFilter = 'Stanford'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'MIT',
                  selected: _universityFilter == 'MIT',
                  onTap: () => setState(() => _universityFilter = 'MIT'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'UC Berkeley',
                  selected: _universityFilter == 'UC Berkeley',
                  onTap: () =>
                      setState(() => _universityFilter = 'UC Berkeley'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _openComposer,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: AppColors.primaryContainer,
                            child: Icon(Icons.person, color: AppColors.primary),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Share something with peers...',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ),
                          Icon(Icons.edit_outlined, color: AppColors.primary),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: _ComposerAction(
                          icon: Icons.image_outlined,
                          label: 'Photo',
                          onTap: _openComposer,
                        ),
                      ),
                      Expanded(
                        child: _ComposerAction(
                          icon: Icons.data_object,
                          label: 'Document/Code',
                          onTap: _openComposer,
                        ),
                      ),
                      Expanded(
                        child: _ComposerAction(
                          icon: Icons.poll_outlined,
                          label: 'Poll',
                          onTap: _openComposer,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final label in [
                  'Trending',
                  'My University',
                  'Study Groups',
                  'Discussions',
                ]) ...[
                  ChoiceChip(
                    label: Text(label),
                    selected: _feedFilter == label,
                    onSelected: (_) => setState(() => _feedFilter = label),
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          for (final post in _createdPosts)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _CreatedPostCard(body: post),
            ),
          _PostCard(
            author: 'Elena Rostova',
            university: 'MIT',
            field: 'Electrical Eng & CS',
            time: '15m ago',
            tags: const ['#MachineLearning', '#NeuralNets'],
            body: 'Has anyone simplified Backpropagation through time (BPTT) for LSTM architectures? Sharing my summarized notes below if anyone wants to review before next week\'s exam!',
            attachmentTitle: 'LSTM_Backprop_Notes_v2.pdf',
            attachmentDetails: '1.4 MB • 6 pages',
            likes: 142,
            comments: 28,
            saved: _savedPosts.contains(0),
            liked: _likedPosts.contains(0),
            onLike: () => setState(() => _toggleSet(_likedPosts, 0)),
            onSave: () => setState(() => _toggleSet(_savedPosts, 0)),
          ),
          const SizedBox(height: 12),
          _RecruitmentPostCard(
            liked: _likedPosts.contains(1),
            saved: _savedPosts.contains(1),
            onLike: () => setState(() => _toggleSet(_likedPosts, 1)),
            onSave: () => setState(() => _toggleSet(_savedPosts, 1)),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('community_create_post'),
        tooltip: 'Create post',
        onPressed: _openComposer,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _toggleSet(Set<int> values, int value) {
    if (values.contains(value)) {
      values.remove(value);
    } else {
      values.add(value);
    }
  }

  Future<void> _openComposer() async {
    final post = await showDialog<String>(
      context: context,
      useRootNavigator: true,
      builder: (context) {
        final media = MediaQuery.of(context);
        final availableHeight =
            media.size.height - media.viewInsets.bottom - 48;
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          child: SizedBox(
            width: math.min(media.size.width - 40, 480),
            height: math.min(520, availableHeight * 0.85),
            child: const _PostComposerDialog(),
          ),
        );
      },
    );
    if (!mounted || post == null || post.trim().isEmpty) return;
    setState(() => _createdPosts.insert(0, post.trim()));
  }
}

class _CreatedPostCard extends StatefulWidget {
  const _CreatedPostCard({required this.body});

  final String body;

  @override
  State<_CreatedPostCard> createState() => _CreatedPostCardState();
}

class _CreatedPostCardState extends State<_CreatedPostCard> {
  bool _liked = false;
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primaryContainer,
                  child: Icon(Icons.person, color: AppColors.primary),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Alex Morgan',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text('Stanford • Just now'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(widget.body, key: const Key('published_post_content')),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  tooltip: 'Like post',
                  onPressed: () => setState(() => _liked = !_liked),
                  icon: Icon(
                    _liked ? Icons.favorite : Icons.favorite_border,
                    color: _liked ? AppColors.danger : null,
                  ),
                ),
                Text(_liked ? '1' : '0'),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'Comment',
                  onPressed: () {},
                  icon: const Icon(Icons.chat_bubble_outline),
                ),
                const Text('0'),
                const Spacer(),
                IconButton(
                  tooltip: 'Bookmark post',
                  onPressed: () => setState(() => _saved = !_saved),
                  icon: Icon(
                    _saved ? Icons.bookmark : Icons.bookmark_border,
                    color: _saved ? AppColors.primary : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(999),
          border: selected ? null : Border.all(color: AppColors.outline),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 18,
                color: selected ? AppColors.surface : AppColors.primary,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: selected ? AppColors.surface : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComposerAction extends StatelessWidget {
  const _ComposerAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: TextButton.styleFrom(foregroundColor: AppColors.primary),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({
    required this.author,
    required this.university,
    required this.field,
    required this.time,
    required this.tags,
    required this.body,
    required this.attachmentTitle,
    required this.attachmentDetails,
    required this.likes,
    required this.comments,
    required this.liked,
    required this.saved,
    required this.onLike,
    required this.onSave,
  });

  final String author;
  final String university;
  final String field;
  final String time;
  final List<String> tags;
  final String body;
  final String attachmentTitle;
  final String attachmentDetails;
  final int likes;
  final int comments;
  final bool liked;
  final bool saved;
  final VoidCallback onLike;
  final VoidCallback onSave;

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
                  backgroundColor: AppColors.primaryContainer,
                  child: Icon(Icons.person, color: AppColors.primary),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              author,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              university,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text('$field • $time'),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_horiz),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: tags
                  .map(
                    (tag) => Chip(
                      label: Text(tag),
                      visualDensity: VisualDensity.compact,
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 10),
            Text(body),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.picture_as_pdf_outlined,
                      color: AppColors.danger,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          attachmentTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        Text(
                          attachmentDetails,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.download_outlined,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  onPressed: onLike,
                  icon: Icon(
                    liked ? Icons.favorite : Icons.favorite_border,
                    color: liked ? AppColors.danger : null,
                  ),
                ),
                Text('$likes'),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.chat_bubble_outline),
                ),
                Text('$comments'),
                const Spacer(),
                IconButton(
                  onPressed: onSave,
                  icon: Icon(
                    saved ? Icons.bookmark : Icons.bookmark_border,
                    color: saved ? AppColors.primary : null,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.share_outlined),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RecruitmentPostCard extends StatelessWidget {
  const _RecruitmentPostCard({
    required this.liked,
    required this.saved,
    required this.onLike,
    required this.onSave,
  });

  final bool liked;
  final bool saved;
  final VoidCallback onLike;
  final VoidCallback onSave;

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
                  backgroundColor: AppColors.primaryContainer,
                  child: Text('MC'),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Marcus Chen',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'UC Berkeley',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Text('Data Science • Year 2 • 2h ago'),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFCCFBF1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'Recruiting',
                    style: TextStyle(
                      color: Color(0xFF0F766E),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                Chip(label: Text('#Hackathon')),
                Chip(label: Text('#LookingForTeammates')),
                Chip(label: Text('#CalHacks')),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Forming a 4-person team for CalHacks next weekend. Looking for 1 frontend developer and 1 UI/UX designer.',
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'TEAM COMPOSITION (2/4 FILLED)\nMarcus (Data/ML) • Aarav (Backend)\nFrontend (Open) • UI/UX (Open)',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  onPressed: onLike,
                  icon: Icon(
                    liked ? Icons.favorite : Icons.favorite_border,
                    color: liked ? AppColors.danger : null,
                  ),
                ),
                const Text('89'),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.chat_bubble_outline),
                ),
                const Text('14'),
                const Spacer(),
                IconButton(
                  onPressed: onSave,
                  icon: Icon(
                    saved ? Icons.bookmark : Icons.bookmark_border,
                    color: saved ? AppColors.primary : null,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const ChatPage(
                          name: 'Marcus Chen',
                          subtitle: 'UC Berkeley • Data Science',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.send_outlined),
                  label: const Text('Message'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PostComposerDialog extends StatefulWidget {
  const _PostComposerDialog();

  @override
  State<_PostComposerDialog> createState() => _PostComposerDialogState();
}

class _PostComposerDialogState extends State<_PostComposerDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                    'Create post',
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
            TextField(
              key: const Key('post_text_field'),
              controller: _controller,
              maxLines: 5,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: 'Share an update, resource, or question...',
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 4,
              runSpacing: 4,
              children: [
                IconButton(
                  tooltip: 'Add photo',
                  onPressed: () {},
                  icon: const Icon(Icons.image_outlined),
                ),
                IconButton(
                  tooltip: 'Add document',
                  onPressed: () {},
                  icon: const Icon(Icons.attach_file),
                ),
                IconButton(
                  tooltip: 'Create poll',
                  onPressed: () {},
                  icon: const Icon(Icons.poll_outlined),
                ),
                const SizedBox(width: 4),
                ElevatedButton(
                  key: const Key('publish_community_post'),
                  onPressed: _controller.text.trim().isEmpty
                      ? null
                      : () => Navigator.of(context).pop(_controller.text),
                  child: const Text('Publish'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../community/presentation/pages/community_feed_page.dart';
import '../../../bookmarks/presentation/pages/bookmarks_page.dart';
import '../../../marketplace/presentation/pages/marketplace_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../study_groups/presentation/pages/study_groups_page.dart';
import '../../../lost_and_found/presentation/pages/lost_and_found_page.dart';

class HomeDashboardPage extends StatelessWidget {
  const HomeDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SmartCampus',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text('Home'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const ProfilePage()),
                );
              },
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primaryContainer,
                child: Icon(Icons.person, color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          Text(
            'Good morning, Alex',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 4),
          const Text(
            'Stanford University • Computer Science (Year 3)',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, Color(0xFF1D4ED8)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.timer_outlined,
                    color: AppColors.surface,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MIDTERM IN 4 DAYS',
                        style: TextStyle(
                          color: AppColors.surface,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Distributed Systems\nCS244',
                        style: TextStyle(
                          color: AppColors.surface,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Room Packard 108 • 10:00 AM',
                        style: TextStyle(
                          color: AppColors.surface,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    backgroundColor: AppColors.surface,
                    shape: const StadiumBorder(),
                  ),
                  child: const Text('Syllabus'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Expanded(
                child: _MetricCard(
                  icon: Icons.school_outlined,
                  value: '3.84',
                  label: 'Cumulative GPA',
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _MetricCard(
                  icon: Icons.menu_book_outlined,
                  value: '16/18',
                  label: 'Credits enrolled',
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _MetricCard(
                  icon: Icons.local_fire_department_outlined,
                  value: '12 days',
                  label: 'Study streak',
                  amber: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Campus Quick Access',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              TextButton(onPressed: () {}, child: const Text('Edit Hub')),
            ],
          ),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.08,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _HubTile(
                icon: Icons.groups_outlined,
                label: 'Study Groups',
                badge: '3',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const StudyGroupsPage(),
                    ),
                  );
                },
              ),
              _HubTile(icon: Icons.folder_open_outlined, label: 'Resources'),
              _HubTile(
                icon: Icons.storefront_outlined,
                label: 'Marketplace',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const MarketplacePage(),
                    ),
                  );
                },
              ),
              _HubTile(icon: Icons.calendar_month_outlined, label: 'Events'),
              _HubTile(
                icon: Icons.travel_explore_outlined,
                label: 'Lost & Found',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const LostAndFoundPage(),
                    ),
                  );
                },
              ),
              _HubTile(
                icon: Icons.bookmark_border,
                label: 'Bookmarks',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const BookmarksPage(),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text(
                  "Today's Timeline",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  '3 items',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const _TimelineCard(
            time: '10:30 AM',
            title: 'Algorithms & Complexity',
            subtitle: 'Room Gates B12 • Lecture 14',
            color: AppColors.primary,
          ),
          const SizedBox(height: 8),
          const _TimelineCard(
            time: '02:00 PM',
            title: 'AI & Machine Learning Lab',
            subtitle: 'Huang Engineering Center D28',
            color: AppColors.secondary,
            trailing: 'Lab',
          ),
          const SizedBox(height: 8),
          const _TimelineCard(
            time: '11:59 PM',
            title: 'Database Assignment 3',
            subtitle: 'CS145 Canvas Upload',
            color: AppColors.danger,
            progress: true,
          ),
          const SizedBox(height: 20),
          Text(
            'Recommended for You',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.picture_as_pdf_outlined,
                  color: AppColors.primary,
                ),
              ),
              title: const Text(
                'CS161 Complete Midterm Cheat Sheet',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: const Text('★ 4.9 • 1.4k downloads'),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.download_outlined,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Community Pulse',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const CommunityFeedPage(),
                            ),
                          );
                        },
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '“Has anyone implemented Raft consensus with log compaction for Assignment 2?...”',
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Icon(Icons.favorite_border, size: 18),
                      SizedBox(width: 5),
                      Text('34'),
                      SizedBox(width: 16),
                      Icon(Icons.chat_bubble_outline, size: 18),
                      SizedBox(width: 5),
                      Text('19'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.value,
    required this.label,
    this.amber = false,
  });

  final IconData icon;
  final String value;
  final String label;
  final bool amber;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Column(
          children: [
            Icon(
              icon,
              color: amber ? AppColors.amber : AppColors.primary,
              size: 20,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _HubTile extends StatelessWidget {
  const _HubTile({
    required this.icon,
    required this.label,
    this.badge,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String? badge;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key('quick_access_$label'),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(icon, color: AppColors.primary),
                  if (badge != null)
                    Positioned(
                      right: -22,
                      top: -8,
                      child: Text(
                        badge!,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({
    required this.time,
    required this.title,
    required this.subtitle,
    required this.color,
    this.trailing,
    this.progress = false,
  });

  final String time;
  final String title;
  final String subtitle;
  final Color color;
  final String? trailing;
  final bool progress;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(16),
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 64,
              child: Text(
                time,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                        if (trailing != null)
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
                              trailing!,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (progress) ...[
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: 0.75,
                        borderRadius: BorderRadius.circular(999),
                        backgroundColor: AppColors.surfaceSoft,
                        color: AppColors.primary,
                        minHeight: 6,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

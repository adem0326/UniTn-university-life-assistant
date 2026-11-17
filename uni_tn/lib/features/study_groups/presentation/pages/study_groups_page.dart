import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../messaging/presentation/pages/conversations_page.dart';

class StudyGroupsPage extends StatefulWidget {
  const StudyGroupsPage({super.key});

  @override
  State<StudyGroupsPage> createState() => _StudyGroupsPageState();
}

class _StudyGroupsPageState extends State<StudyGroupsPage> {
  String _filter = 'Discover';
  final Set<int> _joined = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Groups'),
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
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'Discover', label: Text('Discover')),
              ButtonSegment(value: 'My Groups', label: Text('My Groups')),
            ],
            selected: {_filter},
            onSelectionChanged: (value) {
              setState(() => _filter = value.first);
            },
            showSelectedIcon: false,
          ),
          const SizedBox(height: 16),
          Text(
            _filter == 'Discover' ? 'Groups for you' : 'Your active groups',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < 4; i++) ...[
            _StudyGroupCard(
              index: i,
              title: _groupTitles[i],
              course: _courses[i],
              university: _universities[i],
              description: _descriptions[i],
              members: 8 + i * 3,
              joined: _joined.contains(i),
              onJoin: () {
                setState(() {
                  if (_joined.contains(i)) {
                    _joined.remove(i);
                  } else {
                    _joined.add(i);
                  }
                });
              },
              onOpen: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => StudyGroupDetailPage(
                      title: _groupTitles[i],
                      course: _courses[i],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('create_study_group'),
        onPressed: _openCreateSheet,
        icon: const Icon(Icons.add),
        label: const Text('Create group'),
      ),
    );
  }

  Future<void> _openCreateSheet() {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const _CreateGroupSheet(),
    );
  }
}

const _groupTitles = [
  'Distributed Systems Study Circle',
  'CS161 Midterm Prep',
  'CalHacks Project Team',
  'Linear Algebra Problem Sessions',
];

const _courses = ['CS244', 'CS161', 'Hackathon', 'MATH51'];

const _universities = ['Stanford', 'Stanford', 'UC Berkeley', 'MIT'];

const _descriptions = [
  'Weekly Raft, consistency, and replication sessions before the midterm.',
  'Solve exam-style problems and compare proofs in small groups.',
  'Building a Flutter campus app prototype over one focused weekend.',
  'Shared problem-set reviews and collaborative exam preparation.',
];

class _StudyGroupCard extends StatelessWidget {
  const _StudyGroupCard({
    required this.index,
    required this.title,
    required this.course,
    required this.university,
    required this.description,
    required this.members,
    required this.joined,
    required this.onJoin,
    required this.onOpen,
  });

  final int index;
  final String title;
  final String course;
  final String university;
  final String description;
  final int members;
  final bool joined;
  final VoidCallback onJoin;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.groups_outlined,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 6,
                          children: [
                            Text(
                              course,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '• $university',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(description),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.people_outline,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text('$members members'),
                  const Spacer(),
                  TextButton(
                    onPressed: onJoin,
                    style: TextButton.styleFrom(
                      foregroundColor: joined
                          ? AppColors.textSecondary
                          : AppColors.primary,
                      backgroundColor: joined
                          ? AppColors.surfaceSoft
                          : AppColors.primaryContainer,
                      shape: const StadiumBorder(),
                    ),
                    child: Text(joined ? 'Joined' : 'Join'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StudyGroupDetailPage extends StatelessWidget {
  const StudyGroupDetailPage({
    super.key,
    required this.title,
    required this.course,
  });

  final String title;
  final String course;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Group details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.groups_outlined,
                      color: AppColors.primary,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$course • 11 members',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'A collaborative study group for shared notes, practice problems, and weekly exam preparation.',
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => ChatPage(
                            name: title,
                            subtitle: '$course • 11 members',
                            group: true,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text('Open group chat'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Upcoming sessions',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          const _SessionTile(
            day: 'TUE',
            date: '21',
            title: 'Raft consensus review',
            time: '5:30 PM • Gates 104',
          ),
          const SizedBox(height: 8),
          const _SessionTile(
            day: 'SAT',
            date: '25',
            title: 'Midterm practice set',
            time: '10:00 AM • Online',
          ),
        ],
      ),
    );
  }
}

class _SessionTile extends StatelessWidget {
  const _SessionTile({
    required this.day,
    required this.date,
    required this.title,
    required this.time,
  });

  final String day;
  final String date;
  final String title;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                day,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(date, style: Theme.of(context).textTheme.labelLarge),
            ],
          ),
        ),
        title: Text(title),
        subtitle: Text(time),
      ),
    );
  }
}

class _CreateGroupSheet extends StatefulWidget {
  const _CreateGroupSheet();

  @override
  State<_CreateGroupSheet> createState() => _CreateGroupSheetState();
}

class _CreateGroupSheetState extends State<_CreateGroupSheet> {
  String _visibility = 'Public';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Create study group',
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
            key: Key('group_name_field'),
            decoration: InputDecoration(
              labelText: 'Group name',
              hintText: 'Distributed Systems Review',
            ),
          ),
          const SizedBox(height: 12),
          const TextField(
            decoration: InputDecoration(labelText: 'Course', hintText: 'CS244'),
          ),
          const SizedBox(height: 12),
          const TextField(
            maxLines: 3,
            decoration: InputDecoration(labelText: 'Description'),
          ),
          const SizedBox(height: 12),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'Public', label: Text('Public')),
              ButtonSegment(value: 'Private', label: Text('Private')),
            ],
            selected: {_visibility},
            onSelectionChanged: (value) {
              setState(() => _visibility = value.first);
            },
            showSelectedIcon: false,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Create group'),
          ),
        ],
      ),
    );
  }
}

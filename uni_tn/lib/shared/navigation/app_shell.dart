import 'package:flutter/material.dart';

import '../../features/ai_assistant/presentation/pages/ai_study_assistant_page.dart';
import '../../features/community/presentation/pages/community_feed_page.dart';
import '../../features/home/presentation/pages/home_dashboard_page.dart';
import '../../features/planner/presentation/pages/academic_planner_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  final _pages = const [
    HomeDashboardPage(),
    CommunityFeedPage(),
    AiStudyAssistantPage(),
    AcademicPlannerPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        key: const Key('app_bottom_navigation'),
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            key: Key('nav_home'),
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view),
            label: 'Home',
          ),
          NavigationDestination(
            key: Key('nav_community'),
            icon: Icon(Icons.groups_outlined),
            selectedIcon: Icon(Icons.groups),
            label: 'Community',
          ),
          NavigationDestination(
            key: Key('nav_ai'),
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome),
            label: 'AI Assist',
          ),
          NavigationDestination(
            key: Key('nav_planner'),
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Planner',
          ),
          NavigationDestination(
            key: Key('nav_profile'),
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

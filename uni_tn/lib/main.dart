import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'shared/navigation/app_shell.dart';
import 'features/ai_assistant/presentation/pages/ai_study_assistant_page.dart';
import 'features/community/presentation/pages/community_feed_page.dart';
import 'features/home/presentation/pages/home_dashboard_page.dart';
import 'features/profile/presentation/pages/edit_profile_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';
import 'features/marketplace/presentation/pages/marketplace_page.dart';
import 'features/planner/presentation/pages/academic_planner_page.dart';
import 'features/bookmarks/presentation/pages/bookmarks_page.dart';
import 'features/messaging/presentation/pages/conversations_page.dart';
import 'features/study_groups/presentation/pages/study_groups_page.dart';
import 'features/lost_and_found/presentation/pages/lost_and_found_page.dart';

void main() {
  runApp(const SmartCampusApp());
}

class SmartCampusApp extends StatelessWidget {
  const SmartCampusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartCampus',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const LoginPage(),
      routes: {
        '/app': (_) => const AppShell(),
        '/profile': (_) => const ProfilePage(),
        '/profile/edit': (_) => const EditProfilePage(),
        '/profile/create': (_) => const EditProfilePage(creatingProfile: true),
        '/community': (_) => const CommunityFeedPage(),
        '/home': (_) => const HomeDashboardPage(),
        '/study-groups': (_) => const StudyGroupsPage(),
        '/marketplace': (_) => const MarketplacePage(),
        '/planner': (_) => const AcademicPlannerPage(),
        '/bookmarks': (_) => const BookmarksPage(),
        '/ai-assistant': (_) => const AiStudyAssistantPage(),
        '/messages': (_) => const ConversationsPage(),
        '/lost-and-found': (_) => const LostAndFoundPage(),
      },
    );
  }
}

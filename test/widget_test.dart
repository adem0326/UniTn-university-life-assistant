import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:uni_tn/main.dart';
import 'package:uni_tn/features/community/presentation/pages/community_feed_page.dart';
import 'package:uni_tn/features/study_groups/presentation/pages/study_groups_page.dart';
import 'package:uni_tn/features/marketplace/presentation/pages/marketplace_page.dart';
import 'package:uni_tn/features/ai_assistant/presentation/pages/ai_study_assistant_page.dart';
import 'package:uni_tn/features/messaging/presentation/pages/conversations_page.dart';
import 'package:uni_tn/shared/navigation/app_shell.dart';
import 'package:uni_tn/features/bookmarks/presentation/pages/bookmarks_page.dart';
import 'package:uni_tn/features/lost_and_found/presentation/pages/lost_and_found_page.dart';
import 'package:uni_tn/features/planner/presentation/pages/academic_planner_page.dart';

void main() {
  testWidgets('App opens on the login interface', (tester) async {
    await tester.pumpWidget(const SmartCampusApp());
    await tester.pump();

    expect(find.text('SmartCampus'), findsOneWidget);
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Log in'), findsOneWidget);
  });

  testWidgets('Login navigates to signup and forgot password', (tester) async {
    await tester.binding.setSurfaceSize(const Size(412, 915));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const SmartCampusApp());

    final createAccount = find.byKey(const Key('create_account_button'));
    await tester.ensureVisible(createAccount);
    await tester.tap(createAccount);
    await tester.pumpAndSettle();
    expect(find.text('Join SmartCampus'), findsOneWidget);

    await tester.ensureVisible(find.text('Already have an account? Log in'));
    await tester.tap(find.text('Already have an account? Log in'));
    await tester.pumpAndSettle();
    final forgotPassword = find.byKey(const Key('forgot_password_button'));
    await tester.ensureVisible(forgotPassword);
    await tester.tap(forgotPassword);
    await tester.pumpAndSettle();
    expect(find.text('Reset password'), findsOneWidget);
  });

  testWidgets('Login opens profile and profile edit/logout work', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(412, 915));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const SmartCampusApp());

    await tester.ensureVisible(find.byKey(const Key('login_button')));
    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('nav_profile')));
    await tester.pumpAndSettle();
    expect(find.text('Alex Morgan'), findsOneWidget);

    await tester.ensureVisible(find.byKey(const Key('edit_profile_button')));
    await tester.tap(find.byKey(const Key('edit_profile_button')));
    await tester.pumpAndSettle();
    expect(find.text('Full name'), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('profile_page')), findsOneWidget);
    await tester.drag(find.byType(Scrollable).last, const Offset(0, -3000));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome back'), findsOneWidget);
  });

  testWidgets('Community feed opens and post composer works', (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const SmartCampusApp());

    await tester.pumpWidget(
      MaterialApp(theme: ThemeData(), home: const CommunityFeedPage()),
    );

    expect(find.text('Community'), findsOneWidget);
    expect(find.text('Elena Rostova'), findsOneWidget);

    await tester.tap(find.byKey(const Key('community_create_post')));
    await tester.pumpAndSettle();
    expect(find.text('Create post'), findsOneWidget);
    expect(find.byType(Dialog), findsOneWidget);
    expect(tester.getRect(find.text('Create post')).height, greaterThan(0));
    expect(tester.getRect(find.text('Create post')).top, lessThan(800));
    expect(find.byKey(const Key('post_text_field')), findsOneWidget);
    await tester.enterText(
      find.byKey(const Key('post_text_field')),
      'A community post from the composer',
    );
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('publish_community_post')));
    await tester.tap(find.byKey(const Key('publish_community_post')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('published_post_content')), findsOneWidget);
    expect(find.text('A community post from the composer'), findsOneWidget);
  });

  testWidgets('Login opens home dashboard', (tester) async {
    await tester.binding.setSurfaceSize(const Size(412, 915));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const SmartCampusApp());

    await tester.ensureVisible(find.byKey(const Key('login_button')));
    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pumpAndSettle();

    expect(find.text('Good morning, Alex'), findsOneWidget);
    expect(find.text('Campus Quick Access'), findsOneWidget);
    final studyGroups = tester.getRect(
      find.byKey(const Key('quick_access_Study Groups')),
    );
    final resources = tester.getRect(
      find.byKey(const Key('quick_access_Resources')),
    );
    final marketplace = tester.getRect(
      find.byKey(const Key('quick_access_Marketplace')),
    );
    final events = tester.getRect(find.byKey(const Key('quick_access_Events')));
    final lostAndFound = tester.getRect(
      find.byKey(const Key('quick_access_Lost & Found')),
    );
    final bookmarks = tester.getRect(
      find.byKey(const Key('quick_access_Bookmarks')),
    );
    expect(resources.left, greaterThan(studyGroups.left));
    expect(marketplace.left, greaterThan(resources.left));
    expect(events.top, greaterThan(studyGroups.top));
    expect(lostAndFound.top, events.top);
    expect(bookmarks.top, events.top);
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -800));
    await tester.pumpAndSettle();
    expect(find.text("Today's Timeline"), findsOneWidget);
  });

  testWidgets('Study groups open, join, and create', (tester) async {
    await tester.binding.setSurfaceSize(const Size(412, 915));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MaterialApp(home: StudyGroupsPage()));

    expect(find.text('Groups for you'), findsOneWidget);
    await tester.tap(find.text('Join').first);
    await tester.pump();
    expect(find.text('Joined'), findsOneWidget);

    await tester.tap(find.byKey(const Key('create_study_group')));
    await tester.pumpAndSettle();
    expect(find.text('Create study group'), findsOneWidget);
    expect(find.byKey(const Key('group_name_field')), findsOneWidget);
  });

  testWidgets('Marketplace opens, saves, opens detail, and publishes', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(412, 915));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MaterialApp(home: MarketplacePage()));

    expect(find.text('Student essentials'), findsOneWidget);
    expect(find.text('Calculus textbook'), findsOneWidget);

    await tester.tap(find.text('Calculus textbook'));
    await tester.pumpAndSettle();
    expect(find.text('Item details'), findsOneWidget);
    expect(find.text('Contact seller'), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('publish_marketplace_item')));
    await tester.pumpAndSettle();
    expect(find.text('Publish item'), findsWidgets);
    expect(find.byKey(const Key('item_title_field')), findsOneWidget);
    await tester.ensureVisible(find.byKey(const Key('add_photo_button')));
    await tester.tap(find.byKey(const Key('add_photo_button')));
    await tester.pumpAndSettle();
    expect(find.text('Choose from gallery'), findsOneWidget);
    expect(find.text('Take a photo'), findsOneWidget);
  });

  testWidgets('AI study assistant interface opens', (tester) async {
    await tester.binding.setSurfaceSize(const Size(412, 915));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MaterialApp(home: AiStudyAssistantPage()));

    expect(find.text('SmartCampus Copilot'), findsOneWidget);
    expect(find.text('Accelerated Study Modes'), findsOneWidget);
    expect(find.byKey(const Key('ai_prompt_field')), findsOneWidget);
  });

  testWidgets('Messaging list and private chat open', (tester) async {
    await tester.binding.setSurfaceSize(const Size(412, 915));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MaterialApp(home: ConversationsPage()));

    expect(find.text('Elena Rostova'), findsOneWidget);
    await tester.tap(find.text('Elena Rostova'));
    await tester.pumpAndSettle();
    expect(find.text('Write a message...'), findsOneWidget);
    expect(find.byKey(const Key('chat_message_field')), findsOneWidget);
  });

  testWidgets('Bottom navigation switches main sections', (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MaterialApp(home: AppShell()));

    expect(find.text('Good morning, Alex'), findsOneWidget);
    await tester.tap(find.byKey(const Key('nav_community')));
    await tester.pumpAndSettle();
    expect(find.text('Share something with peers...'), findsOneWidget);
    await tester.tap(find.byKey(const Key('community_create_post')));
    await tester.pumpAndSettle();
    expect(find.text('Create post'), findsOneWidget);
    expect(find.byType(Dialog), findsOneWidget);
    await tester.enterText(
      find.byKey(const Key('post_text_field')),
      'Post published from the Community plus',
    );
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('publish_community_post')));
    await tester.tap(find.byKey(const Key('publish_community_post')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('published_post_content')), findsOneWidget);
    expect(find.text('Post published from the Community plus'), findsOneWidget);
    await tester.tap(find.byKey(const Key('nav_planner')));
    await tester.pumpAndSettle();
    expect(find.text('Academic Planner'), findsOneWidget);
    await tester.tap(find.byKey(const Key('nav_profile')));
    await tester.pumpAndSettle();
    expect(find.text('Alex Morgan'), findsOneWidget);
  });

  testWidgets(
    'Planner adds an item and supports date, view, filter, and tasks',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(412, 915));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const MaterialApp(home: AcademicPlannerPage()));

      await tester.tap(find.byKey(const Key('planner_add_event')));
      await tester.pumpAndSettle();
      expect(find.text('Add planner item'), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('planner_event_title')),
        'Review lecture notes',
      );
      tester.testTextInput.hide();
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const Key('planner_event_save')));
      await tester.tap(find.byKey(const Key('planner_event_save')));
      await tester.pumpAndSettle();

      expect(find.text('Add planner item'), findsNothing);
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -600));
      await tester.pumpAndSettle();
      expect(find.text('Review lecture notes'), findsNWidgets(2));
      final completion = find.byKey(const Key('planner_complete_6'));
      expect(completion, findsOneWidget);
      await tester.tap(completion);
      await tester.pumpAndSettle();
      expect(tester.widget<Checkbox>(completion).value, isTrue);

      await tester.drag(find.byType(Scrollable).first, const Offset(0, 1000));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Agenda'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Exams'));
      await tester.pumpAndSettle();
      expect(find.text('Operating Systems Midterm'), findsOneWidget);

      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Month'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('planner_month_date_17_10')), findsOneWidget);
      await tester.tap(find.byKey(const Key('planner_month_date_17_10')));
      await tester.pumpAndSettle();
      expect(find.text('Thu, Oct 17'), findsOneWidget);

      await tester.tap(find.text('Week'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('planner_next_week')));
      await tester.pumpAndSettle();
      expect(find.text('Thu, Oct 24'), findsOneWidget);
    },
  );

  testWidgets('Bookmarks switch posts and marketplace', (tester) async {
    await tester.binding.setSurfaceSize(const Size(412, 915));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MaterialApp(home: BookmarksPage()));

    expect(find.text('Elena Rostova'), findsOneWidget);
    await tester.tap(find.text('Marketplace'));
    await tester.pumpAndSettle();
    expect(find.text('Calculus textbook'), findsOneWidget);
  });

  testWidgets('Lost and Found filters, details, and report form work', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(412, 915));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MaterialApp(home: LostAndFoundPage()));

    expect(find.text('Blue water bottle'), findsOneWidget);
    await tester.tap(find.text('Found'));
    await tester.pumpAndSettle();
    expect(find.text('Student ID card'), findsOneWidget);
    expect(find.text('Blue water bottle'), findsNothing);

    await tester.tap(find.text('Student ID card'));
    await tester.pumpAndSettle();
    expect(find.text('Contact finder'), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('report_lost_found_item')));
    await tester.pumpAndSettle();
    expect(find.text('Report an item'), findsOneWidget);
    expect(find.byKey(const Key('lost_found_title_field')), findsOneWidget);
    await tester.tap(find.byKey(const Key('add_photo_button')));
    await tester.pumpAndSettle();
    expect(find.text('Choose from gallery'), findsOneWidget);
    expect(find.text('Take a photo'), findsOneWidget);
  });
}

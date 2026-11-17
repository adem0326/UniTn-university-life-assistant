import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/pages/login_page.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _deadlineAlerts = true;
  bool _aiSuggestions = true;
  bool _mentions = true;
  bool _emergencyNotices = true;
  bool _biometricLock = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('profile_page'),
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const CircleAvatar(
                        radius: 48,
                        backgroundColor: AppColors.primaryContainer,
                        child: Icon(
                          Icons.person,
                          size: 52,
                          color: AppColors.primary,
                        ),
                      ),
                      Positioned(
                        right: -2,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.photo_camera_outlined,
                            size: 16,
                            color: AppColors.surface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Alex Morgan',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Stanford University • Computer Science (B.S.)',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Junior • Fall 2026',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'CS & HCI at Stanford. Building open-source study tools.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    key: const Key('edit_profile_button'),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const EditProfilePage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit profile'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const _MetricRow(),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Academic Records',
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                'REGISTRAR VERIFIED',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            children: const [
              _InfoTile(
                icon: Icons.badge_outlined,
                title: 'Student Identification',
                subtitle: 'SU-9482014',
              ),
              _InfoTile(
                icon: Icons.person_outline,
                title: 'Academic Advisor',
                subtitle: 'Prof. Keith Schwarz',
              ),
              _InfoTile(
                icon: Icons.calendar_month_outlined,
                title: 'Expected Graduation',
                subtitle: 'June 2026 • Spring Commencement',
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Notification Preferences',
            trailing: const Text(
              'Instant push',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            children: [
              _SwitchTile(
                title: 'Deadline & exam alerts',
                subtitle: 'Critical 24h & 2h countdown reminders',
                value: _deadlineAlerts,
                onChanged: (value) => setState(() => _deadlineAlerts = value),
              ),
              _SwitchTile(
                title: 'AI study copilot suggestions',
                subtitle: 'Spaced repetition prompts & quiz synthesis',
                value: _aiSuggestions,
                onChanged: (value) => setState(() => _aiSuggestions = value),
              ),
              _SwitchTile(
                title: 'Mentions & group chats',
                subtitle: 'Activity inside study circles',
                value: _mentions,
                onChanged: (value) => setState(() => _mentions = value),
              ),
              _SwitchTile(
                title: 'Emergency & university notices',
                subtitle: 'Mandatory university safety broadcasts',
                value: _emergencyNotices,
                onChanged: (value) => setState(() => _emergencyNotices = value),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Security & Integrations',
            trailing: const Text(
              'Protected',
              style: TextStyle(
                color: AppColors.cyan,
                fontWeight: FontWeight.w600,
              ),
            ),
            children: [
              const _InfoTile(
                icon: Icons.school_outlined,
                title: 'Stanford Single Sign-On',
                subtitle: 'alex.morgan@stanford.edu',
                active: true,
              ),
              const _InfoTile(
                icon: Icons.security_outlined,
                title: 'Two-factor authentication',
                subtitle: 'Authenticator app configured',
              ),
              _SwitchTile(
                title: 'Biometric app lock',
                subtitle: 'Face ID / Touch ID on resume',
                value: _biometricLock,
                onChanged: (value) => setState(() => _biometricLock = value),
              ),
            ],
          ),
          const SizedBox(height: 24),
          OutlinedButton(
            key: const Key('logout_button'),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute<void>(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.danger,
              side: const BorderSide(color: Color(0xFFFECACA)),
            ),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MetricCard(
            icon: Icons.trending_up,
            value: '3.84',
            label: 'Cumulative GPA',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MetricCard(
            icon: Icons.menu_book_outlined,
            value: '16 / 18',
            label: 'Units enrolled',
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 4),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.children,
    this.trailing,
  });

  final String title;
  final List<Widget> children;
  final Widget? trailing;

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
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                ?trailing,
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.active = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: active
          ? Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.cyan,
                shape: BoxShape.circle,
              ),
            )
          : null,
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, this.creatingProfile = false});

  final bool creatingProfile;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String? _university;
  String? _field;
  String? _level;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(widget.creatingProfile ? 'Create profile' : 'Edit profile'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const CircleAvatar(
                    radius: 52,
                    backgroundColor: AppColors.primaryContainer,
                    child: Icon(
                      Icons.person,
                      size: 56,
                      color: AppColors.primary,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        tooltip: 'Change profile photo',
                        onPressed: () {},
                        icon: const Icon(
                          Icons.photo_camera_outlined,
                          color: AppColors.surface,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            _ProfileTextField(
              label: 'Full name',
              initialValue: 'Alex Morgan',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            _ProfileDropdown(
              label: 'University',
              value: _university ?? 'Stanford University',
              items: const ['Stanford University', 'MIT', 'UC Berkeley'],
              onChanged: (value) => setState(() => _university = value),
            ),
            const SizedBox(height: 16),
            _ProfileDropdown(
              label: 'Field of study',
              value: _field ?? 'Computer Science',
              items: const [
                'Computer Science',
                'Electrical Engineering',
                'Data Science',
                'Business',
              ],
              onChanged: (value) => setState(() => _field = value),
            ),
            const SizedBox(height: 16),
            _ProfileDropdown(
              label: 'Academic level',
              value: _level ?? 'Junior',
              items: const [
                'Freshman',
                'Sophomore',
                'Junior',
                'Senior',
                'Graduate',
              ],
              onChanged: (value) => setState(() => _level = value),
            ),
            const SizedBox(height: 16),
            _ProfileTextField(
              label: 'Bio',
              initialValue:
                  'CS & HCI at Stanford. Building open-source study tools.',
              icon: Icons.notes_outlined,
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/profile', (route) => false);
              },
              child: Text(
                widget.creatingProfile ? 'Create profile' : 'Save changes',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTextField extends StatelessWidget {
  const _ProfileTextField({
    required this.label,
    required this.initialValue,
    required this.icon,
    this.maxLines = 1,
  });

  final String label;
  final String initialValue;
  final IconData icon;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}

class _ProfileDropdown extends StatelessWidget {
  const _ProfileDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          isDense: true,
          isExpanded: true,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 12),
          ),
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

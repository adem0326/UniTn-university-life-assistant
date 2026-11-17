import 'package:flutter/material.dart';

import '../../../profile/presentation/pages/edit_profile_page.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_text_field.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _obscurePassword = true;
  bool _acceptedTerms = false;

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Join SmartCampus',
      subtitle: 'Create your student account',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthTextField(
            label: 'Full name',
            hint: 'Your name',
            icon: Icons.person_outline,
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 16),
          const AuthTextField(
            label: 'University email',
            hint: 'student@university.edu',
            icon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          const AuthTextField(
            label: 'University',
            hint: 'Select your university',
            icon: Icons.account_balance_outlined,
          ),
          const SizedBox(height: 16),
          AuthTextField(
            label: 'Password',
            hint: 'Create a secure password',
            icon: Icons.lock_outline,
            obscureText: _obscurePassword,
            suffix: IconButton(
              tooltip: _obscurePassword ? 'Show password' : 'Hide password',
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
            ),
          ),
          const SizedBox(height: 12),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            value: _acceptedTerms,
            onChanged: (value) {
              setState(() {
                _acceptedTerms = value ?? false;
              });
            },
            title: const Text(
              'I am a student and agree to the Terms of Service and Privacy Policy.',
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            key: const Key('signup_create_button'),
            onPressed: _acceptedTerms
                ? () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            const EditProfilePage(creatingProfile: true),
                      ),
                    );
                  }
                : null,
            child: const Text('Create account'),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Already have an account? Log in'),
          ),
        ],
      ),
    );
  }
}

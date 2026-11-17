import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/navigation/app_shell.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_text_field.dart';
import 'forgot_password_page.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Welcome back',
      subtitle: 'Continue to your university community',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthTextField(
            label: 'University email',
            hint: 'student@university.edu',
            icon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          AuthTextField(
            label: 'Password',
            hint: 'Enter your password',
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
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              key: const Key('forgot_password_button'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const ForgotPasswordPage(),
                  ),
                );
              },
              child: const Text('Forgot password?'),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            key: const Key('login_button'),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(builder: (_) => const AppShell()),
              );
            },
            child: const Text('Log in'),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'OR',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.school_outlined),
            label: const Text('Continue with university SSO'),
          ),
          const SizedBox(height: 24),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 4,
            runSpacing: 0,
            children: [
              const Text("Don't have an account?"),
              TextButton(
                key: const Key('create_account_button'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const SignupPage()),
                  );
                },
                child: const Text(
                  'Create account',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

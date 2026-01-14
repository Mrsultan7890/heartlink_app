import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'HeartLink Terms of Service',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Last Updated: ${DateTime.now().year}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            
            _buildSection(
              context,
              '1. Acceptance of Terms',
              'By accessing and using HeartLink, you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to these terms, please do not use our service.',
            ),
            
            _buildSection(
              context,
              '2. Eligibility',
              'You must be at least 18 years old to use HeartLink. By using this service, you represent and warrant that you have the right, authority, and capacity to enter into this agreement.',
            ),
            
            _buildSection(
              context,
              '3. User Account',
              'You are responsible for maintaining the confidentiality of your account and password. You agree to accept responsibility for all activities that occur under your account.',
            ),
            
            _buildSection(
              context,
              '4. User Conduct',
              'You agree not to:\n• Post false, inaccurate, or misleading information\n• Impersonate any person or entity\n• Harass, abuse, or harm another person\n• Use the service for any illegal purpose\n• Upload inappropriate content',
            ),
            
            _buildSection(
              context,
              '5. Privacy',
              'Your privacy is important to us. Please review our Privacy Policy to understand how we collect, use, and protect your personal information.',
            ),
            
            _buildSection(
              context,
              '6. Content',
              'You retain ownership of content you post on HeartLink. By posting content, you grant us a license to use, modify, and display that content in connection with the service.',
            ),
            
            _buildSection(
              context,
              '7. Safety',
              'While we strive to provide a safe environment, we cannot guarantee the conduct of users. Always exercise caution when meeting people in person.',
            ),
            
            _buildSection(
              context,
              '8. Termination',
              'We reserve the right to terminate or suspend your account at any time for violations of these terms or for any other reason.',
            ),
            
            _buildSection(
              context,
              '9. Disclaimer',
              'HeartLink is provided "as is" without warranties of any kind. We do not guarantee that the service will be uninterrupted or error-free.',
            ),
            
            _buildSection(
              context,
              '10. Contact',
              'If you have questions about these terms, please contact us at support@heartlink.app',
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'HeartLink Privacy Policy',
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
              '1. Information We Collect',
              'We collect information you provide directly:\n• Name, age, email\n• Profile photos\n• Bio and interests\n• Location data\n• Messages and interactions',
            ),
            
            _buildSection(
              context,
              '2. How We Use Your Information',
              'We use your information to:\n• Provide and improve our service\n• Match you with compatible users\n• Send notifications\n• Ensure safety and security\n• Comply with legal obligations',
            ),
            
            _buildSection(
              context,
              '3. Information Sharing',
              'We do not sell your personal information. We may share information:\n• With other users (profile info)\n• With service providers\n• For legal compliance\n• With your consent',
            ),
            
            _buildSection(
              context,
              '4. Data Security',
              'We implement security measures to protect your data, including encryption and secure storage. However, no method is 100% secure.',
            ),
            
            _buildSection(
              context,
              '5. Your Rights',
              'You have the right to:\n• Access your data\n• Correct inaccurate data\n• Delete your account\n• Export your data\n• Opt-out of communications',
            ),
            
            _buildSection(
              context,
              '6. Cookies',
              'We use cookies and similar technologies to improve your experience and analyze usage patterns.',
            ),
            
            _buildSection(
              context,
              '7. Children\'s Privacy',
              'HeartLink is not intended for users under 18. We do not knowingly collect information from children.',
            ),
            
            _buildSection(
              context,
              '8. Changes to Policy',
              'We may update this policy from time to time. We will notify you of significant changes.',
            ),
            
            _buildSection(
              context,
              '9. Contact Us',
              'For privacy concerns, contact us at:\nprivacy@heartlink.app',
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

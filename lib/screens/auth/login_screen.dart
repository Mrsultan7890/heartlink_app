import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../providers/auth_provider.dart';
import '../../utils/app_router.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/loading_overlay.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authProvider.notifier).login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (success && mounted) {
      context.go(AppRoutes.home);
    } else {
      _showErrorSnackBar();
    }
  }

  void _showErrorSnackBar() {
    final error = ref.read(authProvider).error;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error ?? 'Login failed'),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    
    return Scaffold(
      body: LoadingOverlay(
        isLoading: authState.isLoading,
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.backgroundGradient,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 60),
                    
                    // Logo and Title
                    _buildHeader(),
                    
                    const SizedBox(height: 60),
                    
                    // Login Form
                    _buildLoginForm(),
                    
                    const SizedBox(height: 24),
                    
                    // Remember Me & Forgot Password
                    _buildRememberAndForgot(),
                    
                    const SizedBox(height: 32),
                    
                    // Login Button
                    _buildLoginButton(),
                    
                    const SizedBox(height: 24),
                    
                    // Divider
                    _buildDivider(),
                    
                    const SizedBox(height: 24),
                    
                    // Social Login
                    _buildSocialLogin(),
                    
                    const SizedBox(height: 32),
                    
                    // Sign Up Link
                    _buildSignUpLink(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.favorite,
            size: 50,
            color: AppTheme.primaryColor,
          ),
        ).animate().scale(delay: 200.ms, duration: 600.ms),
        
        const SizedBox(height: 24),
        
        Text(
          'Welcome Back',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3, end: 0),
        
        const SizedBox(height: 8),
        
        Text(
          'Sign in to continue your journey',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.3, end: 0),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        CustomTextField(
          controller: _emailController,
          label: 'Email',
          hint: 'Enter your email',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.email_outlined,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Email is required';
            }
            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value!)) {
              return 'Enter a valid email';
            }
            return null;
          },
        ).animate().fadeIn(delay: 800.ms).slideX(begin: -0.3, end: 0),
        
        const SizedBox(height: 16),
        
        CustomTextField(
          controller: _passwordController,
          label: 'Password',
          hint: 'Enter your password',
          obscureText: _obscurePassword,
          prefixIcon: Icons.lock_outlined,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            ),
            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Password is required';
            }
            if (value!.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ).animate().fadeIn(delay: 1000.ms).slideX(begin: -0.3, end: 0),
      ],
    );
  }

  Widget _buildRememberAndForgot() {
    return Row(
      children: [
        Expanded(
          child: CheckboxListTile(
            value: _rememberMe,
            onChanged: (value) => setState(() => _rememberMe = value ?? false),
            title: Text(
              'Remember me',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            activeColor: AppTheme.primaryColor,
          ),
        ),
        TextButton(
          onPressed: () => context.push(AppRoutes.forgotPassword),
          child: Text(
            'Forgot Password?',
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 1200.ms);
  }

  Widget _buildLoginButton() {
    return CustomButton(
      text: 'Sign In',
      onPressed: _handleLogin,
      gradient: AppTheme.primaryGradient,
      icon: Icons.login,
    ).animate().fadeIn(delay: 1400.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    ).animate().fadeIn(delay: 1600.ms);
  }

  Widget _buildSocialLogin() {
    return Column(
      children: [
        _buildSocialButton(
          'Continue with Google',
          Icons.g_mobiledata,
          Colors.red,
          () => _handleSocialLogin('google'),
        ),
        const SizedBox(height: 12),
        _buildSocialButton(
          'Continue with Facebook',
          Icons.facebook,
          Colors.blue,
          () => _handleSocialLogin('facebook'),
        ),
      ],
    ).animate().fadeIn(delay: 1800.ms);
  }

  Widget _buildSocialButton(String text, IconData icon, Color color, VoidCallback onPressed) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: color),
      label: Text(text),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        TextButton(
          onPressed: () => context.push(AppRoutes.register),
          child: Text(
            'Sign Up',
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 2000.ms);
  }

  void _handleSocialLogin(String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$provider login coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
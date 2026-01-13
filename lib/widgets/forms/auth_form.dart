import 'package:flutter/material.dart';

class AuthForm extends StatelessWidget {
  final Widget child;
  
  const AuthForm({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Form(child: child);
  }
}
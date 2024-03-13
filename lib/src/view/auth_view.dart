import 'package:flutter/material.dart';
import 'package:rapidd_tech_assignment/widgets/auth_form.dart';

class AuthView extends StatelessWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AuthForm(),
    );
  }
}
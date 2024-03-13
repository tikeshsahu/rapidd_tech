// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rapidd_tech_assignment/src/view_model/auth_view_model.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  startAuthentication(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      await Provider.of<AuthViewModel>(context, listen: false).submitForm(email, password, context);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthViewModel>(context, listen: false);
    final Size size = MediaQuery.of(context).size;
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<AuthViewModel>(
          builder: (context, value, child) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Authentication',
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide()),
                  border: OutlineInputBorder(borderSide: BorderSide()),
                  labelText: 'Enter Email',
                ),
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@') || !value.contains('.com') && !value.contains('.in')) {
                    return 'Incorrect Email address';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              TextFormField(
                controller: passwordController,
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide()),
                  border: OutlineInputBorder(borderSide: BorderSide()),
                  labelText: 'Enter Password',
                ),
                validator: (value) {
                  if (value!.isEmpty || value.length < 4) {
                    return 'Please enter valid Password';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300]),
                onPressed: () {
                  startAuthentication(context);
                },
                child: authProvider.isLoggingIn ? const Text('Login') : const Text('Sign Up'),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(authProvider.isLoggingIn ? 'Not a Member ?' : "Already have an Account ?"),
                  const SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () {
                      var value = authProvider.isLoggingIn;
                      authProvider.updateIsLogin(value ? false : true);
                    },
                    child: Text(
                      authProvider.isLoggingIn ? "Sign Up" : 'Log In',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: Colors.red),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

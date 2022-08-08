import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12.0),
          TextFormField(
            // validator: (value) {
            //   // if (value!.isEmpty) {
            //   //   return 'Please enter an email';
            //   // } else if (!(value.contains('@') && value.contains('.com'))) {
            //   //   return 'Please enter a valid email';
            //   // } else {
            //   //   print('email validated - is Not empty');
            //   // }
            //   // return null;
            // },
            textInputAction: TextInputAction.next,
            controller: _email,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              errorStyle: TextStyle(color: Colors.redAccent.shade200),
              contentPadding: const EdgeInsets.all(8.0),
              hintText: 'Enter an email',
              hintStyle: const TextStyle(fontSize: 14.0),
              fillColor: Colors.white,
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Colors.redAccent.shade100,
                  width: 2.0,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a password';
              }
              return null;
            },
            textInputAction: TextInputAction.next,
            obscureText: true,
            controller: _password,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              errorStyle: TextStyle(color: Colors.redAccent.shade200),
              contentPadding: const EdgeInsets.all(8.0),
              hintText: 'Enter a password',
              hintStyle: const TextStyle(fontSize: 14.0),
              fillColor: Colors.white,
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Colors.redAccent.shade100,
                  width: 2.0,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12.0),
          TextButton(
            onPressed: () async {
              try {
                await AuthService.firebase().login(
                  email: _email.text,
                  password: _password.text,
                );
                final user = AuthService.firebase().currentUser;
                if (user?.isEmailVerified ?? false) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                    (route) => false,
                  );
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyEmailRoute,
                    (route) => false,
                  );
                }
              } catch (e) {
                await showErrorDialog(context, 'Error ${e.toString()}');
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text('Not registered yet? Register here!'),
          ),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().logout();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

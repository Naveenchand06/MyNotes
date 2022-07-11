import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text('Register'),
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
                  width: 2.5,
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
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: _email.text,
                  password: _password.text,
                );
                final user = FirebaseAuth.instance.currentUser;
                user?.sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  await showErrorDialog(context, 'Weak Password');
                } else if (e.code == 'invalid-email') {
                  await showErrorDialog(context, 'Invalid Email');
                } else if (e.code == 'email-already-in-use') {
                  await showErrorDialog(context, 'Email is already in use');
                } else {
                  await showErrorDialog(context, 'Error ${e.code}');
                }
              } catch (e) {
                await showErrorDialog(context, 'Error ${e.toString()}');
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: const Text('Already have an account? Login!'),
          ),
        ],
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
      body: Container(
        padding: const EdgeInsets.all(12.0),
        child: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Column(
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
                          final userCredential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: _email.text,
                            password: _password.text,
                          );
                          print(userCredential);
                        } on FirebaseAuthException catch (e) {
                          print('code: ${e.code}');
                          print('message: ${e.message}');

                          if (e.code == 'user-not-found') {
                            print('User not found');
                          } else if (e.code == 'wrong-password') {
                            print('Wrong Password');
                          } else {
                            print('Something else happend');
                          }
                        } catch (e) {
                          print('There is an error in login');
                          print(e);
                        }
                      },
                      child: const Text('Login'),
                    )
                  ],
                );
              default:
                return const Text('Loading...');
            }
          },
        ),
      ),
    );
  }
}

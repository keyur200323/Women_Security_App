import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:security/child/bottom_page.dart';
import 'package:security/components/PrimaryButton.dart';
import 'package:security/components/SecondaryButton.dart';
import 'package:security/components/custom_textfield.dart';
import 'package:security/child/register_chid.dart';
import 'package:security/db/share_pref.dart';
import 'package:security/child/bottom_screens/child_home_page.dart';
import 'package:security/parent/parent_register_screen.dart';
import 'package:security/utils/constants.dart';
import 'package:security/parent/parent_home_screen.dart';


class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordShown = true;
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};
  bool isLoading = false;

  _onSubmit() async {
    _formKey.currentState!.save();
    try {
      setState(() {
        isLoading = true;
      });
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: _formData['email'].toString(),
          password: _formData['password'].toString());
      if (userCredential.user != null) {
        setState(() {
          isLoading = false;
        });
        FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get()
            .then((value) {
          if (value['type'] == 'parent') {
            print(value['type']);
            MySharedPreferences.saveUserType('parent');
            goTo(context, ParentHomeScreen());
          } else {
            MySharedPreferences.saveUserType('child');
            goTo(context, BottomPage());
          }
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });

      print('Login pressed');
      print('Email: ${_formData['email']}');
      print('Error code: ${e.code}');

      if (e.code == 'user-not-found') {
        showDialogBox('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showDialogBox('Wrong password provided for that user.');
      } else {
        showDialogBox('An error occurred: ${e.message}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      print('An error occurred: $e');
      showDialogBox('An unexpected error occurred. Please try again later.');
    }
    print(_formData['email']);
    print(_formData['password']);
  }

  void showDialogBox(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(height: 16),
                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: Stack(
                    children: [
                      isLoading
                          ? progressIndicator(context)
                          : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'USER LOGIN',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          SizedBox(height: 30),
                          Image.asset(
                            'assets/logo.png',
                            height: 100,
                            width: 100,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 60),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomTextField(
                        hintText: 'Enter Email',
                        textInputAction: TextInputAction.next,
                        keyboardtype: TextInputType.emailAddress,
                        prefix: const Icon(Icons.person),
                        onsave: (email) {
                          _formData['email'] = email ?? "";
                        },
                        validate: (email) {
                          if (email!.isEmpty ||
                              email.length < 3 ||
                              !email.contains("@")) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      const SizedBox(height: 16),
                      CustomTextField(
                        hintText: 'Enter Password',
                        isPassword: isPasswordShown,
                        prefix: const Icon(Icons.vpn_key_rounded),
                        validate: (password) {
                          if (password!.isEmpty || password.length < 7) {
                            return 'Password must be at least 7 characters';
                          }
                          return null;
                        },
                        onsave: (password) {
                          _formData['password'] = password ?? "";
                        },
                        suffix: IconButton(
                          onPressed: () {
                            setState(() {
                              isPasswordShown = !isPasswordShown;
                            });
                          },
                          icon: isPasswordShown
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                        ),
                      ),
                      SizedBox(height: 55),
                      const SizedBox(height: 10),
                      PrimaryButton(
                        title: "LOGIN",
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _onSubmit();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 35),
                const SizedBox(height: 16),
                SizedBox(height: 15),
                SecondaryButton(
                  title: "Register as child",
                  onPressed: () {
                    goTo(context, RegisterChildScreen());
                  },
                ),
                SizedBox(height: 15),
                SecondaryButton(
                  title: "Register as parent",
                  onPressed: () {
                    goTo(context, RegisterParentScreen());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
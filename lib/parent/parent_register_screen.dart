import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:security/components/PrimaryButton.dart';
import 'package:security/components/SecondaryButton.dart';
import 'package:security/components/custom_textfield.dart';
import 'package:security/child/child_login_screen.dart';
import 'package:security/utils/constants.dart';

import '../model/user_model.dart';

class RegisterParentScreen extends StatefulWidget {
  @override
  State<RegisterParentScreen> createState() => _RegisterParentScreenState();
}

class _RegisterParentScreenState extends State<RegisterParentScreen> {
  bool isPasswordShown=true;
  bool isRetypePasswordShown=true;
  final _formkey = GlobalKey<FormState>();
  final _formData =Map<String,Object>();
  bool isLoading = false;

  _onSubmit() async {
    _formkey.currentState!.save();
    if(_formData['password']!=_formData['rpassword']){
      dialogueBox(context, 'Password and retype password should be same');
    }else{
      progressIndicator(context);
      try {
        setState(() {
          isLoading = true;
        });
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _formData['gemail'].toString(),
            password: _formData['password'].toString()
        );
        if(userCredential.user!=null){
          final v =userCredential.user!.uid;
          DocumentReference<Map<String, dynamic>> db=
          FirebaseFirestore.instance.collection('users').doc(v);

          final user = UserModel(
            name: _formData['name'].toString(),
            phone: _formData['phone'].toString(),
            childEmail: _formData['cemail'].toString(),
            guardianEmail: _formData['gemail'].toString(),
            id: v,
            type: 'parent',
          );
          final jsonData = user.toJson();
          await db.set(jsonData).whenComplete(() {
            goTo(context, LoginScreen());
            setState(() {
              isLoading = false;
            });
          });
        }
      }on FirebaseAuthException catch (e) {
        setState(() {
          isLoading = false;
        });
        if (e.code == 'weak-password') {
          // print();
          dialogueBox(context, 'The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          // print();
          dialogueBox(context, 'The account already exists for that email.');
        }
      } catch (e) {
        print(e);
        setState(() {
          isLoading = false;
        });
        dialogueBox(context, e.toString());
      }
    }
    print(_formData['email']);
    print(_formData['password']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Stack(
            children: [
              isLoading
                  ? progressIndicator(context)
                  : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      height:MediaQuery.of(context).size.height *0.3,

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                        children: [
                          Text(
                            'REGISTER AS PARENT',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize:40,
                              fontWeight: FontWeight.bold,
                              color:
                              primaryColor,
                            ),
                          ),
                          Image.asset(
                            'assets/logo.png',
                            height:100,
                            width:100,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height:MediaQuery.of(context).size.height *0.75,
                      child: Form(
                        key:_formkey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children:[
                            CustomTextField(
                              hintText: 'Enter Name',
                              textInputAction: TextInputAction.next,
                              keyboardtype: TextInputType.name,
                              prefix: Icon(Icons.person),
                              onsave: (name){
                                _formData['name']=name ?? "";
                              },
                              validate:(email){
                                if(email!.isEmpty || email.length<3){
                                  return 'enter correct name';
                                }
                                return null;
                              },
                            ),
                            CustomTextField(
                              hintText: 'Enter Phone',
                              textInputAction: TextInputAction.next,
                              keyboardtype: TextInputType.phone,
                              prefix: Icon(Icons.phone),
                              onsave: (phone){
                                _formData['phone']=phone ?? "";
                              },
                              validate:(email){
                                if(email!.isEmpty || email.length<10){
                                  return 'enter correct phone';
                                }
                                return null;
                              },
                            ),

                            CustomTextField(
                              hintText: 'Enter Email',
                              textInputAction: TextInputAction.next,
                              keyboardtype: TextInputType.emailAddress,
                              prefix: Icon(Icons.person),
                              onsave: (email){
                                _formData['gemail']=email ?? "";

                              },
                              validate:(email){
                                if(email!.isEmpty ||
                                    email.length<3 ||
                                    !email.contains("@")){
                                  return 'enter correct email';
                                }
                                return null;
                              },
                            ),
                            CustomTextField(
                              hintText: 'Enter child Email',
                              textInputAction: TextInputAction.next,
                              keyboardtype: TextInputType.emailAddress,
                              prefix: Icon(Icons.person),
                              onsave: (cemail){
                                _formData['cemail']=cemail ?? "";

                              },
                              validate:(email){
                                if(email!.isEmpty ||
                                    email.length<3 ||
                                    !email.contains("@")){
                                  return 'enter correct email';
                                }
                                return null;
                              },
                            ),
                            CustomTextField(
                              hintText: 'Enter Password',
                              isPassword:isPasswordShown,
                              prefix: Icon(Icons.vpn_key_rounded),
                              onsave: (password){
                                _formData['password']=password ?? "";
                              },
                              //Validation
                              validate:(password){
                                if(password!.isEmpty){
                                  return 'enter correct password';
                                }
                                else if (password.length<7){
                                  return 'the length of the password should be greater than 7 ';
                                }
                                return null;
                              },
                              suffix:IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isPasswordShown =!isPasswordShown;
                                    });

                                  },
                                  icon: isPasswordShown
                                      ?Icon(Icons.visibility_off)
                                      : Icon(Icons.visibility)),
                            ),
                            CustomTextField(
                              hintText: 'Retype Password',
                              isPassword:isRetypePasswordShown,
                              prefix: Icon(Icons.vpn_key_rounded),
                              validate:(password){
                                if(password!.isEmpty || password.length<7){
                                  return 'enter correct password';
                                }
                                return null;
                              },
                              onsave: (password){
                                _formData['rpassword']=password ?? "";
                              },

                              suffix:IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isRetypePasswordShown =!isRetypePasswordShown;
                                    });

                                  },
                                  icon: isRetypePasswordShown
                                      ?Icon(Icons.visibility_off)
                                      : Icon(Icons.visibility)),
                            ),




                            PrimaryButton(title:"REGISTER",
                                onPressed:() {
                                  if(_formkey.currentState!.validate()) {
                                    _onSubmit();
                                  }
                                }),
                          ],
                        ),
                      ),
                    ),


                    SecondaryButton(title: "Login with your account", onPressed: () {
                      goTo(context, LoginScreen());

                    } ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


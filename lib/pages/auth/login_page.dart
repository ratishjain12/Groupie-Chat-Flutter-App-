import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groupchat_app/helper/helper_function.dart';
import 'package:groupchat_app/pages/auth/register_page.dart';
import 'package:groupchat_app/pages/home_page.dart';
import 'package:groupchat_app/service/auth_service.dart';
import 'package:groupchat_app/service/database_service.dart';
import 'package:groupchat_app/widgets/widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String pass = "";
  bool _isLoading = false;
  AuthService authService = new AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: formKey,
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                        color: Color.fromRGBO(238, 122, 101, 1)),
                  )
                : SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 55),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Groupie',
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Login now to see what they are talking!',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: 450,
                            height: 327,
                            child: Image.asset(
                              'assets/images/login.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                vertical: 18, horizontal: 19),
                            child: Column(
                              children: [
                                TextFormField(
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          width: 2,
                                          color:
                                              Color.fromRGBO(238, 122, 101, 1)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          width: 1.5,
                                          color:
                                              Color.fromRGBO(238, 122, 101, 1)),
                                    ),
                                    label: Text(
                                      'Email',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    ),
                                    hintText: 'Enter Email',
                                    labelStyle: TextStyle(
                                      color: Color.fromRGBO(238, 122, 101, 1),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: Color.fromRGBO(238, 122, 101, 1),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      email = value;
                                    });
                                  },
                                  validator: (val) {
                                    return RegExp(
                                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                            .hasMatch(val!)
                                        ? null
                                        : "Please enter a valid email";
                                  },
                                ),
                                SizedBox(height: 8),
                                TextFormField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          width: 2,
                                          color:
                                              Color.fromRGBO(238, 122, 101, 1)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          width: 1.5,
                                          color:
                                              Color.fromRGBO(238, 122, 101, 1)),
                                    ),
                                    label: Text(
                                      'Password',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    ),
                                    labelStyle: TextStyle(
                                        color:
                                            Color.fromRGBO(238, 122, 101, 1)),
                                    hintText: 'Enter Password',
                                    prefixIcon: Icon(Icons.lock,
                                        color:
                                            Color.fromRGBO(238, 122, 101, 1)),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      pass = value;
                                    });
                                  },
                                  validator: (val) {
                                    if (val!.length < 8) {
                                      return "Password must be at least 6 characters";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                SizedBox(height: 15),
                                Container(
                                  width: double.infinity,
                                  child: MaterialButton(
                                    padding: EdgeInsets.all(18),
                                    elevation: 0.0,
                                    onPressed: () {
                                      login();
                                    },
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 19),
                                    ),
                                    color: Color.fromRGBO(238, 122, 101, 1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Container(
                                  width: double.infinity,
                                  child: MaterialButton(
                                    onPressed: () {
                                      nextScreen(context, RegisterPage());
                                    },
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    child: Text(
                                      'Dont have a account? register here',
                                      style: TextStyle(color: Colors.black87),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )));
  }

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .signInWithEmailandPassword(email, pass)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);
          await helper_function.saveUserLoggedInStatus(true);
          await helper_function.saveUserEmail(email);
          await helper_function.saveUserName(snapshot.docs[0]['username']);
          nextScreenReplace(context, HomePage());
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}

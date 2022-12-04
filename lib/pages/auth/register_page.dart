import 'package:flutter/material.dart';
import 'package:groupchat_app/helper/helper_function.dart';
import 'package:groupchat_app/pages/home_page.dart';
import 'package:groupchat_app/service/auth_service.dart';
import 'package:groupchat_app/widgets/widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String username = "";
  String email = "";
  String pass = "";
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(color: Colors.black),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
        ),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Register now to see whats going on!',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          SizedBox(height: 3),
                          Container(
                            width: 450,
                            height: 327,
                            child: Image.asset(
                              'assets/images/register.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                vertical: 18, horizontal: 19),
                            child: Column(
                              children: [
                                TextField(
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
                                      'Username',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    ),
                                    labelStyle: TextStyle(
                                        color:
                                            Color.fromRGBO(238, 122, 101, 1)),
                                    hintText: 'Enter Username',
                                    prefixIcon: Icon(Icons.lock,
                                        color:
                                            Color.fromRGBO(238, 122, 101, 1)),
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      username = val;
                                    });
                                  },
                                ),
                                SizedBox(height: 8),
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
                                      register();
                                    },
                                    child: Text(
                                      'Register',
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )));
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailandPassword(username, email, pass)
          .then((value) async {
        if (value == true) {
          await helper_function.saveUserLoggedInStatus(true);
          await helper_function.saveUserEmail(email);
          await helper_function.saveUserName(username);
          nextScreenReplace(context, HomePage());
        } else {
          setState(() {
            _isLoading = false;
          });
          showSnackbar(context, Colors.red, value);
        }
      });
    }
  }
}

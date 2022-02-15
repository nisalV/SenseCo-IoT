import 'package:flutter/material.dart';
import 'package:flutter_firebase/services/auth.dart';
import 'package:flutter_firebase/shared/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({required this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final userController = TextEditingController();
  String password = '';
  bool isPasswordVisible = true;
  bool loading = false;

  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();

    emailController.addListener(() => setState(() {}));
    userController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return loading? Loading() : Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          elevation: 0.0,
          title: Text('Sign up'),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: IconButton(
                  onPressed: () {
                    widget.toggleView();
                  },
                  icon: Icon(
                    Icons.login,
                    color: Colors.white,
                  )),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  TextFormField(
                    controller: userController,
                    maxLines: 1,
                    maxLength: 20,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.redAccent, width: 2.0),
                        ),
                        labelText: 'user name',
                        labelStyle: TextStyle(
                          fontSize: 18.0,
                          color: Colors.redAccent,
                        ),
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.redAccent,
                        ),
                        suffixIcon: userController.text.isEmpty
                            ? Container(
                                width: 0,
                              )
                            : IconButton(
                                splashRadius: 1.0,
                                onPressed: () {
                                  userController.clear();
                                },
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.redAccent,
                                ),
                              )),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter a user name';
                      } else {
                        return null;
                      }
                    },
                  ),

                  // password field

                  SizedBox(
                    height: 15.0,
                  ),

                  // email field

                  TextFormField(
                    controller: emailController,
                    maxLines: 1,
                    enableSuggestions: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.redAccent, width: 2.0),
                        ),
                        labelText: 'e-mail',
                        labelStyle: TextStyle(
                          fontSize: 18.0,
                          color: Colors.redAccent,
                        ),
                        prefixIcon: Icon(
                          Icons.mail,
                          color: Colors.redAccent,
                        ),
                        suffixIcon: emailController.text.isEmpty
                            ? Container(
                                width: 0,
                              )
                            : IconButton(
                                splashRadius: 1.0,
                                onPressed: () {
                                  emailController.clear();
                                },
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.redAccent,
                                ),
                              )),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      final pattern =
                          r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
                      final regExp = RegExp(pattern);

                      if (value!.isEmpty) {
                        return 'Enter the e-mail';
                      } else if (!regExp.hasMatch(value)) {
                        return 'The e-mail format is not valid';
                      } else {
                        return null;
                      }
                    },
                  ),

                  // password field

                  SizedBox(
                    height: 15.0,
                  ),

                  TextFormField(
                    maxLines: 1,
                    maxLength: 8,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.redAccent, width: 2.0),
                      ),
                      labelText: 'password',
                      labelStyle: TextStyle(
                        fontSize: 18.0,
                        color: Colors.redAccent,
                      ),
                      prefixIcon: Icon(
                        Icons.password,
                        color: Colors.redAccent,
                      ),
                      suffixIcon: password.isEmpty
                          ? Container(
                              width: 0,
                            )
                          : IconButton(
                              splashRadius: 1.0,
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                              icon: isPasswordVisible
                                  ? Icon(
                                      Icons.visibility_off,
                                      color: Colors.redAccent,
                                    )
                                  : Icon(
                                      Icons.visibility,
                                      color: Colors.redAccent,
                                    ),
                            ),
                    ),
                    obscureText: isPasswordVisible,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    onChanged: (value) => setState(() {
                      password = value.trim();
                    }),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter the password';
                      }
                      if (value.length < 4) {
                        return 'Enter at least need 4 characters';
                      } else {
                        return null;
                      }
                    },
                  ),

                  SizedBox(
                    height: 35.0,
                  ),

                  // sign in button

                  Row(
                    children: [
                    Expanded(
                      flex: 1,
                      child: TextButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ))
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          final isValid = _formKey.currentState!.validate();

                          if (isValid) {
                            FocusScope.of(context).unfocus();
                            _formKey.currentState!.save();

                            try {
                              loading = true;
                              dynamic result = await _auth.RegisterUser(userController.text,
                                  emailController.text, password);
                              if (result == null) {
                                setState(() => loading = true);
                                final snackBar = SnackBar(
                                  content: Text(
                                    'could not register',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  backgroundColor: Colors.red,
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else {
                                setState(() => loading = false);
                                final snackBar = SnackBar(
                                  content: Text(
                                    'Registered',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  backgroundColor: Colors.green,
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            } catch (e) {
                              setState(() => loading = false);
                              final snackBar = SnackBar(
                                content: Text(
                                  'could not register',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                backgroundColor: Colors.red,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                          }
                        },
                      ),
                    ),]
                  )
                ],
              )),
        ));
  }
}

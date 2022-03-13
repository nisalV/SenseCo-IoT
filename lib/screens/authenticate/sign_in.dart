import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase/services/auth.dart';
import 'package:flutter_firebase/shared/loading.dart';

class SignIn extends StatefulWidget {
  late final Function toggleView;
  SignIn({required this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  String password = '';
  bool isPasswordVisible = true;
  bool loading = false;
  bool pwReset = false;
  final pattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';

  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();

    emailController.addListener(() => setState(() {}));
  }

  @override
  void didChangeDependencies() {
    emailController.text;
    pwReset;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.redAccent,
              elevation: 0.0,
              title: Text('Sign In'),
              actions: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: IconButton(
                      onPressed: () {
                        widget.toggleView();
                      },
                      icon: Icon(
                        Icons.person_add_alt_1_rounded,
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
                      // email field

                      TextFormField(
                        controller: emailController,
                        maxLines: 1,
                        enableSuggestions: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.redAccent, width: 2.0),
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
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.redAccent),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ))),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  'Sign in',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                final isValid =
                                    _formKey.currentState!.validate();

                                if (isValid) {
                                  FocusScope.of(context).unfocus();
                                  _formKey.currentState!.save();

                                  try {
                                    setState(() => loading = true);
                                    dynamic result = await _auth.signIn(
                                        emailController.text, password);
                                    if (result == null) {
                                      setState(() => loading = false);
                                      final snackBar = SnackBar(
                                        content: Text(
                                          'could not sign in',
                                          style: TextStyle(
                                            fontSize: 15.0,
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
                                          'signed in',
                                          style: TextStyle(
                                            fontSize: 15.0,
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
                                        'could not sign in',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      backgroundColor: Colors.red,
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      TextButton(
                          child: Text(
                            "Change password",
                            style: TextStyle(color: Colors.blue),
                          ),
                          onPressed: () async {
                            final regExp = RegExp(pattern);

                            if (!regExp.hasMatch(emailController.text)) {
                              final snackBar = SnackBar(
                                content: Text(
                                  'Email format not valid',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                backgroundColor: Colors.red,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              try {
                                await _auth
                                    .resetPassword(emailController.text)
                                    .whenComplete(() {
                                  final snackBar = SnackBar(
                                    content: Text(
                                      'A password reset mail is set to your email',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    backgroundColor: Colors.green,
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                });
                              } catch (e) {
                                final snackBar = SnackBar(
                                  content: Text(
                                    'Problem occurred',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  backgroundColor: Colors.red,
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            }
                          }),
                    ],
                  )),
            ));
  }
}

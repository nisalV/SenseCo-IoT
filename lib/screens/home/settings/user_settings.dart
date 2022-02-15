import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/services/database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({Key? key}) : super(key: key);

  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _linkController = TextEditingController();
  final _linkTextController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;

  @override
  void initState() {
    super.initState();

    _userController.addListener(() => setState(() {}));
    _linkController.addListener(() => setState(() {}));
    _linkTextController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.redAccent,
        elevation: 0.0,
        actions: [
          loading
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 30.0, 0),
                  child: SpinKitPulse(
                    size: 50,
                    color: Colors.white,
                  ),
                )
              : Container(
                  width: 0.0,
                )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            // User name change
            Form(
              key: _formKey1,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: TextFormField(
                      controller: _userController,
                      maxLines: 1,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.redAccent, width: 2.0),
                          ),
                          labelText: 'update user name',
                          labelStyle: TextStyle(
                            fontSize: 18.0,
                            color: Colors.redAccent,
                          ),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.redAccent,
                          ),
                          suffixIcon: _userController.text.isEmpty
                              ? Container(
                                  width: 0,
                                )
                              : IconButton(
                                  splashRadius: 1.0,
                                  onPressed: () {
                                    _userController.clear();
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.redAccent,
                                  ),
                                )),
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value!.isEmpty ||
                            _userController.text.trim().isEmpty) {
                          return 'Enter a user name';
                        }
                        if (_userController.text.length > 20) {
                          return 'Too much characters';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                        splashColor: Color(0xFFFAC7C6),
                        hoverColor: Color(0xFFFAC7C6),
                        splashRadius: 20,
                        onPressed: () async {
                          final isValid = _formKey1.currentState!.validate();

                          if (isValid) {
                            FocusScope.of(context).unfocus();
                            _formKey1.currentState!.save();

                            try {
                              setState(() => loading = true);
                              await DatabaseService(uid: _auth.currentUser!.uid)
                                  .updateName(_userController.text);

                              final snackBar = SnackBar(
                                content: Text(
                                  'name updated',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                backgroundColor: Colors.green,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } catch (e) {
                              final snackBar = SnackBar(
                                content: Text(
                                  'could not update',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                backgroundColor: Colors.red,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } finally {
                              _userController.clear();
                              setState(() => loading = false);
                            }
                          }
                        },
                        icon: Icon(
                          Icons.upload_rounded,
                          color: Colors.redAccent,
                        )),
                  )
                ],
              ),
            ),

            SizedBox(
              height: 20,
            ),

            // Google Sheet link and link description upload
            Card(
              color: Color(0xF8FFFDF0),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Text(
                          'Add a Google Sheet',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                    Form(
                      key: _formKey2,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _linkTextController,
                                    maxLength: 50,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.redAccent,
                                              width: 2.0),
                                        ),
                                        labelText:
                                            'Google Sheet description',
                                        labelStyle: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.redAccent,
                                        ),
                                        prefixIcon: Icon(
                                          Icons.add_comment,
                                          color: Colors.redAccent,
                                        ),
                                        suffixIcon:
                                            _linkTextController.text.isEmpty
                                                ? Container(
                                                    width: 0,
                                                  )
                                                : IconButton(
                                                    splashRadius: 1.0,
                                                    onPressed: () {
                                                      _linkTextController.clear();
                                                    },
                                                    icon: Icon(
                                                      Icons.close,
                                                      color: Colors.redAccent,
                                                    ),
                                                  )),
                                    keyboardType: TextInputType.name,
                                    textInputAction: TextInputAction.done,
                                    validator: (value) {
                                      if (value!.isEmpty ||
                                          _linkTextController.text
                                              .trim()
                                              .isEmpty) {
                                        return 'Enter some info';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  TextFormField(
                                    controller: _linkController,
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.redAccent,
                                              width: 2.0),
                                        ),
                                        labelText: 'Google Sheet script link',
                                        labelStyle: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.redAccent,
                                        ),
                                        prefixIcon: Icon(
                                          Icons.add_link,
                                          color: Colors.redAccent,
                                        ),
                                        suffixIcon: _linkController.text.isEmpty
                                            ? Container(
                                                width: 0,
                                              )
                                            : IconButton(
                                                splashRadius: 1.0,
                                                onPressed: () {
                                                  _linkController.clear();
                                                },
                                                icon: Icon(
                                                  Icons.close,
                                                  color: Colors.redAccent,
                                                ),
                                              )),
                                    keyboardType: TextInputType.name,
                                    textInputAction: TextInputAction.done,
                                    validator: (value) {
                                      if (value!.isEmpty ||
                                          _linkController.text.trim().isEmpty) {
                                        return 'Enter a link';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                                splashColor: Color(0xFFFAC7C6),
                                hoverColor: Color(0xFFFAC7C6),
                                splashRadius: 20,
                                onPressed: () async {
                                  final isValid =
                                      _formKey2.currentState!.validate();

                                  if (isValid) {
                                    FocusScope.of(context).unfocus();
                                    _formKey2.currentState!.save();

                                    try {
                                      setState(() => loading = true);
                                      await DatabaseService(
                                              uid: _auth.currentUser!.uid).updateLink(_linkTextController.text, _linkController.text);

                                      final snackBar = SnackBar(
                                        content: Text(
                                          'Google Sheet link added',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        backgroundColor: Colors.green,
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    } catch (e) {
                                      final snackBar = SnackBar(
                                        content: Text(
                                          'could not complete',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        backgroundColor: Colors.red,
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    } finally {
                                      _linkController.clear();
                                      _linkTextController.clear();
                                      setState(() => loading = false);
                                    }
                                  }
                                },
                                icon: Icon(
                                  Icons.upload_rounded,
                                  color: Colors.redAccent,
                                )),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

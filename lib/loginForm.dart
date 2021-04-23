import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/profilePage.dart';
import 'package:flutter_signin_button/button_builder.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginForm extends StatefulWidget {
  final String title = 'Sign In';

  @override
  State<StatefulWidget> createState() => _LoginFormFormState();
}

class _LoginFormFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success;
  String _userEmail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Card(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration:
                            const InputDecoration(labelText: 'Password'),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      // Container(
                      //   padding: const EdgeInsets.symmetric(vertical: 16.0),
                      //   alignment: Alignment.center,
                      //   child: RaisedButton(
                      //     onPressed: () async {
                      //       if (_formKey.currentState.validate()) {
                      //         _signInWithEmailAndPassword();
                      //       }
                      //     },
                      //     child: const Text('Submit'),
                      //   ),
                      // ),

                      Container(
                        padding: const EdgeInsets.all(16),
                        alignment: Alignment.center,
                        child: SignInButtonBuilder(
                            icon: Icons.verified_user,
                            backgroundColor: Colors.lightBlue,
                            text: 'Sign In',
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _signInWithEmailAndPassword();
                              }
                            }),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          _success == null
                              ? ''
                              : (_success
                                  ? 'Successfully signed in ' + _userEmail
                                  : 'Sign in failed'),
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    ],
                  ),
                ))));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signInWithEmailAndPassword() async {
    final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    ))
        .user;

    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user.email;

        Navigator.of(context) /*!*/ .push(
          MaterialPageRoute<void>(builder: (_) => ProfilePage(user: user)),
        );
      });
    } else {
      setState(() {
        _success = false;
      });
    }
  }
}

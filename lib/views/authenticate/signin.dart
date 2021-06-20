import 'package:flutter/material.dart';
import 'package:go_kenya/services/auth.dart';
import 'package:go_kenya/models/user.dart';
import 'package:go_kenya/widgets/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  const SignIn({Key? key, required this.toggleView}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  //form state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sign In',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: 30),
                ),
                SizedBox(
                  height: 20,
                ),

                //email field
                TextFormField(
                  decoration: InputDecoration(
                      hintText: 'Email',
                      icon: Icon(
                        Icons.person,
                        color: Theme.of(context).accentColor,
                      )),
                  validator: (val) {
                    String email = val.toString();

                    bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(email);

                    if (!emailValid) {
                      return 'Please enter a valid email';
                    }

                    if (val!.isEmpty) {
                      return 'The email field cannot be blank';
                    }
                  },
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),

                //password field
                TextFormField(
                  decoration: InputDecoration(
                      hintText: 'Password',
                      icon: Icon(
                        Icons.vpn_key,
                        color: Theme.of(context).accentColor,
                      )),
                  validator: (val) => val!.length < 6
                      ? 'Password must be at least 6 characters long'
                      : null,
                  obscureText: true,
                  onChanged: (val) {
                    setState(() {
                      password = val;
                    });
                  },
                ),

                SizedBox(
                  height: 10,
                ),
                Text(
                  error,
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(
                  height: 10,
                ),
                loading
                    ? Loading()
                    : ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            loading = true;
                            error = '';
                          });

                          if (_formKey.currentState!.validate()) {
                            dynamic result =
                                await _auth.signInWithEmailAndPassword(
                                    email: email, password: password);

                            if (result != CustomUser) {
                              setState(() {
                                error = result;
                                loading = false;
                              });
                            }

                            print(result);
                          }
                        },
                        child: Text('Sign In'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                        )),
                SizedBox(
                  height: 50,
                ),

                Text("Don't have an account?"),
                TextButton(
                    onPressed: () {
                      widget.toggleView();
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.green[800]),
                    ))
              ],
            ),
          )),
    );
  }
}

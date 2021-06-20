import 'package:flutter/material.dart';
import 'package:go_kenya/services/auth.dart';
import 'package:go_kenya/widgets/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  const Register({Key? key, required this.toggleView}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String error = '';

  //text field state
  String email = '';
  String password = '';
  String firstName = '';
  String lastName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
          child: Form(
            key: _formKey,
            child: Center(
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  Text(
                    'Register',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 30),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  //first name
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'First Name',
                    ),
                    validator: (val) =>
                        val!.isEmpty ? 'First Name cannot be blank' : null,
                    onChanged: (val) {
                      setState(() {
                        firstName = val;
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //first name
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Last Name',
                    ),
                    validator: (val) =>
                        val!.isEmpty ? 'Last Name cannot be blank' : null,
                    onChanged: (val) {
                      setState(() {
                        lastName = val;
                      });
                    },
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  //email field
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Email',
                    ),
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
                    ),
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
                            if (_formKey.currentState!.validate()) {
                              //register user
                              dynamic result =
                                  await _auth.createUserWithEmailAndPassword(
                                      email: email, password: password);

                              if (result is String) {
                                //check for and display error
                                setState(() {
                                  error = result;
                                });
                              } else {
                                //create user in database if no errors
                                await _auth.createUser(
                                    uid: result.uid,
                                    firstName: firstName,
                                    lastName: lastName,
                                    email: email);
                              }

                              print(result.uid);
                            }
                          },
                          child: Text('Register'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                          )),
                  SizedBox(
                    height: 50,
                  ),

                  Center(child: Text("Already have an account?")),
                  TextButton(
                      onPressed: () {
                        widget.toggleView();
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      )),
                ],
              ),
            ),
          )),
    );
  }
}

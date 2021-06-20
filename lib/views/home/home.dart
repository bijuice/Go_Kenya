import 'package:flutter/material.dart';
import 'package:go_kenya/services/auth.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = new AuthService();
    return Container(
        child: Scaffold(
      body: Container(
        child: Center(
          child: ElevatedButton(
            child: Text('Sign Out'),
            onPressed: () {
              _auth.signOut();
            },
          ),
        ),
      ),
    ));
  }
}

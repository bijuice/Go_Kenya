import 'package:flutter/material.dart';
import 'package:go_kenya/views/authenticate/authenticate.dart';
import 'package:go_kenya/views/home/home.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();

    return SafeArea(child: user == null ? Authenticate() : Home());
  }
}

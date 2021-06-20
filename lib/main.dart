import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_kenya/services/auth.dart';
import 'package:go_kenya/widgets/loading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:go_kenya/wrapper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //initialize firebase instance
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            primaryColor: HexColor("#25594A"),
            accentColor: HexColor("#262626"),
            primaryTextTheme: Theme.of(context)
                .textTheme
                .apply(bodyColor: HexColor("#262626"))),

        //builds the firebase future
        //checks for errors and returns main screen if connection is successful
        home: FutureBuilder(
            future: _initialization,
            builder: (context, snapshot) {
              //check for errors
              if (snapshot.hasError) {
                print(snapshot);
                return FirebaseError();
              }

              //return app wrapper
              if (snapshot.connectionState == ConnectionState.done) {
                final AuthService _auth = new AuthService();

                return StreamProvider(
                  create: (_) => _auth.onAuthChange(),
                  initialData: null,
                  child: Wrapper(),
                );
              }

              return Loading();
            }));
  }
}

class FirebaseError extends StatelessWidget {
  const FirebaseError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Firebase Error'),
    );
  }
}

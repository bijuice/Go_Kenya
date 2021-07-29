import 'package:flutter/material.dart';
import 'package:go_kenya/views/home/home.dart';

class Thanks extends StatelessWidget {
  const Thanks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Container(
            child: Text(
              'Thank you for your booking!',
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 30),
            ),
          )),
          SizedBox(
            height: 15,
          ),
          Center(
            child: Text('You can find your trips in the trips tab',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 20)),
          ),
          SizedBox(
            height: 100,
          ),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).primaryColor)),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },
              child: Text(
                'Go Home',
                style: TextStyle(
                  fontSize: 20,
                ),
              ))
        ],
      ),
    );
  }
}

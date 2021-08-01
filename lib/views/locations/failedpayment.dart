import 'package:flutter/material.dart';

class FailedPayment extends StatelessWidget {
  const FailedPayment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Container(
            child: Text(
              'Payment Failed',
              style: TextStyle(color: Colors.red, fontSize: 30),
            ),
          )),
          SizedBox(
            height: 15,
          ),
          Center(
            child: Text('Please try again',
                style: TextStyle(color: Colors.red, fontSize: 20)),
          ),
          SizedBox(
            height: 100,
          ),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).primaryColor)),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Back',
                style: TextStyle(
                  fontSize: 20,
                ),
              ))
        ],
      ),
    );
  }
}

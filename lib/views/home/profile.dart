import 'package:flutter/material.dart';
import 'package:go_kenya/services/auth.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Profile",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      thickness: 1,
                      indent: 60,
                      endIndent: 60,
                      color: Theme.of(context).primaryColor,
                    ),
                    GestureDetector(
                      onTap: () {
                        AuthService _auth = new AuthService();
                        _auth.signOut();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 30),
                        child: Row(
                          children: [
                            Icon(Icons.person),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Log Out",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      indent: 60,
                      endIndent: 60,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

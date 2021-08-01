import 'package:flutter/material.dart';
import 'package:go_kenya/services/auth.dart';
import 'package:go_kenya/views/home/manage.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  AuthService _auth = new AuthService();
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _getIsAdmin();
  }

  //check if user is admin
  void _getIsAdmin() async {
    var uid = await _auth.getCurrentUser();

    bool admin = await _auth.getIsAdmin(uid: uid);

    setState(() {
      isAdmin = admin;
    });
  }

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
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: isAdmin,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Manage()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 30),
                        child: Row(
                          children: [
                            Icon(Icons.manage_accounts),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Admin Portal",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
              ),
            ),
          )
        ],
      ),
    );
  }
}

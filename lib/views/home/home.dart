import 'package:flutter/material.dart';
import 'package:go_kenya/views/home/profile.dart';
import 'package:go_kenya/views/home/trips.dart';
import 'package:go_kenya/views/locations/explore.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  final PageController controller = PageController(initialPage: 0);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    controller.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flight),
            label: 'Trips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        showUnselectedLabels: true,
        iconSize: 25,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).accentColor,
        onTap: _onItemTapped,
      ),
      body: PageView(
        children: [Explore(), Trips(), Profile()],
        controller: controller,
      ),
    ));
  }
}

import 'package:barterlt_app/models/user.dart';
import 'package:barterlt_app/screens/myitemscreen.dart';
import 'package:barterlt_app/screens/homescreen.dart';
import 'package:barterlt_app/screens/profilescreen.dart';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = "Home";

  @override
  void initState() {
    super.initState();
    print(widget.user.name);
    print(widget.user.id);
    print("Mainscreen");
    tabchildren = [
      HomeScreen(
        user: widget.user,
      ),
      MyItemScreen(
        user: widget.user,
      ),
      ProfileScreen(
        user: widget.user,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabchildren[_currentIndex],
      bottomNavigationBar: ConvexAppBar(
          backgroundColor: Colors.red,
          onTap: onTabTapped,
          initialActiveIndex: _currentIndex,
          items: const [
            TabItem(
                icon: Icon(
                  Icons.home,
                ),
                title: "Home"),
            TabItem(
                icon: Icon(
                  Icons.add,
                ),
                title: "Add"),
            TabItem(
                icon: Icon(
                  Icons.person,
                ),
                title: "Profile"),
          ]),
    );
  }

  void onTabTapped(int value) {
    setState(() {
      _currentIndex = value;
      if (_currentIndex == 0) {
        maintitle = "Home";
      }
      if (_currentIndex == 1) {
        maintitle = "Add Items";
      }
      if (_currentIndex == 2) {
        maintitle = "Profile";
      }
    });
  }
}

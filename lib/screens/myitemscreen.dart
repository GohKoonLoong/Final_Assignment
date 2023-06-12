import 'package:barterlt_app/screens/newitemscreen.dart';
import 'package:flutter/material.dart';
import 'package:barterlt_app/models/user.dart';

class MyItemScreen extends StatefulWidget {
  final User user;
  const MyItemScreen({super.key, required this.user});

  @override
  State<MyItemScreen> createState() => _MyItemScreenState();
}

class _MyItemScreenState extends State<MyItemScreen> {
  late double screenHeight, screenWidth;
  late List<Widget> tabchildren;
  String maintitle = "New Item";

  @override
  void initState() {
    super.initState();
    print("New Item");
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(child: Column()),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (widget.user.id != "na") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => NewItemScreen(user: widget.user)));
            }
          },
          child: const Icon(Icons.add_outlined)),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:barterlt_app/models/user.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Widget> tabchildren;
  String maintitle = "New Item";

  @override
  void initState() {
    super.initState();
    print("Home");
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 230, 140, 2),
      body: Center(
        child: Text(widget.user.name.toString()),
      ),
    );
  }
}

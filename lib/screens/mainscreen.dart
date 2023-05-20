import 'package:barterlt_app/models/user.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required User user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color.fromRGBO(240, 230, 140, 2) ,
      appBar: AppBar(
        title: const Text("Main Menu"),
        backgroundColor: Colors.transparent,
            foregroundColor: Theme.of(context).colorScheme.primary,
            elevation: 0
      ),
    );
  }
}
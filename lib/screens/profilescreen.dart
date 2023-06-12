import 'package:flutter/material.dart';
import 'package:barterlt_app/models/user.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late List<Widget> tabchildren;
  String maintitle = "Profile";

  @override
  void initState() {
    super.initState();
    print("Profile");
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(widget.user.name.toString()),
      ),
    );
  }
}

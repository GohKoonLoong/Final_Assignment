import 'package:barterlt_app/models/profilemenuscreen.dart';
import 'package:barterlt_app/screens/orderdetailscreen.dart';
import 'package:barterlt_app/screens/paymentmethodscreen.dart';
import 'package:barterlt_app/screens/sellerorderscreen.dart';
import 'package:barterlt_app/screens/updateprofilescreen.dart';
import 'package:flutter/material.dart';
import 'package:barterlt_app/models/user.dart';
import 'package:barterlt_app/screens/loginscreen.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

// for profile screen

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  late List<Widget> tabchildren;
  String maintitle = "Profile";
  late double screenHeight, screenWidth, cardwitdh;
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
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 230, 140, 2),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          maintitle,
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromRGBO(240, 230, 140, 2),
        foregroundColor: Theme.of(context).colorScheme.secondary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Stack(children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      "assets/images/profile.avif",
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 0,
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.red),
                    child: const Icon(
                      LineAwesomeIcons.alternate_pencil,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              const SizedBox(height: 10),
              Text(widget.user.name.toString(),
                  style: Theme.of(context).textTheme.headlineMedium),
              Text(widget.user.email.toString(),
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (content) =>
                                UpdateProfileScreen(user: widget.user)));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                  child: const Text("Edit Profile",
                      style: TextStyle(color: Colors.black)),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                  title: "Settings",
                  icon: LineAwesomeIcons.cog,
                  onPress: () {}),
              ProfileMenuWidget(
                  title: "Payment Methods",
                  icon: LineAwesomeIcons.wallet,
                  onPress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (content) => PaymentMethodScreen(
                                  user: widget.user,
                                )));
                  }),
              ProfileMenuWidget(
                  title: "Order Details",
                  icon: LineAwesomeIcons.receipt,
                  onPress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (content) => OrderDetailScreen(
                                  user: widget.user,
                                )));
                  }),
              ProfileMenuWidget(
                  title: "Sales",
                  icon: LineAwesomeIcons.info,
                  onPress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (content) => SellerOrderScreen(
                                  user: widget.user,
                                )));
                  }),
              ProfileMenuWidget(
                title: "Logout",
                icon: LineAwesomeIcons.alternate_sign_out,
                textColor: Colors.red,
                endIcon: false,
                onPress: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (content) => const LoginScreen()));
                },
              ),
            ])),
      ),
    );
  }
}


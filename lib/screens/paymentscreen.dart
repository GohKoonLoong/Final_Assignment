import 'package:barterlt_app/screens/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:barterlt_app/models/user.dart';

class PaymentScreen extends StatefulWidget {
  final User user;

  const PaymentScreen({super.key, required this.user});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

Color themeColor = const Color(0xFF43D19E);

class _PaymentScreenState extends State<PaymentScreen> {
  double screenWidth = 600;
  double screenHeight = 400;
  Color textColor = const Color(0xFF32567A);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 50),
          Container(
            height: 170,
            padding: const EdgeInsets.all(35),
            decoration: BoxDecoration(
              color: themeColor,
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              "assets/images/card.png",
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: screenHeight * 0.1),
          Text(
            "Thank You!",
            style: TextStyle(
              color: themeColor,
              fontWeight: FontWeight.w600,
              fontSize: 36,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          const Text(
            "Payment done Successfully",
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w400,
              fontSize: 17,
            ),
          ),
          SizedBox(height: screenHeight * 0.05),
          const Text(
            "You will be redirected to the home page shortly\nor click here to return to home page",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
          SizedBox(height: screenHeight * 0.06),
          Flexible(
            child: HomeButton(
              title: 'Home',
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (content) => MainScreen(user: widget.user),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}

class HomeButton extends StatelessWidget {
  const HomeButton({Key? key, this.title, this.onTap}) : super(key: key);

  final String? title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 200,
        decoration: BoxDecoration(
          color: themeColor,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Center(
          child: Text(
            title ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}

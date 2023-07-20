import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barterlt_app/models/user.dart';
import 'package:barterlt_app/myconfig.dart';
import 'package:barterlt_app/screens/mainscreen.dart';
import 'package:barterlt_app/screens/registrationscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late double screenHeight, screenWidth;
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isChecked = false;
  bool passwordVisible = true;

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 230, 140, 2),
      appBar: AppBar(
        title: const Text(
          "Login",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: screenHeight * 0.6,
              margin: EdgeInsets.only(top: screenHeight / 3),
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    elevation: 10,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(25, 10, 20, 25),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 60),
                            const Text(
                              "Welcome",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(229, 115, 115, 1),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) => val!.isEmpty ||
                                      !val.contains("@") ||
                                      !val.contains(".")
                                  ? "enter a valid email"
                                  : null,
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelStyle: TextStyle(),
                                labelText: 'Email',
                                icon: Icon(Icons.mail),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ),
                              ),
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.done,
                              controller: passwordController,
                              validator: (val) => val!.isEmpty ||
                                      (val.length < 5)
                                  ? "password must be longer than or equal to 5"
                                  : null,
                              obscureText: passwordVisible,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: const TextStyle(),
                                icon: const Icon(Icons.lock),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      passwordVisible = !passwordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Checkbox(
                                  value: isChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isChecked = value!;
                                    });
                                    saveremovepref(value!);
                                  },
                                ),
                                const Flexible(
                                  child: Text(
                                    'Remember me',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  color: Colors.amber,
                                  minWidth: 100,
                                  height: 35,
                                  elevation: 10,
                                  onPressed: loginUser,
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Register new account? ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.red,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            const RegistrationScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Click here",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              color: Colors.amber,
                              minWidth: 150,
                              height: 35,
                              elevation: 10,
                              onPressed: loginAsGuest,
                              child: const Text(
                                "Login as Guest",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                "assets/images/login.png",
              ),
            ),
          ],
        ),
      ),
    );
  }

  void loginUser() {
    if (!formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Check your input")),
      );
      return;
    }
    String email = emailController.text;
    String pass = passwordController.text;
    try {
      http.post(
        Uri.parse("${MyConfig().SERVER}/barterlt/php/login.php"),
        body: {
          "email": email,
          "password": pass,
        },
      ).then((response) {
        if (response.statusCode == 200) {
          var jsondata = jsonDecode(response.body);
          print(jsondata);
          if (jsondata['status'] == 'success') {
            User user = User.fromJson(jsondata['data']);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Login Success")),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (content) => MainScreen(user: user),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Login Failed")),
            );
          }
        }
      }).timeout(
        const Duration(seconds: 5),
        onTimeout: () {},
      );
    } on TimeoutException catch (_) {
      print("Time out");
    }
  }

  void loginAsGuest() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Login as Guest")),
    );

    // Redirect to desired screen after guest login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainScreen(user: User(id: "0")),
      ),
    );
  }

  void saveremovepref(bool value) async {
    FocusScope.of(context).requestFocus(FocusNode());
    String email = emailController.text;
    String password = passwordController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (value) {
      await prefs.setString('email', email);
      await prefs.setString('password', password);
      await prefs.setBool('checkbox', value);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preferences Stored")),
      );
    } else {
      await prefs.setString('email', '');
      await prefs.setString('password', '');
      await prefs.setBool('checkbox', false);

      setState(() {
        emailController.text = '';
        passwordController.text = '';
        isChecked = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preferences Removed")),
      );
    }
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('password')) ?? '';
    isChecked = (prefs.getBool('checkbox')) ?? false;
    if (isChecked) {
      setState(() {
        emailController.text = email;
        passwordController.text = password;
      });
    }
  }
}

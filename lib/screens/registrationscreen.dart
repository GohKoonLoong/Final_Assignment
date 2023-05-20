import 'package:barterlt_app/myconfig.dart';
import 'package:barterlt_app/screens/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late double screenHeight, screenWidth;
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
  bool passwordVisible = true;
  bool passwordVisible2 = true;
  bool isChecked = false;
  String eula = "";

  loadEula() async {
    eula = await rootBundle.loadString("assets/script/eula.txt");
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor:const Color.fromRGBO(240, 230, 140, 2) ,
      appBar: AppBar(
          title: const Text(
            "Registration",
            style: TextStyle(
              fontWeight: FontWeight.bold
            )),
          backgroundColor: const Color.fromRGBO(240, 230, 140, 2),
          foregroundColor: Theme.of(context).colorScheme.secondary,
          elevation: 0),
      body: SingleChildScrollView(
        child: Stack(
          children:[
            Container(
              height: screenHeight * 0.70,
              color:const Color.fromRGBO(240, 230, 140, 1),
              margin: EdgeInsets.only(top: screenHeight / 3),
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)
                    ),
                    elevation: 10,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(25, 25, 25, 25),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 20),
                            const Text(                       
                              "Register New Account",
                              style: TextStyle(
                                  fontSize: 26, 
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              validator: (val) =>
                                  val!.isEmpty || (val.length < 5)
                                      ? "name must be longer than 5"
                                      : null,
                              controller: nameController,
                              decoration: const InputDecoration(
                                  labelText: 'Name',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.person),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0))),
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.phone,
                              validator: (val) => val!.isEmpty ||
                                      (val.length < 10) || val.contains("-")
                                  ? "Equal or longer than 10 digits and no (-)"
                                  : null,
                              controller: phoneController,
                              decoration: const InputDecoration(
                                  labelText: 'Phone',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.phone),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0))),
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              validator: (val) => val!.isEmpty ||
                                      !val.contains("@") ||
                                      !val.contains(".")
                                  ? "Enter a valid email"
                                  : null,
                              controller: emailController,
                              decoration: const InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.email),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0))),
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: passwordController,
                              validator: (val) =>
                                  validatePassword(val.toString()),
                              obscureText: passwordVisible,
                              decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: const TextStyle(),
                                  icon: const Icon(Icons.lock),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0)),
                                  suffixIcon: IconButton(
                                    icon: Icon(passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        passwordVisible = !passwordVisible;
                                      });
                                    },
                                  )
                                ),
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.done,
                              controller: password2Controller,
                              validator: (val) {
                                validatePassword(val.toString());
                                if (val != passwordController.text) {
                                  return "password do not match";
                                } else {
                                  return null;
                                }
                              },
                              obscureText: passwordVisible2,
                              decoration: InputDecoration(
                                  labelText: 'Re-enter password',
                                  labelStyle: const TextStyle(),
                                  icon: const Icon(Icons.lock),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0)),
                                  suffixIcon: IconButton(
                                    icon: Icon(passwordVisible2
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        passwordVisible2 = !passwordVisible2;
                                      });
                                    },
                                  )),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Checkbox(
                                    value: isChecked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        isChecked = value!;
                                      });
                                    }),
                                Flexible(
                                    child: GestureDetector(
                                  onTap: showEULA,
                                  child: const Text(
                                    "Agree with terms",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  minWidth: 115,
                                  height: 40,
                                  elevation: 10,
                                  onPressed: registerDialog,
                                  color:const Color.fromRGBO(240, 230, 140, 2),
                                  child: const Text(
                                    "Register",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text("Already Registered? ",
                                    style: TextStyle(fontSize: 16)),
                                GestureDetector(
                                  onTap: () => {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                const LoginScreen()))
                                  },
                                  child: const Text("Login here",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 16.0, 
                                          fontWeight: FontWeight.bold)),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: screenWidth,
              child: Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  "assets/images/register.png",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
 void registerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Register new Account",
            style: TextStyle(),
          ),
          content: const Text(
            "Are you sure?",
            style: TextStyle(),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                if (!formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text("Check your input")));
                  return;
                }
                if (!isChecked) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Please agree with terms and conditions")));
                }
                String pass1 = passwordController.text;
                String pass2 = password2Controller.text;
                if (pass2 != pass1) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text("Check your password")));
                }
                registerAccount();
              }),
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          ],
        );
      },
    );
  }
  void registerAccount() {
    String name = nameController.text;
    String email = emailController.text;
    String phone = phoneController.text;
    String password1 = passwordController.text;

    http.post(Uri.parse("${MyConfig().SERVER}/barterlt/php/register.php"),
        body: {
          "name": name,
          "email": email,
          "phone": phone,
          "password": password1,
        }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registration Success")));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registration Failed")));
        }
      }
    });
  }

  String? validatePassword(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$%&*~]).{8,}$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return "Must contain upper, lower, digit and Special character";
      } else {
        return null;
      }
    }
  }

  void showEULA() {
    loadEula();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("EULA", style: TextStyle()),
            content: SizedBox(
              height: screenHeight / 1.5,
              child: Column(
                children: [
                  Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        child: RichText(
                            softWrap: true,
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.black
                                ),
                                text: eula)),
                      ))
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}

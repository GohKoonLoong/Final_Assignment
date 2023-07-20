import 'dart:convert';
import 'package:barterlt_app/models/user.dart';
import 'package:barterlt_app/myconfig.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class UpdateProfileScreen extends StatefulWidget {
  final User user;
  const UpdateProfileScreen({super.key, required this.user});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordVerificationController =
      TextEditingController();
  bool passwordVisible = true;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.user.name.toString();
    phoneController.text = widget.user.phone.toString();
    emailController.text = widget.user.email.toString();
    passwordController.text = widget.user.password.toString();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.user.name);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 230, 140, 2),
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
          style: TextStyle(
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
          child: Column(
            children: [
              Stack(
                children: [
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
                    bottom: 0,
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
                ],
              ),
              const SizedBox(height: 50),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                elevation: 10,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(25, 25, 25, 25),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          validator: (val) => val!.isEmpty || (val.length < 5)
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
                                  (val.length < 10) ||
                                  val.contains("-")
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
                          textInputAction: TextInputAction.done,
                          controller: passwordController,
                          validator: (val) => validatePassword(val.toString()),
                          obscureText:
                              passwordVisible, // Obfuscate text when not visible
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: const TextStyle(),
                            icon: const Icon(Icons.lock),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ),
                            suffixIcon: IconButton(
                                icon: Icon(!passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: verifyToogleIcon),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(10),
                height: 60,
                width: 300,
                child: ElevatedButton(
                  onPressed: verifyPassword,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                  child: const Text("Save Information",
                      style: TextStyle(color: Colors.black)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? validatePassword(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$%&*~]).{8,}$';
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

  void verifyToogleIcon() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Password'),
          content: TextFormField(
            controller: passwordVerificationController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(),
              icon: Icon(Icons.lock),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Verify'),
              onPressed: () {
                String enteredPassword = passwordVerificationController.text;
                String actualPassword = widget.user.password
                    .toString(); // Replace with the actual password
                if (enteredPassword == actualPassword) {
                  setState(() {
                    passwordVisible = !passwordVisible;
                  });
                  Navigator.of(context).pop();
                } else {
                  // Handle incorrect password
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("You have entered the wrong password")),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void verifyPassword() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Password'),
          content: TextFormField(
            controller: passwordVerificationController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(),
              icon: Icon(Icons.lock),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Verify'),
              onPressed: () {
                String enteredPassword = passwordVerificationController.text;
                String actualPassword = widget.user.password
                    .toString(); // Replace with the actual password
                if (enteredPassword == actualPassword) {
                  setState(() {
                    passwordVisible = !passwordVisible;
                  });
                  updateDetails();
                  Navigator.of(context).pop();
                } else {
                  // Handle incorrect password
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("You have entered the wrong password")),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void updateDetails() {
    String name = nameController.text;
    String email = emailController.text;
    String phone = phoneController.text;
    String newpassword = passwordController.text;

    http.post(Uri.parse("${MyConfig().SERVER}/barterlt/php/update_profile.php"),
        body: {
          "userid": widget.user.id.toString(),
          "name": name,
          "phone": phone,
          "email": email,
          "newpassword": newpassword,
        }).then((response) {
      print(response.statusCode);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Update Success")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Update Failed")));
        }
      }
    });
  }

  void saveDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Save Information",
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
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Check your input")));
                    return;
                  }
                  updateDetails();
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
}

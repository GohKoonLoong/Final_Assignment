import 'dart:math';

import 'package:barterlt_app/models/card.dart';
import 'package:barterlt_app/myconfig.dart';
import 'package:barterlt_app/screens/paymentmethodscreen.dart';
import 'package:barterlt_app/screens/paymentscreen.dart';
import 'package:flutter/material.dart';
import 'package:barterlt_app/models/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:barterlt_app/models/cart.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class CartScreen extends StatefulWidget {
  final User user;
  const CartScreen({super.key, required this.user});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CardModel> cardList = <CardModel>[];
  List<Cart> cartList = <Cart>[];
  late double screenHeight, screenWidth, containerHeight, containerWidth;
  late int axiscount = 2;
  double totalprice = 0.0;
  String password = '';
  int index = 0;
  @override
  void initState() {
    super.initState();
    loadcart();
    loadcard();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    containerHeight = screenHeight / 2;
    containerWidth = screenWidth / 2;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 230, 140, 2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        title: const Text(
          "Your Cart",
          style: TextStyle(color: Colors.red),
        ),
        iconTheme: const IconThemeData(color: Colors.red),
      ),
      body: Column(
        children: [
          cartList.isEmpty
              ? Container()
              : Expanded(
                  child: ListView.builder(
                      itemCount: cartList.length,
                      itemBuilder: (context, index) {
                        return Card(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              CachedNetworkImage(
                                width: screenWidth / 3,
                                fit: BoxFit.cover,
                                imageUrl:
                                    "${MyConfig().SERVER}/barterlt/assets/items/${cartList[index].itemId}.1.png",
                                placeholder: (context, url) =>
                                    const LinearProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                              Flexible(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        cartList[index].itemName.toString(),
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                              "RM ${double.parse(cartList[index].cartPrice.toString()).toStringAsFixed(2)}",
                                              style:
                                                  const TextStyle(fontSize: 18))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    deleteDialog(index);
                                  },
                                  icon: const Icon(Icons.delete))
                            ],
                          ),
                        ));
                      })),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Price RM ${totalprice.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (cartList.isNotEmpty) {
                            _paymentModalBottomSheet(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Your cart is empty")),
                            );
                          }
                        },
                        child: const Text("Check Out"))
                  ],
                )),
          )
        ],
      ),
    );
  }

  void loadcart() {
    http.post(Uri.parse("${MyConfig().SERVER}/barterlt/php/load_cart.php"),
        body: {
          "userid": widget.user.id,
        }).then((response) {
      // log(response.body);
      cartList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['carts'].forEach((v) {
            cartList.add(Cart.fromJson(v));
          });
          totalprice = 0.0;

          for (var element in cartList) {
            totalprice =
                totalprice + double.parse(element.cartPrice.toString());
            //print(element.catchPrice);
          }
          //print(catchList[0].catchName);
        } else {
          // Navigator.of(context).pop();
        }
        setState(() {});
      }
    });
  }

  void deleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Delete this item?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                deleteCart(index);
                //registerUser();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void deleteCart(int index) {
    http.post(Uri.parse("${MyConfig().SERVER}/barterlt/php/delete_cart.php"),
        body: {
          "cartid": cartList[index].cartId,
        }).then((response) {
      print(response.statusCode);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          loadcart();
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Delete Success")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Delete Failed")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Delete Failed")));
      }
    });
  }

  void _paymentModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SizedBox(
            height: containerHeight - 100,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                height: containerHeight / 10,
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: const Text(
                  "Google Play",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ),
              const Divider(color: Colors.black),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                height: containerHeight / 4,
                width: double.infinity,
                child: Card(
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cardList[0].bankName.toString(),
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                cardList[0].cardNumber.toString(),
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (content) => PaymentMethodScreen(
                                            user: widget.user,
                                          )));
                            },
                            icon: const Icon(Icons.navigate_next))
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(color: Colors.black),
              Container(
                height: containerHeight / 8,
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Pay Total",
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      "RM ${totalprice.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      child: IconButton(
                          onPressed: () {
                            payNow();
                          },
                          icon: const Icon(LineAwesomeIcons.wallet)),
                    ),
                    const Text("Pay Now")
                  ],
                ),
              ),
            ]),
          );
        });
  }

  void loadcard() {
    http.post(Uri.parse("${MyConfig().SERVER}/barterlt/php/load_card.php"),
        body: {
          "userid": widget.user.id,
        }).then((response) {
      // log(response.body);
      print(response.statusCode);
      cardList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['cards'].forEach((v) {
            cardList.add(CardModel.fromJson(v));
          });
        } else {
          // Navigator.of(context).pop();
        }
        setState(() {});
      }
    });
  }

  void payNow() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter password'),
          content: TextFormField(
            obscureText: true, // Set this to obscure the input
            onChanged: (value) {
              password = value;
            },
            decoration: const InputDecoration(
              hintText: 'Enter your password',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                verifyPassword(index);
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void verifyPassword(index) {
    if (password == widget.user.password) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) => PaymentScreen(user: widget.user)));
      deleteAllCart();
      insertOrder(index);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please input a correct password")));
      return;
    }
  }

  void deleteAllCart() {
    http.post(Uri.parse("${MyConfig().SERVER}/barterlt/php/delete_cart.php"),
        body: {
          "userid": widget.user.id, // or pass the user ID as needed
        }).then((response) {
      print(response.statusCode);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          //loadcart(); // Load cart items after successful deletion
        }
      }
    });
  }

  void insertOrder(int index) {
    String orderbill = generateRandomString(8);
    String orderstatus = "New";

    http.post(Uri.parse("${MyConfig().SERVER}/barterlt/php/order_details.php"),
        body: {
          "orderbill": orderbill,
          "itemid": cartList[index].itemId.toString(),
          "orderpaid": cartList[index].cartPrice.toString(),
          "userid": widget.user.id.toString(),
          "uploaderid": cartList[index].uploaderId.toString(),
          "orderstatus": orderstatus
        }).then((response) {});
  }

  String generateRandomString(int length) {
    final random = Random();
    const letters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';

    String result = '';
    for (int i = 0; i < length; i++) {
      if (random.nextBool()) {
        // Generate a random letter
        result += letters[random.nextInt(letters.length)];
      } else {
        // Generate a random number
        result += numbers[random.nextInt(numbers.length)];
      }
    }
    return result;
  }
}

import 'dart:convert';

import 'package:barterlt_app/models/user.dart';
import 'package:barterlt_app/myconfig.dart';
import 'package:barterlt_app/screens/addcardscreen.dart';
import 'package:barterlt_app/screens/cartscreen.dart';
import 'package:flutter/material.dart';
import 'package:barterlt_app/models/card.dart';
import 'package:http/http.dart' as http;

class PaymentMethodScreen extends StatefulWidget {
  final User user;
  const PaymentMethodScreen({super.key, required this.user});
  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  final List<CardModel> _cardList = [];

  @override
  void initState() {
    super.initState();
    loadcard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Method'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: _cardList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
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
                                      _cardList[index].bankName.toString(),
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      _cardList[index].cardNumber.toString(),
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (content) => CartScreen(
                                                  user: widget.user,
                                                )));
                                  },
                                  icon: const Icon(Icons.navigate_next))
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
              onPressed: () async {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) =>
                            AddCardScreen(user: widget.user)));
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }

  void loadcard() {
    http.post(Uri.parse("${MyConfig().SERVER}/barterlt/php/load_card.php"),
        body: {
          "userid": widget.user.id,
        }).then((response) {
      // log(response.body);
      _cardList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['cards'].forEach((v) {
            _cardList.add(CardModel.fromJson(v));
          });
        } else {
          // Navigator.of(context).pop();
        }
        setState(() {});
      }
    });
  }
}

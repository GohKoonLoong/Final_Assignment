// import 'dart:convert';

import 'package:barterlt_app/components/constants.dart';
import 'package:barterlt_app/models/order.dart';
// import 'package:barterlt_app/myconfig.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key, required this.order});

  final Order order;
  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  final df = DateFormat('dd/MM/yyyy');
  String status = "Loading...";

  @override
  void initState() {
    super.initState();
  }

  // final List<InvoiceItem> invoiceItems = demoData.map((data) {
  //   return InvoiceItem(
  //     data["quantity"] as int, // Cast to int
  //     data["imagePath"] as String,
  //     data["price"] as double, // Cast to double
  //     data["itemDesc"] as String,
  //   );
  // }).toList();
  @override
  Widget build(BuildContext context) {
    ScreenConfig.init(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Invoice",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
              color: Colors.white,
            ),
          ),
          toolbarHeight: 40,
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.red,
          foregroundColor: Theme.of(context).colorScheme.primary,
          elevation: 0,
        ),
        body: Column(children: [invoiceHeader(), invoiceBody()]));
  }

  Widget invoiceHeader() {
    return Container(
      width: ScreenConfig.deviceWidth,
      height: ScreenConfig.getProportionalHeight(160),
      color: Colors.red,
      padding: EdgeInsets.only(
        left: ScreenConfig.getProportionalWidth(40),
        right: ScreenConfig.getProportionalWidth(40),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              SizedBox(
                height: ScreenConfig.getProportionalHeight(40),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    "assets/images/icons8-receipt.png",
                    height: ScreenConfig.getProportionalHeight(78),
                  ),
                  detailsColumn(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Column detailsColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        topHeaderText("Bill ID: ${widget.order.orderBill}"),
        SizedBox(
          height: ScreenConfig.getProportionalHeight(20),
        ),
        topHeaderText(
            "Date: ${df.format(DateTime.parse(widget.order.orderDate.toString()))}"),
      ],
    );
  }

  Text topHeaderText(String label) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.white,
        decoration: TextDecoration.none,
        fontSize: ScreenConfig.getProportionalHeight(23),
      ),
    );
  }

  Widget invoiceBody() {
    var totalAmount = 64;
    double height =
        ScreenConfig.deviceHeight - ScreenConfig.getProportionalHeight(374);
    return Expanded(
      child: Container(
        height: height,
        padding: EdgeInsets.symmetric(
            horizontal: ScreenConfig.getProportionalWidth(40)),
        color: iPrimarryColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: ScreenConfig.getProportionalHeight(27),
              ),
              Text("Items",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenConfig.getProportionalHeight(30))),
              SizedBox(
                height: ScreenConfig.getProportionalHeight(40),
              ),
              // Column(
              //     children: List.generate(
              //   orderdetailsList.length,
              //   (index) => Column(
              //     children: [
              //       Text("")
              //         invoiceItems[index].quantity,
              //         invoiceItems[index].imagePath,
              //         invoiceItems[index].price,
              //         invoiceItems[index].itemDesc,

              //       SizedBox(
              //         height: ScreenConfig.getProportionalHeight(24),
              //       )
              //     ],
              //   ),
              // )),
              invoiceTotal(totalAmount),
              SizedBox(
                height: ScreenConfig.getProportionalHeight(56),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row invoiceTotal(int totalAmount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          children: [
            Text(
              "Total: ",
              style: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenConfig.getProportionalHeight(32)),
            ),
            SizedBox(
              width: ScreenConfig.getProportionalWidth(50),
            ),
            Text(
              "\$$totalAmount",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenConfig.getProportionalHeight(32)),
            )
          ],
        )
      ],
    );
  }

  Container invoiceItem(
      int quantity, String imagePath, double price, String itemDesc) {
    double totalValue = quantity * price;

    return Container(
      height: ScreenConfig.getProportionalHeight(170),
      padding: EdgeInsets.symmetric(
          horizontal: ScreenConfig.getProportionalWidth(27)),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 11),
                blurRadius: 11,
                color: Colors.black.withOpacity(0.06))
          ],
          borderRadius: BorderRadius.circular(6)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            quantity.toString(),
            style: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontWeight: FontWeight.bold,
                fontSize: 12),
          ),
          Image.asset(imagePath),
          Text(
            "\$$price",
            style: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontWeight: FontWeight.bold,
                fontSize: 12),
          ),
          SizedBox(
            width: ScreenConfig.getProportionalWidth(145),
            child: Text(
              itemDesc,
              style: const TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
          Text(
            "\$$totalValue",
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
          )
        ],
      ),
    );
  }
}

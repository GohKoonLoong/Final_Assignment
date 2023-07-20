import 'package:barterlt_app/components/constants.dart';
import 'package:barterlt_app/models/order.dart';
import 'package:flutter/material.dart';

import 'invoice_body.dart';

class Invoice extends StatefulWidget {
  const Invoice({super.key, required this.order});
  final Order order;
  @override
  State<Invoice> createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  @override
  Widget build(BuildContext context) {
    ScreenConfig.init(context);
    return Column(
      children: [invoiceHeader(), InvoiceBody()],
    );
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
        topHeaderText("From"),
        SizedBox(
          height: ScreenConfig.getProportionalHeight(20),
        ),
        topHeaderText("#20/07/1203"),
        SizedBox(
          height: ScreenConfig.getProportionalHeight(20),
        ),
        topHeaderText("04 October 2020"),
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
}

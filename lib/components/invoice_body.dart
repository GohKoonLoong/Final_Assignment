import 'package:barterlt_app/components/constants.dart';
import "package:flutter/material.dart";

class InvoiceBody extends StatelessWidget {
  final List<InvoiceItem> invoiceItems = demoData.map((data) {
    return InvoiceItem(
      data["quantity"] as int, // Cast to int
      data["imagePath"] as String,
      data["price"] as double, // Cast to double
      data["itemDesc"] as String,
    );
  }).toList();

  InvoiceBody({super.key});
  @override
  Widget build(BuildContext context) {
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
              Column(
                  children: List.generate(
                invoiceItems.length,
                (index) => Column(
                  children: [
                    invoiceItem(
                      invoiceItems[index].quantity,
                      invoiceItems[index].imagePath,
                      invoiceItems[index].price,
                      invoiceItems[index].itemDesc,
                    ),
                    SizedBox(
                      height: ScreenConfig.getProportionalHeight(24),
                    )
                  ],
                ),
              )),
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

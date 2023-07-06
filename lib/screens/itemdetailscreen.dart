import 'dart:convert';
import 'package:barterlt_app/screens/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:barterlt_app/models/user.dart';
import 'package:barterlt_app/models/item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:barterlt_app/myconfig.dart';
import 'package:intl/intl.dart';

class ItemDetailScreen extends StatefulWidget {
  final Item useritem;
  final User user;
  const ItemDetailScreen(
      {super.key, required this.useritem, required this.user});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  late double screenHeight, screenWidth, cardwitdh;
  final df = DateFormat('dd-MM-yyyy hh:mm a');

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 230, 140, 2),
      appBar: AppBar(
        title: const Text(
          "Item Details",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(children: [
        Flexible(
            flex: 4,
            // height: screenHeight / 2.5,
            // width: screenWidth,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: Card(
                child: SizedBox(
                  width: screenWidth,
                  child: CachedNetworkImage(
                    width: screenWidth,
                    fit: BoxFit.cover,
                    imageUrl:
                        "${MyConfig().SERVER}/barterlt/assets/items/${widget.useritem.itemId}.0.png",
                    placeholder: (context, url) =>
                        const LinearProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            )),
        Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              widget.useritem.itemName.toString(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            )),
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(4),
                1: FlexColumnWidth(6),
              },
              children: [
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Description",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      widget.useritem.itemDesc.toString(),
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Item Type",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      widget.useritem.itemType.toString(),
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Location",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      "${widget.useritem.itemLocality}/${widget.useritem.itemState}",
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Date",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      df.format(
                          DateTime.parse(widget.useritem.itemDate.toString())),
                    ),
                  )
                ]),
              ],
            ),
          ),
        ),
        // Container(
        //   padding: const EdgeInsets.all(8),
        //   child:
        //       Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        //     IconButton(
        //         onPressed: () {
        //           // if (userqty <= 1) {
        //           //   userqty = 1;
        //           //   totalprice = singleprice * userqty;
        //           // } else {
        //           //   userqty = userqty - 1;
        //           //   totalprice = singleprice * userqty;
        //           // }
        //           setState(() {});
        //         },
        //         icon: const Icon(Icons.remove)),
        //     // Text(
        //     //   userqty.toString(),
        //     //   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        //     // ),
        //     IconButton(
        //         onPressed: () {
        //           // if (userqty >= qty) {
        //           //   userqty = qty;
        //           //   totalprice = singleprice * userqty;
        //           // } else {
        //           //   userqty = userqty + 1;
        //           //   totalprice = singleprice * userqty;
        //           // }
        //           setState(() {});
        //         },
        //         icon: const Icon(Icons.add)),
        //   ]),
        // ),
        // Text(
        //   "RM ${totalprice.toStringAsFixed(2)}",
        //   style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        // ),
        // ElevatedButton(
        //     onPressed: () {
        //       addtocartdialog();
        //     },
        //     child: const Text("Add to Cart"))
      ]),
    );
  }
}
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:barterlt_app/models/user.dart';
// import 'package:barterlt_app/models/item.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:intl/intl.dart';
// import 'package:barterlt_app/myconfig.dart';
// import 'package:http/http.dart' as http;

// class ItemDetailScreen extends StatefulWidget {
//   final Item useritem;
//   final User user;
//   const ItemDetailScreen({required this.useritem, required this.user});

//   @override
//   State<ItemDetailScreen> createState() => _ItemDetailScreenState();
// }

// class _ItemDetailScreenState extends State<ItemDetailScreen> {
//   late double screenHeight, screenWidth, cardwitdh;
//   final df = DateFormat('dd-MM-yyyy hh:mm a');

//   final PageController _pageController =
//       PageController(viewportFraction: 0.8, initialPage: 1);
//   int activePage = 1;
//   List<String> imageUrls = [];

//   void initState() {
//     super.initState();
//     fetchImageUrls();
//   }

//   Future<void> fetchImageUrls() async {
//     final response = await http.get(Uri.parse(
//         "${MyConfig().SERVER}/barterlt/assets/items/${widget.useritem.itemId}.json"));

//     if (response.statusCode == 200) {
//       final jsonData = json.decode(response.body);
//       setState(() {
//         imageUrls = List<String>.from(jsonData['images']);
//       });
//     } else {
//       // Handle error case
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     screenHeight = MediaQuery.of(context).size.height;
//     screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       appBar: AppBar(title: const Text("Item Details")),
//       body: Column(
//         children: [
//           SizedBox(
//             width: screenWidth,
//             height: 200,
//             child: PageView.builder(
//               itemCount: imageUrls.length,
//               pageSnapping: true,
//               controller: _pageController,
//               onPageChanged: (page) {
//                 setState(() {
//                   activePage = page;
//                 });
//               },
//               itemBuilder: (context, pagePosition) {
//                 bool active = pagePosition == activePage;
//                 return AnimatedContainer(
//                   duration: const Duration(milliseconds: 500),
//                   curve: Curves.easeInOutCubic,
//                   margin: EdgeInsets.all(active ? 10 : 20),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(10.0),
//                     child: CachedNetworkImage(
//                       imageUrl: imageUrls[1],
//                       placeholder: (context, url) =>
//                           const CircularProgressIndicator(),
//                       errorWidget: (context, url, error) =>
//                           const Icon(Icons.error),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: indicators(imageUrls.length, activePage),
//           ),
//           Container(
//             padding: const EdgeInsets.all(8),
//             child: Text(
//               widget.useritem.itemName.toString(),
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Expanded(
//             child: Container(
//               padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
//               child: Table(
//                 columnWidths: const {
//                   0: FlexColumnWidth(4),
//                   1: FlexColumnWidth(6),
//                 },
//                 children: [
//                   TableRow(children: [
//                     const TableCell(
//                       child: Text(
//                         "Description",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     TableCell(
//                       child: Text(
//                         widget.useritem.itemDesc.toString(),
//                       ),
//                     )
//                   ]),
//                   TableRow(children: [
//                     const TableCell(
//                       child: Text(
//                         "Item Type",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     TableCell(
//                       child: Text(
//                         widget.useritem.itemType.toString(),
//                       ),
//                     )
//                   ]),
//                   TableRow(children: [
//                     const TableCell(
//                       child: Text(
//                         "Location",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     TableCell(
//                       child: Text(
//                         "${widget.useritem.itemLocality}/${widget.useritem.itemState}",
//                       ),
//                     )
//                   ]),
//                   TableRow(children: [
//                     const TableCell(
//                       child: Text(
//                         "Date",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     TableCell(
//                       child: Text(
//                         df.format(DateTime.parse(
//                             widget.useritem.itemDate.toString())),
//                       ),
//                     )
//                   ]),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   List<Widget> indicators(imagesLength, currentIndex) {
//     return List<Widget>.generate(imagesLength, (index) {
//       return Container(
//         margin: EdgeInsets.all(3),
//         width: 10,
//         height: 10,
//         decoration: BoxDecoration(
//           color: currentIndex == index ? Colors.black : Colors.black26,
//           shape: BoxShape.circle,
//         ),
//       );
//     });
//   }
// }

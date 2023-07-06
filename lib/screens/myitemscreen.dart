import 'package:barterlt_app/myconfig.dart';
import 'package:barterlt_app/screens/newitemscreen.dart';
import 'package:flutter/material.dart';
import 'package:barterlt_app/models/user.dart';
import 'package:barterlt_app/models/item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyItemScreen extends StatefulWidget {
  final User user;

  const MyItemScreen({super.key, required this.user});

  @override
  State<MyItemScreen> createState() => _MyItemScreenState();
}

class _MyItemScreenState extends State<MyItemScreen> {
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  int numofpage = 1, curpage = 1;
  int numberofresult = 0;
  late List<Widget> tabchildren;
  String maintitle = "Add Item";
  List<Item> itemList = <Item>[];
  var color;

  @override
  void initState() {
    super.initState();
    loadItems(1);
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  Future<void> refreshItems() async {
    await loadItems(1);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      axiscount = 3;
    } else {
      axiscount = 2;
    }
    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 230, 140, 2),
      appBar: AppBar(
        title: Text(
          maintitle,
          style:
              const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: refreshItems,
        child: itemList.isEmpty
            ? const Center(
                child: Text("No Data"),
              )
            : Column(children: [
                // Container(
                //   height: 24,
                //   color: const Color.fromRGBO(240, 230, 140, 2),
                //   alignment: Alignment.center,
                //   child: Text(
                //     "$numberofresult Item Found",
                //     style: const TextStyle(color: Colors.red, fontSize: 18),
                //   ),
                // ),
                SizedBox(
                  height: 40,
                  // color: Colors.white,
                  // width: screenWidth,
                  // alignment: Alignment.center,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: numofpage,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      //build the list for textbutton with scroll
                      if ((curpage - 1) == index) {
                        //set current page number active
                        color = Colors.red;
                      } else {
                        color = Colors.black;
                      }
                      return TextButton(
                          onPressed: () {
                            curpage = index + 1;
                            loadItems(index + 1);
                          },
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(color: color, fontSize: 18),
                          ));
                    },
                  ),
                ),
                Expanded(
                  child: GridView.count(
                      crossAxisCount: axiscount,
                      children: List.generate(
                        itemList.length,
                        (index) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Card(
                              child: InkWell(
                                onLongPress: () {},
                                child: Column(children: [
                                  CachedNetworkImage(
                                    height: screenHeight / 6,
                                    width: screenWidth,
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        "${MyConfig().SERVER}/barterlt/assets/items/${itemList[index].itemId}.0.png",
                                    placeholder: (context, url) =>
                                        const LinearProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                  Text(
                                    itemList[index].itemName.toString(),
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    itemList[index].itemType.toString(),
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ]),
                              ),
                            ),
                          );
                        },
                      )),
                ),
              ]),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (widget.user.id != "na") {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => NewItemScreen(
                            user: widget.user,
                          )));
              await refreshItems();
            } else {}
          },
          child: const Icon(Icons.add
          )),
    );
  }

  Future<void> loadItems(int pg) async {
    http.post(Uri.parse("${MyConfig().SERVER}/barterlt/php/load_item.php"),
        body: {
          "userid": widget.user.id,
          "pageno": pg.toString()
        }).then((response) {
      itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          numofpage = int.parse(jsondata['numofpage']); //get number of pages
          numberofresult = int.parse(jsondata['numberofresult']);
          print(numberofresult);
          var extractdata = jsondata['data'];
          extractdata['items'].forEach((v) {
            itemList.add(Item.fromJson(v));
          });
          print(itemList[0].itemName);
        }
        setState(() {});
      }
    });
  }
}

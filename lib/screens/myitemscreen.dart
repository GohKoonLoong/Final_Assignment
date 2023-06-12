import 'package:barterlt_app/myconfig.dart';
import 'package:barterlt_app/screens/newitemscreen.dart';
import 'package:flutter/material.dart';
import 'package:barterlt_app/models/user.dart';
import 'package:barterlt_app/models/item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';

class MyItemScreen extends StatefulWidget {
  final User user;

  const MyItemScreen({super.key, required this.user});

  @override
  State<MyItemScreen> createState() => _MyItemScreenState();
}

class _MyItemScreenState extends State<MyItemScreen> {
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  late List<Widget> tabchildren;
  String maintitle = "Add Item";
  List<Item> itemList = <Item>[];

  @override
  void initState() {
    super.initState();
    loadItem();
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  Future<void> refreshItems() async {
    await loadItem();
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
      appBar: AppBar(
        title: Text(maintitle),
      ),
      body: RefreshIndicator(
        onRefresh: refreshItems,
        child: itemList.isEmpty
            ? const Center(
                child: Text("No Data"),
              )
            : Column(children: [
                Container(
                  height: 24,
                  color: Colors.redAccent,
                  alignment: Alignment.center,
                  child: Text(
                    "${itemList.length} Item Found",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
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
                                        "${MyConfig().SERVER}/barterlt/assets/items/${itemList[index].itemId}.png",
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
                ))
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
          child: const Text(
            "+",
            style: TextStyle(fontSize: 32),
          )),
    );
  }

  Future<void> loadItem() async {
    if (widget.user.id == "na") {
      setState(() {
        // titlecenter = "Unregistered User";
      });
      return;
    }

    http.post(Uri.parse("${MyConfig().SERVER}/barterlt/php/load_item.php"),
        body: {"userid": widget.user.id}).then((response) {
      itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
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

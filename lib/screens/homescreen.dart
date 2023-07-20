import 'dart:convert';
import 'package:barterlt_app/screens/cartscreen.dart';
import 'package:barterlt_app/screens/itemdetailscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:barterlt_app/models/user.dart';
import 'package:barterlt_app/models/item.dart';
import 'package:barterlt_app/myconfig.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Widget> tabchildren;
  String maintitle = "Home";
  List<Item> itemList = <Item>[];
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  int numofpage = 1, curpage = 1;
  int numberofresult = 0;
  // ignore: prefer_typing_uninitialized_variables
  var color;
  int cartqty = 0;

  TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    loadItems(1);
    print("Home");
    print(widget.user.id);
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
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
        automaticallyImplyLeading: false,
        title: isSearching
            ? TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Search',
                  hintStyle:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                style: const TextStyle(color: Colors.red),
                onChanged: (value) {
                  searchItems(value);
                },
              )
            : Text(
                maintitle,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
              });
              if (!isSearching) {
                searchController.clear();
                loadItems(1);
              }
            },
            icon: Icon(
              isSearching ? Icons.close : Icons.search,
              color: Colors.red,
            ),
          ),
          TextButton.icon(
              icon: const Icon(
                Icons.shopping_cart,
              ),

              // Your icon here
              label: Text(cartqty.toString()), // Your text here
              onPressed: () async {
                if (cartqty > 0) {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => CartScreen(
                                user: widget.user,
                              )));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("No item in favourites")));
                }
              }),
        ],
      ),
      backgroundColor: const Color.fromRGBO(240, 230, 140, 2),
      body: itemList.isEmpty
          ? const Center(child: Text("No Data"))
          : RefreshIndicator(
              onRefresh: refreshItems,
              child: Column(
                children: [
                  Container(
                    height: 24,
                    color: Theme.of(context).colorScheme.primary,
                    alignment: Alignment.center,
                    child: Text(
                      "$numberofresult Items Found",
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: numofpage,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        if ((curpage - 1) == index) {
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
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: axiscount,
                      children: List.generate(itemList.length, (index) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Card(
                            child: InkWell(
                              onTap: widget.user.name == null
                                  ? null
                                  : () async {
                                      Item useritem = Item.fromJson(
                                          itemList[index].toJson());
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ItemDetailScreen(
                                            user: widget.user,
                                            useritem: useritem,
                                          ),
                                        ),
                                      );
                                      loadItems(1);
                                    },
                              child: Column(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl:
                                        "${MyConfig().SERVER}/barterlt/assets/items/${itemList[index].itemId}.1.png",
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
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> loadItems(int pg) async {
    http.post(Uri.parse("${MyConfig().SERVER}/barterlt/php/load_item.php"),
        body: {
          "pageno": pg.toString(),
          "cartuserid": widget.user.id,
        }).then((response) {
      itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          numofpage = int.parse(jsondata['numofpage']);
          numberofresult = int.parse(jsondata['numberofresult']);

          var extractdata = jsondata['data'];
          cartqty = int.parse(jsondata['cartqty'].toString());
          extractdata['items'].forEach((v) {
            itemList.add(Item.fromJson(v));
          });
          print(itemList[0].itemName);
          print(cartqty);
          print(widget.user.id);
        }
        setState(() {});
      }
    });

  }
  Future<void> refreshItems() async {
    await loadItems(1);
  }
  void searchItems(String search) {
    http.post(Uri.parse("${MyConfig().SERVER}/barterlt/php/load_item.php"),
        body: {
          "search": search,
          "cartuserid": widget.user.id,
        }).then((response) {
      itemList.clear();
      if (response.statusCode == 200) {
        print(widget.user.id);
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['items'].forEach((v) {
            itemList.add(Item.fromJson(v));
          });
        }
        setState(() {});
      }
    });
  }
}

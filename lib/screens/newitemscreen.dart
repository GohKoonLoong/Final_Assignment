import 'dart:convert';
import 'dart:io';
import 'package:barterlt_app/myconfig.dart';
import 'package:flutter/material.dart';
import 'package:barterlt_app/models/user.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart' as http;
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class NewItemScreen extends StatefulWidget {
  final User user;
  const NewItemScreen({super.key, required this.user});

  @override
  State<NewItemScreen> createState() => _NewItemScreenState();
}

class _NewItemScreenState extends State<NewItemScreen> {
  final picker = ImagePicker();
  List<File> selectedImages = [];
  var pathAsset = "assets/images/camera.jpeg";
  late double screenHeight, screenWidth, cardwitdh;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController itemnameController = TextEditingController();
  final TextEditingController itemdescController = TextEditingController();
  final TextEditingController _prstateEditingController =
      TextEditingController();
  final TextEditingController _prlocalEditingController =
      TextEditingController();
  final TextEditingController _marketvalueController = TextEditingController();
  final TextEditingController _itemInterestedController =
      TextEditingController();
  String selectedType = "Shoes";
  List<String> itemList = [
    "Shoes",
    "Books",
    "Mobile",
    "Computer",
    "Musical",
    "Tools",
    "Video Games",
    "Fashion",
    "Watches",
    "Car",
    "Property",
    "Furniture",
    "Beauty & Health",
    "Others"
  ];
  late Position _currentPosition;

  String curaddress = "";
  String curstate = "";
  String prlat = "";
  String prlong = "";

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("Insert New Item"), actions: [
        IconButton(
            onPressed: () {
              _determinePosition();
            },
            icon: const Icon(Icons.refresh))
      ]),
      body: Column(
        children: [
          Flexible(
            flex: 4,
            child: GestureDetector(
              onTap: () {
                _selectFromCamera();
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: Card(
                  child: SizedBox(
                      width: screenWidth,
                      child: selectedImages.isEmpty
                          ? Image.asset(pathAsset, fit: BoxFit.contain)
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: selectedImages.length,
                              itemBuilder: (context, index) {
                                return Image.file(selectedImages[index]);
                              },
                            )),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                          textInputAction: TextInputAction.next,
                          validator: (val) => val!.isEmpty || (val.length < 3)
                              ? "Item name must be longer than 3"
                              : null,
                          onFieldSubmitted: (v) {},
                          controller: itemnameController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              labelText: 'Item Name',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.abc),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      TextFormField(
                          textInputAction: TextInputAction.next,
                          validator: (val) => val!.isEmpty
                              ? "Item description must be longer than 10"
                              : null,
                          onFieldSubmitted: (v) {},
                          maxLines: 4,
                          controller: itemdescController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              labelText: 'Item Description',
                              alignLabelWithHint: true,
                              labelStyle: TextStyle(),
                              icon: Icon(
                                Icons.description,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      Row(
                        children: [
                          const Icon(Icons.type_specimen),
                          const SizedBox(
                            width: 16,
                          ),
                          SizedBox(
                            height: 60,
                            width: 140,
                            child: DropdownButton(
                              value: selectedType,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedType = newValue!;
                                  print(selectedType);
                                });
                              },
                              items: itemList.map((selectedType) {
                                return DropdownMenuItem(
                                  value: selectedType,
                                  child: Text(
                                    selectedType,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                                textInputAction: TextInputAction.next,
                                validator: (val) => val!.isEmpty
                                    ? "Market Value must contain value"
                                    : null,
                                onFieldSubmitted: (v) {},
                                controller: _marketvalueController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    labelText: 'Market Value',
                                    labelStyle: TextStyle(),
                                    icon: Icon(Icons.money),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    ))),
                          ),
                        ],
                      ),
                      Row(children: [
                        Flexible(
                          flex: 5,
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) =>
                                  val!.isEmpty || (val.length < 3)
                                      ? "Current State"
                                      : null,
                              enabled: false,
                              controller: _prstateEditingController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  labelText: 'Current State',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.flag),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                        ),
                        Flexible(
                          flex: 5,
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              enabled: false,
                              validator: (val) =>
                                  val!.isEmpty || (val.length < 3)
                                      ? "Current Locality"
                                      : null,
                              controller: _prlocalEditingController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  labelText: 'Current Locality',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.map),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                        ),
                      ]),
                      TextFormField(
                          textInputAction: TextInputAction.next,
                          validator: (val) => val!.isEmpty || (val.length < 3)
                              ? "Item name must be longer than 3"
                              : null,
                          onFieldSubmitted: (v) {},
                          controller: _itemInterestedController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              labelText: 'Interested Item',
                              labelStyle: TextStyle(),
                              icon: Icon(LineAwesomeIcons.box),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: screenWidth / 1.2,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () {
                              insertDialog();
                            },
                            child: const Text("Insert Item")),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectFromCamera() async {
    final pickedFileList = await picker.pickMultiImage(
      maxHeight: 1200,
      maxWidth: 800,
    );

    if (pickedFileList.isNotEmpty) {
      List<File> pickedImages =
          pickedFileList.map((pickedFile) => File(pickedFile.path)).toList();
      List<File>? croppedImages = await cropImages(pickedImages);

      if (croppedImages != null) {
        setState(() {
          selectedImages.addAll(croppedImages);
        });
      } else {
        print('No image selected.');
      }
    }
  }

  Future<List<File>?> cropImages(List<File> images) async {
    List<File> croppedImages = [];

    for (var image in images) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          // CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          // CropAspectRatioPreset.original,
          //CropAspectRatioPreset.ratio4x3,
          // CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio3x2,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );

      if (croppedFile != null) {
        croppedImages.add(File(croppedFile.path));
      }
    }

    return croppedImages.isNotEmpty ? croppedImages : null;
  }

  void insertDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
    }
    if (selectedImages.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please take picture")));
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Insert your item?",
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
                insertItem();
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

  void insertItem() async {
    String itemname = itemnameController.text;
    String itemdesc = itemdescController.text;
    String state = _prstateEditingController.text;
    String locality = _prlocalEditingController.text;
    String numofimages = selectedImages.length.toString();
    String itemInterested = _itemInterestedController.text;
    String marketValue = _marketvalueController.text;

    List<String> base64Images = [];
    for (var image in selectedImages) {
      List<int> imageBytes = await image.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      base64Images.add(base64Image);
    }
    print(numofimages);
    http.post(Uri.parse("${MyConfig().SERVER}/barterlt/php/insert_item.php"),
        body: {
          "userid": widget.user.id.toString(),
          "itemname": itemname,
          "itemdesc": itemdesc,
          "type": selectedType,
          "latitude": prlat,
          "longitude": prlong,
          "state": state,
          "locality": locality,
          "images": jsonEncode(base64Images),
          "itemInterested": itemInterested,
          "marketValue": marketValue,
          "numofimages": numofimages
        }).then((response) {
      if (response.statusCode == 200) {
        print(response.body);
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Insert Success")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Insert Failed")));
        }
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Insert Failed")));
        Navigator.pop(context);
      }
    });
  }

  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }
    _currentPosition = await Geolocator.getCurrentPosition();

    _getAddress(_currentPosition);
    //return await Geolocator.getCurrentPosition();
  }

  _getAddress(Position pos) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);
    if (placemarks.isEmpty) {
      _prlocalEditingController.text = "Changlun";
      _prstateEditingController.text = "Kedah";
      prlat = "6.443455345";
      prlong = "100.05488449";
    } else {
      _prlocalEditingController.text = placemarks[0].locality.toString();
      _prstateEditingController.text =
          placemarks[0].administrativeArea.toString();
      prlat = _currentPosition.latitude.toString();
      prlong = _currentPosition.longitude.toString();
    }
    setState(() {});
  }
}

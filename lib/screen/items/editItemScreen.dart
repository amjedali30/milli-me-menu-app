import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../dashboard.dart';
import '../../function.dart';
import '../../model/item.dart';
import '../../provider/category.dart';
import '../../provider/item.dart';
import '../../widget/optionWidget.dart';
import '../../widget/textWithLabel.dart';

class ItemEditScreen extends StatefulWidget {
  ItemEditScreen({super.key, required this.item});
  var item;

  @override
  State<ItemEditScreen> createState() => _ItemEditScreenState();
}

class _ItemEditScreenState extends State<ItemEditScreen> {
  getCate() async {
    Provider.of<CategoryService>(context, listen: false)
        .getCategory()
        .then((val) {
      setState(() {
        categoryData = val;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCate();
    print(widget.item);
    setState(() {
      String url = widget.item["image"];
      String? filename = getFilenameFromUrl(url);
      f1 = filename;
      print(f1);
      selectedSizeOption = [];
      // selectValue = widget.item["category"];
      nameCntrl.text = widget.item["name"];
      DiscCntrl.text = widget.item["discription"];
      _selectedNumber = widget.item["option"].length;
      // for (var i = 0; i < _selectedNumber!; i++) {
      //   print("========================----------===============");
      //   var a = {
      //     "option": widget.item["option"][i]["option"],
      //     "Amount": widget.item["option"][i]["Amount"],
      //   };
      //   setState(() {
      //     selectedSizeOption.add(a);
      //   });
      //   print(selectedSizeOption);
      // }
    });
    print(_selectedNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Container(
            height: 60,
            child: Image(image: AssetImage("assets/images/logo.png"))),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .4,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      imagePick(context);
                    },
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Color.fromARGB(255, 226, 226, 226))),
                      child: Center(
                        child: f1 != null
                            ? Image.network(
                                widget.item["image"],
                                fit: BoxFit
                                    .cover, // adjust the image to cover the whole widget
                              )
                            : Icon(
                                Icons.upload_file,
                                size: 19,
                                color: f1 != null
                                    ? Color.fromARGB(252, 37, 136, 22)
                                    : Colors.black54,
                              ),
                      ),
                    ),
                  ),
                  Text(
                    f1 != null ? f1! : "upload Image",
                    style: TextStyle(
                        fontSize: 11,
                        color: Color.fromARGB(126, 0, 0, 0),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width * .7,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Select Category ",
                        style: TextStyle(
                            fontSize: 13,
                            color: Color.fromRGBO(0, 0, 0, 0.494),
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "*",
                        style: TextStyle(
                            fontSize: 13,
                            color: Color.fromRGBO(255, 6, 6, 0.803),
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * .065,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Color.fromARGB(255, 226, 226, 226))),
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.category,
                          size: 17,
                          color: Colors.black45,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: DropdownButton(
                            underline: SizedBox(),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Color.fromARGB(115, 0, 0, 0)),
                            isExpanded: true,
                            hint: Text(
                              "Select Category",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: Color.fromARGB(115, 0, 0, 0)),
                            ),
                            value: selectValue,
                            items: categoryData.map((item) {
                              return DropdownMenuItem(
                                  onTap: () {
                                    // setState(() {
                                    //   choosecategoryData = {
                                    //     "id": item["id"],
                                    //     "name": item["label"]
                                    //   };
                                    // });
                                    // print(choosecategoryData);
                                  },
                                  value: item["id"],
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(item["category"]),
                                  ));
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectValue = value as String;
                              });
                              // print(selectValue);
                              // if (selectedValue != null &&
                              //     selectValue != null &&
                              //     selectedatttype != null) {
                              //   getAmount();
                              // }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  LabelWithText(
                    cntrl: nameCntrl,
                    text: "Item Name",
                    hint: "Enter Item Name",
                    icon: Icon(
                      Icons.text_decrease,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  LabelWithText(
                    cntrl: DiscCntrl,
                    text: "Item Discription",
                    hint: "Enter Item Discription",
                    icon: Icon(
                      Icons.disc_full,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ),

                  Container(
                      // height: MediaQuery.of(context).size.height * .85,
                      width: MediaQuery.of(context).size.width * .8,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "No of Options",
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Color.fromARGB(126, 0, 0, 0),
                                  fontWeight: FontWeight.bold),
                            ),
                            Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * .065,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color:
                                          Color.fromARGB(255, 226, 226, 226))),
                              padding: EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.food_bank,
                                    size: 17,
                                    color: Colors.black45,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: DropdownButton(
                                        underline: SizedBox(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            color:
                                                Color.fromARGB(115, 0, 0, 0)),
                                        isExpanded: true,
                                        hint: Text(
                                          "Select No of Options",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                              color:
                                                  Color.fromARGB(115, 0, 0, 0)),
                                        ),
                                        value: _selectedNumber,
                                        items: List.generate(
                                          10,
                                          (index) => DropdownMenuItem<int>(
                                            value: index,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text((index).toString()),
                                            ),
                                          ),
                                        ),
                                        onChanged: (newValue) {
                                          setState(() {
                                            _selectedNumber = 0;
                                            _selectedNumber = newValue!;
                                            selectedSizeOption = [];
                                          });
                                          for (var i = 0;
                                              i < _selectedNumber!;
                                              i++) {
                                            var a = {
                                              "option": "",
                                              "Amount": "",
                                            };
                                            setState(() {
                                              selectedSizeOption.add(a);
                                            });
                                          }
                                        }),
                                  ),
                                ],
                              ),
                            ),
                          ])),
                  SizedBox(
                    height: 10,
                  ),
                  // if (_selectedNumber != null)
                  //   ListView.separated(
                  //     separatorBuilder: (context, index) {
                  //       return SizedBox(
                  //         height: 10,
                  //       );
                  //     },
                  //     shrinkWrap: true,
                  //     itemBuilder: (context, index) {
                  //       return OptionWidget(index: index);
                  //     },
                  //     itemCount: _selectedNumber!,
                  //   ),

                  // SizedBox(height: 20),

                  // LabelWithText(
                  //   cntrl: PriceCntrl,
                  //   text: "Item Price",
                  //   hint: "Enter Item Price",
                  //   icon: Icon(Icons.currency_exchange),
                  // ),

                  GestureDetector(
                    onTap: () {
                      // print(selectedSizeOption);
                      bool allNonNullValues = selectedSizeOption.every(
                          (option) =>
                              option['option'] != "" && option['Amount'] != "");

                      if (allNonNullValues) {
                        // print('All options and amounts are non-null.');
                        setState(() {
                          isLoad = true;
                        });
                        if (categoryData.length > 0) {
                          if (f1 != null) {
                            if (isLoad) {
                              if (nameCntrl != "" && PriceCntrl != "") {
                                var a = ItemModel(
                                    name: nameCntrl.text,
                                    disc: DiscCntrl.text,
                                    optionPrice: selectedSizeOption,
                                    category: selectValue!,
                                    fileName: f1!,
                                    path: image!);
                                Provider.of<ItemService>(context, listen: false)
                                    .create(a)
                                    .then((val) {
                                  if (val == 200) {
                                    setState(() {
                                      isLoad = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('Item Added Successfully')),
                                    );
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DashBoardScreen()));
                                  } else {
                                    setState(() {
                                      setState(() {
                                        isLoad = false;
                                      });
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('Error adding Item...!')),
                                    );
                                  }
                                });
                              } else {
                                setState(() {
                                  isLoad = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Category not empty...!')),
                                );
                              }
                            }
                          } else {
                            setState(() {
                              isLoad = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Upload Image...!')),
                            );
                          }
                        } else {
                          setState(() {
                            isLoad = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Add Category First...!')),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Fill Item Options...!')),
                        );
                        print('Some options or amounts are null.');
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * .055,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 122, 73, 138),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: Color.fromARGB(255, 122, 73, 138))),
                      child: Center(
                          child: isLoad == false
                              ? Text(
                                  "Add Item",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )
                              : Center(
                                  child: Container(
                                  height: 20,
                                  child: SpinKitWave(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    size: 50.0,
                                  ),
                                ))),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameCntrl.dispose();
    PriceCntrl.dispose();
    DiscCntrl.dispose();
    QntyCntrl.dispose();
  }

  TextEditingController nameCntrl = TextEditingController();
  TextEditingController PriceCntrl = TextEditingController();
  TextEditingController DiscCntrl = TextEditingController();
  TextEditingController QntyCntrl = TextEditingController();
  bool isLoad = false;
  File? image;
  String? pickedImage1;
  String? f1;
  String? selectValue;
  int? _selectedNumber;
  List categoryData = [];
  imagePick(context) async {
    final pickedFile = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg'],
    );

    if (pickedFile == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No file selected')));
      return null;
    }

    setState(() {
      pickedImage1 = pickedFile.files.single.path;
      f1 = pickedFile.files.single.name;
      image = File(pickedImage1!);
    });
    image = await compressImage(image!);
  }
}

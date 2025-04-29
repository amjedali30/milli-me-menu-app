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

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  String? selectValue;
  int? _selectedNumber;
  List categoryData = [];

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
    super.initState();
    getCate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add New Item',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image upload section
              // Center(
              //   child: GestureDetector(
              //     onTap: () {
              //       imagePick(context);
              //     },
              //     child: Container(
              //       height: 180,
              //       width: 180,
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(8),
              //         color: Colors.grey.shade100,
              //         border: Border.all(color: Colors.grey.shade300, width: 1),
              //       ),
              //       child: f1 != null
              //           ? ClipRRect(
              //               borderRadius: BorderRadius.circular(8),
              //               child: Image.file(
              //                 image!,
              //                 fit: BoxFit.cover,
              //               ),
              //             )
              //           : Column(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: [
              //                 Icon(
              //                   Icons.add_photo_alternate_outlined,
              //                   size: 40,
              //                   color: Colors.grey.shade600,
              //                 ),
              //                 SizedBox(height: 8),
              //                 Text(
              //                   "Upload Image",
              //                   style: TextStyle(
              //                     fontSize: 14,
              //                     color: Colors.grey.shade600,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //     ),
              //   ),
              // ),

              SizedBox(height: 30),

              // Form fields
              Text(
                "BASIC INFORMATION",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                  letterSpacing: 1.2,
                ),
              ),

              SizedBox(height: 16),

              // Category dropdown
              DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                isExpanded: true,
                hint: Text(
                  "Select Category",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                value: selectValue,
                items: categoryData.map((item) {
                  return DropdownMenuItem(
                    value: item["id"],
                    child: Text(item["category"]),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectValue = value as String;
                  });
                },
              ),

              SizedBox(height: 16),

              // Item name field
              TextFormField(
                controller: nameCntrl,
                decoration: InputDecoration(
                  labelText: 'Item Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),

              SizedBox(height: 16),

              // Item description field
              TextFormField(
                controller: DiscCntrl,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),

              SizedBox(height: 30),

              // Item options section
              Text(
                "ITEM OPTIONS",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                  letterSpacing: 1.2,
                ),
              ),

              SizedBox(height: 16),

              // Options dropdown
              DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: 'Number of Options',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                isExpanded: true,
                hint: Text(
                  "Select Number of Options",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                value: _selectedNumber,
                items: List.generate(
                  10,
                  (index) => DropdownMenuItem<int>(
                    value: index,
                    child: Text((index).toString()),
                  ),
                ),
                onChanged: (newValue) {
                  setState(() {
                    _selectedNumber = 0;
                    _selectedNumber = newValue!;
                    selectedSizeOption = [];
                  });
                  for (var i = 0; i < _selectedNumber!; i++) {
                    var a = {
                      "option": "",
                      "Amount": "",
                    };
                    setState(() {
                      selectedSizeOption.add(a);
                    });
                  }
                },
              ),

              SizedBox(height: 16),

              // Option widgets
              if (_selectedNumber != null)
                ListView.separated(
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 12);
                  },
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: OptionWidget(index: index),
                      ),
                    );
                  },
                  itemCount: _selectedNumber!,
                ),

              SizedBox(height: 30),

              // Add item button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Same logic for adding item
                    bool allNonNullValues = selectedSizeOption.every((option) =>
                        option['option'] != "" && option['Amount'] != "");

                    if (allNonNullValues) {
                      setState(() {
                        isLoad = true;
                      });
                      if (categoryData.length > 0) {
                        // if (f1 != null) {
                        if (isLoad) {
                          if (nameCntrl.text.isNotEmpty) {
                            var a = ItemModel(
                                name: nameCntrl.text,
                                disc: DiscCntrl.text,
                                optionPrice: selectedSizeOption,
                                category: selectValue!,
                                fileName: f1 != "" ? f1 : "",
                                path: image != null ? image : null);
                            Provider.of<ItemService>(context, listen: false)
                                .create(a)
                                .then((val) {
                              if (val == 200) {
                                setState(() {
                                  isLoad = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Item Added Successfully'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DashBoardScreen()));
                              } else {
                                setState(() {
                                  isLoad = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error adding Item!'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            });
                          } else {
                            setState(() {
                              isLoad = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Name cannot be empty!'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          }
                        }
                        // } else {
                        //   setState(() {
                        //     isLoad = false;
                        //   });
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     SnackBar(
                        //       content: Text('Please upload an image'),
                        //       backgroundColor: Colors.orange,
                        //     ),
                        //   );
                        // }
                      } else {
                        setState(() {
                          isLoad = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please add categories first'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please fill all item options'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: isLoad
                      ? SpinKitThreeBounce(
                          color: Colors.white,
                          size: 24.0,
                        )
                      : Text(
                          "ADD ITEM",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameCntrl.dispose();
    PriceCntrl.dispose();
    DiscCntrl.dispose();
    QntyCntrl.dispose();
    super.dispose();
  }

  TextEditingController nameCntrl = TextEditingController();
  TextEditingController PriceCntrl = TextEditingController();
  TextEditingController DiscCntrl = TextEditingController();
  TextEditingController QntyCntrl = TextEditingController();
  bool isLoad = false;
  File? image;
  String? pickedImage1;
  String? f1;

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

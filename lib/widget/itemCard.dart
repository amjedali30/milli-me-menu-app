// import 'package:flutter/material.dart';
// import 'package:foodzone/dashboard.dart';
// import 'package:foodzone/widget/optionWidget.dart';

// class ItemCard extends StatefulWidget {
//   ItemCard(
//       {super.key,
//       required this.data,
//       required this.onItemSelected,
//       required this.index});
//   var data;
//   var index;
//   final Function(dynamic)? onItemSelected;

//   @override
//   State<ItemCard> createState() => _ItemCardState();
// }

// class _ItemCardState extends State<ItemCard> {
//   int count = 0;
//   int? foundQty;
//   bool isLoad = false;
//   getCount() async {
//     if (orderData.isNotEmpty) {
//       // for (var item in orderData) {
//       //   if (item['itemId'] == widget.data["id"]) {
//       //     foundQty = item['Qty'];
//       //     break; // Stop iteration once the item is found
//       //   }
//       // }
//       // setState(() {
//       //   isLoad = true;
//       // });
//       // if (foundQty != null) {
//       //   setState(() {
//       //     count = foundQty!;
//       //   });
//       //   print(count);
//       //   print("Quantity for item with ID ${widget.data["id"]}: $foundQty");
//       // } else {
//       //   setState(() {
//       //     count = 0;
//       //   });
//       //   print("Item with ID ${widget.data["id"]} not found.");
//       // }
//     }
//   }

//   int selectIndex = 0;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     print(widget.data["price"][0]["Amount"]);
//     setState(() {
//       _sizes = widget.data["price"].map((option) => option['option']).toList();
//       price = double.parse(widget.data["price"][0]["Amount"]);
//     });

//     getCount();
//   }

//   double price = 0;
//   var countOf;

//   setCount(String id, String opt) async {
//     final matchingItem = orderData.firstWhere(
//       (item) => item["itemId"] == id && item["option"] == opt,
//       orElse: () => null,
//     );
//     var x;
//     setState(() {
//       x = matchingItem != null ? matchingItem["Qty"] : 0.0;
//       countOf = x;
//     });

//     // print(x);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         // print(widget.data["price"]);
//         _sizes =
//             widget.data["price"].map((option) => option['option']).toList();
//         // print(_sizes);
//         diolodOpen(widget.data).then((val) {
//           setCount(
//               widget.data["id"], widget.data["price"][widget.index]["option"]);
//         });
//       },
//       child: Container(
//         decoration: BoxDecoration(
//             color: Color.fromARGB(255, 247, 241, 233),
//             borderRadius: BorderRadius.circular(8)),
//         alignment: Alignment.center,
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               Container(
//                 height: 80,
//                 decoration:
//                     BoxDecoration(borderRadius: BorderRadius.circular(10)),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: Image(image: NetworkImage(widget.data["image"])),
//                 ),
//               ),
//               // SizedBox(
//               //   height: 10,
//               // ),
//               Expanded(
//                   child: Container(
//                       width: double.infinity,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: Container(
//                               child: Column(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Text(
//                                       "${widget.data["name"]}".toUpperCase(),
//                                       style: TextStyle(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w600),
//                                     ),
//                                   ),
//                                   Expanded(
//                                       child: Container(
//                                     // color: Colors.red,
//                                     child: Column(
//                                       children: [
//                                         Container(
//                                           height: 30,
//                                           width: 200,
//                                           // color: Colors.green,
//                                           child: Row(
//                                             mainAxisAlignment: MainAxisAlignment
//                                                 .spaceEvenly, // Adjust as needed
//                                             children: _sizes.map((size) {
//                                               return InkWell(
//                                                   onTap: () {
//                                                     setState(() {
//                                                       selectIndex =
//                                                           _sizes.indexOf(size);
//                                                       setState(() {
//                                                         price = double.parse(
//                                                             widget.data["price"]
//                                                                     [
//                                                                     selectIndex]
//                                                                 ["Amount"]);
//                                                       });
//                                                       // print("------");
//                                                       // print(widget.data);
//                                                       setCount(
//                                                           widget.data["id"],
//                                                           widget.data["price"]
//                                                                   [selectIndex]
//                                                               ["option"]);
//                                                     });

//                                                     // You can perform actions based on the selected size here
//                                                     // print('Selected size: $size');
//                                                   },
//                                                   child: Container(
//                                                     width: 50,
//                                                     height:
//                                                         MediaQuery.of(context)
//                                                                 .size
//                                                                 .height *
//                                                             .5,
//                                                     decoration: BoxDecoration(
//                                                         color: selectIndex ==
//                                                                 _sizes.indexOf(
//                                                                     size)
//                                                             ? Color.fromARGB(
//                                                                 255, 252, 227, 189)
//                                                             : Colors.white,
//                                                         border: Border.all(
//                                                             width: selectIndex ==
//                                                                     _sizes
//                                                                 ? 10
//                                                                 : 0,
//                                                             color: selectIndex ==
//                                                                     _sizes.indexOf(
//                                                                         size)
//                                                                 ? Colors
//                                                                     .blueGrey
//                                                                 : Colors.white),
//                                                         borderRadius:
//                                                             BorderRadius.circular(5)),
//                                                     child: Center(
//                                                       child: Padding(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                 .only(
//                                                                 bottom: 2.0,
//                                                                 top: 2),
//                                                         child: Text(
//                                                           size,
//                                                           style: TextStyle(
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w500,
//                                                               fontSize: 12),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   )

//                                                   //  Container(
//                                                   //   padding: EdgeInsets.all(10),
//                                                   //   decoration: BoxDecoration(
//                                                   //     border: Border
//                                                   //         .all(), // Add border for better visibility
//                                                   //   ),
//                                                   //   child: Text(size),
//                                                   // ),
//                                                   );
//                                             }).toList(),
//                                           ),
//                                         ),
//                                         Expanded(
//                                           child: Container(
//                                             width: double.infinity,
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.spaceEvenly,
//                                               children: [
//                                                 Text(
//                                                   "OMR :${price.toString()}",
//                                                   style: TextStyle(
//                                                       fontSize: 13,
//                                                       fontWeight:
//                                                           FontWeight.w600),
//                                                 ),
//                                                 Text(
//                                                   countOf != null
//                                                       ? countOf.toString()
//                                                       : "0",
//                                                   style: TextStyle(
//                                                       fontSize: 13,
//                                                       fontWeight:
//                                                           FontWeight.w600),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   )),
//                                   // SizedBox(
//                                   //   height: 5,
//                                   // ),
//                                   // Text(
//                                   //   widget.data["discription"],
//                                   //   style: TextStyle(
//                                   //     fontSize: 14,
//                                   //   ),
//                                   // ),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Container(
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ))),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   String _selectedSize = '';
//   TextEditingController countCntrl = TextEditingController();
//   var selectAmount;
//   List _sizes = [];
//   diolodOpen(var item) {
//     // print(orderData);

//     return showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           // print("####");
//           // print(margin);

//           return AlertDialog(
//               title: Row(
//                 children: [
//                   Text('Add to Cart'),
//                 ],
//               ),
//               content: StatefulBuilder(
//                   builder: (BuildContext context, StateSetter setState) {
//                 return Container(
//                     padding: EdgeInsets.only(left: 10, right: 10, top: 10),
//                     height: MediaQuery.of(context).size.height * .4,
//                     child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Text(
//                             "${widget.data["name"]}".toUpperCase(),
//                             style: TextStyle(
//                                 fontSize: 14, fontWeight: FontWeight.w600),
//                           ),
//                           Container(
//                             width: 250,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "Select Option",
//                                   style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(right: 8.0),
//                                   child: Container(
//                                     width:
//                                         MediaQuery.of(context).size.width * .5,
//                                     height: MediaQuery.of(context).size.height *
//                                         .07,
//                                     child: DropdownButtonFormField<String>(
//                                       value: _selectedSize.isNotEmpty
//                                           ? _selectedSize
//                                           : null,
//                                       items: _sizes.map((size) {
//                                         return DropdownMenuItem<String>(
//                                           value: size,
//                                           child: Text(
//                                             size,
//                                             style: TextStyle(fontSize: 10),
//                                           ),
//                                         );
//                                       }).toList(),
//                                       onChanged: (value) {
//                                         setState(() {
//                                           _selectedSize = value!;

//                                           selectAmount = item["price"]
//                                               .firstWhere((option) =>
//                                                   option['option'] ==
//                                                   _selectedSize)['Amount'];
//                                           // print(selectAmount);
//                                         });
//                                         List outputList = orderData.firstWhere(
//                                             (e) =>
//                                                 e['itemId'] ==
//                                                     widget.data["name"] &&
//                                                 e["option"] == _selectedSize);
//                                       },
//                                       decoration: InputDecoration(
//                                           border: OutlineInputBorder(),
//                                           hintText: 'Select Size',
//                                           hintStyle: TextStyle(fontSize: 13)),
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 selectAmount != null
//                                     ? Row(
//                                         children: [
//                                           Text(
//                                             "Amount : ",
//                                             style: TextStyle(
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight.w600),
//                                           ),
//                                           Text(
//                                             selectAmount,
//                                             style: TextStyle(
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight.w600),
//                                           ),
//                                         ],
//                                       )
//                                     : Container(),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 Text(
//                                   "Enter Quantity : ",
//                                   style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 Container(
//                                   width: MediaQuery.of(context).size.width * .5,
//                                   child: TextField(
//                                     controller: countCntrl,
//                                     keyboardType: TextInputType.number,
//                                     decoration: const InputDecoration(
//                                       focusedBorder: OutlineInputBorder(
//                                         borderSide: BorderSide(
//                                           color: Colors.blue,
//                                           width: 1.0,
//                                         ),
//                                       ),
//                                       enabledBorder: OutlineInputBorder(
//                                         borderSide: BorderSide(
//                                           color:
//                                               Color.fromARGB(255, 63, 63, 63),
//                                           width: 1.0,
//                                         ),
//                                       ),
//                                       labelStyle: TextStyle(
//                                           fontSize: 15,
//                                           color:
//                                               Color.fromARGB(115, 66, 66, 66)),
//                                       labelText: 'Item Count',
//                                     ),
//                                     onChanged: (value) {},
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ]));
//               }),
//               actions: <Widget>[
//                 TextButton(
//                   child: Text('Close'),
//                   onPressed: () {
//                     Navigator.of(context).pop(); // Close the dialog
//                   },
//                 ),
//                 TextButton(
//                   child: Text('Proceed'),
//                   onPressed: () {
//                     addCount(
//                         item["id"],
//                         _selectedSize,
//                         double.parse(countCntrl.text),
//                         double.parse(selectAmount));
//                     Navigator.of(context).pop();
//                   },
//                 )
//               ]);
//         });
//   }

//   addCount(String id, String option, double qty, double price) async {
//     double subTotal = 0;
//     setState(() {
//       subTotal = 0;
//     });

//     if (orderData.length > 0) {
//       int srNo = orderData.length + 1;
//       // print("not empty array");
//       int index =
//           orderData.indexWhere((innerList) => innerList["itemId"].contains(id));
//       // print(index);
//       if (index == -1) {
//         // print("============item not Exist(new item)=====");
//         // print(qty);
//         // print(price);
//         subTotal = qty * price;
//         orderData.add({
//           "itemId": widget.data["id"],
//           "name": widget.data["name"],
//           "Qty": qty,
//           "price": price,
//           "option": option,
//           "subtotal": double.parse(subTotal.toStringAsFixed(2)),
//           "SrNo": srNo,
//         });
//         // print(orderData);
//       } else {
//         // print("============item Exist=====");
//         // print(orderData);
//         //  1.  Get all data in Cart
//         //  2.  Group Cart item with itemId - new List
//         //  3.  check purchaseAmt == newPurAmt && saleAmt == newSaleAmt
//         //                Update Count
//         //            Else

//         List outputList = orderData
//             .where((e) => e['itemId'] == id && e["option"] == option)
//             .toList();
//         // print(outputList);
//         if (outputList.length > 0) {
//           // print("---- equal ----");
//           // print(qty);
//           // print(price);
//           var savedSrNo = outputList[0]["SrNo"];

//           int indexSr =
//               orderData.indexWhere((element) => element["SrNo"] == savedSrNo);

//           setState(() {
//             orderData[indexSr]["Qty"] = qty;
//             subTotal = qty * price;
//             orderData[indexSr]["subtotal"] =
//                 double.parse(subTotal.toStringAsFixed(2));
//           });
//           // print("-----------");
//           // print(orderData);
//         } else {
//           // print("---- not equal ----");
//           // print(qty);
//           // print(price);
//           subTotal = qty * price;
//           setState(() {
//             orderData.add({
//               "itemId": widget.data["id"],
//               "name": widget.data["name"],
//               "Qty": qty,
//               "price": price,
//               "option": option,
//               "subtotal": double.parse(subTotal.toStringAsFixed(2)),
//               "SrNo": srNo
//             });
//           });
//         }
//       }
//       // print("---------------");
//       // print(orderData);
//       // print(count);
//     } else {
//       // print("empty array");
//       // print(qty);
//       // print(price);
//       subTotal = qty * price;
//       setState(() {
//         orderData.add({
//           "itemId": widget.data["id"],
//           "name": widget.data["name"],
//           "SrNo": 1,
//           "Qty": qty,
//           "price": price,
//           "option": option,
//           "subtotal": double.parse(subTotal.toStringAsFixed(2)),
//         });
//       });
//     }
//     getCount();
//   }
// }
import 'package:flutter/material.dart';

import '../dashboard.dart';

class ItemCard extends StatefulWidget {
  ItemCard(
      {super.key,
      required this.data,
      required this.onItemSelected,
      required this.index});
  var data;
  var index;
  final Function(dynamic)? onItemSelected;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  int count = 0;
  int? foundQty;
  bool isLoad = false;

  getCount() async {
    if (orderData.isNotEmpty) {
      // Previous commented code remains commented
    }
  }

  int selectIndex = 0;

  @override
  void initState() {
    super.initState();
    print(widget.data["price"][0]["Amount"]);
    setState(() {
      _sizes = widget.data["price"].map((option) => option['option']).toList();
      price = double.parse(widget.data["price"][0]["Amount"]);
    });

    getCount();
  }

  double price = 0;
  var countOf;

  setCount(String id, String opt) async {
    final matchingItem = orderData.firstWhere(
      (item) => item["itemId"] == id && item["option"] == opt,
      orElse: () => null,
    );
    var x;
    setState(() {
      x = matchingItem != null ? matchingItem["Qty"] : 0.0;
      countOf = x;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _sizes =
            widget.data["price"].map((option) => option['option']).toList();
        diolodOpen(widget.data).then((val) {
          setCount(
              widget.data["id"], widget.data["price"][widget.index]["option"]);
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 247, 241, 233),
            borderRadius: BorderRadius.circular(8)),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              widget.data["image"] != ""
                  ? Container(
                      height: 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image(image: NetworkImage(widget.data["image"])),
                      ),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: 80,
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.restaurant_menu,
                        color: Colors.grey[400],
                      ),
                    ),
              Expanded(
                  child: Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "${widget.data["name"]}".toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 30,
                                          width: 200,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: _sizes.map((size) {
                                              return InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      selectIndex =
                                                          _sizes.indexOf(size);
                                                      price = double.parse(
                                                          widget.data["price"]
                                                                  [selectIndex]
                                                              ["Amount"]);
                                                    });
                                                    setCount(
                                                        widget.data["id"],
                                                        widget.data["price"]
                                                                [selectIndex]
                                                            ["option"]);
                                                  },
                                                  child: Container(
                                                    width: 50,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            .5,
                                                    decoration: BoxDecoration(
                                                        color: selectIndex ==
                                                                _sizes.indexOf(
                                                                    size)
                                                            ? Color.fromARGB(
                                                                255, 252, 227, 189)
                                                            : Colors.white,
                                                        border: Border.all(
                                                            width: selectIndex ==
                                                                    _sizes.indexOf(
                                                                        size)
                                                                ? 1
                                                                : 0,
                                                            color: selectIndex ==
                                                                    _sizes.indexOf(
                                                                        size)
                                                                ? Colors.blueGrey
                                                                : Colors.white),
                                                        borderRadius: BorderRadius.circular(5)),
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 2.0,
                                                                top: 2),
                                                        child: Text(
                                                          size,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                  ));
                                            }).toList(),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            width: double.infinity,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  "Rs :${price.toString()}",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  countOf != null
                                                      ? countOf.toString()
                                                      : "0",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ))),
            ],
          ),
        ),
      ),
    );
  }

  String _selectedSize = '';
  TextEditingController countCntrl = TextEditingController();
  var selectAmount;
  List _sizes = [];

  // Updated dialog with improved UI
  diolodOpen(var item) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add to Cart',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.grey),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            content: Container(
              padding: EdgeInsets.all(10),
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height * 0.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 247, 241, 233),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: widget.data["image"] != ""
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image(
                                      image: NetworkImage(widget.data["image"]),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors.grey[200],
                                    child: Icon(
                                      Icons.restaurant_menu,
                                      color: Colors.grey[400],
                                    ),
                                  )),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${widget.data["name"]}".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              if (selectAmount != null)
                                Text(
                                  "Rs: $selectAmount",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Select Option",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'Select Size',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        value: _selectedSize.isNotEmpty ? _selectedSize : null,
                        items: _sizes.map((size) {
                          return DropdownMenuItem<String>(
                            value: size,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                size,
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setDialogState(() {
                            _selectedSize = value!;
                            selectAmount = item["price"].firstWhere((option) =>
                                option['option'] == _selectedSize)['Amount'];
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Quantity",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 80,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: countCntrl,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                setDialogState(() {
                                  int currentValue =
                                      int.tryParse(countCntrl.text) ?? 0;
                                  if (currentValue > 0) {
                                    countCntrl.text =
                                        (currentValue - 1).toString();
                                  }
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Icon(Icons.remove, size: 20),
                              ),
                            ),
                            SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                setDialogState(() {
                                  int currentValue =
                                      int.tryParse(countCntrl.text) ?? 0;
                                  countCntrl.text =
                                      (currentValue + 1).toString();
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade200,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Icon(Icons.add, size: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.grey.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black87),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Add to Cart',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        if (_selectedSize.isNotEmpty &&
                            countCntrl.text.isNotEmpty) {
                          double qty = double.tryParse(countCntrl.text) ?? 0;
                          if (qty > 0 && selectAmount != null) {
                            addCount(
                              item["id"],
                              _selectedSize,
                              qty,
                              double.parse(selectAmount),
                            );
                            Navigator.of(context).pop();
                          } else {
                            // Show error for zero quantity
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Please enter a valid quantity"),
                              duration: Duration(seconds: 2),
                            ));
                          }
                        } else {
                          // Show error for missing fields
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Please select size and quantity"),
                            duration: Duration(seconds: 2),
                          ));
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        });
      },
    );
  }

  addCount(String id, String option, double qty, double price) async {
    double subTotal = 0;
    setState(() {
      subTotal = 0;
    });

    if (orderData.length > 0) {
      int srNo = orderData.length + 1;
      int index =
          orderData.indexWhere((innerList) => innerList["itemId"].contains(id));

      if (index == -1) {
        subTotal = qty * price;
        orderData.add({
          "itemId": widget.data["id"],
          "name": widget.data["name"],
          "Qty": qty,
          "price": price,
          "option": option,
          "subtotal": double.parse(subTotal.toStringAsFixed(2)),
          "SrNo": srNo,
        });
      } else {
        List outputList = orderData
            .where((e) => e['itemId'] == id && e["option"] == option)
            .toList();

        if (outputList.length > 0) {
          var savedSrNo = outputList[0]["SrNo"];
          int indexSr =
              orderData.indexWhere((element) => element["SrNo"] == savedSrNo);

          setState(() {
            orderData[indexSr]["Qty"] = qty;
            subTotal = qty * price;
            orderData[indexSr]["subtotal"] =
                double.parse(subTotal.toStringAsFixed(2));
          });
        } else {
          subTotal = qty * price;
          setState(() {
            orderData.add({
              "itemId": widget.data["id"],
              "name": widget.data["name"],
              "Qty": qty,
              "price": price,
              "option": option,
              "subtotal": double.parse(subTotal.toStringAsFixed(2)),
              "SrNo": srNo
            });
          });
        }
      }
    } else {
      subTotal = qty * price;
      setState(() {
        orderData.add({
          "itemId": widget.data["id"],
          "name": widget.data["name"],
          "SrNo": 1,
          "Qty": qty,
          "price": price,
          "option": option,
          "subtotal": double.parse(subTotal.toStringAsFixed(2)),
        });
      });
    }

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Item added to cart"),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.green,
    ));

    getCount();
  }
}

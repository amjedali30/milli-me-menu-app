import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/order.dart';
import '../../widget/dotedDivider.dart';

class ViewOrder extends StatefulWidget {
  ViewOrder({super.key, required this.order});
  var order;

  @override
  State<ViewOrder> createState() => _ViewOrderState();
}

class _ViewOrderState extends State<ViewOrder> {
  List dataList = [];
  String paymentStatus = "";
  getOrder() async {
    // print(widget.order);
    Provider.of<OrderService>(context, listen: false)
        .getOrderById(widget.order["id"])
        .then((val) {
      // print("--------");
      // print(val);
      setState(() {
        dataList = val[0]["orderItems"];
        paymentStatus = val[0]["paymentStatus"];
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrder();
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "KOT NO:  ${widget.order["kot"]}",
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "Date:  ${widget.order["orderDate"].toDate()}",
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    paymentStatus == "done"
                        ? Text(
                            "Payment Recieved",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          )
                        : ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color.fromARGB(235, 19, 134,
                                      17)), // Change button background color
                              // You can customize other button properties here as needed
                            ),
                            onPressed: () {
                              // print(widget.order);
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return AlertDialog(
                                      title: Text(
                                        'Confirm Payment Done.!',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                      content: Text(
                                          "Kot No : ${widget.order["kot"].toString()}"),
                                      actions: [
                                        TextButton(
                                          onPressed: Navigator.of(context).pop,
                                          child: const Text('Back'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Provider.of<OrderService>(context,
                                                    listen: false)
                                                .updatePayment(
                                                    widget.order["id"])
                                                .then((val) {
                                              if (val == 200) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                      content: Text(
                                                          'Payment Successfully Recieved..')),
                                                );
                                                Navigator.pop(context);
                                                getOrder();
                                              }
                                            });
                                            // delete(
                                            //     catData[index]["id"]);
                                          },
                                          child: const Text('Proceed'),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Text(
                              "Payment Done",
                              style: TextStyle(color: Colors.white),
                            ))
                  ],
                ),
              ),
              Divider(),
              Container(
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .07,
                      height: 40,
                      // child: Text("SI No"),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .5,
                      height: 30,
                      child: Text(
                        "Item",
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .2,
                      height: 30,
                      child: Text(
                        "Qty",
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 30,
                        child: Text(
                          "Amount",
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * .07,
                            child: Text(
                              dataList[index]["SrNo"].toString(),
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * .5,
                            child: Text(
                              "${dataList[index]["name"]} ${dataList[index]["price"].toString()}",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * .2,
                            child: Text(
                              dataList[index]["Qty"].toString(),
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(right: 10),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  dataList[index]["subtotal"]
                                      .toStringAsFixed(2),
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 5,
                    );
                  },
                  itemCount: dataList.length),
              Divider(),
              Text(
                "Grand Total:       Rs. ${widget.order["total"]} ",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget recipt() {
  //   return Container(
  //     width: double.infinity,
  //     decoration: BoxDecoration(
  //         color: Colors.white, borderRadius: BorderRadius.circular(10)),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         // cmpData["logo"] != ""
  //         //     ? Container(
  //         //         height: 100,
  //         //         width: 200,
  //         //         child: Image(
  //         //           image: AssetImage(cmpData["logo"]),
  //         //         ),
  //         //       )
  //         //     : Container(
  //         //         height: 10,
  //         //       ),
  //         SizedBox(
  //           height: 10,
  //         ),
  //         Text(
  //           "FOODZONE",
  //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //         ),
  //         SizedBox(
  //           height: 5,
  //         ),
  //         Text(
  //           "Muscut",
  //           style: TextStyle(fontSize: 11),
  //         ),
  //         Text(
  //           "99537373333",
  //           style: TextStyle(fontSize: 11),
  //         ),
  //         SizedBox(
  //           height: 10,
  //         ),
  //         Text("INVOICE"),
  //         Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: DottedDivider(
  //             height: 1,
  //           ),
  //         ),

  //         Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Expanded(
  //                 child: Container(
  //                   child: Row(
  //                     children: [
  //                       Text(
  //                         "KOT NO: ",
  //                         style: TextStyle(fontSize: 11),
  //                       ),
  //                       SizedBox(
  //                         width: 10,
  //                       ),
  //                       Text(
  //                         kot != 0 ? kot.toStringAsFixed(0) : "",
  //                         // saleData[0]["invoiceNo"],
  //                         style: TextStyle(fontSize: 11),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               Container(
  //                 width: 200,
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.end,
  //                   children: [
  //                     Text(
  //                       "Date :",
  //                       style: TextStyle(fontSize: 11),
  //                     ),
  //                     Text(
  //                       formattedDateTime,
  //                       // DateFormat('dd-MM-yyyy')
  //                       //     .format(saleData[0]["date"].toDate()),
  //                       style: TextStyle(fontSize: 11),
  //                     ),
  //                   ],
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: DottedDivider(
  //             height: 1,
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.only(left: 10.0, right: 10),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 "SI No:",
  //                 style: TextStyle(fontSize: 11),
  //               ),
  //               Text(
  //                 "Item:",
  //                 style: TextStyle(fontSize: 11),
  //               ),
  //               Text(
  //                 "Qty:",
  //                 style: TextStyle(fontSize: 11),
  //               ),
  //               // Text(
  //               //   "Tax:",
  //               //   style: TextStyle(fontSize: 11),
  //               // ),
  //               Text(
  //                 "Sale Price",
  //                 style: TextStyle(fontSize: 11),
  //               ),
  //               Text(
  //                 "Amount",
  //                 style: TextStyle(fontSize: 11),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: DottedDivider(
  //             height: 1,
  //           ),
  //         ),
  //         Padding(
  //           padding: EdgeInsets.all(8.0),
  //           child: ListView.separated(
  //             shrinkWrap: true,
  //             separatorBuilder: (context, index) {
  //               return SizedBox(
  //                 height: 10,
  //               );
  //             },
  //             itemBuilder: (context, index) {
  //               return Padding(
  //                 padding: const EdgeInsets.only(left: 10.0, right: 10),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       orderData[index]["SrNo"].toString(),
  //                       style: TextStyle(fontSize: 11),
  //                     ),
  //                     SizedBox(
  //                       width: 20,
  //                     ),
  //                     Container(
  //                       width: MediaQuery.of(context).size.width * .3,
  //                       child: Text(
  //                         orderData[index]["name"],
  //                         style: TextStyle(fontSize: 11),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       width: 5,
  //                     ),
  //                     Container(
  //                       width: MediaQuery.of(context).size.width * .1,
  //                       child: Text(
  //                         orderData[index]["Qty"].toString(),
  //                         style: TextStyle(fontSize: 11),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       width: 15,
  //                     ),
  //                     Expanded(
  //                       child: Text(
  //                         orderData[index]["price"].toString(),
  //                         style: TextStyle(fontSize: 11),
  //                       ),
  //                     ),
  //                     Text(
  //                       "${orderData[index]["price"] * orderData[index]["Qty"]}"
  //                           .toString(),
  //                       style: TextStyle(fontSize: 11),
  //                     ),
  //                   ],
  //                 ),
  //               );
  //             },
  //             // itemCount: saleItems.length,
  //             itemCount: orderData.length,
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: DottedDivider(
  //             height: 1,
  //           ),
  //         ),
  //         // Padding(
  //         //   padding: const EdgeInsets.only(left: 18.0, right: 18),
  //         //   child: Row(
  //         //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         //     children: [
  //         //       Text(
  //         //         "Total ",
  //         //         style: TextStyle(fontSize: 11),
  //         //       ),
  //         //       Text(
  //         //         "",
  //         //         // saleData[0]["subTotal"].toString(),
  //         //         style: TextStyle(fontSize: 14),
  //         //       ),
  //         //     ],
  //         //   ),
  //         // ),
  //         // Padding(
  //         //   padding: const EdgeInsets.only(left: 18.0, right: 18),
  //         //   child: Row(
  //         //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         //     children: [
  //         //       Text(
  //         //         "Discount ",
  //         //         style: TextStyle(fontSize: 11),
  //         //       ),
  //         //       Text(
  //         //         "",
  //         //         // saleData[0]["discount"] == null
  //         //         //     ? 0.toString()
  //         //         //     : saleData[0]["discount"].toString(),
  //         //         style: TextStyle(fontSize: 14),
  //         //       ),
  //         //     ],
  //         //   ),
  //         // ),
  //         // Padding(
  //         //   padding: const EdgeInsets.only(left: 18.0, right: 18),
  //         //   child: Row(
  //         //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         //     children: [
  //         //       Text(
  //         //         "Total Tax ",
  //         //         style: TextStyle(fontSize: 11),
  //         //       ),
  //         //       Text(
  //         //         "",
  //         //         // saleData[0]["totalTax"].toString(),
  //         //         style: TextStyle(fontSize: 14),
  //         //       ),
  //         //     ],
  //         //   ),
  //         // ),
  //         Padding(
  //           padding: const EdgeInsets.only(left: 18.0, right: 18, top: 8),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 "Net Amount ",
  //                 style: TextStyle(fontSize: 11),
  //               ),
  //               Text(
  //                 sum.toString(),
  //                 // saleData[0]["netAmount"].toString(),
  //                 style: TextStyle(fontSize: 14),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: DottedDivider(
  //             height: 1,
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.only(left: 18.0, right: 18, top: 8),
  //           child: Column(
  //             children: [
  //               Row(
  //                 children: [
  //                   Text(
  //                     "No of Items :${orderData.length}",
  //                     style: TextStyle(fontSize: 11),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //         SizedBox(
  //           height: 10,
  //         ),

  //         // if (printing)
  //         //   Padding(
  //         //     padding: const EdgeInsets.only(left: 8.0, right: 8),
  //         //     child: Container(
  //         //       height: 40,
  //         //       width: double.infinity,
  //         //       decoration: BoxDecoration(
  //         //           color: Color.fromARGB(255, 226, 110, 37),
  //         //           borderRadius: BorderRadius.circular(5)),
  //         //       child: Center(
  //         //           child: Text(
  //         //         "Printing.....",
  //         //         style: TextStyle(
  //         //             color: Colors.white, fontWeight: FontWeight.w500),
  //         //       )),
  //         //     ),
  //         //   )
  //         // else
  //         //   GestureDetector(
  //         //     onTap: () async {
  //         //       if (statusText == "Print Reciept") {
  //         //         getdevice();
  //         //         printTicket();

  //         //         Navigator.pushAndRemoveUntil(
  //         //             context,
  //         //             MaterialPageRoute(
  //         //                 builder: (context) => DashBoardScreen()),
  //         //             (Route<dynamic> route) => false);
  //         //         setState(() {
  //         //           kot = 0;
  //         //         });
  //         //       } else {
  //         //         submitOrder();
  //         //       }
  //         //     },
  //         //     child: Padding(
  //         //       padding: const EdgeInsets.only(left: 8.0, right: 8),
  //         //       child: Container(
  //         //         height: 40,
  //         //         width: double.infinity,
  //         //         decoration: BoxDecoration(
  //         //             color: Color.fromARGB(255, 226, 110, 37),
  //         //             borderRadius: BorderRadius.circular(5)),
  //         //         child: Center(
  //         //             child: Text(
  //         //           statusText,
  //         //           style: TextStyle(
  //         //               color: Colors.white, fontWeight: FontWeight.w500),
  //         //         )),
  //         //       ),
  //         //     ),
  //         //   ),

  //         // SizedBox(
  //         //   height: 10,
  //         // ),
  //         // GestureDetector(
  //         //   onTap: () async {
  //         //     setState(() {
  //         //       orderData.clear();
  //         //     });
  //         //   },
  //         //   child: Padding(
  //         //     padding: const EdgeInsets.only(left: 8.0, right: 8),
  //         //     child: Container(
  //         //       height: 40,
  //         //       width: double.infinity,
  //         //       decoration: BoxDecoration(
  //         //           color: Color.fromARGB(255, 226, 37, 37),
  //         //           borderRadius: BorderRadius.circular(5)),
  //         //       child: Center(
  //         //           child: Text(
  //         //         "Clear Order",
  //         //         style: TextStyle(
  //         //             color: Colors.white, fontWeight: FontWeight.w500),
  //         //       )),
  //         //     ),
  //         //   ),
  //         // ),
  //       ],
  //     ),
  //   );
  // }
}

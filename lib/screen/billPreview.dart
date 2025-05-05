import 'dart:io';
import 'dart:typed_data';

import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:whatsapp_share2/whatsapp_share2.dart';

import '../dashboard.dart';
import '../provider/order.dart';
import '../widget/dotedDivider.dart';
import 'printer/samplePrint.dart';

import 'dart:io' show File, Platform;

class BillPreview extends StatefulWidget {
  BillPreview({super.key, required this.kot, required this.date});
  double kot;
  String date;

  @override
  State<BillPreview> createState() => _BillPreviewState();
}

class _BillPreviewState extends State<BillPreview> {
  DateTime now = DateTime.now();
  String formattedDateTime = "";

  // Screenshot controller
  ScreenshotController screenshotController = ScreenshotController();

  var orderDetails = [];
  double sum = 0;
  List orderList = [];

  bool isLoad = false;
  getData() async {
    print(widget.date);
    Provider.of<OrderService>(context, listen: false)
        .getOrderByKot(widget.kot, widget.date)
        .then((val) {
      print(val);
      setState(() {
        orderDetails = val;
        if (orderDetails.length > 0) {
          orderList = val[0]["orderItems"];
          sum = orderList.fold(
              0, (previousValue, item) => previousValue + (item['subtotal']));
          isLoad = true;
          orderData = orderList;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          leading: GestureDetector(
              onTap: () {
                if (statusText == "Confirm to Proceed Order") {
                  Navigator.pop(context, true);
                } else {
                  Navigator.pop(context, false);
                }
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          // backgroundColor: Colors.black,
          centerTitle: true,
          // title: Container(
          //     height: 60,
          //     child: Image(image: AssetImage("assets/images/logo.png"))),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: (isLoad == true
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: Container(
                            width: MediaQuery.of(context).size.width * .8,
                            child: recipt())),
                  )
                : Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: ListView.builder(
                      itemCount: 5, // Adjust the count based on your needs
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Container(
                            height: 20,
                            width: 200,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  )),
          ),
        ));
  }

  Widget recipt() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              controller: mobileNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Enter Mobile Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),

          SizedBox(
            height: 10,
          ),
          // Wrap the receipt in Screenshot widget
          Screenshot(
            controller: screenshotController,
            child: Container(
              color: Colors.white,
              child: buildRec(),
            ),
          ),
          SizedBox(
            height: 10,
          ),

          if (printing)
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 226, 110, 37),
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                    child: Text(
                  "Printing.....",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                )),
              ),
            )
          else
            GestureDetector(
              onTap: () async {
                getdevice();
                printTicket();
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 226, 110, 37),
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                      child: Text(
                    statusText,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  )),
                ),
              ),
            ),
          SizedBox(
            height: 10,
          ),
          // Add WhatsApp Share button
          GestureDetector(
            onTap: () {
              shareReceiptViaWhatsApp();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 37, 211, 102), // WhatsApp green
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Share via WhatsApp",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () async {
              setState(() {
                orderData.clear();
              });
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => DashBoardScreen()),
                  (Route<dynamic> route) => false);
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 226, 110, 37),
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                    child: Text(
                  "Go Back To New Order",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                )),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          orderDetails[0]["paymentStatus"] == "done"
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
                        Color.fromARGB(235, 19, 134, 17)),
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: Text(
                              'Confirm Payment Done.!',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            content: Text(
                                "Kot No : ${orderDetails[0]["kot"].toString()}"),
                            actions: [
                              TextButton(
                                onPressed: Navigator.of(context).pop,
                                child: const Text('Back'),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    isLoad = false;
                                  });
                                  Provider.of<OrderService>(context,
                                          listen: false)
                                      .updatePayment(orderDetails[0]["id"])
                                      .then((val) {
                                    if (val == 200) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Payment Successfully Recieved..')),
                                      );
                                      Navigator.pop(context);
                                      setState(() {
                                        isLoad = true;
                                      });
                                      getData();
                                    }
                                  });
                                },
                                child: const Text('Proceed'),
                              ),
                            ],
                          );
                        });
                  },
                  child: Text(
                    "Complete Payment",
                    style: TextStyle(color: Colors.white),
                  )),
        ],
      ),
    );
  }

  buildRec() {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Image(width: 200, image: AssetImage("assets/images/LOGO2.png")),
          // Text(
          //   "Milli & Me",
          //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          // ),
          SizedBox(
            height: 5,
          ),
          Text(
            "Near Sahakarana Hospital,Vatakara",
            style: TextStyle(fontSize: 11),
          ),
          Text(
            "9961 499 500",
            style: TextStyle(fontSize: 11),
          ),
          SizedBox(
            height: 10,
          ),
          Text("INVOICE"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DottedDivider(
              height: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    child: Row(
                      children: [
                        Text(
                          "Bill NO: ",
                          style: TextStyle(fontSize: 11),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          orderDetails[0]["kot"].toString(),
                          style: TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Date :",
                        style: TextStyle(fontSize: 11),
                      ),
                      Text(
                        orderDetails[0]["formatedDate"],
                        style: TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DottedDivider(
              height: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "SI No:",
                  style: TextStyle(fontSize: 11),
                ),
                Text(
                  "Item:",
                  style: TextStyle(fontSize: 11),
                ),
                Text(
                  "Qty:",
                  style: TextStyle(fontSize: 11),
                ),
                Text(
                  "Sale Price",
                  style: TextStyle(fontSize: 11),
                ),
                Text(
                  "Amount",
                  style: TextStyle(fontSize: 11),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DottedDivider(
              height: 1,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 10,
                );
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        orderList[index]["SrNo"].toString(),
                        style: TextStyle(fontSize: 11),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * .3,
                        child: Text(
                          orderList[index]["name"],
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * .1,
                        child: Text(
                          orderList[index]["Qty"].toString(),
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * .1,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            orderList[index]["price"].toStringAsFixed(2),
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            orderList[index]["subtotal"].toStringAsFixed(2),
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              itemCount: orderList.length,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DottedDivider(
              height: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18, top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Sub Amount ",
                  style: TextStyle(fontSize: 11),
                ),
                Text(
                  sum.toStringAsFixed(2),
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18, top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Additional Amount ",
                  style: TextStyle(fontSize: 11),
                ),
                Text(
                  orderDetails[0]["additionalAmount"].toStringAsFixed(2),
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18, top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Discount Amount ",
                  style: TextStyle(fontSize: 11),
                ),
                Text(
                  orderDetails[0]["discountAmount"].toStringAsFixed(2),
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18, top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Net Amount ",
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  orderDetails[0]["finalPrice"].toStringAsFixed(2),
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DottedDivider(
              height: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18, top: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "No of Items: ${orderList.length}",
                      style: TextStyle(fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  String statusText = "Print Reciept";
  double kot = 0;
  bool printing = false;

  Future<void> printTicket() async {
    String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    print(isConnected);
    if (isConnected == "true") {
      printFunction();
    } else {
      if (name != "") {
        setState(() {
          isLoadToconnect = false;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Waiting for Connecting..!'),
              content: Container(
                height: 100,
                child: SpinKitWave(
                  color: Colors.green,
                  size: 50.0,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );

        final String? result = await BluetoothThermalPrinter.connect(mac);
        print("state conneected $result");

        if (result == "true") {
          Future.delayed(Duration(seconds: 3), () {
            Navigator.of(context).pop();
          });
          const snackBar = SnackBar(
              backgroundColor: Color.fromARGB(255, 156, 41, 33),
              content: Text(
                "Printer Connected Successfully...",
                style: TextStyle(fontWeight: FontWeight.bold),
              ));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          printFunction();
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Printer Not Connect..!'),
              content: Text('Printer connect before print'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SamplePrintSc()))
                        .then((value) {
                      Navigator.of(context).pop();
                    });
                  },
                  child: Text('Goto Settings'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  bool isLoadToconnect = true;
  void printFunction() async {
    setState(() {
      printing = true;
    });
    List<int> bytes = await getTicket();
    final result = await BluetoothThermalPrinter.writeBytes(bytes);
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        printing = false;
      });
      orderList.clear();
      orderData.clear();
    });
  }

  Future<List<int>> getTicket() async {
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    bytes += generator.text("",
        styles: PosStyles(align: PosAlign.center), linesAfter: 1);
    bytes += generator.text(
      "Milli & Me",
      styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size3,
          width: PosTextSize.size2,
          bold: true),
    );
    bytes += generator.text(
      "Cafe",
      styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          bold: true),
    );

    bytes += generator.text(
      "Near Sahakarana Hospital,Vatakara",
      styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          bold: true),
    );
    bytes += generator.text(
      "9961 499 500",
      styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          bold: true),
    );
    bytes += generator.text("",
        styles: PosStyles(align: PosAlign.center), linesAfter: 1);
    bytes += generator.row([
      PosColumn(
        text: 'Date : ',
        width: 6,
        styles: PosStyles(
          align: PosAlign.left,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      ),
      PosColumn(
          text: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'Time : ',
        width: 6,
        styles: PosStyles(
          align: PosAlign.left,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      ),
      PosColumn(
          text: DateFormat('hh:mm a').format(DateTime.now()),
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
    ]);
    bytes += generator.text("",
        styles: PosStyles(align: PosAlign.center), linesAfter: 1);
    bytes += generator.row([
      PosColumn(
        text: 'KOT NO: ',
        width: 6,
        styles: PosStyles(
          align: PosAlign.left,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      ),
      PosColumn(
          text: orderDetails[0]["kot"].toString(),
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
    ]);
    bytes += generator.text("------------------------",
        styles: PosStyles(align: PosAlign.center), linesAfter: 0);
    bytes += generator.row([
      PosColumn(
          text: 'No',
          width: 1,
          styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: 'Item',
          width: 4,
          styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: 'Qty',
          width: 2,
          styles: PosStyles(align: PosAlign.center, bold: true)),
      PosColumn(
          text: 'Rate',
          width: 2,
          styles: PosStyles(align: PosAlign.center, bold: true)),
      PosColumn(
          text: 'Total',
          width: 3,
          styles: PosStyles(align: PosAlign.right, bold: true)),
    ]);
    bytes += generator.text("------------------------",
        styles: PosStyles(align: PosAlign.center), linesAfter: 1);

    for (var e in orderList) {
      bytes += generator.row([
        PosColumn(text: e["SrNo"].toString(), width: 1),
        PosColumn(
            text: e["name"],
            width: 5,
            styles: PosStyles(
              align: PosAlign.left,
            )),
        PosColumn(
            text: e["Qty"].toString(),
            width: 1,
            styles: PosStyles(
              align: PosAlign.center,
            )),
        PosColumn(
            text: e["price"].toString(),
            width: 2,
            styles: PosStyles(align: PosAlign.center)),
        PosColumn(
            text: (e["Qty"] * e["price"]).toString(),
            width: 3,
            styles: PosStyles(align: PosAlign.right)),
      ]);
    }

    bytes += generator.text("------------------------",
        styles: PosStyles(align: PosAlign.center), linesAfter: 1);
    bytes += generator.text(
      "SubTotal : ${sum.toString()}",
      styles: PosStyles(
          align: PosAlign.right,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          bold: true),
    );
    bytes += generator.text(
      "Additional Amount : ${orderDetails[0]["additionalAmount"].toString()}",
      styles: PosStyles(
          align: PosAlign.right,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          bold: true),
    );
    bytes += generator.text(
      "Discount Amount : ${orderDetails[0]["discountAmount"].toString()}",
      styles: PosStyles(
          align: PosAlign.right,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          bold: true),
    );
    bytes += generator.text(
      "Total : ${orderDetails[0]["finalPrice"].toString()}",
      styles: PosStyles(
          align: PosAlign.right,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          bold: true),
    );

    bytes += generator.text('---- Thank you! -----',
        styles: PosStyles(align: PosAlign.center, bold: true));
    bytes += generator.text('---- Visit Again -----',
        styles: PosStyles(align: PosAlign.center, bold: true));
    bytes += generator.text("",
        styles: PosStyles(align: PosAlign.center), linesAfter: 1);

    bytes += generator.cut();
    return bytes;
  }

  String mac = "";
  String name = "";
  getdevice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      mac = prefs.getString('mac') ?? "";
      name = prefs.getString('name') ?? "";
    });
  }

  // Future<void> shareReceiptViaWhatsApp() async {
  //   // Capture the receipt as an image
  //   final Uint8List? imageBytes = await screenshotController.capture();

  //   if (imageBytes != null) {
  //     // Save the image temporarily
  //     final directory = await getTemporaryDirectory();
  //     final imagePath =
  //         '${directory.path}/receipt_${orderDetails[0]["kot"].toString()}.png';
  //     final imageFile = File(imagePath);
  //     await imageFile.writeAsBytes(imageBytes);

  //     // Create WhatsApp URL with phone number
  //     // Replace with the specific phone number you want to use
  //     String phoneNumber = "9961624063"; // Using the number from your receipt

  //     // Format the message
  //     String message =
  //         "Receipt for KOT #${orderDetails[0]["kot"].toString()} - Total: ₹${orderDetails[0]["finalPrice"].toStringAsFixed(2)}";

  //     // Check platform to use the right URL scheme
  //     String whatsappUrl;
  //     if (Platform.isAndroid) {
  //       // Direct WhatsApp URL with phone number for Android
  //       whatsappUrl =
  //           "https://wa.me/$phoneNumber/?text=${Uri.encodeComponent(message)}";
  //     } else if (Platform.isIOS) {
  //       // Direct WhatsApp URL with phone number for iOS
  //       whatsappUrl =
  //           "https://api.whatsapp.com/send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}";
  //     } else {
  //       // Fallback for other platforms
  //       whatsappUrl =
  //           "https://wa.me/$phoneNumber/?text=${Uri.encodeComponent(message)}";
  //     }
  //     final Uri _url = Uri.parse(whatsappUrl);
  //     // await launchUrl(_url);
  //     // print(whatsappUrl);
  //     // Launch WhatsApp with the image
  //     // if (await canLaunchUrl(_url)) {
  //     // First open WhatsApp with the prepared message
  //     await launchUrl(_url);

  //     // Then share the image file
  //     await Future.delayed(
  //         Duration(seconds: 1)); // Small delay to ensure WhatsApp is open

  //     try {
  //       await Share.shareXFiles([XFile(imagePath)], text: message);
  //     } catch (e) {
  //       print("-------------");
  //       print(e);
  //     }

  //   }
  // }

  //// below was done
  // Future<void> shareReceiptViaWhatsApp() async {
  //   final Uint8List? imageBytes = await screenshotController.capture();

  //   if (imageBytes != null) {
  //     try {
  //       // Save the image temporarily
  //       final directory = await getTemporaryDirectory();
  //       final imagePath =
  //           '${directory.path}/receipt_${orderDetails[0]["kot"].toString()}.png';
  //       final imageFile = File(imagePath);
  //       await imageFile.writeAsBytes(imageBytes);

  //       // Format the message
  //       String message =
  //           "Receipt for KOT #${orderDetails[0]["kot"].toString()} - Total: ₹${orderDetails[0]["finalPrice"].toStringAsFixed(2)}";

  //       // Share directly without launching WhatsApp first
  //       await Share.shareXFiles(
  //         [XFile(imagePath)],
  //         text: message,
  //       );
  //     } catch (e) {
  //       print("Error sharing: $e");
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error sharing: $e')),
  //       );
  //     }
  //   }
  // }

  // Future<void> shareReceiptViaWhatsApp() async {
  //   // Capture the receipt as an image
  //   final Uint8List? imageBytes = await screenshotController.capture();

  //   if (imageBytes != null) {
  //     try {
  //       // Save the image temporarily
  //       final directory = await getTemporaryDirectory();
  //       final imagePath =
  //           '${directory.path}/receipt_${orderDetails[0]["kot"].toString()}.png';
  //       final imageFile = File(imagePath);
  //       await imageFile.writeAsBytes(imageBytes);

  //       // Create WhatsApp URL with phone number
  //       String phoneNumber = "9961624063";

  //       // Format the message
  //       String message =
  //           "Receipt for KOT #${orderDetails[0]["kot"].toString()} - Total: ₹${orderDetails[0]["finalPrice"].toStringAsFixed(2)}";

  //       // Use the share sheet to let the user choose WhatsApp
  //       await Share.shareXFiles(
  //         [XFile(imagePath)],
  //         text: message,
  //       );

  //       // After sharing, give the option to open WhatsApp directly with the number
  //       // This is optional - you can remove this if you want just the share sheet
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content:
  //               Text('Image shared. Open WhatsApp to message this number?'),
  //           action: SnackBarAction(
  //             label: 'Open',
  //             onPressed: () async {
  //               String whatsappUrl = "https://wa.me/$phoneNumber";
  //               final Uri url = Uri.parse(whatsappUrl);
  //               if (await launchUrl(url)) {
  //                 await launchUrl(url, mode: LaunchMode.externalApplication);
  //               }
  //             },
  //           ),
  //         ),
  //       );
  //     } catch (e) {
  //       print("Error sharing: $e");
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error sharing: $e')),
  //       );
  //     }
  //   }
  // }

  // Future<void> shareReceiptViaWhatsApp() async {
  //   // Capture the receipt as an image
  //   final Uint8List? imageBytes = await screenshotController.capture();

  //   if (imageBytes != null) {
  //     try {
  //       // Save the image temporarily
  //       final directory = await getTemporaryDirectory();
  //       final imagePath =
  //           '${directory.path}/receipt_${orderDetails[0]["kot"].toString()}.png';
  //       final imageFile = File(imagePath);
  //       await imageFile.writeAsBytes(imageBytes);

  //       // Create WhatsApp URL with phone number - use country code
  //       String phoneNumber = "919961624063"; // Adding 91 for India country code

  //       // For directly opening WhatsApp with this specific number
  //       String message =
  //           "Receipt for KOT #${orderDetails[0]["kot"].toString()} - Total: ₹${orderDetails[0]["finalPrice"].toStringAsFixed(2)}";

  //       // First try sharing directly to WhatsApp with the specific number
  //       if (Platform.isAndroid) {
  //         // For Android, we can try using the Intent system
  //         final Uri whatsappUri = Uri.parse(
  //             "whatsapp://send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}");

  //         if (await canLaunchUrl(whatsappUri)) {
  //           // Open WhatsApp with the specific number
  //           await launchUrl(whatsappUri);

  //           // After a brief delay, share the image file through the general share dialog
  //           // The user will likely still be in WhatsApp
  //           await Future.delayed(Duration(seconds: 1));
  //           await Share.shareXFiles([XFile(imagePath)]);
  //         } else {
  //           // Fallback to web URL if the app URL doesn't work
  //           final Uri webWhatsappUri = Uri.parse(
  //               "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}");
  //           await launchUrl(webWhatsappUri,
  //               mode: LaunchMode.externalApplication);

  //           await Future.delayed(Duration(seconds: 1));
  //           await Share.shareXFiles([XFile(imagePath)]);
  //         }
  //       } else {
  //         // For iOS
  //         final Uri whatsappUri = Uri.parse(
  //             "https://api.whatsapp.com/send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}");
  //         await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);

  //         await Future.delayed(Duration(seconds: 1));
  //         await Share.shareXFiles([XFile(imagePath)]);
  //       }
  //     } catch (e) {
  //       print("Error sharing: $e");
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error sharing: $e')),
  //       );
  //     }
  //   }
  // }
  // Future<void> shareReceiptViaWhatsApp() async {
  //   // Capture the receipt as an image
  //   final Uint8List? imageBytes = await screenshotController.capture();

  //   if (imageBytes != null) {
  //     try {
  //       // Save the image temporarily
  //       final directory = await getTemporaryDirectory();
  //       final imagePath =
  //           '${directory.path}/receipt_${orderDetails[0]["kot"].toString()}.png';
  //       final imageFile = File(imagePath);
  //       await imageFile.writeAsBytes(imageBytes);

  //       // Create WhatsApp URL with phone number - use country code
  //       String phoneNumber = "9961499500"; // Adding 91 for India country code

  //       // Create message with relevant details
  //       String message =
  //           "Receipt for Bill No #${orderDetails[0]["kot"].toString()} - Total: ₹${orderDetails[0]["finalPrice"].toStringAsFixed(2)}";

  //       // For Android
  //       // if (Platform.isAndroid) {
  //       // Create a content URI using FileProvider
  //       final authority =
  //           "${Platform.isAndroid ? 'com.example.milli_me_menu.fileprovider' : 'com.example.milli_me_menu'}";
  //       final contentUri = Uri.parse(
  //           "content://$authority${imagePath.substring(imagePath.indexOf('/data'))}");

  //       // Try direct WhatsApp intent with specific number
  //       String whatsappUrl =
  //           "https://wa.me/$phoneNumber/?text=${Uri.encodeComponent(message)}";
  //       final Uri url = Uri.parse(whatsappUrl);

  //       await launchUrl(url, mode: LaunchMode.externalApplication);

  //       // Show instructions to the user
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('WhatsApp opened. Now share the receipt image.'),
  //           duration: Duration(seconds: 15),
  //           action: SnackBarAction(
  //             label: 'Share Image',
  //             onPressed: () async {
  //               await Share.shareXFiles([XFile(imagePath)]);
  //             },
  //           ),
  //         ),
  //       );
  //       // } else {
  //       //   // For iOS - similar approach
  //       //   final Uri whatsappUri = Uri.parse(
  //       //       "https://api.whatsapp.com/send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}");
  //       //   await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);

  //       //   // Show snackbar with share image button
  //       //   ScaffoldMessenger.of(context).showSnackBar(
  //       //     SnackBar(
  //       //       content: Text('WhatsApp opened. Now share the receipt image.'),
  //       //       duration: Duration(seconds: 15),
  //       //       action: SnackBarAction(
  //       //         label: 'Share Image',
  //       //         onPressed: () async {
  //       //           await Share.shareXFiles([XFile(imagePath)]);
  //       //         },
  //       //       ),
  //       //     ),
  //       //   );
  //       // }
  //     } catch (e) {
  //       print("Error sharing: $e");
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error sharing: $e')),
  //       );
  //     }
  //   }
  // }
  Future<void> shareReceiptViaWhatsApp() async {
    final Uint8List? imageBytes = await screenshotController.capture();

    if (imageBytes != null) {
      try {
        final directory = await getTemporaryDirectory();
        final imagePath =
            '${directory.path}/receipt_${orderDetails[0]["kot"].toString()}.png';
        final imageFile = File(imagePath);
        await imageFile.writeAsBytes(imageBytes);

        // Get phone number from TextField
        String phoneNumber = mobileNumberController.text.trim();
        if (phoneNumber.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please enter a mobile number first!')),
          );
          return;
        }

        String message =
            "Receipt for Bill No #${orderDetails[0]["kot"].toString()} - Total: ₹${orderDetails[0]["finalPrice"].toStringAsFixed(2)}";

        String whatsappUrl =
            "https://wa.me/$phoneNumber/?text=${Uri.encodeComponent(message)}";
        final Uri url = Uri.parse(whatsappUrl);

        await launchUrl(url, mode: LaunchMode.externalApplication);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('WhatsApp opened. Now share the receipt image.'),
            duration: Duration(seconds: 15),
            action: SnackBarAction(
              label: 'Share Image',
              onPressed: () async {
                await Share.shareXFiles([XFile(imagePath)]);
              },
            ),
          ),
        );
      } catch (e) {
        print("Error sharing: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sharing: $e')),
        );
      }
    }
  }

  TextEditingController mobileNumberController = TextEditingController();
}

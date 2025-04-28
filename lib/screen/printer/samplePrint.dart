import 'dart:ffi';

import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SamplePrintSc extends StatefulWidget {
  @override
  _SamplePrintScState createState() => _SamplePrintScState();
}

class _SamplePrintScState extends State<SamplePrintSc> {
  @override
  void initState() {
    super.initState();
    checStatus();
  }

  checStatus() async {
    String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    if (isConnected == "true") {
      // print("Connected..........................");

      setState(() {
        indexConnceted = true;
      });
    } else {
      // print("Not Connect..........................");
      //Hadnle Not Connected Senario
    }
  }

  bool indexConnceted = false;
  int selectedindex = -1;

  bool connected = false;
  List availableBluetoothDevices = [];
  Future<void> getBluetooth() async {
    PermissionStatus status = await Permission.bluetoothConnect.request();
    if (status.isGranted) {
      // print("==================");

      final List? bluetooths = await BluetoothThermalPrinter.getBluetooths;

      // print("Print $bluetooths");
      setState(() {
        availableBluetoothDevices = bluetooths!;
      });

      const snackBar = SnackBar(
          backgroundColor: Color.fromARGB(255, 156, 41, 33),
          content: Text(
            "Please Turn On Bluetooth Device and Pair..",
            style: TextStyle(fontWeight: FontWeight.bold),
          ));
      availableBluetoothDevices.isEmpty
          ? ScaffoldMessenger.of(context).showSnackBar(snackBar)
          : null;
      // You have the BLUETOOTH_CONNECT permission, and you can use Bluetooth features.
    } else {
      // The user did not grant the permission, handle this case accordingly.
    }
  }

  Future<void> setConnect(String mac, String name, int index) async {
    String? isStatus = await BluetoothThermalPrinter.connectionStatus;
    // print(isStatus);
    if (isStatus == true) {
      // print("=======");
      // print(isStatus);
    } else {
      // print('string ' + mac.toString());
      final String? result = await BluetoothThermalPrinter.connect(mac);
      // print("state conneected $result");

      if (result == "true") {
        setState(() {
          connected = true;
          selectedindex = index;
        });
        storeData(mac, name);
        // storeData(mac, name);
        const snackBar = SnackBar(
            backgroundColor: Color.fromARGB(255, 156, 41, 33),
            content: Text(
              "Printer Connected Successfully...",
              style: TextStyle(fontWeight: FontWeight.bold),
            ));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        // print(mac);
        // print(name);

        const snackBar = SnackBar(
            backgroundColor: Color.fromARGB(255, 156, 41, 33),
            content: Text(
              "Connection Failed...",
              style: TextStyle(fontWeight: FontWeight.bold),
            ));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // final String? result = await BluetoothThermalPrinter.connect(mac);
        // if (result == "true") {
        //   setState(() {
        //     connected = true;
        //   });
        //   storeData(mac, name);
        //   // storeData(mac, name);
        //   const snackBar = SnackBar(
        //       backgroundColor: Color.fromARGB(255, 156, 41, 33),
        //       content: Text(
        //         "Printer Connected Successfully...",
        //         style: TextStyle(fontWeight: FontWeight.bold),
        //       ));
        //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
        //   Navigator.push(
        //       context, MaterialPageRoute(builder: (context) => HomeScreen()));
        // }
      }
    }
  }

  Future<void> printTicket() async {
    String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    if (isConnected == "true") {
      List<int> bytes = await getTicket();
      final result = await BluetoothThermalPrinter.writeBytes(bytes);
      // print("Print $result");
    } else {
      //Hadnle Not Connected Senario
    }
  }

  Future<void> printGraphics() async {
    String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    print("hello " + isConnected.toString());
    if (isConnected == "true") {
      List<int> bytes = await getGraphicsTicket();
      var result = await BluetoothThermalPrinter.writeBytes(bytes);
      result = await BluetoothThermalPrinter.writeText(
          "Bienvenu a Gyu-Kaku Montreal\n"
          "(514) 866-8808"
          "\n1255 Rue Crescent"
          "\nMontreal, QC H3G 2B1");
      // print("Print $result");
    } else {
      //Hadnle Not Connected Senario
    }
  }

  Future<List<int>> getGraphicsTicket() async {
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
// Print QR Code using native function
    bytes += generator.qrcode('example.com');
    bytes += generator.hr();
// Print Barcode using native function
    final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    bytes += generator.barcode(Barcode.upcA(barData));
    bytes += generator.cut();
    return bytes;
  }

  Future<List<int>> getTicket() async {
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    bytes += generator.text("",
        styles: PosStyles(align: PosAlign.center), linesAfter: 1);
    bytes += generator.text(
      "Bienvenu a Guy-Kaku Montreal",
      styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          bold: true),
    );
    // bytes += generator.text(
    //   "(514) 866-8808\n1255 Rue Crescent,\nMontreal, QC H3G 2B1",
    //   styles: PosStyles(
    //       align: PosAlign.center,
    //       height: PosTextSize.size1,
    //       width: PosTextSize.size1,
    //       bold: true),
    // );
    bytes += generator.text("",
        styles: PosStyles(align: PosAlign.center), linesAfter: 1);
    bytes += generator.row([
      PosColumn(
        text: 'Server: Tida',
        width: 6,
        styles: PosStyles(
          align: PosAlign.left,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      ),
      PosColumn(
          text: "05/05/2022",
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
    ]);
    bytes += generator.row([
      PosColumn(
          text: '1000/1',
          width: 6,
          styles: PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(
          text: "11:55 AM",
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
    ]);
    bytes += generator.row([
      PosColumn(
          text: 'Guests: 0',
          width: 6,
          styles: PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(
          text: '',
          width: 6,
          styles: PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
    ]);
    bytes += generator.text("",
        styles: PosStyles(align: PosAlign.center), linesAfter: 1);
    bytes += generator.row([
      PosColumn(
          text: 'Fiscal Transaction ID:',
          width: 8,
          styles: PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(
          text: "20220505115503",
          width: 4,
          styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
    ]);
    // bytes += generator.text('Order Type: Take-Out',
    //     styles: PosStyles(align: PosAlign.left));
    // bytes += generator.text('Area: TakeOut',
    //     styles: PosStyles(align: PosAlign.left));
    // bytes += generator.text('Menu: HH Lunch Server',
    //     styles: PosStyles(align: PosAlign.left));
    // bytes += generator.text('Day Part: Lunch',
    //     styles: PosStyles(align: PosAlign.left), linesAfter: 1);
    // bytes += generator.text('TakeOut Order',
    //     styles: PosStyles(align: PosAlign.left), linesAfter: 1);
    // bytes += generator.row([
    //   PosColumn(
    //       text: 'Sukiyaki FriedRice w/Beef',
    //       width: 6,
    //       styles: PosStyles(
    //         align: PosAlign.center,
    //         height: PosTextSize.size1,
    //         width: PosTextSize.size1,
    //       )),
    //   PosColumn(
    //       text: "14.95",
    //       width: 6,
    //       styles: PosStyles(
    //         align: PosAlign.right,
    //         height: PosTextSize.size1,
    //         width: PosTextSize.size1,
    //       )),
    // ]);
    // bytes += generator.row([
    //   PosColumn(
    //       text: 'Sukiyaki FriedRice w/Beef',
    //       width: 6,
    //       styles: PosStyles(
    //         align: PosAlign.center,
    //         height: PosTextSize.size1,
    //         width: PosTextSize.size1,
    //       )),
    //   PosColumn(
    //       text: "14.95",
    //       width: 6,
    //       styles: PosStyles(
    //         align: PosAlign.right,
    //         height: PosTextSize.size1,
    //         width: PosTextSize.size1,
    //       )),
    // ]);
    bytes += generator.text("",
        styles: PosStyles(align: PosAlign.center), linesAfter: 1);
    bytes += generator.row([
      PosColumn(
          text: 'Complete Subtotal',
          width: 6,
          styles: PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(
          text: "22.95",
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
    ]);
    // bytes += generator.row([
    //   PosColumn(
    //       text: 'TPS',
    //       width: 6,
    //       styles: PosStyles(
    //         align: PosAlign.left,
    //         height: PosTextSize.size1,
    //         width: PosTextSize.size1,
    //       )),
    //   PosColumn(
    //       text: "0.95",
    //       width: 6,
    //       styles: PosStyles(
    //         align: PosAlign.right,
    //         height: PosTextSize.size1,
    //         width: PosTextSize.size1,
    //       )),
    // ]);
    bytes += generator.text("",
        styles: PosStyles(align: PosAlign.center), linesAfter: 1);
    // bytes += generator.row([
    //   PosColumn(
    //       text: 'TOTAL',
    //       width: 6,
    //       styles: PosStyles(
    //         align: PosAlign.left,
    //         height: PosTextSize.size2,
    //         width: PosTextSize.size2,
    //       )),
    //   PosColumn(
    //       text: "35\$",
    //       width: 6,
    //       styles: PosStyles(
    //         align: PosAlign.right,
    //         height: PosTextSize.size2,
    //         width: PosTextSize.size2,
    //       )),
    // ]);
    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(
          text: 'No',
          width: 1,
          styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: 'Item',
          width: 5,
          styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: 'Price',
          width: 2,
          styles: PosStyles(align: PosAlign.center, bold: true)),
      PosColumn(
          text: 'Qty',
          width: 2,
          styles: PosStyles(align: PosAlign.center, bold: true)),
      PosColumn(
          text: 'Total',
          width: 2,
          styles: PosStyles(align: PosAlign.right, bold: true)),
    ]);
    bytes += generator.row([
      PosColumn(text: "1", width: 1),
      PosColumn(
          text: "Tea",
          width: 5,
          styles: PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: "10",
          width: 2,
          styles: PosStyles(
            align: PosAlign.center,
          )),
      PosColumn(text: "1", width: 2, styles: PosStyles(align: PosAlign.center)),
      PosColumn(text: "10", width: 2, styles: PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.row([
      PosColumn(text: "2", width: 1),
      PosColumn(
          text: "Sada Dosa",
          width: 5,
          styles: PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: "30",
          width: 2,
          styles: PosStyles(
            align: PosAlign.center,
          )),
      PosColumn(text: "1", width: 2, styles: PosStyles(align: PosAlign.center)),
      PosColumn(text: "30", width: 2, styles: PosStyles(align: PosAlign.right)),
    ]);
    // bytes += generator.row([
    //   PosColumn(text: "3", width: 1),
    //   PosColumn(
    //       text: "Masala Dosa",
    //       width: 5,
    //       styles: PosStyles(
    //         align: PosAlign.left,
    //       )),
    //   PosColumn(
    //       text: "50",
    //       width: 2,
    //       styles: PosStyles(
    //         align: PosAlign.center,
    //       )),
    //   PosColumn(text: "1", width: 2, styles: PosStyles(align: PosAlign.center)),
    //   PosColumn(text: "50", width: 2, styles: PosStyles(align: PosAlign.right)),
    // ]);
    // bytes += generator.row([
    //   PosColumn(text: "4", width: 1),
    //   PosColumn(
    //       text: "Rova Dosa",
    //       width: 5,
    //       styles: PosStyles(
    //         align: PosAlign.left,
    //       )),
    //   PosColumn(
    //       text: "70",
    //       width: 2,
    //       styles: PosStyles(
    //         align: PosAlign.center,
    //       )),
    //   PosColumn(text: "1", width: 2, styles: PosStyles(align: PosAlign.center)),
    //   PosColumn(text: "70", width: 2, styles: PosStyles(align: PosAlign.right)),
    // ]);
    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(
          text: 'TOTAL',
          width: 6,
          styles: PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size4,
            width: PosTextSize.size4,
          )),
      PosColumn(
          text: "160",
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size4,
            width: PosTextSize.size4,
          )),
    ]);
    bytes += generator.hr(ch: '=', linesAfter: 1);
// ticket.feed(2);
    bytes += generator.text('Thank you!',
        styles: PosStyles(align: PosAlign.center, bold: true));
    bytes += generator.text("26-11-2020 15:22:45",
        styles: PosStyles(align: PosAlign.center), linesAfter: 1);
    bytes += generator.text(
        'Note: Goods once sold will not be taken back or exchanged.',
        styles: PosStyles(align: PosAlign.center, bold: false));
    bytes += generator.cut();
    return bytes;
  }

  String name = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Printer'),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (await Permission.bluetoothScan.request().isGranted) {
              getBluetooth();
              setState(() {
                indexConnceted = false;
              });
              // Permission is granted. You can now perform Bluetooth operations.
              // For example, start Bluetooth scanning or connect to devices.
            } else {
              // Permission is not granted. Handle accordingly.
              // You might want to inform the user about the necessity of the Bluetooth scan permission.
            }
          },
          child: Icon(Icons.search)),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            indexConnceted == true
                ? Row(
                    children: [
                      Text("App Already Connceted......"),
                      TextButton(
                        onPressed: this.printTicket,
                        child: Text("Print Ticket"),
                      )
                    ],
                  )
                : Container(),

            // Text("Select Bluetooth Device"),
            // TextButton(
            //   onPressed: () {
            //     getBluetooth();
            //   },
            //   child: Text("Search"),
            // ),

            // connected
            //     ? TextButton(
            //         onPressed: this.printGraphics,
            //         child: Text("Print"),
            //       )
            //     : Container(),
            // connected
            //     ? TextButton(
            //         onPressed: connected ? this.printTicket : null,
            //         child: Text("Print Ticket"),
            //       )
            //     : Container(),

            availableBluetoothDevices.isNotEmpty
                ? Expanded(
                    child: Container(
                      // height: 200,

                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: availableBluetoothDevices.isNotEmpty
                            ? availableBluetoothDevices.length
                            : 0,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              String select = availableBluetoothDevices[index];
                              List list = select.split("#");
                              name = list[0];
                              String mac = list[1];
                              // print("-----------");
                              // print(name);

                              this.setConnect(mac, name, index);
                            },
                            title: Text('${availableBluetoothDevices[index]}'),
                            subtitle: Text(selectedindex == index
                                ? "Connected"
                                : "Click to connect"),
                          );
                        },
                      ),
                    ),
                  )
                : Container(
                    height: 300,
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "No Bluetooth device detected... ",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(174, 240, 147, 147)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "You can Search And Connect....",
                          style:
                              TextStyle(color: Color.fromARGB(176, 86, 86, 86)),
                        ),
                      ],
                    ))),

            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  Future storeData(String macId, String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("mac", macId);
    await prefs.setString("name", name);
  }
}

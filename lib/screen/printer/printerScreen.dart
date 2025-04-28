import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widget/commonDrawer.dart';
import 'samplePrint.dart';

class PrinterScreen extends StatefulWidget {
  const PrinterScreen({super.key});

  @override
  State<PrinterScreen> createState() => _PrinterScreenState();
}

class _PrinterScreenState extends State<PrinterScreen> {
  String mac = "";
  String name = "";
  getdevice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      mac = prefs.getString('mac')!;
      name = prefs.getString('name')!;
    });
    // print(mac);
    // print(name);
  }

  Future<void> setConnect(String mac, String name) async {
    // print('string ' + mac.toString());
    final String? result = await BluetoothThermalPrinter.connect(mac);
    // print("state conneected $result");

    if (result == "true") {
      setState(() {
        connected = true;
      });
      const snackBar = SnackBar(
          backgroundColor: Color.fromARGB(255, 156, 41, 33),
          content: Text(
            "Printer Connected Successfully...",
            style: TextStyle(fontWeight: FontWeight.bold),
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      const snackBar1 = SnackBar(
          backgroundColor: Color.fromARGB(255, 156, 41, 33),
          content: Text(
            "Ready to Print...",
            style: TextStyle(fontWeight: FontWeight.bold),
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar1);
      printTicket();
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => HomeScreen()));
      // storeData(mac, name);
    }
  }

  noConncect() {
    // printTicket();
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdevice();
  }

  bool connected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(page: "CRM"),
      appBar: AppBar(
        title: Text("Printer "),
        // actions: [
        //   name != ""
        //       ? Center(
        //           child: Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: GestureDetector(
        //             onTap: () {
        //               setConnect(mac, name);
        //             },
        //             child: Text(
        //               "Print con fn",
        //               style: TextStyle(color: Colors.black),
        //             ),
        //           ),
        //         ))
        //       : Text(""),
        //   name != ""
        //       ? Center(
        //           child: Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: GestureDetector(
        //             onTap: () {
        //               noConncect();
        //             },
        //             child: Text(
        //               "Print nocon fn",
        //               style: TextStyle(color: Colors.black),
        //             ),
        //           ),
        //         ))
        //       : Text(""),
        // ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SamplePrintSc()));
          },
          child: Icon(Icons.add)),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: name != ""
            ? Column(
                children: [
                  ListTile(
                    onTap: () {
                      // setConnect(mac, name);
                    },
                    leading: Icon(Icons.print_disabled_outlined),
                    title: Text(name),
                    // trailing: GestureDetector(
                    //     onTap: () async {
                    //       // SharedPreferences preferences =
                    //       //     await SharedPreferences.getInstance();
                    //       // await preferences.remove("name");
                    //       // await preferences.remove("mac");
                    //       // setState(() {
                    //       //   name = "";
                    //       //   mac = "";
                    //       // });
                    //     },
                    //     child: Icon(Icons.remove_circle)),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage("assets/images/5572.jpg"),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "You Have No Printers Yet",
                    style: TextStyle(
                        color: Color.fromARGB(255, 112, 111, 111),
                        fontSize: 16),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "To add the printers, Press the (+) botton",
                    style: TextStyle(
                        color: Color.fromARGB(136, 112, 111, 111),
                        fontSize: 13),
                  ),
                ],
              ),
      ),
    );
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
          height: PosTextSize.size4,
          width: PosTextSize.size1,
          bold: true),
    );

    bytes += generator.text("-----------------------",
        styles: PosStyles(align: PosAlign.center), linesAfter: 1);
    bytes += generator.text("======================",
        styles: PosStyles(align: PosAlign.center), linesAfter: 1);
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
          text: 'Qty',
          width: 1,
          styles: PosStyles(align: PosAlign.center, bold: true)),
      PosColumn(
          text: 'Price',
          width: 2,
          styles: PosStyles(align: PosAlign.center, bold: true)),
      PosColumn(
          text: 'Total',
          width: 3,
          styles: PosStyles(align: PosAlign.right, bold: true)),
    ]);
    bytes += generator.row([
      PosColumn(text: "1", width: 1),
      PosColumn(
          text: "Tea ffffffff hhhh hjjkkcd dccdj",
          width: 5,
          styles: PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: "10",
          width: 1,
          styles: PosStyles(
            align: PosAlign.center,
          )),
      PosColumn(
          text: "1000", width: 2, styles: PosStyles(align: PosAlign.center)),
      PosColumn(
          text: "1000.00", width: 3, styles: PosStyles(align: PosAlign.right)),
    ]);

    bytes += generator.cut();
    return bytes;
  }
}

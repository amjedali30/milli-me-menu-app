import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../provider/order.dart';
import '../../widget/commonDrawer.dart';
import '../billPreview.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  List orderData = [];
  double grandTotal = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(page: "CRM"),
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Image.asset(
          "assets/images/logo.png",
          height: 50,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            orderData.clear();
            grandTotal = 0;
          });
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sales Report",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                SizedBox(height: 8),
                Divider(),

                SizedBox(height: 16),

                // Date Range Selector
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _dateRow(
                          label: "Start Date",
                          date: startDate,
                          onTap: () => _selectStartDate(context)),
                      SizedBox(height: 12),
                      _dateRow(
                          label: "End Date",
                          date: endDate,
                          onTap: () => _selectEndDate(context)),
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _fetchReport,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "Submit",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                // Summary Cards
                if (orderData.isNotEmpty) ...[
                  Row(
                    children: [
                      _summaryCard(
                          title: "Total Amount",
                          value: "₹${grandTotal.toStringAsFixed(2)}",
                          icon: Icons.currency_rupee),
                      SizedBox(width: 16),
                      _summaryCard(
                          title: "Total Orders",
                          value: orderData.length.toString(),
                          icon: Icons.receipt_long),
                    ],
                  ),
                  SizedBox(height: 20),
                ],

                // Orders List
                orderData.isNotEmpty
                    ? ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: orderData.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          var order = orderData[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BillPreview(
                                            kot: order["kot"].toDouble(),
                                            date: order["formatedDate"],
                                          )));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  )
                                ],
                              ),
                              padding: EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Icon(Icons.food_bank,
                                      size: 32, color: Colors.green),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "KOT No: ${order["kot"]}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "Date: ${order["formatedDate"]}",
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Text(
                            "No Orders Found",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dateRow(
      {required String label,
      required DateTime date,
      required VoidCallback onTap}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_month, size: 18, color: Colors.black54),
                SizedBox(width: 8),
                Text(DateFormat('dd-MM-yyyy').format(date),
                    style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _summaryCard(
      {required String title, required String value, required IconData icon}) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
            ]),
        child: Column(
          children: [
            Icon(icon, size: 30, color: Colors.green),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87),
            ),
            SizedBox(height: 4),
            Text(title,
                style: TextStyle(fontSize: 14, color: Colors.grey[700])),
          ],
        ),
      ),
    );
  }

  _fetchReport() {
    setState(() {
      grandTotal = 0;
    });
    Provider.of<OrderService>(context, listen: false)
        .getSaleDataByDate(startDate, endDate)
        .then((val) {
      setState(() {
        orderData = val;
      });
      for (var order in orderData) {
        grandTotal += order['finalPrice'];
      }
    });
  }

  _selectStartDate(BuildContext context) {
    showDatePicker(
            context: context,
            initialDate: startDate,
            firstDate: DateTime(2000),
            lastDate: DateTime(2050))
        .then((pickedDate) {
      if (pickedDate != null) {
        setState(() {
          startDate = pickedDate;
        });
      }
    });
  }

  _selectEndDate(BuildContext context) {
    showDatePicker(
            context: context,
            initialDate: endDate,
            firstDate: DateTime(2000),
            lastDate: DateTime(2050))
        .then((pickedDate) {
      if (pickedDate != null) {
        setState(() {
          endDate = pickedDate;
        });
      }
    });
  }
}

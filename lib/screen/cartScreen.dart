import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dashboard.dart';
import '../provider/order.dart';
import 'billPreview.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List cartItems = [];
  double totalPrice = 0.0;
  double additionalAmount = 0.0;
  double discountAmount = 0.0;
  double finalPrice = 0.0;
  bool isChange = false;
  bool _isLoading = false;
  double kot = 0;

  @override
  void initState() {
    super.initState();
    cartItems = orderData;
    getTotal();
  }

  Future<void> getTotal() async {
    double total = 0;
    for (var item in cartItems) {
      total += item['subtotal'];
    }
    setState(() {
      totalPrice = total;
      finalPrice = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Cart', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.all(16),
                  itemCount: cartItems.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    double sub =
                        cartItems[index]['price'] * cartItems[index]['Qty'];
                    return Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          '${cartItems[index]['name']} - ${cartItems[index]['option']}',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            '${cartItems[index]['price']} × ${cartItems[index]['Qty']}  =  ${sub.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[600]),
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.remove_circle_outline,
                              color: Colors.redAccent),
                          onPressed: () {
                            setState(() {
                              cartItems.removeAt(index);
                            });
                            getTotal();
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              _buildSummarySection(),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                  child: CircularProgressIndicator(color: Colors.deepPurple)),
            ),
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 10, offset: Offset(0, -2)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total: ₹${totalPrice.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          SizedBox(height: 12),
          Row(
            children: [
              _buildAmountField('Add Charges', (value) {
                setState(() {
                  additionalAmount = double.tryParse(value) ?? 0.0;
                  isChange = true;
                });
              }),
              SizedBox(width: 8),
              _buildAmountField('Discount', (value) {
                setState(() {
                  discountAmount = double.tryParse(value) ?? 0.0;
                  isChange = true;
                });
              }),
            ],
          ),
          if (isChange)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    calculate();
                    setState(() {
                      isChange = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple),
                  child: Text(
                    'Apply Changes',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          SizedBox(height: 12),
          Text('Grand Total: ₹${finalPrice.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _checkout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('Checkout',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountField(String label, Function(String) onChanged) {
    return Expanded(
      child: TextField(
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          isDense: true,
        ),
        onChanged: onChanged,
      ),
    );
  }

  Future<void> _checkout() async {
    setState(() {
      _isLoading = true;
    });
    await submitOrder(additionalAmount, discountAmount);
  }

  Future<void> submitOrder(double addAmount, double discAmount) async {
    await Provider.of<OrderService>(context, listen: false)
        .createOrder(orderData, addAmount, discAmount, finalPrice)
        .then((val) async {
      if (val == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order Placed Successfully')),
        );
        var val = await Provider.of<OrderService>(context, listen: false)
            .getprevisKot();
        setState(() {
          kot = double.parse(val[0]["kot"].toString()) - 1;
          _isLoading = false;
        });
        DateTime now = DateTime.now();
        String formattedDate = "${now.year}-${now.month}-${now.day}";
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BillPreview(kot: kot, date: formattedDate),
          ),
        );
      }
    });
  }

  void calculate() {
    if (discountAmount != 0.0 && additionalAmount == 0.0) {
      finalPrice = totalPrice - discountAmount;
    } else if (discountAmount == 0.0 && additionalAmount != 0.0) {
      finalPrice = totalPrice + additionalAmount;
    } else {
      finalPrice = totalPrice + additionalAmount - discountAmount;
    }
    setState(() {});
  }
}

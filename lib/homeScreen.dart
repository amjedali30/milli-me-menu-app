import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _orderItems = [];

  void _addItemToOrder(String item) {
    setState(() {
      _orderItems.add(item);
    });
  }

  void _removeItemFromOrder(String item) {
    setState(() {
      _orderItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Restaurant Order App'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Menu'),
              Tab(text: 'Order'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MenuScreen(addItemToOrder: _addItemToOrder),
            OrderScreen(
                orderItems: _orderItems,
                removeItemFromOrder: _removeItemFromOrder),
          ],
        ),
      ),
    );
  }
}

class MenuScreen extends StatelessWidget {
  final Function(String) addItemToOrder;

  MenuScreen({required this.addItemToOrder});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text('Pizza'),
          subtitle: Text('Delicious pizza'),
          trailing: IconButton(
            icon: Icon(Icons.add),
            onPressed: () => addItemToOrder('Pizza'),
          ),
        ),
        ListTile(
          title: Text('Burger'),
          subtitle: Text('Juicy burger'),
          trailing: IconButton(
            icon: Icon(Icons.add),
            onPressed: () => addItemToOrder('Burger'),
          ),
        ),
        ListTile(
          title: Text('Pasta'),
          subtitle: Text('Tasty pasta'),
          trailing: IconButton(
            icon: Icon(Icons.add),
            onPressed: () => addItemToOrder('Pasta'),
          ),
        ),
      ],
    );
  }
}

class OrderScreen extends StatelessWidget {
  final List<String> orderItems;
  final Function(String) removeItemFromOrder;

  OrderScreen({required this.orderItems, required this.removeItemFromOrder});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: orderItems.length,
      itemBuilder: (context, index) {
        final item = orderItems[index];
        return ListTile(
          title: Text(item),
          trailing: IconButton(
            icon: Icon(Icons.remove),
            onPressed: () => removeItemFromOrder(item),
          ),
        );
      },
    );
  }
}

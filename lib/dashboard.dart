import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/category.dart';
import 'provider/item.dart';
import 'screen/cartScreen.dart';
import 'widget/commonDrawer.dart';
import 'widget/menuGrid.dart';
import 'widget/topSelecterMenu.dart';

List orderData = [];

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  TextEditingController _searchController = TextEditingController();
  List category = [];
  List items = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getCategory();
    getItem();
  }

  Future<void> getCategory() async {
    var categoryService = Provider.of<CategoryService>(context, listen: false);
    setState(() => isLoading = true);
    var val = await categoryService.getCategory();
    setState(() {
      category = val;
      isLoading = false;
    });
  }

  Future<void> getItem() async {
    var itemService = Provider.of<ItemService>(context, listen: false);
    setState(() => isLoading = true);
    var val = await itemService.getItem();
    setState(() {
      items = val;
      isLoading = false;
    });
  }

  Future<void> getItemById(String cateId) async {
    var itemService = Provider.of<ItemService>(context, listen: false);
    setState(() => isLoading = true);
    var val = await itemService.getItemByCategory(cateId);
    setState(() {
      items = val;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerScrimColor: Colors.white,
      drawer: MyDrawer(page: "Foodzone"),
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: true,
        title: Container(
          height: 60,
          child: Image(image: AssetImage("assets/images/LOGO2.png")),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                print(orderData);
                if (orderData.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartScreen()),
                  ).then((value) {
                    if (value == false) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DashBoardScreen()),
                        (route) => false,
                      );
                    }
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Get Order First...!')),
                  );
                }
              },
              child: Icon(Icons.kitchen),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            category.isNotEmpty
                ? Container(
                    height: 60,
                    child: TopMenuCard(
                      data: category,
                      onItemSelected: (itemData) {
                        setState(() {
                          items = [];
                          _searchController.text = "";
                        });
                        print(itemData);
                        getItemById(itemData);
                      },
                    ),
                  )
                : Text("No Category Found...."),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Search Items",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon:
                            Icon(Icons.search, color: Colors.grey.shade600),
                        hintText: "Search for items...",
                        hintStyle: TextStyle(
                            fontSize: 13, color: Colors.grey.shade500),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                      ),
                      onChanged: (val) {
                        if (val.isNotEmpty) {
                          Provider.of<ItemService>(context, listen: false)
                              .getItemBySearch(val.trim())
                              .then((val) {
                            print(val);
                            setState(() {
                              items = val;
                            });
                          });
                        } else {
                          getItem();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Container(
              width: double.infinity,
              child: Text(
                "Today's Menu",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
            ),
            SizedBox(height: 10),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: items.isNotEmpty
                        ? MyGridView(
                            data: items,
                            onItemSelected: (itemData) {
                              // Handle item selection
                            },
                          )
                        : Align(
                            alignment: Alignment.topCenter,
                            child: Text("No Items Found"),
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}

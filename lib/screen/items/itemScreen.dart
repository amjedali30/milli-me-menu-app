import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../provider/category.dart';
import '../../provider/item.dart';
import '../../widget/commonDrawer.dart';
import 'addItem.dart';
import 'editItemScreen.dart';

class ItemsScreen extends StatefulWidget {
  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  Future<List<Map<String, dynamic>>>? _allItems;
  List categories = [];
  String selectedCategory = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    setState(() {
      isLoading = true;
    });
    await getCategories();
    _allItems = getAllItems();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getCategories() async {
    await Provider.of<CategoryService>(context, listen: false)
        .getCategory()
        .then((val) {
      setState(() {
        categories = val;
      });
    });
  }

  Future<List<Map<String, dynamic>>> getAllItems() async {
    List<Map<String, dynamic>> data = [];
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('item').get();

      for (var doc in querySnapshot.docs) {
        var item = {
          "id": doc.id,
          "name": doc["name"],
          "image": doc["image"],
          "category": doc["category"],
          "option": doc["Options"],
          "discription": doc["discription"],
        };
        data.add(item);
      }
    } catch (e) {
      print('Error fetching items: $e');
    }
    return data;
  }

  Future<List<Map<String, dynamic>>> getItemsByCategory(
      String categoryId) async {
    List<Map<String, dynamic>> data = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('item')
          .where("category", isEqualTo: categoryId)
          .get();

      for (var doc in querySnapshot.docs) {
        var item = {
          "id": doc.id,
          "name": doc["name"],
          "image": doc["image"],
          "category": doc["category"],
          "option": doc["Options"],
          "discription": doc["discription"],
        };
        data.add(item);
      }
    } catch (e) {
      print('Error fetching items by category: $e');
    }
    return data;
  }

  void _selectCategory(String categoryId, String categoryName) {
    setState(() {
      selectedCategory = categoryId;
      _allItems = getItemsByCategory(categoryId);
    });
  }

  void _showAllItems() {
    setState(() {
      selectedCategory = "";
      _allItems = getAllItems();
    });
  }

  void _deleteItem(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Item"),
        content: Text("Do you want to delete \"${item['name']}\"?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[700],
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await Provider.of<ItemService>(context, listen: false)
                  .delete(item['id']);

              setState(() {
                if (selectedCategory.isNotEmpty) {
                  _allItems = getItemsByCategory(selectedCategory);
                } else {
                  _allItems = getAllItems();
                }
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${item['name']} deleted successfully"),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text("Delete"),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      drawer: MyDrawer(page: "items"),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black87),
        title: Text(
          "Items",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_outlined),
            onPressed: _initializeData,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddItem()))
              .then((_) {
            // Refresh items when returning from add screen
            if (selectedCategory.isNotEmpty) {
              _allItems = getItemsByCategory(selectedCategory);
            } else {
              _allItems = getAllItems();
            }
            setState(() {});
          });
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
        elevation: 2,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.green))
          : Column(
              children: [
                // Category filter chips
                Container(
                  height: 60,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: categories.isEmpty
                      ? Center(child: Text("No categories found"))
                      : ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: FilterChip(
                                label: Text("All"),
                                selected: selectedCategory.isEmpty,
                                onSelected: (_) => _showAllItems(),
                                backgroundColor: Colors.white,
                                selectedColor: Colors.green[50],
                                checkmarkColor: Colors.green,
                                labelStyle: TextStyle(
                                  color: selectedCategory.isEmpty
                                      ? Colors.green[700]
                                      : Colors.grey[700],
                                  fontWeight: selectedCategory.isEmpty
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                                shape: StadiumBorder(
                                  side: BorderSide(
                                    color: selectedCategory.isEmpty
                                        ? Colors.green
                                        : Colors.grey[300]!,
                                  ),
                                ),
                              ),
                            ),
                            ...categories.map((category) {
                              print("---------");
                              print(category);
                              bool isSelected =
                                  selectedCategory == category['id'];
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: FilterChip(
                                  label: Text(category['category']),
                                  selected: isSelected,
                                  onSelected: (_) => _selectCategory(
                                      category['id'], category['category']),
                                  backgroundColor: Colors.white,
                                  selectedColor: Colors.green[50],
                                  checkmarkColor: Colors.green,
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? Colors.green[700]
                                        : Colors.grey[700],
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                  shape: StadiumBorder(
                                    side: BorderSide(
                                      color: isSelected
                                          ? Colors.green
                                          : Colors.grey[300]!,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                ),

                // Items list
                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _allItems,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child:
                                CircularProgressIndicator(color: Colors.green));
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.restaurant_menu_outlined,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 16),
                              Text(
                                selectedCategory.isEmpty
                                    ? "No items found"
                                    : "No items in this category",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var item = snapshot.data![index];
                          return Card(
                            margin: EdgeInsets.only(bottom: 12),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.grey[200]!),
                            ),
                            child: Slidable(
                              key: Key(item['id']),
                              endActionPane: ActionPane(
                                extentRatio: 0.25,
                                motion: const DrawerMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (_) => _deleteItem(item),
                                    backgroundColor: Colors.red[50]!,
                                    foregroundColor: Colors.red,
                                    icon: Icons.delete_outline,
                                    label: 'Delete',
                                    borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(12),
                                    ),
                                  ),
                                ],
                              ),
                              startActionPane: ActionPane(
                                extentRatio: 0.25,
                                motion: const DrawerMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (_) {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //       builder: (context) =>
                                      //           ItemEditScreen(item: item)),
                                      // ).then((_) {
                                      //   // Refresh items when returning from edit screen
                                      //   if (selectedCategory.isNotEmpty) {
                                      //     _allItems = getItemsByCategory(
                                      //         selectedCategory);
                                      //   } else {
                                      //     _allItems = getAllItems();
                                      //   }
                                      //   setState(() {});
                                      // });
                                    },
                                    backgroundColor: Colors.blue[50]!,
                                    foregroundColor: Colors.blue,
                                    icon: Icons.edit_outlined,
                                    label: 'Edit',
                                    borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(12),
                                    ),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(12),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    item['image'],
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 60,
                                        height: 60,
                                        color: Colors.grey[200],
                                        child: Icon(
                                          Icons.restaurant_menu,
                                          color: Colors.grey[400],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                title: Text(
                                  item['name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  item['discription'] ?? 'No description',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.grey[400],
                                ),
                                onTap: () {
                                  // View item details
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ItemEditScreen(item: item)),
                                  ).then((_) {
                                    // Refresh items when returning
                                    if (selectedCategory.isNotEmpty) {
                                      _allItems =
                                          getItemsByCategory(selectedCategory);
                                    } else {
                                      _allItems = getAllItems();
                                    }
                                    setState(() {});
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

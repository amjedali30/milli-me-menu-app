import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../provider/category.dart';
import '../widget/commonDrawer.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  bool isAdd = false;
  bool isLoad = false;
  List catData = [];
  TextEditingController textCntrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCategoryData();
  }

  Future<void> getCategoryData() async {
    final val = await Provider.of<CategoryService>(context, listen: false)
        .getCategory();
    setState(() {
      catData = val;
    });
  }

  Future<void> deleteCategory(String id) async {
    final value =
        await Provider.of<CategoryService>(context, listen: false).delete(id);
    if (value == 200) {
      getCategoryData();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category deleted!')),
      );
    }
  }

  void addCategory() async {
    if (textCntrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category cannot be empty.')),
      );
      return;
    }

    setState(() => isLoad = true);

    final result = await Provider.of<CategoryService>(context, listen: false)
        .createCate(textCntrl.text.trim());

    setState(() => isLoad = false);

    if (result == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category added successfully!')),
      );
      textCntrl.clear();
      isAdd = false;
      getCategoryData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category already exists.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(page: "CRM"),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title:
            SizedBox(height: 50, child: Image.asset("assets/images/logo.png")),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
        onPressed: () => setState(() => isAdd = !isAdd),
      ),
      body: isAdd ? buildAddCategoryForm() : buildCategoryList(),
    );
  }

  Widget buildAddCategoryForm() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Add Item Category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: textCntrl,
              decoration: InputDecoration(
                hintText: 'Category name',
                prefixIcon: const Icon(Icons.category),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: isLoad ? null : addCategory,
              child: isLoad
                  ? const SpinKitThreeBounce(color: Colors.white, size: 20)
                  : const Text('Add Category',
                      style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCategoryList() {
    if (catData.isEmpty) {
      return const Center(child: Text('No categories found.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: catData.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final category = catData[index];
        return Slidable(
          key: ValueKey(category['id']),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (_) => showDeleteDialog(category),
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: ListTile(
            tileColor: Colors.grey.shade200,
            leading: const Icon(Icons.category),
            title: Text(category['category'] ?? ''),
          ),
        );
      },
    );
  }

  void showDeleteDialog(dynamic category) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Category'),
        content:
            Text('Are you sure you want to delete "${category['category']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => deleteCategory(category['id']),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

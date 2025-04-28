import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dashboard.dart';
import '../screen/addCategory.dart';
import '../screen/items/itemScreen.dart';
import '../screen/orders/showOrderList.dart';
import '../screen/printer/printerScreen.dart';
import '../screen/profileScreen.dart';
import '../screen/report/reportScreen.dart';

class MyDrawer extends StatefulWidget {
  final String page;

  const MyDrawer({super.key, required this.page});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool isLog = false;
  String userType = "";

  Future<void> getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var a = await pref.getString("logged");
    userType = pref.getString('userType') ?? "";

    if (a == "true") {
      setState(() {
        isLog = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            width: double.infinity,
            color: Colors.green.shade50,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Milli & Me",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.green,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 2,
                    width: 40,
                    color: Colors.green,
                  )
                ],
              ),
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(
                  icon: Icons.person_outline,
                  title: 'Profile',
                  onTap: () => _navigateTo(ProfileScreen()),
                  isSelected: widget.page == 'profile',
                ),
                _buildMenuItem(
                  icon: Icons.dashboard_outlined,
                  title: 'Menu',
                  onTap: () => _navigateTo(DashBoardScreen()),
                  isSelected: widget.page == 'dashboard',
                ),
                _buildMenuItem(
                  icon: Icons.receipt_outlined,
                  title: 'Orders',
                  onTap: () => _navigateTo(OrderList()),
                  isSelected: widget.page == 'orders',
                ),
                if (userType != "Staff") ...[
                  _buildMenuItem(
                    icon: Icons.restaurant_menu_outlined,
                    title: 'Items',
                    onTap: () => _navigateTo(ItemsScreen()),
                    isSelected: widget.page == 'items',
                  ),
                  _buildMenuItem(
                    icon: Icons.category_outlined,
                    title: 'Categories',
                    onTap: () => _navigateTo(AddCategory()),
                    isSelected: widget.page == 'categories',
                  ),
                  _buildMenuItem(
                    icon: Icons.bar_chart_outlined,
                    title: 'Reports',
                    onTap: () => _navigateTo(ReportScreen()),
                    isSelected: widget.page == 'reports',
                  ),
                ],
                _buildMenuItem(
                  icon: Icons.print_outlined,
                  title: 'Printer Setup',
                  onTap: () => _navigateTo(PrinterScreen()),
                  isSelected: widget.page == 'printer',
                ),
              ],
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'v1.0.0',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.green.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.green : Colors.grey.shade700,
          size: 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? Colors.green : Colors.grey.shade800,
          ),
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  void _navigateTo(Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}

import 'package:flutter/material.dart';

class TopMenuCard extends StatefulWidget {
  final Function(dynamic)? onItemSelected;
  final List<dynamic> data;

  TopMenuCard({this.onItemSelected, required this.data});

  @override
  State<TopMenuCard> createState() => _TopMenuCardState();
}

class _TopMenuCardState extends State<TopMenuCard> {
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12),
        itemCount: widget.data.length,
        separatorBuilder: (context, index) => SizedBox(width: 12),
        itemBuilder: (context, index) {
          bool isSelected = _selectedIndex == index;
          return GestureDetector(
            onTap: () {
              if (widget.onItemSelected != null) {
                widget.onItemSelected!(widget.data[index]["id"]);
                setState(() {
                  _selectedIndex = index;
                });
              }
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? Color.fromARGB(255, 240, 230, 255)
                    : Color.fromARGB(255, 248, 248, 248),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? Color.fromARGB(255, 111, 53, 165)
                      : Colors.grey.shade300,
                  width: 1.5,
                ),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                ],
              ),
              child: Center(
                child: Text(
                  widget.data[index]["category"],
                  style: TextStyle(
                    color: isSelected
                        ? Color.fromARGB(255, 111, 53, 165)
                        : Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

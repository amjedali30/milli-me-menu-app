import 'package:flutter/material.dart';

List selectedSizeOption = [];

class OptionWidget extends StatefulWidget {
  OptionWidget({super.key, required this.index});
  int index;

  @override
  State<OptionWidget> createState() => _OptionWidgetState();
}

class _OptionWidgetState extends State<OptionWidget> {
  TextEditingController cntrl = TextEditingController();
  String _selectedSize = '';

  List<String> _sizes = [
    'Small',
    'Medium',
    'Large',
    "Single",
    "Double"
  ]; // Sample sizes, you can replace it with your own data
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Option ${widget.index + 1}",
            style: TextStyle(
                fontSize: 13,
                color: Color.fromARGB(126, 0, 0, 0),
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * .35,
                  height: MediaQuery.of(context).size.height * .07,
                  child: DropdownButtonFormField<String>(
                    value: _selectedSize.isNotEmpty ? _selectedSize : null,
                    items: _sizes.map((size) {
                      return DropdownMenuItem<String>(
                        value: size,
                        child: Text(
                          size,
                          style: TextStyle(fontSize: 10),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSize = value!;
                        setState(() {
                          selectedSizeOption[widget.index]["option"] =
                              _selectedSize;
                        });
                      });
                      // print(selectedSizeOption);
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Select Size',
                        hintStyle: TextStyle(fontSize: 13)),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * .3,
                height: MediaQuery.of(context).size.height * .07,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: Color.fromARGB(255, 226, 226, 226))),
                padding: EdgeInsets.all(8),
                child: TextField(
                  controller: cntrl,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      // suffixIcon: Icon(
                      //   Icons.remove_red_eye,
                      //   size: 20,
                      // ),
                      hintText: "amount",
                      hintStyle: TextStyle(fontSize: 12)),
                  // onSubmitted: (value) {
                  //   selectedSizeOption[widget.index]["Amount"] = cntrl.text;
                  // },
                  onChanged: (val) {
                    selectedSizeOption[widget.index]["Amount"] = cntrl.text;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

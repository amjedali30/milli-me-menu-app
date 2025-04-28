import 'package:flutter/material.dart';

class LabelWithText extends StatelessWidget {
  LabelWithText(
      {super.key,
      required this.cntrl,
      required this.text,
      required this.hint,
      required this.icon});
  TextEditingController cntrl;

  String text;
  String hint;
  Icon icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
              fontSize: 13,
              color: Color.fromARGB(126, 0, 0, 0),
              fontWeight: FontWeight.bold),
        ),
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * .055,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color.fromARGB(255, 226, 226, 226))),
          padding: EdgeInsets.all(8),
          child: TextField(
            controller: cntrl,
            decoration: InputDecoration(
                prefixIcon: icon,
                border: InputBorder.none,
                // suffixIcon: Icon(
                //   Icons.remove_red_eye,
                //   size: 20,
                // ),
                hintText: hint,
                hintStyle: TextStyle(fontSize: 12)),
            onChanged: (val) {},
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import 'itemCard.dart';

class MyGridView extends StatelessWidget {
  var data;
  final Function(dynamic)?
      onItemSelected; // Callback function to handle selected item

  MyGridView({this.onItemSelected, required this.data});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 400) {
          // If screen width is greater than 600 (tablet size), show GridView with 3 columns
          return data != null
              ? GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 20.0,
                      mainAxisSpacing: 20.0,
                      childAspectRatio: .9),
                  itemCount:
                      data.length, // Adjust the number of items as needed
                  itemBuilder: (BuildContext context, int index) {
                    return ItemCard(
                      data: data[index],
                      onItemSelected: (itemData) {
                        // print(itemData);

                        // Handle selected item data here in MyApp class
                      },
                      index: index,
                    );
                    // return GestureDetector(
                    //   onTap: () {
                    //     if (onItemSelected != null) {
                    //       onItemSelected!(
                    //           data); // Pass selected item data to the callback function
                    //     }
                    //   },
                    //   child: Container(
                    //     alignment: Alignment.center,
                    //     child: Column(
                    //       children: [
                    //         Container(
                    //           height: 200,
                    //           decoration: BoxDecoration(
                    //               borderRadius: BorderRadius.circular(10)),
                    //           child: ClipRRect(
                    //             borderRadius: BorderRadius.circular(10),
                    //             child: Image(
                    //                 image: NetworkImage(data[index]["image"])),
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           height: 10,
                    //         ),
                    //         Expanded(
                    //             child: Container(
                    //                 width: double.infinity,
                    //                 child: Padding(
                    //                   padding: const EdgeInsets.all(8.0),
                    //                   child: Column(
                    //                     crossAxisAlignment:
                    //                         CrossAxisAlignment.start,
                    //                     mainAxisAlignment:
                    //                         MainAxisAlignment.spaceBetween,
                    //                     children: [
                    //                       Expanded(
                    //                         child: Container(
                    //                           child: Column(
                    //                             mainAxisAlignment:
                    //                                 MainAxisAlignment
                    //                                     .spaceEvenly,
                    //                             children: [
                    //                               Text(
                    //                                 data[index]["name"],
                    //                                 style: TextStyle(
                    //                                     fontSize: 20,
                    //                                     fontWeight:
                    //                                         FontWeight.w600),
                    //                               ),
                    //                               SizedBox(
                    //                                 height: 5,
                    //                               ),
                    //                               Text(
                    //                                 data[index]["discription"],
                    //                                 style: TextStyle(
                    //                                   fontSize: 14,
                    //                                 ),
                    //                               ),
                    //                               Row(
                    //                                 mainAxisAlignment:
                    //                                     MainAxisAlignment
                    //                                         .center,
                    //                                 children: [
                    //                                   Text(
                    //                                     "AED",
                    //                                     style: TextStyle(
                    //                                         fontSize: 20,
                    //                                         fontWeight:
                    //                                             FontWeight
                    //                                                 .bold),
                    //                                   ),
                    //                                   SizedBox(
                    //                                     width: 10,
                    //                                   ),
                    //                                   Text(
                    //                                     data[index]["price"],
                    //                                     style: TextStyle(
                    //                                         fontSize: 20,
                    //                                         fontWeight:
                    //                                             FontWeight
                    //                                                 .bold),
                    //                                   ),
                    //                                 ],
                    //                               ),
                    //                             ],
                    //                           ),
                    //                         ),
                    //                       ),
                    //                       Container(
                    //                         width: double.infinity,
                    //                         child: Row(
                    //                           mainAxisAlignment:
                    //                               MainAxisAlignment
                    //                                   .spaceBetween,
                    //                           children: [
                    //                             Container(
                    //                               height: 60,
                    //                               width: 60,
                    //                               decoration: BoxDecoration(
                    //                                 color: Color.fromARGB(
                    //                                     255, 247, 130, 35),
                    //                                 borderRadius:
                    //                                     BorderRadius.circular(
                    //                                         10),
                    //                                 // border: Border.all(
                    //                                 //     color: Color.fromARGB(
                    //                                 //         255, 122, 73, 138)
                    //                                 //         )
                    //                               ),
                    //                               child: Center(
                    //                                   child: Icon(
                    //                                 Icons.add,
                    //                                 color: Colors.white,
                    //                               )),
                    //                             ),
                    //                             Container(
                    //                               child: Row(
                    //                                 children: [
                    //                                   Text(
                    //                                     "Qty:",
                    //                                     style: TextStyle(
                    //                                         fontSize: 15,
                    //                                         fontWeight:
                    //                                             FontWeight
                    //                                                 .bold),
                    //                                   ),
                    //                                   SizedBox(
                    //                                     width: 10,
                    //                                   ),
                    //                                   Text(
                    //                                     data[index]["price"],
                    //                                     style: TextStyle(
                    //                                         fontSize: 20,
                    //                                         fontWeight:
                    //                                             FontWeight
                    //                                                 .bold),
                    //                                   ),
                    //                                 ],
                    //                               ),
                    //                             )
                    //                           ],
                    //                         ),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ))),
                    //       ],
                    //     ),
                    //   ),
                    // );
                  },
                )
              : Center(
                  child: Text('No Item Found'),
                );
        } else {
          // For smaller screens, show a simple message
          // return Center(
          //   child: Text('Screen size is too small for this layout'),
          // );

          return GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 20.0,
                mainAxisSpacing: 20.0,
                childAspectRatio: .9),
            itemCount: data.length, // Adjust the number of items as needed
            itemBuilder: (BuildContext context, int index) {
              return ItemCard(
                data: data[index],
                onItemSelected: (itemData) {
                  // Handle selected item data here in MyApp class
                },
                index: index,
              );
            },
          );
        }
      },
    );
  }
}

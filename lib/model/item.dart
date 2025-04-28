import 'dart:io';

class ItemModel {
  final String name;
  final String disc;
  var optionPrice;
  final String category;
  File? path;
  String? fileName;

  ItemModel(
      {required this.name,
      required this.disc,
      required this.optionPrice,
      required this.category,
      required this.fileName,
      required this.path});
  // ItemModel.fromData(Map<String, dynamic> data)
  //     : id = data['id'],
  //       gram = data['gram'],
  //       pavan = data['pavan'],
  //       down = data['down'],
  //       up = data['up'];

  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': id,
  //     'gram': gram,
  //     'pavan': pavan,
  //     'down': down,
  //     'up': up,
  //   };
  // }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:amazon_clone/models/ratings.dart';

class Product {
  final String name;
  final String description;
  final double quantity;
  final List<String> images;
  final String category;
  final double price;
  final String? id;
  final List<Rating>? ratings;
  //rating yet to be added

  Product({
    required this.name,
    required this.description,
    required this.quantity,
    required this.images,
    required this.category,
    required this.price,
    this.id,
    this.ratings
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'quantity': quantity,
      'images': images,
      'category': category,
      'price': price,
      'id': id,
      'ratings' : ratings
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] as String,
      description: map['description'] as String,
      quantity: (map['quantity'] is int)
          ? (map['quantity'] as int).toDouble()
          : map['quantity'] as double,
      images:
          List<String>.from((map['images'] as List).map((e) => e as String)),
      category: map['category'] as String,
      price: (map['price'] is int)
          ? (map['price'] as int).toDouble()
          : map['price'] as double,

      //here we need to change 'id' to '_id' as we have done in user.dart as well, since we have _id provided automatically by mongoDB
      id: map['_id'] != null ? map['_id'] as String : null,

      /*
        If map['ratings'] exists and is not null,
          it converts each element of the map['ratings'] list into a Rating object using the Rating.fromMap() method and then creates a list of these Rating objects.
        If map['ratings'] is null, the ratings field is set to null.
      */
      ratings: map['ratings'] != null ? List<Rating>.from(map['ratings']?.map((x) => Rating.fromMap(x))) :null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);
}

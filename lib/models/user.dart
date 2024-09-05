// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

//creating user model like the model we created in mongoose(backend)
//its going to have the save properties as the user model in mongoose
class User {
  //this id we dont have it in backend model of ours since mongoDB auto generates id, but we need that id here so we initialize it here
  final String id;
  final String name;
  final String password;
  final String address;
  final String type;
  final String token;
  final String email;
  final List<dynamic> cart;
  User({
    required this.id,
    required this.name,
    required this.password,
    required this.address,
    required this.type,
    required this.token,
    required this.email,
    required this.cart
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'password': password,
      'address': address,
      'type': type,
      'token': token,
      'email': email,
      'cart':cart
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      //here we need to change 'id' to '_id' since we have the later provided automatically by mongoDB
      id: map['_id'] as String,
      name: map['name'] as String,
      password: map['password'] as String,
      address: map['address'] as String,
      type: map['type'] as String,
      token: map['token'] as String,
      email: map['email'] as String,
      cart : List<Map<String, dynamic>>.from(map['cart']!.map((x) => Map<String, dynamic>.from(x)))
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  User copyWith({
    String? id,
    String? name,
    String? password,
    String? address,
    String? type,
    String? token,
    String? email,
    List<dynamic>? cart,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      password: password ?? this.password,
      address: address ?? this.address,
      type: type ?? this.type,
      token: token ?? this.token,
      email: email ?? this.email,
      cart: cart ?? this.cart,
    );
  }
}

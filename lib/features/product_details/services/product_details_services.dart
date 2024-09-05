import 'dart:convert';
import 'dart:ffi';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/models/user.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ProductDetailsServices{

  void addToCart({
    required BuildContext context,
    required Product product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try{
      http.Response res = await http.post(
        Uri.parse('$uri/api/add-to-cart'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id' : product.id,
        }),
      );
      httpErrorHandle(
        response: res,
        onSucccess: () {
          
          //copyWith(), generated in user model, keeps all the other parameters same and only changes the parameter provided in it and return the user model
          User user = userProvider.user.copyWith(
            cart: jsonDecode(res.body)['cart']
          );
          
          //the setUser() from userProvider cannot be used since it takes a string, hence we created a new function in user provider, setUserFromModel(), which sets user from a user model
          userProvider.setUserFromModel(user);
        },
      );
    }
    catch (e){
      showSnackBar(e.toString());
    }
  }

  void rateProduct({
    required BuildContext context,
    required Product product,
    required double rating
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try{
      http.Response res = await http.post(
        Uri.parse('$uri/api/rate-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id' : product.id,
          'rating' : rating
        }),
      );
      httpErrorHandle(
        response: res,
        onSucccess: () {
        },
      );
    }
    catch (e){
      showSnackBar(e.toString());
    }
  }
}
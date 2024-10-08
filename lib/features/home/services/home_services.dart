import 'dart:convert';

import 'package:provider/provider.dart';

import '../../../constants/error_handling.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';
import '../../../models/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../providers/user_provider.dart';

class HomeServices {
  Future<List<Product>> fetchCategoryProducts({
    required BuildContext context,
    required String category,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/products?category=$category'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
          response: res,
          onSucccess: () {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              productList.add(
                Product.fromJson(
                  jsonEncode(jsonDecode(res.body)[i]),
                ),
              );
            }
          });
    } catch (e) {
      showSnackBar(e.toString());
    }
    return productList;
  }

  Future<Product> fetchDealOfDay({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    //we initialize dealOfDayProduct with emplty strings and 0 instead of making it nullable so that user does not see a constant loader if there is some error fetching the deal of the day or if it doesnt exists in the backend
    Product dealOfDayProduct = Product(name: "", description: "", quantity: 0, images: [], category: "", price: 0);
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/deal-of-day'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );  
      httpErrorHandle(
          response: res,
          onSucccess: () {
            dealOfDayProduct = Product.fromJson(res.body);
          });
    } catch (e) {
      showSnackBar(e.toString());
    }
    return dealOfDayProduct;
  }
}

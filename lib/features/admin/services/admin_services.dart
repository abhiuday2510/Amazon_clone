import 'dart:convert';
import 'dart:io';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../constants/global_variables.dart';

class AdminServices {
  //TO LIST THE PRODUCT TO BE SOLD
  void sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required double quantity,
    required String category,
    required List<File> images,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      //cloudinary is the online cloud storage for media(images, videwos etc)
      final cloudinary = CloudinaryPublic('ds9oe2ynq', 'yumwuv9p');
      List<String> imageUrls = [];

      for (int i = 0; i < images.length; i++) {
        //we can get this from the documentation
        CloudinaryResponse res = await cloudinary
            //folder will create a seperate folder for every product we have with its name
            .uploadFile(CloudinaryFile.fromFile(images[i].path, folder: name));
        //cloudinaryresponse gives us a secure url for all our files
        imageUrls.add(res.secureUrl);
      }

      Product product = Product(
        name: name,
        description: description,
        quantity: quantity,
        images: imageUrls,
        category: category,
        price: price,
      );

      http.Response res = await http.post(
        Uri.parse('$uri/admin/add-product'),
        //headers is needed as this will be accessed only by authorised users since it has the functionality of admin middleware
        headers: {
          //its the same one in the auth_service.dart
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        //we authorise ourselves using headers, but with body we send the data that we need after authorisation
        body: product.toJson(),
      );

      httpErrorHandle(
        response: res,
        onSucccess: () {
          showSnackBar("Product Added Successfully");
          Navigator.pop(context);
        },
      );
    } catch (e) {
      showSnackBar(e.toString());
    }
  }

  //TO GET ALL THE LISTED PRODUCTS TO DISPLAY THEM ON ADMIN SCREEN
  Future<List<Product>> fetchAllProducts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/admin/get-product'),
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
                //fromJson converts the given json to our product model
                Product.fromJson(
                  //fromJson expects string, to convert jsonDecode into string, we jsonEncode it
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

  //TO DELETE LISTED PRODUCT
  void deleteProduct(
      {required BuildContext context,
      required Product product,
      //onSuccess will help us delete the product from server side as well as client side simultaneously
      //if we dont have onSuccess, we wont be able to call the setState method, hence not deleting from the client side realtime
      required VoidCallback onSuccess}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
          Uri.parse('$uri/admin/delete-product'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token,
          },
          //we dont need to pass the entire product, only the product id is enough
          body: jsonEncode(
            {
              'id': product.id,
            },
          ));

      httpErrorHandle(
        response: res,
        onSucccess: () {
          onSuccess();
        },
      );
    } catch (e) {
      showSnackBar(e.toString());
    }
  }
}

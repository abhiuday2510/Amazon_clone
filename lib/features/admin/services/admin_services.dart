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
        context: context,
        onSucccess: () {
          showSnackBar(context, "Product Added Successfully");
          Navigator.pop(context);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}

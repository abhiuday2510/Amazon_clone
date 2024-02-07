import 'dart:io';

import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';

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
          price: price);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}

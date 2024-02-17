import 'dart:convert';

import 'package:amazon_clone/constants/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

//this function handles error based on the status codes of the API response and shows a status bar
void httpErrorHandle({
  required http.Response response,
  //its a void callback function like Function()?
  required VoidCallback onSucccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSucccess();
      break;
    case 400:
      //we need to decode response.body since its not actually a string but json and snackbar only accepts string
      showSnackBar(jsonDecode(response.body)['msg']);
      break;
    case 500:
      showSnackBar(jsonDecode(response.body)['error']);
      break;
    //default is very rarly encountered
    default:
      showSnackBar(response.body);
  }
}

//the below ignore can be ignored
// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/user.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/widgets/bottom_bar.dart';

class AuthService {
  //Sign Up User
  void signUpUser(
      {required String email,
      required String password,
      required String name,
      required BuildContext context}) async {
    try {
      User user = User(
        id: "",
        name: name,
        password: password,
        address: "",
        type: "",
        token: "",
        email: email,
      );

      //since sign up is a post request, we use http.post
      //we could simply use something like http.post().then and continue further, but a cleaner approach is to await it and store it in a variable and then use that variable
      //since http.post() is or type future<response>, we are storing it in a http.Response type of variable
      http.Response res = await http.post(
        //http.post takes uri, so we need to parse our string to a uri
        Uri.parse("$uri/api/signup"),
        //in the body we are providing json(by encoding it to json using user.tojson()) as we have a middleware in our server that only accepts json
        body: user.toJson(),
        //this section is since we are using express.json middleware in our server
        //we add this at every API request
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      httpErrorHandle(
        response: res,
        onSucccess: () {
          showSnackBar(
            'Account created! Login with the same credentials!',
          );
        },
      );
    } catch (e) {
      showSnackBar(e.toString());
    }
  }

  //Sign In User
  void signInUser(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      http.Response res = await http.post(
        Uri.parse("$uri/api/signin"),
        //If value contains objects that are not directly encodable to a JSON string, the jsonEncode() function is used to convert it to an object that must be directly encodable
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      httpErrorHandle(
        response: res,
        onSucccess: () async {
          // Obtains shared preferences
          SharedPreferences prefs = await SharedPreferences.getInstance();

          //of<UserProvider> states that this provider is of the model UserProvider
          //listen: false, we do this since we are out of the build function
          //setUser(res.body) is a function in the user provider model
          Provider.of<UserProvider>(context, listen: false).setUser(res.body);

          // Saves an String value(jsonDecode(res.body)["token"]) to 'x-auth-token' key using object of SharedPreferences of the signed in user
          await prefs.setString("x-auth-token", jsonDecode(res.body)["token"]);

          Navigator.pushNamedAndRemoveUntil(
              context, BottomBar.routeName, (route) => false);
        },
      );
    } catch (e) {
      showSnackBar(e.toString());
    }
  }

  //Get User Data through API, to sign in directly if the user is already logged in
  void getUserData(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      //get the token of already signed in user, if present
      String? token = prefs.getString("x-auth-token");

      //if there is no already signed in user
      if (token == null) {
        prefs.setString("x-auth-token", "");
      }

      var tokenRes = await http.post(Uri.parse("$uri/tokenIsValid"),

          //now along with the mandatory express headers, we are passing the token as well
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            //we have already checked if the token is null, so here we are stating that the token is not null by doing token!
            'x-auth-token': token!
          });

      //this response is gonna provide us with true/false value
      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        //getting the user data from API
        http.Response userRes = await http.get(Uri.parse("$uri/"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'x-auth-token': token
            });

        //setting the logged in user after verification using provider
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.body);
      }
    } catch (e) {
      showSnackBar(e.toString());
    }
  }
}

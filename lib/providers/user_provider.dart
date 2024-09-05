import 'package:amazon_clone/models/user.dart';
import 'package:flutter/cupertino.dart';

//ChnageNotifier is used to implement provider
class UserProvider extends ChangeNotifier {
  User _user = User(
      id: "",
      name: "",
      password: "",
      address: "",
      type: "",
      token: "",
      email: "", 
      cart: []
    );

  //since the _user is a private variable, we need to make a getter for it
  User get user => _user;

  //setting user as string since we are going to pass res.body to it and res.body is a string
  void setUser(String user) {
    //fromJson is a function(auto generated) in the user model
    _user = User.fromJson(user);

    //this notifies everywhere that the user value has been change and asks for a rebuild
    notifyListeners();
  }

  //used when we want to set user from a user model
  void setUserFromModel( User user){
    _user = user;
    notifyListeners();
  }
}

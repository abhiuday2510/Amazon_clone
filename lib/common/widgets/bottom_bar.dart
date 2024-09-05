import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/account/screens/accounts_screen.dart';
import 'package:amazon_clone/features/home/screens/home_screen.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';

class BottomBar extends StatefulWidget {
  static const String routeName = '/actual-home';

  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  //contains the content of different pages
  List<Widget> pages = [
    const HomeScreen(),
    const AccountScreen(),
    const Center(
      child: Text('Cart Page'),
    )
  ];

  //to shift to different pages in the navigation bar
  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {

    //contect.watch() is a short syntax of Provider.of(context)
    final userCartLength = context.watch<UserProvider>().user.cart.length;

    return Scaffold(
      //the body is goint to be the widget at a particualr index which we are changing by tapping different icons of the bottom navigation bar
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        selectedItemColor: GlobalVariables.selectedNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        backgroundColor: GlobalVariables.backgroundColor,
        iconSize: 28,
        onTap: updatePage,
        items: [
          //HOME
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                  border: Border(
                top: BorderSide(
                  color: _page == 0
                      ? GlobalVariables.selectedNavBarColor
                      : GlobalVariables.backgroundColor,
                  width: bottomBarBorderWidth,
                ),
              )),
              child: const Icon(Icons.home_outlined),
            ),
            label: '',
          ),

          //ACCOUNT
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                  border: Border(
                top: BorderSide(
                  color: _page == 1
                      ? GlobalVariables.selectedNavBarColor
                      : GlobalVariables.backgroundColor,
                  width: bottomBarBorderWidth,
                ),
              )),
              child: const Icon(Icons.person_outline_outlined),
            ),
            label: '',
          ),

          //CART
          BottomNavigationBarItem(
            icon: Container(
                width: bottomBarWidth,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: _page == 2
                          ? GlobalVariables.selectedNavBarColor
                          : GlobalVariables.backgroundColor,
                      width: bottomBarBorderWidth,
                    ),
                  ),
                ),
                //badge package is used to add badge(no of items) to the cart or any other icon
                child: badges.Badge(
                  badgeStyle: const badges.BadgeStyle(
                    elevation: 0,
                    badgeColor: Colors.white,
                  ),
                  badgeContent: Text(userCartLength.toString()),
                  child: const Icon(Icons.shopping_cart_outlined),
                )),
            label: '',
          )
        ],
      ),
    );
  }
}

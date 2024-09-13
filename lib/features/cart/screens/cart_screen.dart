import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/cart/widgets/cart_product.dart';
import 'package:amazon_clone/features/cart/widgets/cart_subTotal.dart';
import 'package:amazon_clone/features/home/widgets/address_box.dart';
import 'package:amazon_clone/features/search/screens/search_screen.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }


  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            //we are using flexible space so that we can add a linear gradient here and by default appbar doest have any proerty to add linear gradient
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: GlobalVariables.appBarGradient,
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  //we need to give a margin here, thats why we are using a container otherwise we could have used a sized box
                  child: Container(
                    margin: const EdgeInsets.only(left: 15),
                    height: 42,
                    //we are using the material just to give some elevation and some border radius
                    child: Material(
                      borderRadius: BorderRadius.circular(7),
                      elevation: 1,
                      child: TextFormField(
                        onFieldSubmitted: navigateToSearchScreen,
                        decoration: InputDecoration(
                          //we are using inkwell here because when we click on it, it gives a splash effect
                          prefixIcon: InkWell(
                            onTap: () {},
                            child: const Padding(
                              padding: EdgeInsets.only(left: 6),
                              child: Icon(
                                Icons.search,
                                color: Colors.black,
                                size: 23,
                              ),
                            ),
                          ),
                          //if filled is true, the decoration's container is filled with fillcolor
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.only(top: 10),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            //If the [borderSide] parameter is [BorderSide.none], it will not draw a border.
                            // However, it will still define a shape (which you can see if [InputDecoration.filled] is true)
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            borderSide:
                                BorderSide(color: Colors.black38, width: 1),
                          ),
                          hintText: 'Search Amazon.in',
                          hintStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  height: 42,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: const Icon(
                    Icons.mic,
                    color: Colors.black,
                    size: 25,
                  ),
                )
              ],
            ),
          ),
        ),
      body: SingleChildScrollView(
        child: Column(children: [
          const AddressBox(),
          const CartSubTotal(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(text: 'Proceed to Buy (${user.cart.length} items)',backgroundColor: Colors.yellow[600],foregroundColor: Colors.black, 
              onTap:(){},
            ),
          ),
          const SizedBox(height: 15,),
          Container(
            color: Colors.black12.withOpacity(0.8),
            height: 1,
          ),
          const SizedBox(height: 15,),
          ListView.builder(
            itemCount: user.cart.length,
            
            /*
              Creates a scrollable, linear array of widgets that are created on demand.
              This constructor is appropriate for list views with a large (or infinite) number of children because the builder is called only for those children that are actually visible.
              Providing a non-null itemCount improves the ability of the [ListView] to estimate the maximum scroll extent.
            */ 
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return CartProduct(index: index);
            },
          )
        ],),
        ),
    );
  }
}
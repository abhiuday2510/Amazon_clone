import 'package:amazon_clone/features/admin/screens/add_product_screen.dart';
import 'package:flutter/material.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  //a seperate function just to not mix our UI with our logic
  void navigateToAddProduct() {
    Navigator.pushNamed(context, AddProductsScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          "Products Page",
        ),
      ),
      //using this button we go to a new page where we add new products
      floatingActionButton: FloatingActionButton(
        //upon long press, tooltip describes the action the button performs
        tooltip: 'Add a Product',
        onPressed: () {
          navigateToAddProduct();
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      //makes floating action button appear in the center
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

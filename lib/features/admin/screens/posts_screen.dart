import 'package:amazon_clone/common/widgets/loader.dart';
import 'package:amazon_clone/features/admin/screens/add_product_screen.dart';
import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:flutter/material.dart';

import '../../../models/product.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  //the following list in nullable and not empty
  //this is because as long as the product is being fetched from the server, we would be showing a loading indicator
  List<Product>? products;
  final AdminServices adminServices = AdminServices();

  //a seperate function just to not mix our UI with our logic
  void navigateToAddProduct() {
    Navigator.pushNamed(context, AddProductsScreen.routeName);
  }

  //since initState cannot be async and we need an async function to fetch all the produts, we are creating a seperate fetchAllProducts() function
  @override
  void initState() {
    super.initState();
    fetchAllProducts();
  }

  fetchAllProducts() async {
    products = await adminServices.fetchAllProducts(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return products == null
        ? const Loader()
        : Scaffold(
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
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}

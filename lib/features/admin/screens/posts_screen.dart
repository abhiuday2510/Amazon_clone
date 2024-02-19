import 'package:amazon_clone/common/widgets/loader.dart';
import 'package:amazon_clone/features/account/widgets/single_product.dart';
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
    Navigator.pushNamed(context, AddProductsScreen.routeName)
        //the below line executes the fetchAllProducts() function even when this screen is popped from some other screen
        //especially used after clicking on the "sell" button , when this screen is popped, it adds the newly sold item on the client's side in realtime
        .then((value) => fetchAllProducts());
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

  void deleteProduct(
    Product product,
    //index is needed so that we can delete it from the client side as well
    int index,
  ) {
    adminServices.deleteProduct(
      context: context,
      product: product,
      onSuccess: () async {
        products!.removeAt(index);
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return products == null
        ? const Loader()
        : Scaffold(
            //GridView.builder Creates a scrollable, 2D array of widgets that are created on demand.
            //This is appropriate for grid views with a large (or infinite) number of children because the builder is called only for those children that are actually visible.
            body: GridView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemCount: products!.length,
              //gridDelegate is a delegate that controls the layout of the children within the
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //crossAxisCount denotes how many grids you want to display horizontally
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                final productData = products![index];
                return Column(
                  children: [
                    SizedBox(
                      height: 140,
                      child: SingleProduct(
                        //productData.images can be a list of images, but we only want to show the first image from it in the grid, hence productData.images[0]
                        image: productData.images[0],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              productData.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            deleteProduct(productData, index);
                          },
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    )
                  ],
                );
              },
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

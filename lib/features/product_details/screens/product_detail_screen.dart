import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/common/widgets/stars.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/product_details/services/product_details_services.dart';
import 'package:amazon_clone/features/search/screens/search_screen.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  static const String routeName = '/product-details';
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {

  ProductDetailsServices productDetailServices = ProductDetailsServices();

  double avgRating = 0;
  double myRating = 0;

  //copied from homepage
  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  @override
  void initState() {
    super.initState();
    double totalRating = 0;

    //calculating total rating and updating myRating
    for(int i=0; i<widget.product.ratings!.length; i++){
      totalRating += widget.product.ratings![i].rating;

      //updating myRating here itself to avoid looping it in another loop from i=0
      if(widget.product.ratings![i].userId == Provider.of<UserProvider>(context, listen: false).user.id){
        myRating = widget.product.ratings![i].rating;
      }
    }

    //calculating the avgRating of each product
    if(totalRating != 0){
      avgRating = totalRating/widget.product.ratings!.length;
    }

  }

  void addToCart(){
    productDetailServices.addToCart(context: context, product: widget.product);
  }

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.product.id!),
                  Stars(rating: avgRating),
                ],
              ),
            ),
            Padding(padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Text(widget.product.name, style: const TextStyle(fontSize: 15),),
            ),
            CarouselSlider(
              //.map () maps and iterates over each element in carouselImages, referred to as i in this context.
              items: widget.product.images.map((i) {
                //The Builder widget is used here to create a context for each carousel item.
                return Builder(
                    builder: (BuildContext context) => Image.network(
                          i,
                          fit: BoxFit.contain,
                          height: 200,
                        ));
              }).toList(),
              options: CarouselOptions(
                //The fraction of the viewport that each page should occupy, by default its 0.8
                viewportFraction: 1,
                height: 300,
              ),
            ),
            const SizedBox(height: 4,),
            Container(
              color: Colors.black12,
              height: 5,
            ),
            Padding(padding: const EdgeInsets.all(8), 
            child: RichText(
              text: TextSpan(text : 'Deal Price : ', style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
              children: [
                TextSpan(text : '\$${widget.product.price}', style: const TextStyle(fontSize: 22, color: Colors.red, fontWeight: FontWeight.w500),)
              ]
            ),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.product.description),
            ),
            Container(
              color: Colors.black12,
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: CustomButton(text: "Buy Now",backgroundColor: GlobalVariables.secondaryColor,foregroundColor: Colors.white, onTap: (){}),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(10),
              child: CustomButton(text: "Add to Cart",backgroundColor: const Color.fromRGBO(254, 216, 19, 1),foregroundColor: Colors.black, onTap: (){addToCart();}),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text("Rate the Product", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
            ),
            //builds interactive rating for us to rate the product
            RatingBar.builder(
              initialRating: myRating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4),
              itemBuilder: (context, _) => const Icon(Icons.star, color: GlobalVariables.secondaryColor,),
                    onRatingUpdate: (rating) {
                      productDetailServices.rateProduct(context: context, product: widget.product, rating: rating);
                    }
            )
        ],),
        ),
    );
  }
}
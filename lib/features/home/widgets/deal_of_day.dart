import 'package:amazon_clone/common/widgets/loader.dart';
import 'package:amazon_clone/features/home/services/home_services.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:flutter/material.dart';

class DealOfDay extends StatefulWidget {
  const DealOfDay({super.key});

  @override
  State<DealOfDay> createState() => _DealOfDayState();
}

class _DealOfDayState extends State<DealOfDay> {  
  Product? product;
  final HomeServices homeServices = HomeServices();

  @override
  void initState() {
    super.initState();
    fetchDealOfDay();
    setState(() {});
  }

  void fetchDealOfDay() async {
    product = await homeServices.fetchDealOfDay(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return product == null 
    ? const Loader()
    : product!.name.isEmpty 
      ? const SizedBox() 
      : Column(
      children: [
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(left: 10, top: 15),
          child: const Text(
            'Deal of the day',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        Image.network(
          product!.images[0],
          height: 235,
          //Make sure the full height of the source is shown, regardless of whether this means the source overflows the target box horizontally.
          fit: BoxFit.fitHeight,
        ),
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(
            left: 15,
          ),
          child: Text(
            '\$${product!.price}',
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(left: 15, top: 5, right: 40),
          child: Text(
            product!.name,
            //If the text exceeds the given number of lines, it will be truncated according to overflow
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: product!.images.map((e) => Image.network(
                e,
                fit: BoxFit.fitWidth,
                width: 100,
                height: 100,
              ),).toList(), 
          ),
        ),
        Container(
          padding: const EdgeInsets.only(
            left: 15,
            top: 15,
            bottom: 15,
          ),
          alignment: Alignment.topLeft,
          child: Text(
            'See all deals',
            style: TextStyle(
              color: Colors.cyan[800],
            ),
          ),
        )
      ],
    );
  }
}

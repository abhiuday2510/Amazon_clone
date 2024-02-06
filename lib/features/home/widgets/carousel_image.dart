import 'package:amazon_clone/constants/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselImage extends StatelessWidget {
  const CarouselImage({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      //.map () maps and iterates over each element in carouselImages, referred to as i in this context.
      items: GlobalVariables.carouselImages.map((i) {
        //The Builder widget is used here to create a context for each carousel item.
        return Builder(
            builder: (BuildContext context) => Image.network(
                  i,
                  fit: BoxFit.cover,
                  height: 200,
                ));
      }).toList(),
      options: CarouselOptions(
        //The fraction of the viewport that each page should occupy, by default its 0.8
        viewportFraction: 1,
        height: 200,
      ),
    );
  }
}

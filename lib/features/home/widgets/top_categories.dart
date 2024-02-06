import 'package:amazon_clone/constants/global_variables.dart';
import 'package:flutter/material.dart';

class TopCategories extends StatelessWidget {
  const TopCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        //Specifying an itemExtent is more efficient than letting the children determine their own extent because the scrolling machinery can make use of the foreknowledge of the children's extent to save work
        itemExtent: 75,
        itemCount: GlobalVariables.categoryImages.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                //clipRRect creates a rounded rectangular (circular) clip. CircularAvatar could also be used
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    GlobalVariables.categoryImages[index]['image']!,
                    fit: BoxFit.cover,
                    height: 40,
                    width: 40,
                  ),
                ),
              ),
              Text(
                GlobalVariables.categoryImages[index]['title']!,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              ),
            ],
          );
        },
      ),
    );
  }
}

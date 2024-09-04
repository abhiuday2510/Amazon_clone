// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Rating {
  final String userId;
  final double rating;

  Rating({required this.userId, required this.rating});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'rating': rating,
    };
  }

  factory Rating.fromMap(Map<String, dynamic> map) {


    // Check if rating is an int and convert to double if necessary, since in the backend its mentioned as number, so it can be both
    var ratingValue = map['rating'];
    double parsedRating;
    if (ratingValue is int) {
      parsedRating = ratingValue.toDouble(); // Convert int to double
    } else if (ratingValue is double) {
      parsedRating = ratingValue;
    } else {
      throw Exception('Unexpected type for rating: ${ratingValue.runtimeType}');
    }


    return Rating(
      userId: map['userId'] as String,
      rating: parsedRating,
    );
  }

  String toJson() => json.encode(toMap());

  factory Rating.fromJson(String source) => Rating.fromMap(json.decode(source) as Map<String, dynamic>);
}

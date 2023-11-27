import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_recommender/food.dart';
import 'package:food_recommender/parameters.dart';
import 'package:csv/csv.dart';

class Output extends StatefulWidget {
  Map<String, Parameters> selectedCategory;
  Output({Key? key, required this.selectedCategory}) : super(key: key);

  @override
  State<Output> createState() => _OutputState();
}

class _OutputState extends State<Output> {
  Map<String, Food> result = {};
  // get recommendation
  _getRecommendation() async {
    final input = File('assets/data.csv').openRead();
    // fetch data from csv file
    final allFoodItems = await input
        .transform(utf8.decoder)
        .transform(const CsvToListConverter())
        .toList();

    Map<String, double> maxRating = {
      'Starter': 0,
      'Soup': 0,
      'Main Course': 0,
      'Side Dish': 0,
      'Dessert': 0,
      'Chaat': 0,
    };

    // print each field
    for (var i = 1; i < allFoodItems.length; i++) {
      var eachRows = allFoodItems[i];

      widget.selectedCategory.forEach((key, value) {
        try {
          String foodName = eachRows[1];
          String category = eachRows[0]; // starter, Main Course, etc...
          String typeOfFood = eachRows[4]; // veg or non-veg
          String flavour = eachRows[3]; // mild, medium, strong
          double price = double.parse(eachRows[2].toString()); // price of food
          double rating = double.parse(eachRows[5].toString());

          // check according to user preference
          if ((category == key) &&
              (value.type == typeOfFood) &&
              (value.flavour == flavour) &&
              (price >= value.minPrice) &&
              (price <= value.maxPrice)) {
            // store data with max rating
            if (rating > (maxRating[key] ?? 0)) {
              maxRating[key] = rating;
              result[key] = Food(
                  foodName: foodName,
                  price: price,
                  flavor: flavour,
                  rating: rating,
                  type: typeOfFood);
            }
          }
        } catch (e) {
          print('$i$e');
        }
      });
    }

    // print result
    result.forEach((key, value) {
      print(
          '$key -> ${value.foodName}, ${value.price}, ${value.flavor}, ${value.rating}');
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Recommendation'),
      ),
      body: FutureBuilder(
        future: _getRecommendation(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: result.length,
              itemBuilder: (context, index) {
                return ListTile(
                  // minVerticalPadding: 30,
                  tileColor: index % 2 == 0 ? Colors.white : Colors.grey[200],
                  visualDensity: VisualDensity.comfortable,
                  style: ListTileStyle.list,
                  shape: RoundedRectangleBorder(
                    side: BorderSide.lerp(
                      const BorderSide(
                          color: Color.fromARGB(255, 66, 57, 57), width: 1),
                      const BorderSide(
                          color: Color.fromARGB(0, 255, 255, 255), width: 10),
                      0.5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  title: Text(result.keys.elementAt(index)),
                  subtitle: Text(result.values.elementAt(index).foodName),
                  trailing: Text(
                      '₹${result.values.elementAt(index).price}\n⭐${result.values.elementAt(index).rating}'),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:food_recommender/output.dart';
import 'package:food_recommender/parameters.dart';

class UserChoices extends StatefulWidget {
  const UserChoices({Key? key}) : super(key: key);

  @override
  State<UserChoices> createState() => _UserChoicesState();
}

class _UserChoicesState extends State<UserChoices> {
  var category = [
    'Starter',
    'Soup',
    'Main Course',
    'Side Dish',
    'Dessert',
    'Chaat',
  ];

  // map to store the selected category
  Map<String, Parameters> selectedCategory = {};

  int _selectedIndex = 0;
  String? _selectedType;
  String? _selectedFlavor;
  RangeValues _priceRange = const RangeValues(20, 200);

  _reset() {
    _selectedType = null;
    _selectedFlavor = null;
    _priceRange = const RangeValues(20, 200);
  }

  void _next() {
    setState(() {
      if (_selectedIndex < category.length - 1) {
        _selectedIndex++;
        _reset();
      } else {
        // go to output page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Output(
              selectedCategory: selectedCategory,
            ),
          ),
        );
      }
    });
  }

  void _back() {
    setState(() {
      if (_selectedIndex > 0) {
        _selectedIndex--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // back button
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            _back();
          },
        ),
        centerTitle: true,
        title: Text(
          category[_selectedIndex],
          style: const TextStyle(
            fontSize: 30,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Type of food(Veg or Non-Veg)
          const Text(
            "Type",
            style: TextStyle(fontSize: 20),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Radio<String>(
                    value: 'Veg',
                    groupValue: _selectedType,
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value!;
                      });
                    },
                  ),
                  const Text("Veg"),
                ],
              ),
              Row(
                children: [
                  Radio<String>(
                    value: "Non-Veg",
                    groupValue: _selectedType,
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value!;
                      });
                    },
                  ),
                  const Text("Non-Veg"),
                ],
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Price Range
          Column(
            children: [
              const Text(
                "Price Range",
                style: TextStyle(fontSize: 20),
              ),
              // slider
              RangeSlider(
                values: _priceRange,
                min: 0,
                max: 450,
                divisions: 100,
                labels: RangeLabels(
                    _priceRange.start.toString(),
                    _priceRange.end >= 450
                        ? "₹450+"
                        : "₹" + _priceRange.end.toString()),
                onChanged: (RangeValues value) {
                  setState(() {
                    _priceRange = value;
                  });
                },
              ),

              // price range label
              Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "₹${_priceRange.start}",
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(
                      _priceRange.end >= 1000
                          ? "₹1000+"
                          : "₹${_priceRange.end}",
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Flavor
          const Text(
            "Flavor",
            style: TextStyle(fontSize: 20),
          ),
          // Mild, Medium, Strong
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Radio<String>(
                      value: 'Mild',
                      groupValue: _selectedFlavor,
                      onChanged: (value) {
                        setState(() {
                          _selectedFlavor = value!;
                        });
                      },
                    ),
                    const Text("Mild"),
                  ],
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Medium',
                      groupValue: _selectedFlavor,
                      onChanged: (value) {
                        setState(() {
                          _selectedFlavor = value!;
                        });
                      },
                    ),
                    const Text("Medium"),
                  ],
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Strong',
                      groupValue: _selectedFlavor,
                      onChanged: (value) {
                        setState(() {
                          _selectedFlavor = value!;
                        });
                      },
                    ),
                    const Text("Strong"),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 100),

          // Next button
          ElevatedButton(
            onPressed: () {
              if (_selectedType != null && _selectedFlavor != null) {
                selectedCategory[category[_selectedIndex]] = Parameters(
                    type: _selectedType!,
                    minPrice: _priceRange.start,
                    maxPrice: _priceRange.end,
                    flavour: _selectedFlavor!);
                _next();
              }
            },
            child: const Text(
              "Next",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

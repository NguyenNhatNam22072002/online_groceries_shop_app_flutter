import 'package:flutter/material.dart';
import 'package:online_groceries/common_widget/round_button.dart';
import 'package:online_groceries/view/search/filter_parameters.dart';

import '../../common/color_extension.dart';
import '../../common_widget/filter_row.dart';

class FilterView extends StatefulWidget {
  const FilterView({super.key});

  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  List selectArr = [];

  RangeValues _priceRange = const RangeValues(0, 100);

  List filterCatArr = [
    {
      "id": "1",
      "name": "Eggs",
    },
    {
      "id": "2",
      "name": "Noodles & Pasta",
    },
    {
      "id": "3",
      "name": "Chips & Crisps",
    },
    {
      "id": "4",
      "name": "Fast Food",
    },
  ];

  List filterBrandArr = [
    {
      "id": "1",
      "name": "Individual Callection",
    },
    {
      "id": "2",
      "name": "Cocola",
    },
    {
      "id": "3",
      "name": "Ifad",
    },
    {
      "id": "4",
      "name": "Kazi Farmas",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Image.asset(
                "assets/img/close.png",
                width: 20,
                height: 20,
              )),
          title: Text(
            "Filters",
            style: TextStyle(
                color: TColor.primaryText,
                fontSize: 20,
                fontWeight: FontWeight.w700),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
              color: Color(0xffF2F3F2),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Price Range",
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),

                    // Min Price Text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Min Price: \$${_priceRange.start.toStringAsFixed(2)}"),
                        Text("Max Price: \$${_priceRange.end.toStringAsFixed(2)}"),
                      ],
                    ),

                    // Price Range Slider
                    RangeSlider(
                      values: _priceRange,
                      onChanged: (RangeValues values) {
                        setState(() {
                          _priceRange = values;
                        });
                      },
                      min: _priceRange.start,
                      max: _priceRange.end,
                      divisions: 100,
                      labels: RangeLabels('\$${_priceRange.start}', '\$${_priceRange.end}'),
                    ),
                  ],
                ),
              ),
              RoundButton(title: "Apply Filter", onPressed: () {
                Navigator.pop(context, FilterParameters(
                  minPrice: _priceRange.start.toString(),
                  maxPrice: _priceRange.end.toString(),
                ));
              })
            ],
          ),
        ));
  }
}

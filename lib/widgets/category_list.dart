import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../models/category_model.dart';
import 'category_card.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({required this.categories, super.key});
  final List<CategoryModel> categories;

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) => SizedBox(
      height: 175,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingLarge,
        ),
        itemCount: widget.categories.length,
        itemBuilder: (context, index) {
          final category = widget.categories[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CategoryCard(
              category: category,
              isSelected: _selectedIndex == index,
              index: index,
              onTap: () {
                setState(() {
                  _selectedIndex = _selectedIndex == index ? null : index;
                });
              },
            ),
          );
        },
      ),
    );
}
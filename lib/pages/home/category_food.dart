import 'package:flutter/material.dart';

import '../../category/ProductPage.dart';
import '../../utils/dimensions.dart';


class CategoryWidget extends StatefulWidget {
  const CategoryWidget({super.key});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.symmetric(
        vertical: Dimensions.height20,
        horizontal: Dimensions.width20,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,  // Enable horizontal scrolling
        child: Row(
          children: [
            _buildCategoryItem(context, "assets/images/images3.png", "Burgers"),
            _buildCategoryItem(context, "assets/images/images3.png", "Pizza"),
            _buildCategoryItem(context, "assets/images/images3.png", "Drinks"),
            _buildCategoryItem(context, "assets/images/images3.png", "Desserts"),
            _buildCategoryItem(context, "assets/images/images3.png", "Combo"),
            _buildCategoryItem(context, "assets/images/images3.png", "Khuyến Mãi"),

          ],
        ),
      ),
    );
  }

  // Function to build a category item
  Widget _buildCategoryItem(BuildContext context, String imagePath, String categoryName) {
    return GestureDetector(
      onTap: () {
        // Navigate to the ProductPage with the selected category
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductPage(categoryName: categoryName),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(right: Dimensions.width20),  // Increased padding for better spacing between items
        child: Column(
          children: [
            Container(
              width: 70,  // Increased width for a larger category image
              height: 70,  // Increased height for a larger category image
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Circular shape
                color: Colors.white, // Background color
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // Shadow effect
                  ),
                ],
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover, // Fit image within the circle
                ),
              ),
            ),
            SizedBox(height: 12),  // Increased space between image and text
            Text(
              categoryName,
              style: TextStyle(
                fontSize: 16,  // Increased font size for the category name
                fontWeight: FontWeight.w600,  // Slightly bolder font weight
              ),
            ),
          ],
        ),
      ),
    );
  }
}





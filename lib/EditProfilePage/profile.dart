import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../utils/constants.dart';

class ProfileListItem extends StatelessWidget {
  final IconData icon; // Icon to be displayed
  final String text;   // Text for the list item
  final bool hasNavigation; // Flag to show navigation icon

  // Constructor with named parameters
  const ProfileListItem({
    Key? key,
    required this.icon,
    required this.text,
    this.hasNavigation = true, // Default value for hasNavigation is true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kSpacingUnit.w * 5.5,
      margin: EdgeInsets.symmetric(
        horizontal: kSpacingUnit.w * 4,
      ).copyWith(
        bottom: kSpacingUnit.w * 2,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: kSpacingUnit.w * 2,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kSpacingUnit.w * 3),
        color: Theme.of(context).colorScheme.background,
      ),
      child: Row(
        children: <Widget>[
          Icon(
            icon, // Dynamic icon passed to constructor
            size: kSpacingUnit.w * 2.5, // Scalable icon size
          ),
          SizedBox(width: kSpacingUnit.w * 1.5), // Space between icon and text
          Text(
            text, // Dynamic text passed to constructor
            style: kTitleTextStyle.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacer(), // Push the right icon to the far right
          if (hasNavigation) // Show navigation icon if true
            Icon(
              Icons.add_a_photo_outlined, // Arrow icon for navigation
              size: kSpacingUnit.w * 2.5, // Scalable icon size
            ),
        ],
      ),
    );
  }
}

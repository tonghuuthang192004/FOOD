import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onthi/widgets/small_text.dart';

import '../utils/color.dart';
import '../utils/dimensions.dart';
import 'big_text.dart';
import 'icon_and_text_widget.dart';

class AppColumn extends StatelessWidget {
  const AppColumn({super.key, });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        SizedBox(
          height: Dimensions.height10,
        ),
        Row(
          children: [
            Wrap(
              children: List.generate(5, (index) {
                return Icon(
                  Icons.star,
                  color: AppColors.mainColor,
                  size: 17,
                );
              }),
            ),
            SizedBox(
              width: 10,
            ),
            SmallText(text: "4.5"),
            SizedBox(
              width: 10,
            ),
            SmallText(text: "1287"),
            SizedBox(
              width: 10,
            ),
            SmallText(text: "comments"),
          ],
        ),
        SizedBox(
          height: Dimensions.height10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconAndTextWidget(
                icon: Icons.circle_sharp,
                text: "Normal",
                iconColor: AppColors.iconColor1),
            IconAndTextWidget(
                icon: Icons.location_on,
                text: "1.7km",
                iconColor: AppColors.mainColor),
            IconAndTextWidget(
                icon: Icons.access_time,
                text: "32min",
                iconColor: AppColors.iconColor2)
          ],
        )
      ],
    ) ;
  }
}

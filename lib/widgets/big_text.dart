import 'package:flutter/material.dart';
import 'package:onthi/utils/dimensions.dart';
class BigText extends StatelessWidget {
  final Color? color;
  final String text;
  double size;
  TextOverflow overflow;
  BigText({super.key,this.color=const Color(0xFF332d2b),required this.text,this.overflow=TextOverflow.ellipsis,this.size=20});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow:overflow,style: TextStyle(
      color: color,
      fontSize:size==0? Dimensions.font20:size,
      fontWeight: FontWeight.bold,
      fontFamily: 'Roboto'
    )

    );
  }
}

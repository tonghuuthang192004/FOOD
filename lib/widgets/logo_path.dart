import 'dart:ui';

import 'package:flutter/cupertino.dart';

class Logo extends StatelessWidget {
  final String logoPath;

  const Logo(this.logoPath, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      logoPath,
      height: 40.0, // You can adjust the size as needed
    );
  }
}
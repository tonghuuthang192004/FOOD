import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:onthi/pages/ProfilePage/ProfilePage.dart';
import 'package:onthi/pages/food/food_detail.dart';
import 'package:onthi/pages/food/popular_food_detail.dart';
import 'package:onthi/pages/home/food_page_body.dart';
import 'package:onthi/pages/home/main_food_page.dart';
import 'package:onthi/pages/login/login.dart';
import 'package:onthi/pay/payment.dart';
import 'package:onthi/registerPage/registerPage.dart';
import 'package:onthi/signup/signin_screen.dart';

import 'package:onthi/welcome/welcome.dart';

import 'package:onthi/widgets/app_column.dart';

import 'ChangePasswordPage/ChangePasswordPage.dart';
import 'EditProfilePage/profile.dart';
import 'ProductBottomSheetPage/ProductBottomSheetPage.dart';
import 'admin/OrderListWithFilter.dart';
import 'admin/Order_List_Screen.dart';
import 'cart/cart.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
      ),
      home:RegisterPage(),
    );
  }
}

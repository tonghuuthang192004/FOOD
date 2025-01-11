import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:onthi/utils/color.dart';
import 'package:onthi/widgets/big_text.dart';
import 'package:onthi/widgets/icon_and_text_widget.dart';
import 'package:onthi/widgets/small_text.dart';
import 'package:onthi/utils/dimensions.dart';

import '../../category/ProductPage.dart';
import '../food/food_detail.dart';
import '../food/popular_food_detail.dart';
import 'category_food.dart';

class FoodPageBody extends StatefulWidget {
  const FoodPageBody({super.key});

  @override
  State<FoodPageBody> createState() => _FoodPageBodyState();
}

class _FoodPageBodyState extends State<FoodPageBody> {
  PageController pageController = PageController(viewportFraction: 0.9);
  var _currpapevalue = 0.0;
  double _scaleFactory = 0.8;
  double _height = Dimensions.pageViewContainer;

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        _currpapevalue = pageController.page!;
        print("current value is " + _currpapevalue.toString());
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //slider section
        SizedBox(
          // color: Colors.redAccent,
          height: Dimensions.pageView,
          child: PageView.builder(
              controller: pageController,
              itemCount: 5,
              itemBuilder: (context, position) {
                return _buildPageItem(position);
              }),
        ),
        // dots
        DotsIndicator(
          dotsCount: 5,
          position: _currpapevalue,
          decorator: DotsDecorator(
            activeColor: AppColors.mainColor,
            size: const Size.square(9.0),
            activeSize: const Size(18.0, 9.0),
            activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          ),
        ),
        CategoryWidget(),

        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 10,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Navigate to RecommendFoodDetail page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecommendFoodDetail()),
                );
              },
              child: Container(
                margin: EdgeInsets.only(
                    left: Dimensions.width20,
                    right: Dimensions.width20,
                    bottom: Dimensions.height10),
                child: Row(
                  children: [
                    // image section
                    Container(
                      width: Dimensions.listViewImgSize,
                      height: Dimensions.listViewImgSize,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radius20),
                        color: Colors.white38,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/images1.png"),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: Dimensions.listViewTextContsize,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(Dimensions.radius20),
                            bottomRight: Radius.circular(Dimensions.radius20),
                          ),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: Dimensions.width10,
                            right: Dimensions.width10,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BigText(text: "Gà rán"),
                              SizedBox(height: Dimensions.height10),
                              SmallText(text: "thơm ngon"),
                              SizedBox(height: Dimensions.height10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                      iconColor: AppColors.iconColor2),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        )

      ],
    );
  }

  Widget _buildPageItem(int index) {
    Matrix4 matrix = new Matrix4.identity();
    if (index == _currpapevalue.floor()) {
      var currScale = 1 - (_currpapevalue - index) * (1 - _scaleFactory);
      var currTrans = _height * (1 - currScale) / 2;

      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currpapevalue.floor() + 1) {
      var currScale =
          _scaleFactory + (_currpapevalue - index + 1) * (1 - _scaleFactory);
      var currTrans = _height * (1 - currScale) / 2;

      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currpapevalue.floor() - 1) {
      var currScale = 1 - (_currpapevalue - index) * (1 - _scaleFactory);
      var currTrans = _height * (1 - currScale) / 2;

      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else {
      var currScale = 0.8;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, _height * (1 - _scaleFactory) / 2, 1);
    }

    return Transform(
      transform: matrix,
      child: GestureDetector(
        onTap: () {
          // Navigate to RecommendFoodDetail page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RecommendFoodDetail()),
          );
        },
        child: Stack(
          children: [
            Container(
              height: 220,
              margin: EdgeInsets.only(
                  left: Dimensions.width10, right: Dimensions.width10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: index.isEven ? Color(0xFF69c5df) : Color(0xFF9294cc),
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/images3.png",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: Dimensions.pageViewTextContainer,
                margin: EdgeInsets.only(left: 30, right: 30, bottom: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFFe8e8e8),
                      blurRadius: 10.0,
                      offset: Offset(5, 5),
                    ),
                    BoxShadow(color: Colors.white, offset: Offset(-5, 0)),
                    BoxShadow(color: Colors.white, offset: Offset(5, 0)),
                  ],
                ),
                child: Container(
                  padding: EdgeInsets.only(
                    top: Dimensions.height10,
                    left: Dimensions.height10,
                    right: Dimensions.height10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BigText(
                        text: "CHINESE SIDE",
                        size: 25,
                      ),
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
                          const SizedBox(width: 10),
                          SmallText(text: "4.5"),
                          const SizedBox(width: 10),
                          SmallText(text: "1287"),
                          const SizedBox(width: 10),
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
                            iconColor: AppColors.iconColor1,
                          ),
                          IconAndTextWidget(
                            icon: Icons.location_on,
                            text: "1.7km",
                            iconColor: AppColors.mainColor,
                          ),
                          IconAndTextWidget(
                            icon: Icons.access_time,
                            text: "32min",
                            iconColor: AppColors.iconColor2,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}



import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dots_indicator/dots_indicator.dart';
import 'package:onthi/utils/color.dart';
import 'package:onthi/widgets/big_text.dart';
import 'package:onthi/widgets/small_text.dart';
import 'package:onthi/utils/dimensions.dart';
import 'package:onthi/widgets/icon_and_text_widget.dart';
import '../../category/ProductPage.dart';
import '../food/food_detail.dart';
import '../food/popular_food_detail.dart';
import 'category_food.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dots_indicator/dots_indicator.dart';
import 'package:onthi/utils/color.dart';
import 'package:onthi/widgets/big_text.dart';
import 'package:onthi/widgets/small_text.dart';
import 'package:onthi/utils/dimensions.dart';
import 'package:onthi/widgets/icon_and_text_widget.dart';
import 'category_food.dart';

class FoodPageBody extends StatefulWidget {
  const FoodPageBody({super.key, required this.searchQuery});

  final String searchQuery;

  @override
  State<FoodPageBody> createState() => _FoodPageBodyState();
}

class _FoodPageBodyState extends State<FoodPageBody> {
  String connection = "http://192.168.1.9/API/";  // API connection URL
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  String selectedCategoryId = '';  // Store selected category ID
  PageController pageController = PageController(viewportFraction: 0.9);
  double _currpapevalue = 0.0;
  double _scaleFactory = 0.8;
  double _height = Dimensions.pageViewContainer;

  @override
  void initState() {
    super.initState();
    fetchProducts();  // Load all products when the page is first opened
    pageController.addListener(() {
      setState(() {
        _currpapevalue = pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();  // Dispose of page controller when no longer needed
  }

  // Fetch products from API with optional category ID and search query
  Future<void> fetchProducts({String categoryId = '', String searchQuery = ''}) async {
    final url = categoryId.isEmpty
        ? '$connection/list.php?search_query=$searchQuery'  // If no category is selected, just search by query
        : '$connection/list.php?id_danh_muc=$categoryId';  // If category is selected, search by category

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _products = data.map((json) => Product.fromJson(json)).toList();
          _filteredProducts = List.from(_products);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching products: $e');
    }
  }

  // Filter products when search query changes
  void _searchProducts(String query) {
    setState(() {
      _filteredProducts = _products
          .where((product) => product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void didUpdateWidget(covariant FoodPageBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != oldWidget.searchQuery) {
      _searchProducts(widget.searchQuery);  // If search query changes, filter the products
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Slider section
        SizedBox(
          height: Dimensions.pageView,
          child: PageView.builder(
              controller: pageController,
              itemCount: 5,
              itemBuilder: (context, position) {
                return _buildPageItem(position);
              }),
        ),
        // Dots for page indicator
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
        // Category Widget with selection callback
        CategoryWidget(
          onCategorySelected: (categoryId) {
            setState(() {
              selectedCategoryId = categoryId;
              _isLoading = true;  // Show loading spinner while fetching products
            });
            fetchProducts(categoryId: selectedCategoryId, searchQuery: widget.searchQuery);  // Fetch products by category
          },
          selectedCategoryId: selectedCategoryId, // Truyền ID danh mục đang chọn

        ),

        // Show loading spinner while fetching data
        if (_isLoading)
          Center(child: CircularProgressIndicator())
        else
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _filteredProducts.length,
            itemBuilder: (context, index) {
              final product = _filteredProducts[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PopularFoodDetail(product: product),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(
                      left: Dimensions.width20,
                      right: Dimensions.width20,
                      bottom: Dimensions.height10),
                  child: Row(
                    children: [
                      // Product image section
                      Container(
                        width: Dimensions.listViewImgSize,
                        height: Dimensions.listViewImgSize,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radius20),
                          color: Colors.white38,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: product.imageUrl != null && product.imageUrl!.isNotEmpty
                                ? NetworkImage(product.imageUrl!)
                                : AssetImage("assets/images/image1.png") as ImageProvider,
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
                                BigText(text: product.name),
                                SizedBox(height: Dimensions.height10),
                                SmallText(text: product.description),
                                SizedBox(height: Dimensions.height10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    BigText(text: product.price.toString(), color: Colors.red),
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
          ),
      ],
    );
  }

  // Page item builder for the slider
  Widget _buildPageItem(int index) {
    Matrix4 matrix = Matrix4.identity();
    if (index == _currpapevalue.floor()) {
      var currScale = 1 - (_currpapevalue - index) * (1 - _scaleFactory);
      var currTrans = _height * (1 - currScale) / 2;

      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currpapevalue.floor() + 1) {
      var currScale = _scaleFactory + (_currpapevalue - index + 1) * (1 - _scaleFactory);
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
                  image: AssetImage("assets/images/images3.png"),
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
                      BigText(text: "CHINESE SIDE", size: 25),
                      SizedBox(height: Dimensions.height10),
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
                      SizedBox(height: Dimensions.height10),
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

class Product {
  final int id;
  final String name;
  final double price;
  final String description;
  final String sauceName;
  final String sauceDescription;
  final double saucePrice;
  final String categoryName;
  final String? imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.sauceName,
    required this.sauceDescription,
    required this.saucePrice,
    required this.categoryName,
    this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: int.tryParse(json['id_san_pham'].toString()) ?? 0,
      name: json['product_name'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      description: json['description'],
      sauceName: json['sauce_name'],
      sauceDescription: json['sauce_description'],
      saucePrice: double.tryParse(json['sauce_price'].toString()) ?? 0.0,
      categoryName: json['category_name'],
      imageUrl: json['image_url'],
    );
  }
}
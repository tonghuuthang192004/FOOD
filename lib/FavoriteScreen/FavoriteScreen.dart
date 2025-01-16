import 'package:flutter/material.dart';
import '../ProductBottomSheetPage/ProductBottomSheetPage.dart';
import '../pages/food/food_detail.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  // List of favorite products
  List<Map<String, String>> favoriteItems = [
    {
      "image": "assets/images/images1.png",
      "name": "KFC Combo",
      "price": "90,000 VND",
    },
    {
      "image": "assets/images/images2.png",
      "name": "Pizza Special",
      "price": "150,000 VND",
    },
    {
      "image": "assets/images/images3.png",
      "name": "Cheese Burger",
      "price": "50,000 VND",
    },
  ];

  // List of filtered favorite items
  List<Map<String, String>> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = favoriteItems; // Show all products by default
  }

  // Filter products by name
  void _filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredItems = favoriteItems;
      });
    } else {
      setState(() {
        filteredItems = favoriteItems
            .where((item) =>
            item['name']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Favorite Products",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepOrange,
        actions: [
          // Cart icon on app bar
          IconButton(
            onPressed: () {
              // Navigate to cart or handle cart functionality here
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductBottomSheetPage()),
              );
            },
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _filterSearchResults,
              decoration: InputDecoration(
                labelText: 'Search Products',
                prefixIcon: Icon(Icons.search, color: Colors.deepOrange),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.deepOrange),
                ),
              ),
            ),
          ),
          // List of favorite products
          filteredItems.isEmpty
              ? const Center(
            child: Text(
              "No favorite products yet!",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          )
              : Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 5,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        item['image']!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      item['name']!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      item['price']!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Cart icon for adding the product to the cart
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProductBottomSheetPage()), // Navigate to the cart page
                            );
                          },
                          icon: const Icon(
                            Icons.shopping_cart,
                            color: Colors.deepOrange,
                          ),
                        ),
                        const SizedBox(width: 8), // Add some spacing between icons
                        // Delete icon for removing from favorites
                        IconButton(
                          onPressed: () {
                            setState(() {
                              filteredItems.removeAt(index);
                              favoriteItems.removeAt(index); // Remove from both lists
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("${item['name']} removed from favorites"),
                            ));
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Navigate to product detail page on tap
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecommendFoodDetail(),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

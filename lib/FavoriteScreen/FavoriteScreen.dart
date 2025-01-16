import 'package:flutter/material.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  // Danh sách sản phẩm yêu thích (tạm thời)
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

  // Danh sách sản phẩm sau khi lọc
  List<Map<String, String>> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = favoriteItems; // Mặc định hiển thị tất cả sản phẩm
  }

  // Hàm lọc sản phẩm theo tên
  void _filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredItems = favoriteItems; // Hiển thị tất cả sản phẩm khi không có từ khóa tìm kiếm
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
      ),
      body: Column(
        children: [
          // Thanh tìm kiếm nằm dưới AppBar
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
          // Danh sách sản phẩm sau khi lọc
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
                    trailing: IconButton(
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

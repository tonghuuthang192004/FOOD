import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../shared_preferences/shared_preferences.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Map<String, dynamic>> favoriteItems = [];
  List<Map<String, dynamic>> filteredItems = [];

  // Fetch favorite products from the API
  Future<void> fetchFavoriteItems() async {
    try {
      Map<String, String> userData = await LocalStorage.getUserData();
      String userId = userData['id_nguoi_dung'] ?? '';

      if (userId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User ID not found")),
        );
        return;
      }

      final response = await http.get(
        Uri.parse('http://192.168.1.9/API/favorite.php?action=get_favorite_items&id_nguoi_dung=$userId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          favoriteItems = List<Map<String, dynamic>>.from(data);
          filteredItems = favoriteItems;
        });
      } else {
        throw Exception('Failed to load favorite items');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading favorite items: $e")),
      );
    }
  }

  // Remove product from favorites
  Future<void> removeFromFavorites(int productId) async {
    try {
      Map<String, String> userData = await LocalStorage.getUserData();
      String userId = userData['id_nguoi_dung'] ?? '';

      if (userId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User ID not found")),
        );
        return;
      }

      final response = await http.post(
        Uri.parse('http://192.168.1.9/API/favorite.php?action=delete_from_favorites'),
        body: {
          'id_nguoi_dung': userId.toString(),
          'id_san_pham': productId.toString(),
        },
      );

      final result = json.decode(response.body);
      if (result['status'] == 'success') {
        setState(() {
          // Immediately remove the product from both favoriteItems and filteredItems
          favoriteItems.removeWhere((item) => item['id_san_pham'] == productId.toString());
          filteredItems.removeWhere((item) => item['id_san_pham'] == productId.toString());
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Product removed from favorites")),
        );
      } else {
        throw Exception('Failed to remove product from favorites');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error removing product from favorites: $e")),
      );
    }
  }

  // Filter search results
  void _filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredItems = favoriteItems;
      });
    } else {
      setState(() {
        filteredItems = favoriteItems.where((item) {
          return item['ten']!.toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  // Confirmation dialog for deleting
  Future<void> _confirmDelete(int productId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to remove this product from favorites?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                removeFromFavorites(productId);  // Remove product immediately
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchFavoriteItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Products"),
        backgroundColor: Colors.deepOrange,
      ),
      body: Column(
        children: [
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
          filteredItems.isEmpty
              ? const Center(
            child: Text("No favorite products yet!"),
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
                      child: Image.network(
                        item['image_url'] ?? '',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      item['ten'] ?? '',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      item['gia'] ?? '',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        _confirmDelete(item['id_san_pham']);

                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
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

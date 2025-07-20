import 'package:flutter/material.dart';
import 'cart_page.dart';
import 'login_page.dart';

class ProductMenuPage extends StatefulWidget {
  const ProductMenuPage({super.key});

  @override
  State<ProductMenuPage> createState() => _ProductMenuPageState();
}

class _ProductMenuPageState extends State<ProductMenuPage> {
  final Color backgroundColor = const Color(0xFFD08742);

  final List<Map<String, dynamic>> allProducts = [
    // Coffee
    {'name': 'Americano', 'type': 'Coffee'},
    {'name': 'Cappuccino', 'type': 'Coffee'},
    {'name': 'Caramel Macchiato', 'type': 'Coffee'},
    {'name': 'Matcha Latte', 'type': 'Coffee'},

    // Rice Meals
    {'name': 'Pork Belly Adobo', 'size': 'Rice Meal', 'price': 159},
    {'name': 'Crispy Binagoongan', 'size': 'Rice Meal', 'price': 189},
    {'name': 'Crispy Liempo', 'size': 'Rice Meal', 'price': 159},
    {'name': 'Tapa', 'size': 'Rice Meal', 'price': 159},
    {'name': 'Crispy Sisig', 'size': 'Rice Meal', 'price': 180},
    {'name': 'Chicharon Bulaklak', 'size': 'Rice Meal', 'price': 130},

    // Silog Meals
    {'name': 'Spamsilog', 'size': 'Silog Meal', 'price': 109},
    {'name': 'Cornsilog', 'size': 'Silog Meal', 'price': 109},
    {'name': 'Skinsilog', 'size': 'Silog Meal', 'price': 109},
    {'name': 'Tapsilog', 'size': 'Silog Meal', 'price': 109},
    {'name': 'Hotsilog', 'size': 'Silog Meal', 'price': 109},

    // Specialties
    {'name': 'Tacos', 'size': 'Specialty', 'price': 139},
    {'name': 'Crispy Kare-Kare', 'size': 'Specialty (2-3 persons)', 'price': 399},
    {'name': 'Calderetang Batangas', 'size': 'Specialty (2-3 persons)', 'price': 399},
    {'name': 'Sinigang na Hipon', 'size': 'Specialty', 'price': 349},

    // Rice
    {'name': 'Java Rice', 'size': 'Rice', 'price': 25},
    {'name': 'Plain Rice', 'size': 'Rice', 'price': 20},
  ];

  List<Map<String, dynamic>> filteredProducts = [];
  final List<Map<String, dynamic>> cart = [];
  final TextEditingController searchController = TextEditingController();
  String? selectedSizeFilter;

  @override
  void initState() {
    super.initState();
    filteredProducts = List.from(allProducts);
  }

  void _onProductTap(Map<String, dynamic> product) {
    if (product['type'] == 'Coffee') {
      _showSizePicker(product['name']);
    } else {
      _addToCart(product['name'], product['size'], product['price']);
    }
  }

  void _addToCart(String name, String size, int price) {
    int index = cart.indexWhere((item) => item['name'] == name && item['size'] == size);

    if (index != -1) {
      setState(() {
        cart[index]['quantity'] += 1;
      });
    } else {
      setState(() {
        cart.add({'name': name, 'size': size, 'price': price, 'quantity': 1});
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name ($size) added to cart'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showSizePicker(String coffeeName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Size for $coffeeName'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Tall - ₱89'),
              onTap: () {
                Navigator.pop(context);
                _addToCart(coffeeName, 'Tall', 89);
              },
            ),
            ListTile(
              title: const Text('Grande - ₱99'),
              onTap: () {
                Navigator.pop(context);
                _addToCart(coffeeName, 'Grande', 99);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _searchProducts() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredProducts = allProducts.where((product) {
        final name = product['name'].toString().toLowerCase();
        final size = product['size']?.toString().toLowerCase() ?? '';
        final type = product['type']?.toString().toLowerCase() ?? '';
        final category = size.isNotEmpty ? size : type;

        return name.contains(query) &&
            (selectedSizeFilter == null ||
                category == selectedSizeFilter!.toLowerCase());
      }).toList();
    });
  }

  void _filterBySize() {
    final uniqueSizes = allProducts
        .map((e) => e['size']?.toString() ?? e['type']?.toString())
        .where((e) => e != null)
        .toSet()
        .cast<String>()
        .toList();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              title: const Text('All'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  selectedSizeFilter = null;
                  _searchProducts();
                });
              },
            ),
            ...uniqueSizes.map((size) => ListTile(
                  title: Text(size),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      selectedSizeFilter = size;
                      _searchProducts();
                    });
                  },
                )),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
          },
        ),
        title: const Text(
          'POS System',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: const InputDecoration(
                            hintText: 'Search...',
                            border: InputBorder.none,
                          ),
                          onChanged: (_) => _searchProducts(),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: _searchProducts,
                      ),
                      IconButton(
                        icon: const Icon(Icons.filter_alt),
                        onPressed: _filterBySize,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    itemCount: filteredProducts.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.95,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return GestureDetector(
                        onTap: () => _onProductTap(product),
                        child: ProductCard(
                          name: product['name'],
                          size: product['size'] ?? product['type'] ?? '',
                          price: product['price'] ?? 0,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(color: Colors.black),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CartPage(cartItems: cart),
                  ),
                );
              },
              icon: const Icon(Icons.shopping_cart_checkout),
              label: const Text('Cart'),
            ),
          )
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final String size;
  final int price;

  const ProductCard({
    super.key,
    required this.name,
    required this.size,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E7),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              size,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              price > 0 ? '₱ $price' : '',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

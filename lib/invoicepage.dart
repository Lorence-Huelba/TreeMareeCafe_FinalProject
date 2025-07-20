import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'product_menu_page.dart';
import 'cart_page.dart';

class InvoicePage extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final num cash;

  const InvoicePage({
    super.key,
    required this.cartItems,
    required this.cash,
  });

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'en_PH', symbol: '₱', decimalDigits: 2);
    final total = cartItems.fold<num>(
      0,
      (sum, item) => sum + (item['price'] * item['quantity']),
    );
    final change = cash - total;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E7),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CartPage(cartItems: List<Map<String, dynamic>>.from(cartItems)),
              ),
            );
          },
        ),
        title: const Text('Receipt'),
        backgroundColor: const Color(0xFFD08742),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📄 Receipt Container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          'Tre Maree Café',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Official Receipt',
                          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          DateFormat('MMM dd, yyyy – hh:mm a').format(DateTime.now()),
                          style: const TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(thickness: 1.5),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  '${item['name']} ${item['size'] ?? ''}'.trim(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  '${item['quantity']} x ${currency.format(item['price'])}',
                                  style: const TextStyle(fontSize: 16),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  currency.format(item['price'] * item['quantity']),
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(thickness: 1.5),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Total: ${currency.format(total)}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                        Text(
                          'Cash: ${currency.format(cash)}',
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.right,
                        ),
                        Text(
                          'Change: ${currency.format(change)}',
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Column(
                      children: const [
                        Text(
                          'Thank you for your purchase!',
                          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                        ),
                        Text(
                          'Come Again!',
                          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // 🖨 Print Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Receipt is printing...')),
                  );
                  await Future.delayed(const Duration(seconds: 2));
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const ProductMenuPage()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[700],
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Print Receipt',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

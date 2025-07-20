import 'package:flutter/material.dart';
import 'invoicepage.dart'; // Ensure this file is created

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  const CartPage({super.key, required this.cartItems});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  num get total {
    num totalSum = 0;
    for (var item in widget.cartItems) {
      totalSum += (item['price'] as num) * (item['quantity'] as num);
    }
    return totalSum;
  }

  void _increaseQuantity(int index) {
    setState(() {
      widget.cartItems[index]['quantity'] += 1;
    });
  }

  void _decreaseQuantity(int index) {
    setState(() {
      if (widget.cartItems[index]['quantity'] > 1) {
        widget.cartItems[index]['quantity'] -= 1;
      } else {
        widget.cartItems.removeAt(index);
      }
    });
  }

  void _checkout() async {
    final cashInput = await showDialog<num>(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Enter Cash Amount'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Cash'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final cash = num.tryParse(controller.text);
                if (cash != null && cash >= total) {
                  Navigator.pop(context, cash);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Insufficient cash.')),
                  );
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    if (cashInput != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InvoicePage(cartItems: widget.cartItems, cash: cashInput),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD08742),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD08742),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'POS System',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Cart',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: widget.cartItems.length,
                itemBuilder: (context, index) {
                  final item = widget.cartItems[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Product name
                          Expanded(
                            flex: 4,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.brown),
                                borderRadius: BorderRadius.circular(8),
                                color: const Color(0xFFFFF8E7),
                              ),
                              child: Text(
                                '${item['name']} ${item['size'] ?? ''}'.trim(),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                                overflow: TextOverflow.clip,
                                softWrap: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Quantity controls
                          Flexible(
                            flex: 3,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.brown),
                                borderRadius: BorderRadius.circular(8),
                                color: const Color(0xFFFFF8E7),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: IconButton(
                                      icon: const Icon(Icons.remove),
                                      iconSize: 20,
                                      onPressed: () => _decreaseQuantity(index),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        '${item['quantity']}',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: IconButton(
                                      icon: const Icon(Icons.add),
                                      iconSize: 20,
                                      onPressed: () => _increaseQuantity(index),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Price
                          Flexible(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.brown),
                                borderRadius: BorderRadius.circular(8),
                                color: const Color(0xFFFFF8E7),
                              ),
                              child: FittedBox(
                                child: Text(
                                  '₱ ${(item['price'] * item['quantity']).toStringAsFixed(0)}',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const Divider(thickness: 1),

            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    '₱ ${total.toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _checkout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Checkout', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

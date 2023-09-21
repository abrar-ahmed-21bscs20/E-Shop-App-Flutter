import '/screens/order/order_info_screen.dart';
import '/providers/product_provider.dart';
import '/widgets/cart/cart_items.dart';
import '/providers/cart_item_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartItemProvider>(context);
    final cartValues = cart.cartItems.values.toList();
    return cart.itemsCount <= 0
        ? const Center(
            child: Text('Cart is Empty!'),
          )
        : FutureBuilder(
            future: cart.fetchCartItems(),
            builder: (ctx, futureSnapshot) {
              if (futureSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Column(
                children: [
                  Card(
                    margin: const EdgeInsets.all(10),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Total Bill',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                              const Spacer(),
                              Chip(
                                label: Text(
                                  '\$${cart.total.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: Colors.grey[800],
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pushNamed(
                              OrderInfoScreen.routeName,
                              arguments: {
                                'total': cart.total,
                                'cartItem': cartValues,
                              },
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[800],
                            ),
                            child: const Text(
                              'Place Order',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Consumer<ProductProvider>(
                      builder: (context, product, child) => ListView.builder(
                        itemCount: cart.itemsCount,
                        itemBuilder: (ctx, index) {
                          final productId = cart.cartItems.keys.toList()[index];
                          final stock = product.findById(productId).stock;
                          return CartItems(
                            id: cartValues[index].id,
                            productId: productId,
                            title: cartValues[index].title,
                            price: cartValues[index].price,
                            image: cartValues[index].image,
                            stock: stock,
                            quantity: cartValues[index].quantity,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            });
  }
}
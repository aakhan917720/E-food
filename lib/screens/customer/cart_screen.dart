import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/customer/cart_item.dart';
import '../../providers/customer/cart_provider.dart';
import '../../providers/customer/user_provider.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final userProfile = ref.read(userProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Your Cart',
          style: TextStyle(
            color: Color(0xFF222222),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: const Color(0xFF222222),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: cartItems.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Add some delicious items! 🍕',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = cartItems[index];
                return _CartItemCard(
                  cartItem: cartItem,
                  onIncrement: () {
                    cartNotifier.addToCart(cartItem.foodItem);
                  },
                  onDecrement: () {
                    cartNotifier.decrementQuantity(cartItem.foodItem.id);
                  },
                  onRemove: () {
                    cartNotifier.removeFromCart(cartItem.foodItem.id);
                  },
                );
              },
            ),
          ),
          _buildCheckoutBottomSheet(context, cartNotifier.grandTotal),
        ],
      ),
    );
  }

  Widget _buildCheckoutBottomSheet(BuildContext context, double total) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Grand Total',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF222222),
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: total > 0 ? () => _processCheckout(context) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE21B70),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Pay via Stripe',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _processCheckout(BuildContext context) {
    // ✅ Check if mounted before showing dialog
    if (!mounted) return;

    // STRIPE INTENT ENGINE BLUEPRINT:
    // 1. Create Stripe PaymentIntent
    // final stripeService = StripeService();
    // final paymentIntent = await stripeService.createPaymentIntent(
    //   amount: (total * 100).toInt(),
    //   currency: 'usd',
    // );
    //
    // 2. Present Stripe Payment Sheet
    // await stripeService.presentPaymentSheet(paymentIntent);
    //
    // FIREBASE TRANSACTIONAL PAYLOAD UPLOAD BLUEPRINT:
    // 3. On successful payment, create order in Firestore
    // final orderData = {
    //   'userId': userProfile.id,
    //   'items': cartItems.map((item) => item.toMap()).toList(),
    //   'total': total,
    //   'status': 'pending',
    //   'createdAt': FieldValue.serverTimestamp(),
    //   'paymentStatus': 'completed',
    // };
    // await FirebaseFirestore.instance
    //     .collection('orders')
    //     .add(orderData);
    //
    // 4. Clear cart and navigate to tracking
    // ref.read(cartProvider.notifier).clearCart();
    // Navigator.push(context, MaterialPageRoute(builder: (_) => OrderTrackingScreen()));

    // Show payment simulation
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Processing Payment'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Please wait...'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              // ✅ Check if mounted before navigation
              if (!mounted) return;

              Navigator.pop(dialogContext);

              // ✅ Check again before clearing cart
              if (!mounted) return;
              ref.read(cartProvider.notifier).clearCart();

              // ✅ Check again before popping
              if (!mounted) return;
              Navigator.pop(context);

              // ✅ Show success snackbar
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Order placed successfully! 🎉'),
                  backgroundColor: Color(0xFF2ECC71),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItem cartItem;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const _CartItemCard({
    required this.cartItem,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFE21B70).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.restaurant,
              size: 30,
              color: const Color(0xFFE21B70).withOpacity(0.5),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.foodItem.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF222222),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${cartItem.totalItemPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFE21B70),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              // ✅ Decrease Button
              GestureDetector(
                onTap: onDecrement,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: cartItem.quantity > 1
                      ? const Color(0xFFE21B70)
                      : Colors.grey[300],
                  child: Icon(
                    Icons.remove,
                    size: 18,
                    color: cartItem.quantity > 1
                        ? Colors.white
                        : Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                cartItem.quantity.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF222222),
                ),
              ),
              const SizedBox(width: 8),
              // ✅ Increase Button
              GestureDetector(
                onTap: onIncrement,
                child: const CircleAvatar(
                  radius: 16,
                  backgroundColor: Color(0xFFE21B70),
                  child: Icon(
                    Icons.add,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // ✅ Delete Button
              GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    size: 20,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
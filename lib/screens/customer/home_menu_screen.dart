import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/food_item.dart';
import '../../providers/customer/user_provider.dart';
import '../../providers/customer/cart_provider.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';
import 'order_tracking_screen.dart';
import 'food_detail_screen.dart';

class HomeMenuScreen extends ConsumerStatefulWidget {
  const HomeMenuScreen({super.key});

  @override
  ConsumerState<HomeMenuScreen> createState() => _HomeMenuScreenState();
}

class _HomeMenuScreenState extends ConsumerState<HomeMenuScreen> {
  final List<FoodItem> _mockMenuItems = [
    const FoodItem(
      id: '1',
      name: 'Margherita Pizza',
      price: 14.99,
      category: 'Pizza',
      imageUrl: '',
      variations: ['Extra Cheese', 'Thin Crust', 'Gluten Free'],
    ),
    const FoodItem(
      id: '2',
      name: 'Classic Burger',
      price: 11.99,
      category: 'Burgers',
      imageUrl: '',
      variations: ['Double Patty', 'Bacon', 'Veggie Option'],
    ),
    const FoodItem(
      id: '3',
      name: 'California Sushi Roll',
      price: 16.99,
      category: 'Sushi',
      imageUrl: '',
    ),
    const FoodItem(
      id: '4',
      name: 'Pasta Carbonara',
      price: 13.99,
      category: 'Pasta',
      imageUrl: '',
      variations: ['Gluten Free Pasta', 'Extra Parmesan'],
    ),
    const FoodItem(
      id: '5',
      name: 'Chicken Tikka Masala',
      price: 15.99,
      category: 'Indian',
      imageUrl: '',
    ),
    const FoodItem(
      id: '6',
      name: 'Greek Salad',
      price: 9.99,
      category: 'Salads',
      imageUrl: '',
      variations: ['Add Chicken', 'Add Salmon'],
    ),
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProvider);
    final cartItems = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Hello, ${userProfile.name}! 🍕',
          style: const TextStyle(
            color: Color(0xFF222222),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                color: const Color(0xFF222222),
                onPressed: () {
                  if (!mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
              ),
              if (cartItems.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE21B70),
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      cartItems.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildMenuGrid(context, cartNotifier),
          const OrderTrackingScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (!mounted) return;
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: const Color(0xFFE21B70),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context, CartNotifier cartNotifier) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // ✅ TOP CARDS
          _buildTopCards(),
          const SizedBox(height: 8),

          // Menu Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.7,
            ),
            itemCount: _mockMenuItems.length,
            itemBuilder: (context, index) {
              final item = _mockMenuItems[index];
              return _MenuItemCard(
                item: item,
                onAddToCart: () {
                  if (!mounted) return;
                  cartNotifier.addToCart(item);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${item.name} added to cart'),
                      backgroundColor: const Color(0xFF2ECC71),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // ✅ TOP CARDS
  Widget _buildTopCards() {
    final List<Map<String, dynamic>> cards = [
      {'icon': Icons.fastfood, 'title': 'Food', 'color': const Color(0xFFE21B70)},
      {'icon': Icons.restaurant, 'title': 'Dine', 'color': const Color(0xFFF39C12)},
      {'icon': Icons.shopping_bag, 'title': 'Grocery', 'color': const Color(0xFF2ECC71)},
      {'icon': Icons.local_pizza, 'title': 'Pizza', 'color': const Color(0xFFE74C3C)},
      {'icon': Icons.emoji_food_beverage, 'title': 'Coffee', 'color': const Color(0xFF3498DB)},
      {'icon': Icons.health_and_safety, 'title': 'Healthy', 'color': const Color(0xFF2ECC71)},
    ];

    return SizedBox(
      height: 125,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final card = cards[index];
          return Container(
            width: 110,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: card['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    card['icon'],
                    color: card['color'],
                    size: 32,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  card['title'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF222222),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ✅ Fixed _MenuItemCard
class _MenuItemCard extends StatelessWidget {
  final FoodItem item;
  final VoidCallback onAddToCart;

  const _MenuItemCard({
    required this.item,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FoodDetailScreen(foodItem: item),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ✅ Image replaced with icon (no asset loading)
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFE21B70).withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Center(
                child: Icon(
                  Icons.restaurant,
                  size: 40,
                  color: const Color(0xFFE21B70).withOpacity(0.3),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF222222),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFE21B70),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        onAddToCart();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE21B70),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                        minimumSize: const Size(double.infinity, 28),
                      ),
                      child: const Text(
                        'Add to Cart',
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
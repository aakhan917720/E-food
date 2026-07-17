import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/customer/user_provider.dart';
import '../../providers/customer/cart_provider.dart';
import 'tabs/live_orders_tab.dart';
import 'tabs/manage_menu_tab.dart';

class RestaurantDashboard extends ConsumerStatefulWidget {
  const RestaurantDashboard({super.key});

  @override
  ConsumerState<RestaurantDashboard> createState() => _RestaurantDashboardState();
}

class _RestaurantDashboardState extends ConsumerState<RestaurantDashboard> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'E-Foodie Restaurant 👨‍🍳',
            style: TextStyle(
              color: Color(0xFF222222),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              color: Colors.red,
              onPressed: () => _handleLogout(context, ref),
            ),
          ],
          bottom: TabBar(
            indicatorColor: const Color(0xFFE21B70),
            labelColor: const Color(0xFFE21B70),
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(
                icon: Icon(Icons.list_alt),
                text: 'Live Orders',
              ),
              Tab(
                icon: Icon(Icons.restaurant_menu),
                text: 'Manage Menu',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            LiveOrdersTab(),
            ManageMenuTab(),
          ],
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context, WidgetRef ref) {
    ref.read(userProvider.notifier).resetUser();
    ref.read(cartProvider.notifier).clearCart();
    Navigator.pushReplacementNamed(context, '/login');
  }
}
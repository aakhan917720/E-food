import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/customer/user_provider.dart';
import '../../providers/customer/cart_provider.dart';
import '../../providers/admin/admin_dashboard_provider.dart';
import 'tabs/analytics_overview_tab.dart';
import 'tabs/manage_restaurants_tab.dart';
import 'tabs/active_orders_tab.dart';

class AdminDashboardWrapper extends ConsumerStatefulWidget {
  const AdminDashboardWrapper({super.key});

  @override
  ConsumerState<AdminDashboardWrapper> createState() => _AdminDashboardWrapperState();
}

class _AdminDashboardWrapperState extends ConsumerState<AdminDashboardWrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminDashboardProvider.notifier).initializeMockData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'E-Foodie Super Admin 👑',
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
                icon: Icon(Icons.analytics),
                text: 'Overview',
              ),
              Tab(
                icon: Icon(Icons.business),
                text: 'Partners',
              ),
              Tab(
                icon: Icon(Icons.local_shipping),
                text: 'Live Orders',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AnalyticsOverviewTab(),
            ManageRestaurantsTab(),
            ActiveOrdersTab(),
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
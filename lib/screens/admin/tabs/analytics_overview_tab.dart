import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/admin/admin_dashboard_provider.dart';
import '../widgets/stats_card_widget.dart';

class AnalyticsOverviewTab extends ConsumerWidget {
  const AnalyticsOverviewTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminDashboardProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              StatsCardWidget(
                label: 'Total Sales',
                value: '\$${state.totalSales.toStringAsFixed(2)}',
                color: const Color(0xFFE21B70),
                icon: Icons.monetization_on,
              ),
              StatsCardWidget(
                label: 'Platform Commission',
                // ✅ FIXED: Changed Icons.commission to Icons.percentage
                value: '\$${(state.totalSales * 0.15).toStringAsFixed(2)}',
                color: const Color(0xFFF39C12),
                icon: Icons.percent,
              ),
              StatsCardWidget(
                label: 'Active Orders',
                value: state.activeOrders.toString(),
                color: const Color(0xFF2ECC71),
                icon: Icons.local_shipping,
              ),
              StatsCardWidget(
                label: 'Registered Partners',
                value: state.totalPartners.toString(),
                color: const Color(0xFF3498DB),
                icon: Icons.business_center,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
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
              children: [
                const Text(
                  'Recent Activity',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF222222),
                  ),
                ),
                const SizedBox(height: 12),
                ...state.orders.take(3).map((order) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _getStatusColor(order.orderStatus),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Order #${order.orderId} - ${order.customerName}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF222222),
                          ),
                        ),
                      ),
                      Text(
                        order.orderStatus,
                        style: TextStyle(
                          fontSize: 12,
                          color: _getStatusColor(order.orderStatus),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return const Color(0xFFF39C12);
      case 'preparing':
        return const Color(0xFFE21B70);
      case 'en_route':
        return const Color(0xFF3498DB);
      case 'completed':
        return const Color(0xFF2ECC71);
      default:
        return Colors.grey;
    }
  }
}
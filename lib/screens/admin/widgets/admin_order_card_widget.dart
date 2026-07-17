import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/admin/admin_order_model.dart';
import '../../../providers/admin/admin_dashboard_provider.dart';

class AdminOrderCardWidget extends ConsumerWidget {
  final AdminOrderModel order;

  const AdminOrderCardWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adminNotifier = ref.read(adminDashboardProvider.notifier);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #${order.orderId}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF222222),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(order.orderStatus).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  order.orderStatus.toUpperCase(),
                  style: TextStyle(
                    color: _getStatusColor(order.orderStatus),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Customer Details:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF222222),
            ),
          ),
          const SizedBox(height: 4),
          Text('Name: ${order.customerName}'),
          Text('Phone: ${order.customerPhone}'),
          const SizedBox(height: 8),
          const Text(
            'Restaurant Details:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF222222),
            ),
          ),
          const SizedBox(height: 4),
          Text('Name: ${order.restaurantName}'),
          Text('Phone: ${order.restaurantPhone}'),
          const SizedBox(height: 8),
          const Text(
            'Rider Details:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF222222),
            ),
          ),
          const SizedBox(height: 4),
          Text('Name: ${order.riderName}'),
          Text('Phone: ${order.riderPhone}'),
          const SizedBox(height: 8),
          Text(
            'Total: \$${order.totalBill.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE21B70),
            ),
          ),
          const SizedBox(height: 16),
          // ECOSYSTEM CONTACT SYSTEM WIDGET ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildContactButton(
                icon: Icons.phone,
                label: 'Customer',
                color: const Color(0xFFE21B70),
                onPressed: () {
                  // url_launcher IMPLEMENTATION BLUEPRINT:
                  // final url = 'tel:${order.customerPhone}';
                  // if (await canLaunch(url)) {
                  //   await launch(url);
                  // }
                  adminNotifier.initiateCall(order.customerPhone);
                },
              ),
              _buildContactButton(
                icon: Icons.message,
                label: 'Restaurant',
                color: const Color(0xFFF39C12),
                onPressed: () {
                  adminNotifier.openAdminChat(order.restaurantName);
                },
              ),
              _buildContactButton(
                icon: Icons.phone,
                label: 'Rider',
                color: const Color(0xFF3498DB),
                onPressed: () {
                  adminNotifier.initiateCall(order.riderPhone);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          // OVERRIDE CONTROL LAYER
          if (order.orderStatus != 'completed')
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Force Complete Order'),
                      content: const Text(
                        'This will mark the order as completed. Are you sure?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            adminNotifier.forceCompleteOrder(order.orderId);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Order marked as completed!'),
                                backgroundColor: Color(0xFF2ECC71),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFFE21B70),
                          ),
                          child: const Text('Complete'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE21B70),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Mark as Delivered',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
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

  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/admin/admin_dashboard_provider.dart';

class ManageRestaurantsTab extends ConsumerWidget {
  const ManageRestaurantsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restaurants = ref.watch(adminDashboardProvider).restaurants;
    final adminNotifier = ref.read(adminDashboardProvider.notifier);

    return restaurants.isEmpty
        ? const Center(
      child: Text(
        'No restaurants registered',
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
    )
        : ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        final restaurant = restaurants[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      restaurant.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF222222),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: restaurant.isApproved
                          ? const Color(0xFF2ECC71).withOpacity(0.1)
                          : const Color(0xFFE74C3C).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      restaurant.isApproved ? 'Active' : 'Blocked',
                      style: TextStyle(
                        color: restaurant.isApproved
                            ? const Color(0xFF2ECC71)
                            : const Color(0xFFE74C3C),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                restaurant.email,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                restaurant.phone,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Switch(
                    value: restaurant.isApproved,
                    onChanged: (_) {
                      adminNotifier.toggleRestaurantApproval(restaurant.id);
                    },
                    activeColor: const Color(0xFF2ECC71),
                    inactiveThumbColor: const Color(0xFFE74C3C),
                    inactiveTrackColor: const Color(0xFFE74C3C).withOpacity(0.3),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    restaurant.isApproved ? 'Approved' : 'Block',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: restaurant.isApproved
                          ? const Color(0xFF2ECC71)
                          : const Color(0xFFE74C3C),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
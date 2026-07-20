import 'package:e_foodie/screens/customer/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'screens/customer/onboarding_screen.dart';
import 'screens/customer/login_screen.dart';
import 'screens/customer/home_menu_screen.dart';
import 'screens/restaurant/restaurant_dashboard.dart';
import 'screens/rider/rider_dashboard.dart';
import 'screens/admin/admin_dashboard_wrapper.dart';

void main() {


  Stripe.publishableKey = "pk_test_51Tm9iI46kaApcreV8gZkQazQJBK7abdRh2I4uRsDPh5BUIl5sjJZ7zK5hqiMxZisD7GBhm5Ss4yVxifqx12wyMoD000iJFfcQR";
  Stripe.instance.applySettings();

  runApp(const ProviderScope(child: EFoodieApp()));

}

class EFoodieApp extends StatelessWidget {
  const EFoodieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Foodie',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SF Pro Display',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE21B70),
          primary: const Color(0xFFE21B70),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF222222)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),  // ✅ ADD THIS
        '/customer/home': (context) => const HomeMenuScreen(),
        '/restaurant/dashboard': (context) => const RestaurantDashboard(),
        '/rider/dashboard': (context) => const RiderDashboard(),
        '/admin/dashboard': (context) => const AdminDashboardWrapper(),
      },
    );
  }
}
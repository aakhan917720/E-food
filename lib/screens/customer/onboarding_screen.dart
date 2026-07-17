import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPanel> _panels = const [
    OnboardingPanel(
      title: 'Premium Culinary Selection',
      description: 'Access a curated network of top-rated restaurants with authentic cuisine and premium ingredients.',
      imageAsset: 'assets/images/culinary_selection.png',
      backgroundColor: Color(0xFFFFF0F5),
    ),
    OnboardingPanel(
      title: 'Live Kitchen Engineering',
      description: 'Real-time preparation tracking with hygiene certifications and transparent cooking processes.',
      imageAsset: 'assets/images/kitchen_engineering.png',
      backgroundColor: Color(0xFFF0FFF4),
    ),
    OnboardingPanel(
      title: 'Accelerated Courier Networks',
      description: 'Live GPS tracking of your rider with accurate ETA and route optimization technology.',
      imageAsset: 'assets/images/courier_network.png',
      backgroundColor: Color(0xFFF0F8FF),
    ),
    OnboardingPanel(
      title: 'Super Admin Direct Oversight',
      description: 'Full ecosystem visibility with real-time monitoring and safety deployment protocols.',
      imageAsset: 'assets/images/admin_oversight.png',
      backgroundColor: Color(0xFFFFF5F0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _panels.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                return _buildPanel(_panels[index]);
              },
            ),
          ),
          _buildBottomControls(context),
        ],
      ),
    );
  }

  Widget _buildPanel(OnboardingPanel panel) {
    return Container(
      color: panel.backgroundColor,
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              _getIconForPanel(panel.title),
              size: 120,
              color: const Color(0xFFE21B70),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            panel.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF222222),
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            panel.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData _getIconForPanel(String title) {
    if (title.contains('Premium Culinary')) return Icons.restaurant_menu;
    if (title.contains('Live Kitchen')) return Icons.kitchen;
    if (title.contains('Accelerated Courier')) return Icons.delivery_dining;
    return Icons.admin_panel_settings;
  }

  Widget _buildBottomControls(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: List.generate(
              _panels.length,
                  (index) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index
                      ? const Color(0xFFE21B70)
                      : Colors.grey[300],
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_currentPage == _panels.length - 1) {
                // Clear slider stack and load authentication
                Navigator.pushReplacementNamed(context, '/login');
              } else {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE21B70),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
            child: Text(
              _currentPage == _panels.length - 1 ? 'Get Started' : 'Next',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPanel {
  final String title;
  final String description;
  final String imageAsset;
  final Color backgroundColor;

  const OnboardingPanel({
    required this.title,
    required this.description,
    required this.imageAsset,
    required this.backgroundColor,
  });
}
import 'package:flutter/material.dart';
import '../widgets/service_card.dart';
import '../models/service.dart';
import 'login_screen.dart';
import 'dart:async';
import '../widgets/base_layout.dart';
import '../services/auth_service.dart';
import 'special_offer_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool showBottomNav;
  
  const HomeScreen({super.key, this.showBottomNav = true});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> bannerImages = const [
    'assets/images/banner1.png',
    'assets/images/banner2.png',
    'assets/images/banner3.png',
  ];

  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Auto slide setup
    Future.delayed(const Duration(seconds: 1), () {
      autoSlide();
    });
  }

  void autoSlide() {
    Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < bannerImages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;  // Get current user

    return BaseLayout(
      showAppBar: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user != null ? 'Welcome back!' : 'Welcome!',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'What service do you need?',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      if (user == null) // Only show login button if user is not logged in
                        TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                            );
                          },
                          icon: const Icon(Icons.person_outline),
                          label: const Text('Login'),
                        ),
                    ],
                  ),
                ),

                // Image Slider
                Column(
                  children: [
                    SizedBox(
                      height: 180,
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemCount: bannerImages.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: AssetImage(bannerImages[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Add page indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        bannerImages.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          height: 8,
                          width: _currentPage == index ? 20 : 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index 
                                ? Theme.of(context).primaryColor 
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search services',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Services Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Services',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Horizontal Services Slider
                SizedBox(
                  height: 180,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildServiceCard(context, 'House Cleaning', Icons.cleaning_services, const Color(0xFFE8E1FF)),
                      _buildServiceCard(context, 'Car Mechanic', Icons.car_repair, const Color(0xFFFFE8E1)),
                      _buildServiceCard(context, 'Item Pickup', Icons.local_shipping, const Color(0xFFE1FFE8)),
                      _buildServiceCard(context, 'Sanitization', Icons.sanitizer, const Color(0xFFE1F5FF)),
                      _buildServiceCard(context, 'Office Cleaning', Icons.business, const Color(0xFFFFE1E8)),
                      _buildServiceCard(context, 'AC Repair', Icons.ac_unit, const Color(0xFFE8FFE1)),
                      _buildServiceCard(context, 'Mobile Repair', Icons.phone_android, const Color(0xFFFFF0E1)),
                      _buildServiceCard(context, 'Sofa Repair', Icons.chair, const Color(0xFFE1FFFF)),
                      _buildServiceCard(context, 'Spa & Massage', Icons.spa, const Color(0xFFFFE1F5)),
                      _buildServiceCard(context, 'Translator', Icons.translate, const Color(0xFFE1E8FF)),
                      _buildServiceCard(context, 'PC Repair', Icons.computer, const Color(0xFFF5E1FF)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Suggestions Section
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Suggestions for You',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      _buildSuggestionCard(
                        context,
                        'Special Offer',
                        '20% off on first house cleaning',
                        Icons.local_offer,
                      ),
                      _buildSuggestionCard(
                        context,
                        'Package Deal',
                        'Book any 3 services and get 15% off',
                        Icons.card_giftcard,
                      ),
                      _buildSuggestionCard(
                        context,
                        'New Service',
                        'Try our premium car detailing service',
                        Icons.new_releases,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    String title,
    IconData icon,
    Color backgroundColor,
  ) {
    return Container(
      width: 140,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Card(
        color: backgroundColor,
        child: InkWell(
          onTap: () {
            // Navigate to service details
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(title),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SpecialOfferScreen(
                title: title,
                description: description,
              ),
            ),
          );
        },
      ),
    );
  }
} 
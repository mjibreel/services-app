import 'package:flutter/material.dart';
import '../widgets/base_layout.dart';
import '../utils/currency_formatter.dart';
import '../screens/booking_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../models/service.dart';
import '../screens/login_screen.dart';

class ServiceDetailScreen extends StatelessWidget {
  final String serviceName;
  final String description;
  final List<String> features;
  final double basePrice;
  final Color backgroundColor;
  final IconData icon;
  final List<String> imageUrls;
  final String serviceId;
  final List<String> availableCities;

  const ServiceDetailScreen({
    super.key,
    required this.serviceName,
    required this.description,
    required this.features,
    required this.basePrice,
    required this.backgroundColor,
    required this.icon,
    this.imageUrls = const [],
    required this.serviceId,
    required this.availableCities,
  });

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      title: serviceName,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Carousel
            SizedBox(
              height: 200,
              child: imageUrls.isEmpty
                  ? Container(
                      width: double.infinity,
                      color: backgroundColor,
                      child: Icon(
                        icon,
                        size: 80,
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : PageView.builder(
                      itemCount: imageUrls.length,
                      itemBuilder: (context, index) {
                        return Image.network(
                          imageUrls[index],
                          fit: BoxFit.cover,
                        );
                      },
                    ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price with larger font
                  Text(
                    formatPrice(basePrice),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'About this service',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(description),
                  const SizedBox(height: 24),

                  Text(
                    'What\'s included',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  ...features.map((feature) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green),
                        const SizedBox(width: 8),
                        Expanded(child: Text(feature)),
                      ],
                    ),
                  )),

                  const SizedBox(height: 24),

                  // Book Now Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _handleBooking(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Book Now'),
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

  void _handleBooking(BuildContext context) {
    final user = AuthService().currentUser;
    
    if (user == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Required'),
          content: const Text('Please login to book this service'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: const Text('Login'),
            ),
          ],
        ),
      );
      return;
    }

    // Navigate to booking screen with service details
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingScreen(
          service: Service(
            id: serviceId,
            name: serviceName,
            description: description,
            features: features,
            basePrice: basePrice,
            icon: icon,
            backgroundColor: backgroundColor,
            availableCities: availableCities,
            imageUrls: imageUrls,
          ),
        ),
      ),
    );
  }
} 
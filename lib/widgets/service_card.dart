import 'package:flutter/material.dart';
import '../models/service.dart';
import '../screens/booking_screen.dart';
import '../screens/login_screen.dart';
import '../screens/service_detail_screen.dart';
import '../utils/currency_formatter.dart';
import '../services/auth_service.dart';

class ServiceCard extends StatelessWidget {
  final Service service;
  final bool isBookingAction;

  const ServiceCard({
    super.key, 
    required this.service, 
    this.isBookingAction = false
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => _handleServiceTap(context),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getIconForService(service.name),
                  color: Theme.of(context).primaryColor,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                service.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                service.description,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatPrice(service.basePrice),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _handleServiceTap(context),
                    child: const Text('Book Now'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleServiceTap(BuildContext context) {
    final user = AuthService().currentUser;
    
    if (user == null && isBookingAction) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Required'),
          content: const Text('Please login or register to book this service.'),
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

    // Continue with booking or showing details
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => isBookingAction 
            ? BookingScreen(service: service)
            : ServiceDetailScreen(
                serviceName: service.name,
                description: service.description,
                features: service.features,
                basePrice: service.basePrice,
                backgroundColor: service.backgroundColor,
                icon: service.icon,
                serviceId: service.id,
                availableCities: service.availableCities,
              ),
      ),
    );
  }

  IconData _getIconForService(String serviceName) {
    switch (serviceName) {
      case 'House Cleaning':
        return Icons.cleaning_services;
      case 'Car Mechanic':
        return Icons.car_repair;
      case 'Item Pickup':
        return Icons.local_shipping;
      default:
        return Icons.miscellaneous_services;
    }
  }
} 
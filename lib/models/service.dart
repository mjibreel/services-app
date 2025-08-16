import 'package:flutter/material.dart';

class Service {
  final String id;
  final String name;
  final String description;
  final List<String> features;
  final double basePrice;
  final IconData icon;
  final Color backgroundColor;
  final List<String> availableCities;
  final List<String> imageUrls;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.features,
    required this.basePrice,
    required this.icon,
    required this.backgroundColor,
    required this.availableCities,
    required this.imageUrls,
  });

  // Add to Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'features': features,
      'basePrice': basePrice,
      'availableCities': availableCities,
      'imageUrls': imageUrls,
    };
  }

  // From Firestore
  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      features: List<String>.from(map['features']),
      basePrice: map['basePrice'].toDouble(),
      icon: Icons.cleaning_services, // You'll need to handle icons separately
      backgroundColor: Colors.blue.shade50, // Handle colors separately
      availableCities: List<String>.from(map['availableCities']),
      imageUrls: List<String>.from(map['imageUrls']),
    );
  }
} 
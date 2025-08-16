import 'package:flutter/material.dart';
import '../widgets/base_layout.dart';
import '../screens/service_detail_screen.dart';
import '../models/service.dart';
import '../utils/currency_formatter.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  String _selectedCategory = 'All Services';
  String _selectedCity = 'All Cities';
  final _searchController = TextEditingController();

  final List<String> _categories = [
    'All Services',
    'Home Services',
    'Cleaning',
    'Repairs',
    'Transport',
    'Professional',
  ];

  final List<String> _cities = [
    'All Cities',
    'Kuala Lumpur',
    'Petaling Jaya',
    'Shah Alam',
    'Subang Jaya',
    'Klang',
    'Cyberjaya',
  ];

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      title: 'Services',
      child: Column(
        children: [
          // Search and Filter Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search services',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    // Implement search functionality
                  },
                ),
                const SizedBox(height: 16),

                // Categories
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((category) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(category),
                        selected: _selectedCategory == category,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                      ),
                    )).toList(),
                  ),
                ),

                const SizedBox(height: 16),

                // City Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedCity,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.location_city),
                  ),
                  items: _cities
                      .map((city) => DropdownMenuItem(
                            value: city,
                            child: Text(city),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCity = value!;
                    });
                  },
                ),
              ],
            ),
          ),

          // Services Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                return _buildServiceCard(context, service);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, Service service) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ServiceDetailScreen(
                serviceName: service.name,
                description: service.description,
                features: service.features,
                basePrice: service.basePrice,
                backgroundColor: service.backgroundColor,
                icon: service.icon,
                imageUrls: service.imageUrls,
                serviceId: service.id,
                availableCities: service.availableCities,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Image
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: service.backgroundColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: Center(
                  child: Icon(
                    service.icon,
                    size: 48,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            // Service Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatPrice(service.basePrice),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
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

  static final List<Service> services = [
    Service(
      id: '1',
      name: 'House Cleaning',
      description: 'Professional house cleaning service',
      features: ['Deep cleaning', 'Eco-friendly products'],
      basePrice: 80.00, // RM 80
      icon: Icons.cleaning_services,
      backgroundColor: const Color(0xFFE8E1FF),
      availableCities: ['Kuala Lumpur', 'Petaling Jaya', 'Shah Alam', 'Cyberjaya'],
      imageUrls: [],
    ),
    Service(
      id: '2',
      name: 'Car Mechanic',
      description: 'Expert car repair and maintenance',
      features: ['Diagnostics', 'Repairs', 'Maintenance'],
      basePrice: 120.00, // RM 120
      icon: Icons.car_repair,
      backgroundColor: const Color(0xFFFFE8E1),
      availableCities: ['Kuala Lumpur', 'Petaling Jaya', 'Shah Alam'],
      imageUrls: [],
    ),
    Service(
      id: '3',
      name: 'Item Pickup',
      description: 'Reliable delivery service',
      features: ['Same day delivery', 'Safe handling'],
      basePrice: 30.00, // RM 30
      icon: Icons.local_shipping,
      backgroundColor: const Color(0xFFE1FFE8),
      availableCities: ['Kuala Lumpur', 'Petaling Jaya', 'Shah Alam'],
      imageUrls: [],
    ),
    Service(
      id: '4',
      name: 'Sanitization',
      description: 'Professional sanitization and disinfection service',
      features: ['Full space sanitization', 'EPA approved products', 'Covid-19 protection'],
      basePrice: 150.00,
      icon: Icons.sanitizer,
      backgroundColor: const Color(0xFFE1F5FF),
      availableCities: ['Kuala Lumpur', 'Petaling Jaya', 'Shah Alam'],
      imageUrls: [],
    ),
    Service(
      id: '5',
      name: 'Office Cleaning',
      description: 'Complete office cleaning and maintenance service',
      features: ['Daily/Weekly service', 'Floor cleaning', 'Waste management'],
      basePrice: 200.00,
      icon: Icons.business,
      backgroundColor: const Color(0xFFFFE1E8),
      availableCities: ['Kuala Lumpur', 'Petaling Jaya', 'Shah Alam'],
      imageUrls: [],
    ),
    Service(
      id: '6',
      name: 'AC Repair',
      description: 'Professional air conditioning repair and maintenance',
      features: ['Diagnostics', 'Repair', 'Regular maintenance'],
      basePrice: 100.00,
      icon: Icons.ac_unit,
      backgroundColor: const Color(0xFFE8FFE1),
      availableCities: ['Kuala Lumpur', 'Petaling Jaya', 'Shah Alam'],
      imageUrls: [],
    ),
    Service(
      id: '7',
      name: 'Mobile Repair',
      description: 'Expert smartphone and tablet repair service',
      features: ['Screen replacement', 'Battery replacement', 'Software issues'],
      basePrice: 50.00,
      icon: Icons.phone_android,
      backgroundColor: const Color(0xFFFFF0E1),
      availableCities: ['Kuala Lumpur', 'Petaling Jaya', 'Shah Alam'],
      imageUrls: [],
    ),
    Service(
      id: '8',
      name: 'Sofa Repair',
      description: 'Professional sofa cleaning and repair service',
      features: ['Deep cleaning', 'Repair', 'Reupholstery'],
      basePrice: 180.00,
      icon: Icons.chair,
      backgroundColor: const Color(0xFFE1FFFF),
      availableCities: ['Kuala Lumpur', 'Petaling Jaya', 'Shah Alam'],
      imageUrls: [],
    ),
    Service(
      id: '9',
      name: 'Spa & Massage',
      description: 'Professional massage and spa treatments',
      features: ['Full body massage', 'Aromatherapy', 'Reflexology'],
      basePrice: 120.00,
      icon: Icons.spa,
      backgroundColor: const Color(0xFFFFE1F5),
      availableCities: ['Kuala Lumpur', 'Petaling Jaya', 'Shah Alam'],
      imageUrls: [],
    ),
    Service(
      id: '10',
      name: 'Translator',
      description: 'Professional translation and interpretation services',
      features: ['Document translation', 'Live interpretation', 'Multiple languages'],
      basePrice: 80.00,
      icon: Icons.translate,
      backgroundColor: const Color(0xFFE1E8FF),
      availableCities: ['Kuala Lumpur', 'Petaling Jaya', 'Shah Alam'],
      imageUrls: [],
    ),
    Service(
      id: '11',
      name: 'PC Repair',
      description: 'Expert computer repair and maintenance service',
      features: ['Hardware repair', 'Software issues', 'Data recovery'],
      basePrice: 90.00,
      icon: Icons.computer,
      backgroundColor: const Color(0xFFF5E1FF),
      availableCities: ['Kuala Lumpur', 'Petaling Jaya', 'Shah Alam'],
      imageUrls: [],
    ),
  ];
} 
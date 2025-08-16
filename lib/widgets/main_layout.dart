import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/services_screen.dart';
import '../screens/booking_history_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/login_screen.dart';
import '../services/auth_service.dart';

class MainLayout extends StatefulWidget {
  final int initialIndex;
  
  const MainLayout({super.key, this.initialIndex = 2});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late int _selectedIndex;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  // List of screens that don't require authentication
  final List<Widget> _publicScreens = [
    const ServicesScreen(),
    const HomeScreen(showBottomNav: false),
  ];

  // List of screens that require authentication
  final List<Widget> _authScreens = [
    const ProfileScreen(),
    const BookingHistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const ServicesScreen(),
          user != null ? const ProfileScreen() : const LoginScreen(),
          const HomeScreen(showBottomNav: false),
          user != null ? const BookingHistoryScreen() : const LoginScreen(),
          user != null ? const ProfileScreen() : const LoginScreen(),
        ],
      ),
      floatingActionButton: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).primaryColor,
        ),
        child: IconButton(
          onPressed: () {
            setState(() {
              _selectedIndex = 2;
            });
          },
          icon: const Icon(Icons.home, size: 20, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey, width: 0.2),
          ),
        ),
        child: BottomAppBar(
          height: 50,
          elevation: 0,
          shape: const CircularNotchedRectangle(),
          notchMargin: 6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.settings_suggest),
              _buildNavItem(1, Icons.person_outline),
              const SizedBox(width: 40),
              _buildNavItem(3, Icons.history),
              _buildNavItem(4, Icons.person),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon) {
    final isSelected = _selectedIndex == index;
    return IconButton(
      onPressed: () {
        // Check if the screen requires authentication
        if ((index == 1 || index == 3 || index == 4) && _authService.currentUser == null) {
          // Show login dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Login Required'),
              content: const Text('Please login to access this feature'),
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
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
          );
          return;
        }
        setState(() {
          _selectedIndex = index;
        });
      },
      icon: Icon(
        icon,
        size: 24,
        color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
      ),
    );
  }
} 

import 'package:flutter/material.dart';

// Existing screens
import 'screens/home_screen.dart';
import 'screens/hotel_search_screen.dart';
import 'screens/places_screen.dart';
import 'screens/map_screen.dart';
import 'screens/ai_itinerary_screen.dart';
import 'screens/booking_history_screen.dart';

// Dashboard screens
import 'screens/dashboard/user_dashboard_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';

void main() {
  runApp(const TravelApp());
}

class TravelApp extends StatelessWidget {
  const TravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Travel',

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF087F8C),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
      ),

      // Named routes
      routes: {
        '/admin': (context) => const AdminDashboardScreen(),
      },

      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int selectedIndex = 0;

  late final List<Widget> screens = [
    HomeScreen(
      onNavigate: navigateTo,
    ),
    const HotelSearchScreen(),
    const PlacesScreen(),
    const MapScreen(),
    const AIItineraryScreen(),
    const BookingHistoryScreen(),
    const UserDashboardScreen(),
  ];

  // Change bottom navigation screen
  void navigateTo(int index) {
    if (index < 0 || index >= screens.length) {
      return;
    }

    setState(() {
      selectedIndex = index;
    });
  }

  // Open Admin Dashboard
  void openAdminDashboard() {
    Navigator.pushNamed(context, '/admin');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: selectedIndex,
          children: screens,
        ),
      ),

      // Temporary Admin access button for testing
      floatingActionButton: FloatingActionButton.extended(
        onPressed: openAdminDashboard,
        backgroundColor: const Color(0xFF087F8C),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.admin_panel_settings),
        label: const Text(
          'Admin',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: navigateTo,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.hotel_outlined),
            selectedIcon: Icon(Icons.hotel),
            label: 'Hotels',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Places',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Map',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome),
            label: 'AI Trip',
          ),
          NavigationDestination(
            icon: Icon(Icons.book_online_outlined),
            selectedIcon: Icon(Icons.book_online),
            label: 'Bookings',
          ),
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
        ],
      ),
    );
  }
}

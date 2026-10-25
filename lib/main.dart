import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/hotel_search_screen.dart';
import 'screens/places_screen.dart';
import 'screens/map_screen.dart';
import 'screens/ai_itinerary_screen.dart';
import 'screens/booking_history_screen.dart';

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
  ];

  void navigateTo(int index) {
    if (index < 0 || index >= screens.length) return;

    setState(() {
      selectedIndex = index;
    });
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
        ],
      ),
    );
  }
}
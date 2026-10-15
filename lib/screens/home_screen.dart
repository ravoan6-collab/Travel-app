
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Discover Cambodia 🇰🇭',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Your next adventure starts here.',
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 24),
        TextField(
          readOnly: true,
          decoration: InputDecoration(
            hintText: 'Where do you want to go?',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
          onTap: () {
            // Search navigation will be connected later.
          },
        ),
        const SizedBox(height: 28),
        const Text(
          'Explore by category',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Row(
          children: [
            Expanded(
              child: CategoryCard(
                icon: Icons.hotel,
                title: 'Hotels',
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: CategoryCard(
                icon: Icons.landscape,
                title: 'Places',
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: CategoryCard(
                icon: Icons.auto_awesome,
                title: 'AI Trip',
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        const Text(
          'Popular destinations',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const DestinationCard(
          name: 'Angkor Wat',
          location: 'Siem Reap, Cambodia',
          icon: Icons.account_balance,
        ),
        const SizedBox(height: 12),
        const DestinationCard(
          name: 'Koh Rong',
          location: 'Sihanoukville, Cambodia',
          icon: Icons.beach_access,
        ),
        const SizedBox(height: 12),
        const DestinationCard(
          name: 'Royal Palace',
          location: 'Phnom Penh, Cambodia',
          icon: Icons.location_city,
        ),
      ],
    );
  }
}

class CategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const CategoryCard({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, size: 30, color: const Color(0xFF087F8C)),
          const SizedBox(height: 8),
          Text(title),
        ],
      ),
    );
  }
}

class DestinationCard extends StatelessWidget {
  final String name;
  final String location;
  final IconData icon;

  const DestinationCard({
    super.key,
    required this.name,
    required this.location,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE0F3F3),
          child: Icon(icon, color: const Color(0xFF087F8C)),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(location),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}

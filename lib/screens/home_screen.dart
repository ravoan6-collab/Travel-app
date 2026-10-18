
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final ValueChanged<int> onNavigate;

  const HomeScreen({
    super.key,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 12),

          const Text(
            'Discover Cambodia 🇰🇭',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Your next adventure starts here.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 22),

          // Search box
          TextField(
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                onNavigate(2);
              }
            },
            decoration: InputDecoration(
              hintText: 'Where do you want to go?',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Main banner
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Image.asset(
                  'assets/images/angkor_wat.jpg',
                  width: double.infinity,
                  height: 230,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black87,
                      ],
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Explore Cambodia',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Discover unforgettable places.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          const Text(
            'Explore by category',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: _categoryCard(
                  'Hotels',
                  Icons.hotel,
                      () => onNavigate(1),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _categoryCard(
                  'Places',
                  Icons.landscape,
                      () => onNavigate(2),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _categoryCard(
                  'AI Trip',
                  Icons.auto_awesome,
                      () => onNavigate(3),
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          const Text(
            'Popular destinations',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          _destinationCard(
            title: 'Angkor Wat',
            location: 'Siem Reap, Cambodia',
            imagePath: 'assets/images/angkor_wat.jpg',
            description: 'Discover Cambodia’s famous temple.',
            onTap: () => _showDestination(
              context,
              'Angkor Wat',
              'Siem Reap, Cambodia',
            ),
          ),

          const SizedBox(height: 16),

          _destinationCard(
            title: 'Koh Rong',
            location: 'Sihanoukville, Cambodia',
            imagePath: 'assets/images/koh rong.jpg',
            description: 'Enjoy beautiful beaches and clear water.',
            onTap: () => _showDestination(
              context,
              'Koh Rong',
              'Sihanoukville, Cambodia',
            ),
          ),

          const SizedBox(height: 16),

          _destinationCard(
            title: 'Cambodia Resort',
            location: 'Cambodia',
            imagePath: 'assets/images/resort.jpg',
            description: 'Find a relaxing place for your holiday.',
            onTap: () => _showDestination(
              context,
              'Cambodia Resort',
              'Cambodia',
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            height: 54,
            child: FilledButton.icon(
              onPressed: () => onNavigate(2),
              icon: const Icon(Icons.explore),
              label: const Text('Explore All Places'),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _categoryCard(
      String title,
      IconData icon,
      VoidCallback onTap,
      ) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 105,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: const Color(0xFF087F8C)),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _destinationCard({
    required String title,
    required String location,
    required String imagePath,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              imagePath,
              width: double.infinity,
              height: 190,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 190,
                  color: Colors.grey.shade200,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    size: 45,
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          location,
                          style: const TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 8),
                        Text(description),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDestination(
      BuildContext context,
      String title,
      String location,
      ) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(location),
              const SizedBox(height: 20),
              const Text(
                'Explore this destination and plan your next adventure.',
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onNavigate(2);
                  },
                  child: const Text('Explore Places'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

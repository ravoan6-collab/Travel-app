import 'package:flutter/material.dart';

import 'user_management_screen.dart';
import 'hotel_management_screen.dart';
import 'attraction_management_screen.dart';
import 'restaurant_management_screen.dart';
import 'booking_management_screen.dart';
import 'payment_management_screen.dart';
import 'review_management_screen.dart';
import 'report_management_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF087F8C),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No new notifications.'),
                ),
              );
            },
            icon: const Icon(Icons.notifications_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(),
            const SizedBox(height: 24),

            _buildSectionTitle('Dashboard Overview'),
            const SizedBox(height: 12),
            _buildStatisticsGrid(),

            const SizedBox(height: 24),

            _buildSectionTitle('Management'),
            const SizedBox(height: 12),
            _buildManagementGrid(context),

            const SizedBox(height: 24),

            _buildSectionTitle('Booking Statistics'),
            const SizedBox(height: 12),
            _buildBookingStatistics(),

            const SizedBox(height: 24),

            _buildSectionTitle('Top Destinations'),
            const SizedBox(height: 12),
            _buildTopDestinations(),

            const SizedBox(height: 24),

            _buildSectionTitle('Recent Activity'),
            const SizedBox(height: 12),
            _buildRecentActivity(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // WELCOME CARD
  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF087F8C),
            Color(0xFF13A6A6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.admin_panel_settings,
            color: Colors.white,
            size: 38,
          ),
          SizedBox(height: 14),
          Text(
            'Welcome, Administrator!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Manage your AI Travel platform in one place.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // SECTION TITLE
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.bold,
        color: Color(0xFF202B3C),
      ),
    );
  }

  // DASHBOARD STATISTICS
  Widget _buildStatisticsGrid() {
    final statistics = [
      {
        'title': 'Total Users',
        'value': '1,250',
        'icon': Icons.people_alt_outlined,
        'color': Colors.blue,
      },
      {
        'title': 'Total Hotels',
        'value': '85',
        'icon': Icons.hotel_outlined,
        'color': Colors.orange,
      },
      {
        'title': 'Total Bookings',
        'value': '320',
        'icon': Icons.book_online_outlined,
        'color': Colors.green,
      },
      {
        'title': 'Revenue',
        'value': '\$12.5K',
        'icon': Icons.attach_money,
        'color': Colors.purple,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: statistics.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.45,
      ),
      itemBuilder: (context, index) {
        final item = statistics[index];

        return Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                item['icon'] as IconData,
                color: item['color'] as Color,
                size: 27,
              ),
              const SizedBox(height: 10),
              Text(
                item['value'] as String,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                item['title'] as String,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // MANAGEMENT GRID
  Widget _buildManagementGrid(BuildContext context) {
    final managementItems = [
      {
        'title': 'Users',
        'subtitle': 'Manage users',
        'icon': Icons.people_alt_outlined,
        'color': Colors.blue,
      },
      {
        'title': 'Hotels',
        'subtitle': 'Manage hotels',
        'icon': Icons.hotel_outlined,
        'color': Colors.orange,
      },
      {
        'title': 'Attractions',
        'subtitle': 'Manage destinations',
        'icon': Icons.location_on_outlined,
        'color': Colors.red,
      },
      {
        'title': 'Restaurants',
        'subtitle': 'Manage restaurants',
        'icon': Icons.restaurant_outlined,
        'color': Colors.deepOrange,
      },
      {
        'title': 'Bookings',
        'subtitle': 'Manage bookings',
        'icon': Icons.book_online_outlined,
        'color': Colors.green,
      },
      {
        'title': 'Payments',
        'subtitle': 'Manage payments',
        'icon': Icons.payment_outlined,
        'color': Colors.purple,
      },
      {
        'title': 'Reviews',
        'subtitle': 'Manage reviews',
        'icon': Icons.star_outline,
        'color': Colors.amber,
      },
      {
        'title': 'Reports',
        'subtitle': 'View reports',
        'icon': Icons.bar_chart_outlined,
        'color': Colors.teal,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: managementItems.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemBuilder: (context, index) {
        final item = managementItems[index];
        final title = item['title'] as String;

        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (title == 'Users') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserManagementScreen(),
                ),
              );
            } else if (title == 'Hotels') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HotelManagementScreen(),
                ),
              );
            } else if (title == 'Attractions') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AttractionManagementScreen(),
                ),
              );
            } else if (title == 'Restaurants') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RestaurantManagementScreen(),
                ),
              );
            } else if (title == 'Bookings') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BookingManagementScreen(),
                ),
              );
            } else if (title == 'Payments') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaymentManagementScreen(),
                ),
              );
            } else if (title == 'Reviews') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReviewManagementScreen(),
                ),
              );
            } else if (title == 'Reports') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReportManagementScreen(),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '$title management will be developed next.',
                  ),
                ),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item['icon'] as IconData,
                  color: item['color'] as Color,
                  size: 29,
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item['subtitle'] as String,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // BOOKING STATISTICS
  Widget _buildBookingStatistics() {
    final bookingData = [
      {
        'title': 'Confirmed',
        'count': '180',
        'color': Colors.green,
      },
      {
        'title': 'Pending',
        'count': '95',
        'color': Colors.orange,
      },
      {
        'title': 'Cancelled',
        'count': '45',
        'color': Colors.red,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: bookingData.map((item) {
          final color = item['color'] as Color;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 9),
            child: Row(
              children: [
                Container(
                  width: 11,
                  height: 11,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item['title'] as String,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                Text(
                  item['count'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // TOP DESTINATIONS
  Widget _buildTopDestinations() {
    final destinations = [
      {
        'name': 'Angkor Wat',
        'location': 'Siem Reap',
        'icon': Icons.temple_buddhist,
      },
      {
        'name': 'Royal Palace',
        'location': 'Phnom Penh',
        'icon': Icons.account_balance,
      },
      {
        'name': 'Koh Rong',
        'location': 'Sihanoukville',
        'icon': Icons.beach_access,
      },
      {
        'name': 'Bokor Mountain',
        'location': 'Kampot',
        'icon': Icons.landscape,
      },
    ];

    return Column(
      children: destinations.map((destination) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: const Color(0xFF087F8C)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  destination['icon'] as IconData,
                  color: const Color(0xFF087F8C),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destination['name'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      destination['location'] as String,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 15,
                color: Colors.grey,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // RECENT ACTIVITY
  Widget _buildRecentActivity() {
    final activities = [
      {
        'title': 'New user registered',
        'subtitle': 'A new user joined AI Travel',
        'time': 'Recently',
        'icon': Icons.person_add_alt_1,
        'color': Colors.blue,
      },
      {
        'title': 'New booking received',
        'subtitle': 'A hotel booking was submitted',
        'time': 'Today',
        'icon': Icons.hotel,
        'color': Colors.green,
      },
      {
        'title': 'New attraction added',
        'subtitle': 'A destination was added',
        'time': 'Today',
        'icon': Icons.location_on,
        'color': Colors.orange,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: activities.map((activity) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  activity['icon'] as IconData,
                  color: activity['color'] as Color,
                  size: 25,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity['title'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        activity['subtitle'] as String,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  activity['time'] as String,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
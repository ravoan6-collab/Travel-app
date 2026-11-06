
import 'package:flutter/material.dart';
import '../../services/booking_store.dart';

class UserDashboardScreen extends StatelessWidget {
  const UserDashboardScreen({super.key});

  static const Color primaryColor = Color(0xFF087F8C);
  static const Color backgroundColor = Color(0xFFF5F7FB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'My Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: AnimatedBuilder(
        animation: BookingStore.instance,
        builder: (context, child) {
          final bookings = BookingStore.instance.bookings;

          final total = bookings.length;
          final pending = bookings.where(
                (b) => (b['status'] ?? '').toString().toLowerCase() == 'pending',
          ).length;
          final confirmed = bookings.where(
                (b) => (b['status'] ?? '').toString().toLowerCase() == 'confirmed',
          ).length;
          final cancelled = bookings.where(
                (b) => (b['status'] ?? '').toString().toLowerCase() == 'cancelled',
          ).length;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF087F8C), Color(0xFF075B70)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.travel_explore,
                      color: Colors.white,
                      size: 35,
                    ),
                    SizedBox(height: 14),
                    Text(
                      'Welcome to AI Travel!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 7),
                    Text(
                      'Manage your bookings and explore your travel plans.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Booking Overview',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.55,
                children: [
                  _statCard(
                    'Total Bookings',
                    total.toString(),
                    Icons.book_online,
                    primaryColor,
                  ),
                  _statCard(
                    'Pending',
                    pending.toString(),
                    Icons.hourglass_top,
                    Colors.orange,
                  ),
                  _statCard(
                    'Confirmed',
                    confirmed.toString(),
                    Icons.check_circle_outline,
                    Colors.green,
                  ),
                  _statCard(
                    'Cancelled',
                    cancelled.toString(),
                    Icons.cancel_outlined,
                    Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 26),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Bookings',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$total total',
                    style: const TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (bookings.isEmpty)
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.luggage_outlined,
                        size: 55,
                        color: primaryColor,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'No bookings yet',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Your recent hotel bookings will appear here.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              else
                ...bookings.take(5).map((booking) {
                  final name = (booking['name'] ??
                      booking['hotelName'] ??
                      'Hotel')
                      .toString();
                  final location =
                  (booking['location'] ?? 'Cambodia').toString();
                  final status =
                  (booking['status'] ?? 'Pending').toString();

                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFFE0F2F1),
                        child: Icon(
                          Icons.hotel,
                          color: primaryColor,
                        ),
                      ),
                      title: Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(location),
                      trailing: Text(
                        status,
                        style: TextStyle(
                          color: status.toLowerCase() == 'confirmed'
                              ? Colors.green
                              : status.toLowerCase() == 'cancelled'
                              ? Colors.red
                              : Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }

  static Widget _statCard(
      String title,
      String value,
      IconData icon,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 23),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';
import '../services/booking_store.dart';

class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({super.key});

  static const Color primaryColor = Color(0xFF087F8C);
  static const Color backgroundColor = Color(0xFFF5F7FB);

  String _formatDate(dynamic value) {
    if (value is! DateTime) {
      return '-';
    }

    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');

    return '$day/$month/${value.year}';
  }

  Future<void> _confirmCancelBooking(
      BuildContext context,
      String bookingId,
      String hotelName,
      ) async {
    final shouldCancel = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
            size: 44,
          ),
          title: const Text(
            'Cancel Booking?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to cancel your demo booking for '
                '$hotelName?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Keep Booking'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Yes, Cancel'),
            ),
          ],
        );
      },
    );

    if (shouldCancel == true) {
      BookingStore.instance.cancelBooking(bookingId);
    }
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'pending':
        return Colors.orange.shade800;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'My Bookings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: false,
      ),
      body: AnimatedBuilder(
        animation: BookingStore.instance,
        builder: (context, child) {
          final bookings = BookingStore.instance.bookings;

          if (bookings.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.luggage_outlined,
                        size: 65,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'No Bookings Yet',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Your hotel bookings will appear here '
                          'after you complete a demo booking.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Explore hotels and plan your next trip!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.calendar_month_outlined,
                        color: Colors.white,
                        size: 29,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your Travel Plans',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${bookings.length} booking'
                                '${bookings.length == 1 ? '' : 's'} in this session',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Booking History',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Review your hotel booking details below.',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 18),
              ...bookings.map((booking) {
                final String id = booking['id']?.toString() ?? '';
                final String name =
                    booking['name']?.toString() ?? 'Hotel';
                final String location =
                    booking['location']?.toString() ?? 'Cambodia';
                final String image =
                    booking['image']?.toString() ??
                        'assets/images/hotel.jpg';
                final String status =
                    booking['status']?.toString() ?? 'Pending';

                final double total = booking['totalPrice'] is num
                    ? (booking['totalPrice'] as num).toDouble()
                    : double.tryParse(
                  booking['totalPrice']?.toString() ?? '',
                ) ??
                    0.0;

                final int guests = booking['guests'] is num
                    ? (booking['guests'] as num).toInt()
                    : 1;

                final int rooms = booking['rooms'] is num
                    ? (booking['rooms'] as num).toInt()
                    : 1;

                final int nights = booking['nights'] is num
                    ? (booking['nights'] as num).toInt()
                    : 1;

                final double pricePerNight =
                booking['pricePerNight'] is num
                    ? (booking['pricePerNight'] as num).toDouble()
                    : nights > 0 && rooms > 0
                    ? total / nights / rooms
                    : total;

                final Color statusColor = _statusColor(status);

                return Card(
                  margin: const EdgeInsets.only(bottom: 20),
                  clipBehavior: Clip.antiAlias,
                  elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            height: 190,
                            width: double.infinity,
                            child: Image.asset(
                              image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey.shade200,
                                  child: const Icon(
                                    Icons.hotel,
                                    size: 65,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    status.toLowerCase() == 'cancelled'
                                        ? Icons.cancel_outlined
                                        : status.toLowerCase() == 'confirmed'
                                        ? Icons.check_circle_outline
                                        : Icons.hourglass_top,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    status,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(17),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 9),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  color: primaryColor,
                                  size: 19,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    location,
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Booking ID',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  SelectableText(
                                    id.isEmpty ? '-' : id,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Stay Details',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),
                            _InfoRow(
                              icon: Icons.login,
                              label: 'Check-in',
                              value: _formatDate(booking['checkIn']),
                            ),
                            const SizedBox(height: 13),
                            _InfoRow(
                              icon: Icons.logout,
                              label: 'Check-out',
                              value: _formatDate(booking['checkOut']),
                            ),
                            const SizedBox(height: 13),
                            _InfoRow(
                              icon: Icons.nights_stay_outlined,
                              label: 'Number of nights',
                              value: '$nights',
                            ),
                            const SizedBox(height: 13),
                            _InfoRow(
                              icon: Icons.people_outline,
                              label: 'Guests',
                              value: '$guests',
                            ),
                            const SizedBox(height: 13),
                            _InfoRow(
                              icon: Icons.meeting_room_outlined,
                              label: 'Rooms',
                              value: '$rooms',
                            ),
                            const SizedBox(height: 13),
                            _InfoRow(
                              icon: Icons.payments_outlined,
                              label: 'Price per night / room',
                              value: '\$${pricePerNight.toStringAsFixed(2)}',
                            ),
                            const Divider(height: 30),
                            Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Total Price',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  '\$${total.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 23,
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Demo price only. Taxes and additional fees '
                                  'may not be included.',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                            if (status.toLowerCase() != 'cancelled') ...[
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    _confirmCancelBooking(
                                      context,
                                      id,
                                      name,
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.cancel_outlined,
                                  ),
                                  label: const Text(
                                    'Cancel Booking',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red,
                                    side: const BorderSide(
                                      color: Colors.red,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ] else ...[
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red.withValues(alpha: 0.07),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'This demo booking has been cancelled.',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Demo only • Bookings are stored in memory',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 2),
        Icon(
          icon,
          size: 19,
          color: const Color(0xFF087F8C),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

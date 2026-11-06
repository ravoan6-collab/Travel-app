
import 'package:flutter/material.dart';
import '../../services/booking_store.dart';

class BookingManagementScreen extends StatefulWidget {
  const BookingManagementScreen({super.key});

  @override
  State<BookingManagementScreen> createState() =>
      _BookingManagementScreenState();
}

class _BookingManagementScreenState
    extends State<BookingManagementScreen> {
  final TextEditingController _searchController =
  TextEditingController();

  String _selectedFilter = 'All';

  final Color primaryColor = const Color(0xFF087F8C);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getFilteredBookings(
      List<Map<String, dynamic>> bookings) {
    final search = _searchController.text.toLowerCase();

    return bookings.where((booking) {
      final id = (booking['id'] ?? '').toString().toLowerCase();
      final name = (booking['name'] ?? '').toString().toLowerCase();
      final location =
      (booking['location'] ?? '').toString().toLowerCase();
      final status = (booking['status'] ?? 'Pending').toString();

      final matchesSearch = id.contains(search) ||
          name.contains(search) ||
          location.contains(search);

      final matchesFilter =
          _selectedFilter == 'All' || status == _selectedFilter;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Confirmed':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  void _showBookingDetails(Map<String, dynamic> booking) {
    final status = (booking['status'] ?? 'Pending').toString();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 45,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Booking Details',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 18),
                _detailRow('Booking ID', booking['id']),
                _detailRow('Customer', booking['name']),
                _detailRow('Hotel / Location', booking['location']),
                _detailRow('Check-in', booking['checkIn']),
                _detailRow('Check-out', booking['checkOut']),
                _detailRow('Guests', booking['guests']),
                _detailRow('Nights', booking['nights']),
                _detailRow(
                  'Total Price',
                  '\$${booking['totalPrice'] ?? 0}',
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text(
                      'Status: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      status,
                      style: TextStyle(
                        color: _getStatusColor(status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (status == 'Pending')
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            BookingStore.instance.cancelBooking(
                              booking['id'].toString(),
                            );
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            BookingStore.instance.confirmBooking(
                              booking['id'].toString(),
                            );
                            Navigator.pop(context);
                          },
                          child: const Text('Confirm'),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _detailRow(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 125,
            child: Text(
              title,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          Expanded(
            child: Text(
              value?.toString() ?? '-',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
      String title,
      int count,
      Color color,
      IconData icon,
      ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 10),
            Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    final status = (booking['status'] ?? 'Pending').toString();
    final color = _getStatusColor(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.hotel_outlined,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking['name']?.toString() ?? 'Unknown Customer',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      booking['location']?.toString() ?? 'Unknown Location',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 25),
          Text(
            'ID: ${booking['id'] ?? '-'}',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_month_outlined, size: 17),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  '${booking['checkIn'] ?? '-'}  →  ${booking['checkOut'] ?? '-'}',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              Text(
                '\$${booking['totalPrice'] ?? 0}',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showBookingDetails(booking),
              icon: const Icon(Icons.visibility_outlined, size: 18),
              label: const Text('View Details'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text(
          'Bookings Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: AnimatedBuilder(
        animation: BookingStore.instance,
        builder: (context, child) {
          final allBookings = BookingStore.instance.bookings;
          final filteredBookings = _getFilteredBookings(allBookings);

          final pending = allBookings
              .where((b) => b['status'] == 'Pending')
              .length;
          final confirmed = allBookings
              .where((b) => b['status'] == 'Confirmed')
              .length;
          final cancelled = allBookings
              .where((b) => b['status'] == 'Cancelled')
              .length;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _buildSummaryCard(
                          'Pending',
                          pending,
                          Colors.orange,
                          Icons.pending_actions,
                        ),
                        const SizedBox(width: 10),
                        _buildSummaryCard(
                          'Confirmed',
                          confirmed,
                          Colors.green,
                          Icons.check_circle_outline,
                        ),
                        const SizedBox(width: 10),
                        _buildSummaryCard(
                          'Cancelled',
                          cancelled,
                          Colors.red,
                          Icons.cancel_outlined,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Search booking, customer or location...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                          icon: const Icon(Icons.clear),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          'All',
                          'Pending',
                          'Confirmed',
                          'Cancelled',
                        ].map((filter) {
                          final selected = _selectedFilter == filter;

                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(filter),
                              selected: selected,
                              selectedColor: primaryColor,
                              labelStyle: TextStyle(
                                color: selected
                                    ? Colors.white
                                    : Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                              onSelected: (_) {
                                setState(() {
                                  _selectedFilter = filter;
                                });
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: filteredBookings.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.book_online_outlined,
                        size: 65,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'No bookings found',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Bookings will appear here.',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredBookings.length,
                  itemBuilder: (context, index) {
                    return _buildBookingCard(
                      filteredBookings[index],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

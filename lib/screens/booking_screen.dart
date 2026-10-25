
import 'package:flutter/material.dart';
import '../services/booking_store.dart';

class BookingScreen extends StatefulWidget {
  final Map<String, dynamic> hotel;

  const BookingScreen({
    super.key,
    required this.hotel,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  static const Color primaryColor = Color(0xFF087F8C);
  static const Color backgroundColor = Color(0xFFF5F7FA);

  late DateTime checkIn;
  late DateTime checkOut;

  int guests = 2;
  int rooms = 1;

  @override
  void initState() {
    super.initState();

    final today = DateUtils.dateOnly(DateTime.now());

    checkIn = today.add(const Duration(days: 1));
    checkOut = checkIn.add(const Duration(days: 1));
  }

  double get pricePerNight {
    final value = widget.hotel['price'];

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }

  int get numberOfNights {
    return checkOut.difference(checkIn).inDays;
  }

  double get subtotal {
    return pricePerNight * numberOfNights * rooms;
  }

  String formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  Future<void> _selectDate({
    required bool isCheckIn,
  }) async {
    final today = DateUtils.dateOnly(DateTime.now());

    final firstDate = isCheckIn
        ? today
        : checkIn.add(const Duration(days: 1));

    final lastDate = DateTime(today.year + 3, 12, 31);

    final currentDate = isCheckIn ? checkIn : checkOut;

    final initialDate = currentDate.isBefore(firstDate)
        ? firstDate
        : currentDate;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: isCheckIn
          ? 'Select Check-in Date'
          : 'Select Check-out Date',
      cancelText: 'Cancel',
      confirmText: 'Select',
    );

    if (picked == null || !mounted) {
      return;
    }

    setState(() {
      if (isCheckIn) {
        checkIn = DateUtils.dateOnly(picked);

        if (!checkOut.isAfter(checkIn)) {
          checkOut = checkIn.add(const Duration(days: 1));
        }
      } else {
        checkOut = DateUtils.dateOnly(picked);
      }
    });
  }

  void _changeGuests(int amount) {
    setState(() {
      guests = (guests + amount).clamp(1, 10).toInt();
    });
  }

  void _changeRooms(int amount) {
    setState(() {
      rooms = (rooms + amount).clamp(1, 5).toInt();
    });
  }

  void _reviewBooking() {
    if (pricePerNight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'The hotel price is invalid. Please check the hotel data.',
          ),
        ),
      );
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(26),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Review Your Booking',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Please check your details before confirming.',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _ReviewRow(
                    icon: Icons.hotel_outlined,
                    label: 'Hotel',
                    value: widget.hotel['name']?.toString() ?? 'Hotel',
                  ),
                  _ReviewRow(
                    icon: Icons.location_on_outlined,
                    label: 'Location',
                    value:
                    widget.hotel['location']?.toString() ?? 'Cambodia',
                  ),
                  _ReviewRow(
                    icon: Icons.login,
                    label: 'Check-in',
                    value: formatDate(checkIn),
                  ),
                  _ReviewRow(
                    icon: Icons.logout,
                    label: 'Check-out',
                    value: formatDate(checkOut),
                  ),
                  _ReviewRow(
                    icon: Icons.nights_stay_outlined,
                    label: 'Nights',
                    value: '$numberOfNights',
                  ),
                  _ReviewRow(
                    icon: Icons.people_outline,
                    label: 'Guests',
                    value: '$guests',
                  ),
                  _ReviewRow(
                    icon: Icons.meeting_room_outlined,
                    label: 'Rooms',
                    value: '$rooms',
                  ),
                  const Divider(height: 28),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Total price',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '\$${subtotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Demo booking only. No payment or real reservation '
                        'will be made.',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        _confirmBooking();
                      },
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text(
                        'Confirm Demo Booking',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(sheetContext);
                      },
                      child: const Text('Go Back and Edit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _confirmBooking() {
    final hotel = widget.hotel;
    final bookingId =
        'DEMO-${DateTime.now().millisecondsSinceEpoch}';

    final booking = <String, dynamic>{
      'id': bookingId,
      'name': hotel['name']?.toString() ?? 'Hotel',
      'location': hotel['location']?.toString() ?? 'Cambodia',
      'image': hotel['image']?.toString() ?? 'assets/images/hotel.jpg',
      'checkIn': checkIn,
      'checkOut': checkOut,
      'guests': guests,
      'rooms': rooms,
      'nights': numberOfNights,
      'pricePerNight': pricePerNight,
      'totalPrice': subtotal,
      'status': 'Pending',
    };

    BookingStore.instance.addBooking(booking);

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          icon: const Icon(
            Icons.check_circle,
            color: primaryColor,
            size: 52,
          ),
          title: const Text('Demo Booking Saved!'),
          content: SingleChildScrollView(
            child: Text(
              'Hotel: ${booking['name']}\n'
                  'Booking ID: $bookingId\n'
                  'Check-in: ${formatDate(checkIn)}\n'
                  'Check-out: ${formatDate(checkOut)}\n'
                  'Guests: $guests\n'
                  'Rooms: $rooms\n'
                  'Nights: $numberOfNights\n'
                  'Total: \$${subtotal.toStringAsFixed(2)}\n\n'
                  'This is a demo only. No real reservation was made.',
            ),
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pop(context);
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hotel = widget.hotel;
    final hotelName = hotel['name']?.toString() ?? 'Hotel';
    final hotelLocation =
        hotel['location']?.toString() ?? 'Cambodia';
    final hotelImage =
        hotel['image']?.toString() ?? 'assets/images/hotel.jpg';

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Book Your Stay',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            clipBehavior: Clip.antiAlias,
            elevation: 2,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: Image.asset(
                    hotelImage,
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
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hotelName,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: primaryColor,
                            size: 19,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              hotelLocation,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.payments_outlined,
                            color: primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '\$${pricePerNight.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: primaryColor,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ' / night / room',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          const _SectionTitle(
            title: 'Choose Your Dates',
            subtitle: 'Select when you plan to arrive and leave.',
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _DateTile(
                  icon: Icons.login,
                  title: 'Check-in',
                  date: formatDate(checkIn),
                  onTap: () => _selectDate(isCheckIn: true),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _DateTile(
                  icon: Icons.logout,
                  title: 'Check-out',
                  date: formatDate(checkOut),
                  onTap: () => _selectDate(isCheckIn: false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
          const _SectionTitle(
            title: 'Guests & Rooms',
            subtitle: 'Choose the number of guests and rooms.',
          ),
          const SizedBox(height: 12),
          _CounterCard(
            icon: Icons.people_alt_outlined,
            title: 'Guests',
            subtitle: '1–10 guests',
            value: guests,
            minValue: 1,
            maxValue: 10,
            onChanged: _changeGuests,
          ),
          const SizedBox(height: 10),
          _CounterCard(
            icon: Icons.meeting_room_outlined,
            title: 'Rooms',
            subtitle: '1–5 rooms',
            value: rooms,
            minValue: 1,
            maxValue: 5,
            onChanged: _changeRooms,
          ),
          const SizedBox(height: 26),
          const _SectionTitle(
            title: 'Price Summary',
            subtitle: 'Calculated from your dates and room count.',
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 1,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  _PriceRow(
                    label: 'Price per night',
                    value: '\$${pricePerNight.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 12),
                  _PriceRow(
                    label: 'Number of nights',
                    value: '$numberOfNights',
                  ),
                  const SizedBox(height: 12),
                  _PriceRow(
                    label: 'Number of rooms',
                    value: '$rooms',
                  ),
                  const Divider(height: 28),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Total price',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '\$${subtotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 23,
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Taxes and additional fees are not included.',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 54,
            child: FilledButton.icon(
              onPressed: _reviewBooking,
              icon: const Icon(Icons.fact_check_outlined),
              label: const Text(
                'Review Booking',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Center(
            child: Text(
              'Demo only • No payment will be processed',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

class _DateTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String date;
  final VoidCallback onTap;

  const _DateTile({
    required this.icon,
    required this.title,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 19,
                backgroundColor:
                const Color(0xFF087F8C).withValues(alpha: 0.1),
                child: Icon(
                  icon,
                  color: const Color(0xFF087F8C),
                  size: 20,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                date,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Change date',
                style: TextStyle(
                  color: Color(0xFF087F8C),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CounterCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final int value;
  final int minValue;
  final int maxValue;
  final ValueChanged<int> onChanged;

  const _CounterCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF087F8C);

    return Card(
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: primaryColor.withValues(alpha: 0.1),
              child: Icon(
                icon,
                color: primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: value > minValue
                  ? () => onChanged(-1)
                  : null,
              icon: const Icon(Icons.remove_circle_outline),
              color: primaryColor,
            ),
            Text(
              '$value',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: value < maxValue
                  ? () => onChanged(1)
                  : null,
              icon: const Icon(Icons.add_circle_outline),
              color: primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;

  const _PriceRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ReviewRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ReviewRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF087F8C);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: primaryColor,
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 95,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

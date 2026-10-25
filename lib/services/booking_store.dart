
import 'package:flutter/foundation.dart';

class BookingStore extends ChangeNotifier {
  BookingStore._();

  static final BookingStore instance = BookingStore._();

  final List<Map<String, dynamic>> _bookings = [];

  List<Map<String, dynamic>> get bookings =>
      List.unmodifiable(_bookings);

  void addBooking(Map<String, dynamic> booking) {
    _bookings.insert(
      0,
      Map<String, dynamic>.from(booking),
    );
    notifyListeners();
  }

  void cancelBooking(String bookingId) {
    final index = _bookings.indexWhere(
          (booking) => booking['id'] == bookingId,
    );

    if (index == -1) return;

    _bookings[index]['status'] = 'Cancelled';
    notifyListeners();
  }

  void clearBookings() {
    _bookings.clear();
    notifyListeners();
  }
}

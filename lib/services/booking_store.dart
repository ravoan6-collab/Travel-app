
import 'package:flutter/material.dart';

class BookingStore extends ChangeNotifier {
  BookingStore._();

  static final BookingStore instance = BookingStore._();

  final List<Map<String, dynamic>> _bookings = [];

  List<Map<String, dynamic>> get bookings =>
      List.unmodifiable(_bookings);

  void addBooking(Map<String, dynamic> booking) {
    _bookings.insert(0, booking);
    notifyListeners();
  }

  void confirmBooking(String bookingId) {
    final index = _bookings.indexWhere(
          (booking) => booking['id'].toString() == bookingId,
    );

    if (index == -1) return;

    if (_bookings[index]['status'] == 'Pending') {
      _bookings[index]['status'] = 'Confirmed';
      notifyListeners();
    }
  }

  void cancelBooking(String bookingId) {
    final index = _bookings.indexWhere(
          (booking) => booking['id'].toString() == bookingId,
    );

    if (index == -1) return;

    _bookings[index]['status'] = 'Cancelled';
    notifyListeners();
  }

  void deleteBooking(String bookingId) {
    _bookings.removeWhere(
          (booking) => booking['id'].toString() == bookingId,
    );

    notifyListeners();
  }

  void clearBookings() {
    _bookings.clear();
    notifyListeners();
  }
}

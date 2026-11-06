
import 'package:flutter/material.dart';

class PaymentManagementScreen extends StatefulWidget {
  const PaymentManagementScreen({super.key});

  @override
  State<PaymentManagementScreen> createState() =>
      _PaymentManagementScreenState();
}

class _PaymentManagementScreenState
    extends State<PaymentManagementScreen> {
  final TextEditingController _searchController =
  TextEditingController();

  final Color primaryColor = const Color(0xFF087F8C);

  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _payments = [
    {
      'id': 'PAY-1001',
      'customer': 'Dara Sok',
      'bookingId': 'DEMO-10001',
      'method': 'ABA Bank',
      'amount': 250.00,
      'date': '2026-10-28',
      'status': 'Paid',
    },
    {
      'id': 'PAY-1002',
      'customer': 'Sokha Chan',
      'bookingId': 'DEMO-10002',
      'method': 'Credit Card',
      'amount': 180.00,
      'date': '2026-10-29',
      'status': 'Pending',
    },
    {
      'id': 'PAY-1003',
      'customer': 'Vannak Kim',
      'bookingId': 'DEMO-10003',
      'method': 'Cash',
      'amount': 120.00,
      'date': '2026-10-30',
      'status': 'Failed',
    },
    {
      'id': 'PAY-1004',
      'customer': 'Srey Leak',
      'bookingId': 'DEMO-10004',
      'method': 'ABA Bank',
      'amount': 320.00,
      'date': '2026-10-31',
      'status': 'Paid',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Paid':
        return Colors.green;
      case 'Failed':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  List<Map<String, dynamic>> get _filteredPayments {
    final query = _searchController.text.toLowerCase();

    return _payments.where((payment) {
      final id = payment['id'].toString().toLowerCase();
      final customer =
      payment['customer'].toString().toLowerCase();
      final bookingId =
      payment['bookingId'].toString().toLowerCase();

      final matchesSearch = id.contains(query) ||
          customer.contains(query) ||
          bookingId.contains(query);

      final matchesFilter = _selectedFilter == 'All' ||
          payment['status'] == _selectedFilter;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  void _updateStatus(Map<String, dynamic> payment) {
    final currentStatus = payment['status'].toString();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Update Payment Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['Pending', 'Paid', 'Failed'].map((status) {
              return RadioListTile<String>(
                value: status,
                groupValue: currentStatus,
                title: Text(status),
                activeColor: primaryColor,
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    payment['status'] = value;
                  });

                  Navigator.pop(dialogContext);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _deletePayment(Map<String, dynamic> payment) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Payment?'),
          content: Text(
            'Are you sure you want to delete ${payment['id']}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _payments.remove(payment);
                });
                Navigator.pop(dialogContext);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showDetails(Map<String, dynamic> payment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (context) {
        final status = payment['status'].toString();

        return Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                'Payment Details',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 18),
              _detailRow('Payment ID', payment['id']),
              _detailRow('Customer', payment['customer']),
              _detailRow('Booking ID', payment['bookingId']),
              _detailRow('Payment Method', payment['method']),
              _detailRow('Amount', '\$${payment['amount']}'),
              _detailRow('Date', payment['date']),
              _detailRow('Status', status),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(14),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _updateStatus(payment);
                  },
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Update Status'),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
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
              value.toString(),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(
      String title,
      int count,
      Color color,
      IconData icon,
      ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 23),
            const SizedBox(height: 9),
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

  Widget _paymentCard(Map<String, dynamic> payment) {
    final status = payment['status'].toString();
    final color = _statusColor(status);

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
                  Icons.account_balance_wallet_outlined,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      payment['customer'].toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      payment['id'].toString(),
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
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      payment['method'].toString(),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      payment['date'].toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              Text(
                '\$${payment['amount']}',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showDetails(payment),
                  icon: const Icon(Icons.visibility_outlined, size: 17),
                  label: const Text('Details'),
                ),
              ),
              const SizedBox(width: 9),
              IconButton(
                tooltip: 'Update status',
                onPressed: () => _updateStatus(payment),
                icon: const Icon(Icons.edit_outlined),
                color: primaryColor,
              ),
              IconButton(
                tooltip: 'Delete payment',
                onPressed: () => _deletePayment(payment),
                icon: const Icon(Icons.delete_outline),
                color: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final paid = _payments.where((p) => p['status'] == 'Paid').length;
    final pending =
        _payments.where((p) => p['status'] == 'Pending').length;
    final failed =
        _payments.where((p) => p['status'] == 'Failed').length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text(
          'Payments Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    _summaryCard(
                      'Paid',
                      paid,
                      Colors.green,
                      Icons.check_circle_outline,
                    ),
                    const SizedBox(width: 10),
                    _summaryCard(
                      'Pending',
                      pending,
                      Colors.orange,
                      Icons.pending_actions,
                    ),
                    const SizedBox(width: 10),
                    _summaryCard(
                      'Failed',
                      failed,
                      Colors.red,
                      Icons.error_outline,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search payment or customer...',
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
                    children: ['All', 'Paid', 'Pending', 'Failed']
                        .map((filter) {
                      final selected = _selectedFilter == filter;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(filter),
                          selected: selected,
                          selectedColor: primaryColor,
                          labelStyle: TextStyle(
                            color: selected ? Colors.white : Colors.black87,
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
            child: _filteredPayments.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.payment_outlined,
                    size: 65,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'No payments found',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredPayments.length,
              itemBuilder: (context, index) {
                return _paymentCard(_filteredPayments[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

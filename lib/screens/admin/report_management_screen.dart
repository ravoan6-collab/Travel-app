
import 'package:flutter/material.dart';

class ReportManagementScreen extends StatefulWidget {
  const ReportManagementScreen({super.key});

  @override
  State<ReportManagementScreen> createState() =>
      _ReportManagementScreenState();
}

class _ReportManagementScreenState extends State<ReportManagementScreen> {
  String _selectedPeriod = '30 Days';

  final List<Map<String, dynamic>> _monthlyRevenue = [
    {'month': 'Jan', 'revenue': 1800.0},
    {'month': 'Feb', 'revenue': 2400.0},
    {'month': 'Mar', 'revenue': 2100.0},
    {'month': 'Apr', 'revenue': 3200.0},
    {'month': 'May', 'revenue': 2800.0},
    {'month': 'Jun', 'revenue': 3900.0},
    {'month': 'Jul', 'revenue': 3500.0},
    {'month': 'Aug', 'revenue': 4200.0},
    {'month': 'Sep', 'revenue': 3800.0},
    {'month': 'Oct', 'revenue': 4600.0},
    {'month': 'Nov', 'revenue': 4100.0},
    {'month': 'Dec', 'revenue': 5200.0},
  ];

  final List<Map<String, dynamic>> _destinations = [
    {
      'name': 'Angkor Wat',
      'location': 'Siem Reap',
      'bookings': 125,
      'icon': Icons.temple_buddhist,
      'color': Colors.orange,
    },
    {
      'name': 'Koh Rong',
      'location': 'Sihanoukville',
      'bookings': 98,
      'icon': Icons.beach_access,
      'color': Colors.blue,
    },
    {
      'name': 'Royal Palace',
      'location': 'Phnom Penh',
      'bookings': 76,
      'icon': Icons.account_balance,
      'color': Colors.purple,
    },
    {
      'name': 'Bokor National Park',
      'location': 'Kampot',
      'bookings': 54,
      'icon': Icons.landscape,
      'color': Colors.green,
    },
  ];

  final List<Map<String, dynamic>> _bookingStatuses = [
    {
      'name': 'Confirmed',
      'count': 180,
      'color': Colors.green,
    },
    {
      'name': 'Pending',
      'count': 95,
      'color': Colors.orange,
    },
    {
      'name': 'Cancelled',
      'count': 45,
      'color': Colors.red,
    },
  ];

  int get _totalBookings {
    return _bookingStatuses.fold<int>(
      0,
          (sum, item) => sum + (item['count'] as int),
    );
  }

  double get _totalRevenue {
    return _monthlyRevenue.fold<double>(
      0,
          (sum, item) => sum + (item['revenue'] as double),
    );
  }

  double get _averageRevenue {
    return _monthlyRevenue.isEmpty
        ? 0
        : _totalRevenue / _monthlyRevenue.length;
  }

  double get _maximumRevenue {
    return _monthlyRevenue
        .map((item) => item['revenue'] as double)
        .reduce((a, b) => a > b ? a : b);
  }

  String _formatMoney(double amount) {
    return '\$${amount.toStringAsFixed(0)}';
  }

  Widget _buildSectionTitle(String title, {String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF202B3C),
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSummaryCard(
      String title,
      String value,
      String subtitle,
      IconData icon,
      Color color,
      ) {
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart() {
    final visibleRevenue = _selectedPeriod == '7 Days'
        ? _monthlyRevenue.sublist(5, 12)
        : _selectedPeriod == '30 Days'
        ? _monthlyRevenue.sublist(8, 12)
        : _monthlyRevenue;

    final maxRevenue = visibleRevenue
        .map((item) => item['revenue'] as double)
        .reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Revenue Overview',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              DropdownButton<String>(
                value: _selectedPeriod,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(
                    value: '7 Days',
                    child: Text('7 Days'),
                  ),
                  DropdownMenuItem(
                    value: '30 Days',
                    child: Text('30 Days'),
                  ),
                  DropdownMenuItem(
                    value: '12 Months',
                    child: Text('12 Months'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedPeriod = value;
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 22),
          SizedBox(
            height: 190,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: visibleRevenue.map((item) {
                final revenue = item['revenue'] as double;
                final barHeight = maxRevenue == 0
                    ? 0.0
                    : (revenue / maxRevenue) * 125;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${(revenue / 1000).toStringAsFixed(1)}k',
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: barHeight,
                          decoration: BoxDecoration(
                            color: const Color(0xFF087F8C),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(7),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['month'].toString(),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 15),
          const Divider(),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Average Monthly Revenue',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
              Text(
                _formatMoney(_averageRevenue),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF087F8C),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookingStatus() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Booking Status',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                '$_totalBookings Total',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: 13,
              child: Row(
                children: _bookingStatuses.map((item) {
                  final count = item['count'] as int;

                  return Expanded(
                    flex: count,
                    child: Container(
                      color: item['color'] as Color,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 18),
          ..._bookingStatuses.map((item) {
            final count = item['count'] as int;
            final percentage = _totalBookings == 0
                ? 0.0
                : count / _totalBookings * 100;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 9),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: item['color'] as Color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item['name'] as String,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  Text(
                    '$count',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 48,
                    child: Text(
                      '${percentage.toStringAsFixed(1)}%',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTopDestinations() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: _destinations.asMap().entries.map((entry) {
          final index = entry.key;
          final destination = entry.value;
          final bookings = destination['bookings'] as int;
          final maximum = _destinations
              .map((item) => item['bookings'] as int)
              .reduce((a, b) => a > b ? a : b);

          return Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: (destination['color'] as Color)
                            .withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        destination['icon'] as IconData,
                        color: destination['color'] as Color,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            destination['name'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            destination['location'] as String,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '$bookings bookings',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: maximum == 0 ? 0 : bookings / maximum,
                    minHeight: 7,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      destination['color'] as Color,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCustomerStatistics() {
    final customerData = [
      {
        'title': 'Total Customers',
        'value': '1,250',
        'icon': Icons.people_outline,
        'color': Colors.blue,
      },
      {
        'title': 'New Customers',
        'value': '185',
        'icon': Icons.person_add_alt_1,
        'color': Colors.green,
      },
      {
        'title': 'Returning Customers',
        'value': '420',
        'icon': Icons.replay,
        'color': Colors.purple,
      },
      {
        'title': 'Average Rating',
        'value': '4.6 / 5',
        'icon': Icons.star_outline,
        'color': Colors.orange,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: customerData.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.55,
      ),
      itemBuilder: (context, index) {
        final item = customerData[index];

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                item['icon'] as IconData,
                color: item['color'] as Color,
                size: 24,
              ),
              const SizedBox(height: 9),
              Text(
                item['value'] as String,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                item['title'] as String,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReportNote() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFE7F4F5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: Color(0xFF087F8C),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'These reports use sample demonstration data. '
                  'Connect the Laravel and MySQL backend to display '
                  'real platform statistics.',
              style: TextStyle(
                color: Color(0xFF075B65),
                fontSize: 12,
                height: 1.5,
              ),
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
          'Reports Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF087F8C),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReportNote(),

            const SizedBox(height: 22),

            _buildSectionTitle(
              'Platform Overview',
              subtitle: 'Summary of AI Travel performance',
            ),

            const SizedBox(height: 14),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.25,
              children: [
                _buildSummaryCard(
                  'Total Bookings',
                  '320',
                  'All booking records',
                  Icons.book_online_outlined,
                  Colors.blue,
                ),
                _buildSummaryCard(
                  'Total Revenue',
                  _formatMoney(_totalRevenue),
                  'Sample yearly revenue',
                  Icons.attach_money,
                  Colors.green,
                ),
                _buildSummaryCard(
                  'Average Revenue',
                  _formatMoney(_averageRevenue),
                  'Per month',
                  Icons.trending_up,
                  Colors.orange,
                ),
                _buildSummaryCard(
                  'Destinations',
                  '${_destinations.length}',
                  'Featured destinations',
                  Icons.location_on_outlined,
                  Colors.purple,
                ),
              ],
            ),

            const SizedBox(height: 25),

            _buildSectionTitle(
              'Revenue Report',
              subtitle: 'Revenue chart by month',
            ),

            const SizedBox(height: 13),

            _buildRevenueChart(),

            const SizedBox(height: 25),

            _buildSectionTitle(
              'Booking Report',
              subtitle: 'Booking status breakdown',
            ),

            const SizedBox(height: 13),

            _buildBookingStatus(),

            const SizedBox(height: 25),

            _buildSectionTitle(
              'Top Destinations',
              subtitle: 'Destinations ranked by sample bookings',
            ),

            const SizedBox(height: 13),

            _buildTopDestinations(),

            const SizedBox(height: 25),

            _buildSectionTitle(
              'Customer Statistics',
              subtitle: 'Customer activity overview',
            ),

            const SizedBox(height: 13),

            _buildCustomerStatistics(),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}

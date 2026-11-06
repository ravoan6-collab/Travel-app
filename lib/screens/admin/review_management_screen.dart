
import 'package:flutter/material.dart';

class ReviewManagementScreen extends StatefulWidget {
  const ReviewManagementScreen({super.key});

  @override
  State<ReviewManagementScreen> createState() =>
      _ReviewManagementScreenState();
}

class _ReviewManagementScreenState extends State<ReviewManagementScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _reviews = [
    {
      'id': 'REV-1001',
      'customer': 'Dara Sok',
      'destination': 'Angkor Wat',
      'rating': 5,
      'comment':
      'Amazing place! I really enjoyed visiting Angkor Wat. The temple is beautiful.',
      'date': '2026-10-12',
    },
    {
      'id': 'REV-1002',
      'customer': 'Sokha Chan',
      'destination': 'Koh Rong',
      'rating': 4,
      'comment':
      'Beautiful beach and clear water. I had a wonderful experience.',
      'date': '2026-10-11',
    },
    {
      'id': 'REV-1003',
      'customer': 'Vanna Kim',
      'destination': 'Royal Palace',
      'rating': 3,
      'comment':
      'The place is nice, but it was quite crowded during my visit.',
      'date': '2026-10-10',
    },
    {
      'id': 'REV-1004',
      'customer': 'Mony Ly',
      'destination': 'Bokor National Park',
      'rating': 5,
      'comment':
      'Wonderful nature and fresh air. I recommend this destination!',
      'date': '2026-10-09',
    },
    {
      'id': 'REV-1005',
      'customer': 'Rithy Heng',
      'destination': 'Angkor Wat',
      'rating': 2,
      'comment':
      'The weather was too hot and the visit was not very comfortable.',
      'date': '2026-10-08',
    },
    {
      'id': 'REV-1006',
      'customer': 'Sreypov Touch',
      'destination': 'Koh Rong',
      'rating': 5,
      'comment':
      'Excellent experience! I would love to visit this island again.',
      'date': '2026-10-07',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredReviews {
    final searchText = _searchController.text.toLowerCase().trim();

    return _reviews.where((review) {
      final customer =
      review['customer'].toString().toLowerCase();
      final destination =
      review['destination'].toString().toLowerCase();

      final matchesSearch = customer.contains(searchText) ||
          destination.contains(searchText);

      final rating = review['rating'].toString();

      final matchesFilter =
          _selectedFilter == 'All' || rating == _selectedFilter;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  double get _averageRating {
    if (_reviews.isEmpty) return 0;

    final total = _reviews.fold<int>(
      0,
          (sum, review) => sum + (review['rating'] as int),
    );

    return total / _reviews.length;
  }

  int _countByRating(int rating) {
    return _reviews.where((review) => review['rating'] == rating).length;
  }

  void _deleteReview(Map<String, dynamic> review) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Review'),
          content: Text(
            'Are you sure you want to delete the review from ${review['customer']}?',
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
                  _reviews.remove(review);
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Review deleted successfully'),
                  ),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showReviewDetails(Map<String, dynamic> review) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final rating = review['rating'] as int;

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: SafeArea(
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
                const SizedBox(height: 24),
                const Text(
                  'Review Details',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _detailRow('Review ID', review['id'].toString()),
                _detailRow('Customer', review['customer'].toString()),
                _detailRow(
                  'Destination',
                  review['destination'].toString(),
                ),
                _detailRow('Date', review['date'].toString()),
                const SizedBox(height: 15),
                const Text(
                  'Rating',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ...List.generate(
                      5,
                          (index) => Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 25,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$rating / 5',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Text(
                  'Comment',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7FB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    review['comment'].toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF087F8C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => Navigator.pop(sheetContext),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(
      String title,
      String value,
      IconData icon,
      Color color,
      ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
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
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 21),
            ),
            const SizedBox(height: 13),
            Text(
              value,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    final rating = review['rating'] as int;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFF087F8C)
                    .withValues(alpha: 0.12),
                child: Text(
                  review['customer']
                      .toString()
                      .substring(0, 1)
                      .toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFF087F8C),
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['customer'].toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      review['date'].toString(),
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'details') {
                    _showReviewDetails(review);
                  } else if (value == 'delete') {
                    _deleteReview(review);
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'details',
                    child: Row(
                      children: [
                        Icon(Icons.visibility_outlined, size: 19),
                        SizedBox(width: 10),
                        Text('View Details'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 19,
                        ),
                        SizedBox(width: 10),
                        Text('Delete Review'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              ...List.generate(
                5,
                    (index) => Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 19,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$rating.0',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Text(
            review['destination'].toString(),
            style: const TextStyle(
              color: Color(0xFF087F8C),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            review['comment'].toString(),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey.shade700,
              height: 1.4,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => _showReviewDetails(review),
              icon: const Icon(Icons.visibility_outlined, size: 17),
              label: const Text('View Details'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF087F8C),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredReviews = _filteredReviews;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Reviews Management',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _statCard(
                    'Total Reviews',
                    '${_reviews.length}',
                    Icons.rate_review_outlined,
                    const Color(0xFF087F8C),
                  ),
                  const SizedBox(width: 12),
                  _statCard(
                    'Average Rating',
                    _averageRating.toStringAsFixed(1),
                    Icons.star_rounded,
                    Colors.orange,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _statCard(
                    '5 Star Reviews',
                    '${_countByRating(5)}',
                    Icons.star,
                    Colors.amber.shade700,
                  ),
                  const SizedBox(width: 12),
                  _statCard(
                    '1 Star Reviews',
                    '${_countByRating(1)}',
                    Icons.star_border,
                    Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 25),
              const Text(
                'Customer Reviews',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _searchController,
                onChanged: (value) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search customer or destination...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    onPressed: () {
                      _searchController.clear();
                      setState(() {});
                    },
                    icon: const Icon(Icons.close),
                  )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    'All',
                    '5',
                    '4',
                    '3',
                    '2',
                    '1',
                  ].map((filter) {
                    final selected = _selectedFilter == filter;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(
                          filter == 'All' ? 'All Reviews' : '$filter Stars',
                        ),
                        selected: selected,
                        selectedColor: const Color(0xFF087F8C),
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          color: selected
                              ? Colors.white
                              : Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                        onSelected: (value) {
                          setState(() {
                            _selectedFilter = filter;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Review List',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${filteredReviews.length} Reviews',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 13),
              if (filteredReviews.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.rate_review_outlined,
                        size: 45,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'No reviews found',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Try another search or rating filter.',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...filteredReviews.map(_buildReviewCard),
            ],
          ),
        ),
      ),
    );
  }
}

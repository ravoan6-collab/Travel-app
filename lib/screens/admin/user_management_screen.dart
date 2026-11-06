
import 'package:flutter/material.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() =>
      _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final Color primaryColor = const Color(0xFF087F8C);

  final TextEditingController searchController =
  TextEditingController();

  String selectedFilter = 'All';

  final List<Map<String, dynamic>> users = [
    {
      'name': 'Dara Sok',
      'email': 'dara@gmail.com',
      'role': 'Customer',
      'active': true,
      'initial': 'D',
    },
    {
      'name': 'Sokha Chan',
      'email': 'sokha@gmail.com',
      'role': 'Customer',
      'active': true,
      'initial': 'S',
    },
    {
      'name': 'Vanna Kim',
      'email': 'vanna@gmail.com',
      'role': 'Hotel Partner',
      'active': false,
      'initial': 'V',
    },
    {
      'name': 'Mony Ly',
      'email': 'mony@gmail.com',
      'role': 'Customer',
      'active': true,
      'initial': 'M',
    },
    {
      'name': 'Srey Pov',
      'email': 'srey@gmail.com',
      'role': 'Hotel Partner',
      'active': true,
      'initial': 'S',
    },
  ];

  List<Map<String, dynamic>> get filteredUsers {
    final query = searchController.text.toLowerCase();

    return users.where((user) {
      final matchesSearch =
          user['name'].toString().toLowerCase().contains(query) ||
              user['email'].toString().toLowerCase().contains(query);

      final matchesFilter =
          selectedFilter == 'All' ||
              (selectedFilter == 'Active' && user['active'] == true) ||
              (selectedFilter == 'Inactive' && user['active'] == false);

      return matchesSearch && matchesFilter;
    }).toList();
  }

  int get activeCount =>
      users.where((user) => user['active'] == true).length;

  int get inactiveCount =>
      users.where((user) => user['active'] == false).length;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void showAddUserDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add New User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final name = nameController.text.trim();
                final email = emailController.text.trim();

                if (name.isEmpty ||
                    email.isEmpty ||
                    !email.contains('@')) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid name and email.'),
                    ),
                  );
                  return;
                }

                final exists = users.any(
                      (user) =>
                  user['email'].toString().toLowerCase() ==
                      email.toLowerCase(),
                );

                if (exists) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('This email already exists.'),
                    ),
                  );
                  return;
                }

                setState(() {
                  users.insert(0, {
                    'name': name,
                    'email': email,
                    'role': 'Customer',
                    'active': true,
                    'initial': name[0].toUpperCase(),
                  });
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('User added successfully!'),
                  ),
                );
              },
              child: const Text('Add User'),
            ),
          ],
        );
      },
    ).then((_) {
      nameController.dispose();
      emailController.dispose();
    });
  }

  void toggleUserStatus(int index) {
    setState(() {
      users[index]['active'] = !users[index]['active'];
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          users[index]['active']
              ? 'User activated successfully.'
              : 'User deactivated successfully.',
        ),
      ),
    );
  }

  void deleteUser(int index) {
    final user = users[index];

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete User?'),
          content: Text(
            'Are you sure you want to delete ${user['name']}?',
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
                  users.removeAt(index);
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('User deleted successfully.'),
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

  @override
  Widget build(BuildContext context) {
    final visibleUsers = filteredUsers;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Text(
          'User Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: showAddUserDialog,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Add User'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Total Users',
                  users.length.toString(),
                  Icons.people_outline,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildSummaryCard(
                  'Active',
                  activeCount.toString(),
                  Icons.check_circle_outline,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildSummaryCard(
                  'Inactive',
                  inactiveCount.toString(),
                  Icons.block_outlined,
                  Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),

          const Text(
            'All Users',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),

          TextField(
            controller: searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Search name or email...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                onPressed: () {
                  searchController.clear();
                  setState(() {});
                },
                icon: const Icon(Icons.close),
              )
                  : null,
            ),
          ),
          const SizedBox(height: 14),

          Wrap(
            spacing: 8,
            children: ['All', 'Active', 'Inactive'].map((filter) {
              final selected = selectedFilter == filter;

              return ChoiceChip(
                label: Text(filter),
                selected: selected,
                selectedColor: primaryColor.withValues(alpha: 0.15),
                onSelected: (_) {
                  setState(() {
                    selectedFilter = filter;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          if (visibleUsers.isEmpty)
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.person_search,
                    size: 48,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'No users found',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Try another search or filter.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          else
            ...visibleUsers.map((user) {
              final originalIndex = users.indexOf(user);

              return _buildUserCard(
                user,
                originalIndex,
              );
            }),

          const SizedBox(height: 90),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
      String title,
      String value,
      IconData icon,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(
      Map<String, dynamic> user,
      int index,
      ) {
    final isActive = user['active'] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: primaryColor.withValues(alpha: 0.12),
            child: Text(
              user['initial'],
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user['email'],
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  user['role'],
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 8,
                      color: isActive ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      isActive ? 'Active' : 'Inactive',
                      style: TextStyle(
                        color: isActive ? Colors.green : Colors.orange,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'status') {
                toggleUserStatus(index);
              } else if (value == 'delete') {
                deleteUser(index);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'status',
                child: Text(
                  isActive ? 'Deactivate' : 'Activate',
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete User'),
              ),
            ],
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
    );
  }
}

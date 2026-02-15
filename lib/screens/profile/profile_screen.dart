import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/issue_provider.dart';
import '../auth/gateway_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = Provider.of<AuthProvider>(context, listen: false).user?.uid;
      if (userId != null) {
        Provider.of<IssueProvider>(context, listen: false).listenToUserReports(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final issueProvider = Provider.of<IssueProvider>(context);
    final user = authProvider.user;
    
    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            CircleAvatar(
              radius: 50,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
              child: Text(
                user.displayName[0].toUpperCase(),
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.displayName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              user.email,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            
            // Role Badge
            Chip(
              label: Text(
                user.role.toString().split('.').last.toUpperCase(),
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
              backgroundColor: _getRoleColor(user.role),
            ),
            
            if (user.role == UserRole.ngo) ...[
              const SizedBox(height: 8),
              if (user.isVerified)
                const Chip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified, size: 16, color: Colors.white),
                      SizedBox(width: 4),
                      Text('Verified', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  backgroundColor: Colors.green,
                )
              else
                Chip(
                  label: const Text('Pending Verification'),
                  backgroundColor: Colors.amber.shade100,
                ),
            ],
            
            const SizedBox(height: 32),
            
            // Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard(
                  'Reports',
                  issueProvider.userReports.length.toString(),
                  Icons.report_outlined,
                ),
                _buildStatCard(
                  'Likes',
                  '0',
                  Icons.favorite_outline,
                ),
                _buildStatCard(
                  'Events',
                  '0',
                  Icons.event_outlined,
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Menu Items
            _buildMenuItem(Icons.report, 'My Reports', () {}),
            _buildMenuItem(Icons.event, 'My Events', () {}),
            _buildMenuItem(Icons.notifications, 'Notifications', () {}),
            _buildMenuItem(Icons.help_outline, 'Help & Support', () {}),
            
            const SizedBox(height: 32),
            
            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await authProvider.signOut();
                  if (mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const GatewayScreen()),
                      (route) => false,
                    );
                  }
                },
                icon: const Icon(Icons.logout),
                label: const Text('Log Out'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[600]),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(label, style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.ngo:
        return Colors.orange;
      case UserRole.volunteer:
        return Colors.blue;
      case UserRole.public:
        return Colors.grey;
    }
  }
}
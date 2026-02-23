import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/issue_model.dart';
import '../../providers/issue_provider.dart';
import '../../widgets/issue_card.dart';

class WatchScreen extends StatefulWidget {
  const WatchScreen({Key? key}) : super(key: key);

  @override
  State<WatchScreen> createState() => _WatchScreenState();
}

class _WatchScreenState extends State<WatchScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<IssueProvider>(context, listen: false).listenToIssues();
    });
  }

  @override
  Widget build(BuildContext context) {
    final issueProvider = Provider.of<IssueProvider>(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Column(
        children: [
          // Teal Header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 12,
              left: 20,
              right: 20,
              bottom: 16,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0F766E), Color(0xFF115E59)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                // Title Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: Colors.white24,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text('🌱', style: TextStyle(fontSize: 16)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Red2Green',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.settings_outlined, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('Near Me', null, issueProvider, isSpecial: true),
                      const SizedBox(width: 8),
                      _buildFilterChip('All Issues', null, issueProvider),
                      const SizedBox(width: 8),
                      _buildFilterChip('Reported', IssueStatus.reported, issueProvider),
                      const SizedBox(width: 8),
                      _buildFilterChip('Claimed', IssueStatus.claimed, issueProvider),
                      const SizedBox(width: 8),
                      _buildFilterChip('Resolved', IssueStatus.resolved, issueProvider),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Issues List
          Expanded(
            child: issueProvider.isLoading && issueProvider.issues.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF059669)),
                    ),
                  )
                : issueProvider.issues.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(Icons.inbox_outlined, size: 40, color: Color(0xFF9CA3AF)),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No issues yet',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Be the first to report an issue!',
                              style: TextStyle(color: Colors.grey[500], fontSize: 14),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: issueProvider.issues.length,
                        itemBuilder: (context, index) {
                          final issue = issueProvider.issues[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: IssueCard(issue: issue),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, IssueStatus? status, IssueProvider provider, {bool isSpecial = false}) {
    final isSelected = provider.statusFilter == status && !isSpecial;
    return GestureDetector(
      onTap: () {
        if (!isSpecial) {
          provider.setStatusFilter(isSelected ? null : status);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF0F766E) : Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
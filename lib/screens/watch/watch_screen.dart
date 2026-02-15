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
      appBar: AppBar(
        title: const Text('Red2Green'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip('All', null, issueProvider),
                const SizedBox(width: 8),
                _buildFilterChip('Reported', IssueStatus.reported, issueProvider),
                const SizedBox(width: 8),
                _buildFilterChip('Claimed', IssueStatus.claimed, issueProvider),
                const SizedBox(width: 8),
                _buildFilterChip('Resolved', IssueStatus.resolved, issueProvider),
              ],
            ),
          ),
          
          // Issues List
          Expanded(
            child: issueProvider.isLoading && issueProvider.issues.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : issueProvider.issues.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inbox, size: 64, color: Colors.grey[300]),
                            const SizedBox(height: 16),
                            Text(
                              'No issues yet',
                              style: TextStyle(color: Colors.grey[600]),
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

  Widget _buildFilterChip(String label, IssueStatus? status, IssueProvider provider) {
    final isSelected = provider.statusFilter == status;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        provider.setStatusFilter(selected ? status : null);
      },
      backgroundColor: Colors.grey[200],
      selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
      checkmarkColor: Theme.of(context).primaryColor,
    );
  }
}
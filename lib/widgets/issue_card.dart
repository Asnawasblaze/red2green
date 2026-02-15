import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/auth_provider.dart';
import '../providers/issue_provider.dart';

class IssueCard extends StatelessWidget {
  final IssueModel issue;

  const IssueCard({Key? key, required this.issue}) : super(key: key);

  Color _getStatusColor() {
    switch (issue.status) {
      case IssueStatus.reported:
        return Colors.red;
      case IssueStatus.claimed:
        return Colors.amber;
      case IssueStatus.resolved:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = authProvider.user;
    
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Text(
                    issue.reporterName[0].toUpperCase(),
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        issue.reporterName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _formatDate(issue.createdAt),
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    issue.statusText,
                    style: TextStyle(
                      color: _getStatusColor(),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Image
          if (issue.photoUrl.isNotEmpty)
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[200],
              child: issue.photoUrl == 'placeholder_url'
                  ? Center(
                      child: Icon(Icons.image, size: 48, color: Colors.grey[400]),
                    )
                  : Image.network(
                      issue.photoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Center(child: Icon(Icons.broken_image, color: Colors.grey[400])),
                    ),
            ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  issue.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  issue.description,
                  style: TextStyle(color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.category, size: 16, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      issue.categoryText,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.location_on, size: 16, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Reported nearby',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                // Like Button
                IconButton(
                  icon: Icon(
                    issue.likes.contains(currentUser?.uid)
                        ? Icons.favorite
                        : Icons.favorite_outline,
                    color: issue.likes.contains(currentUser?.uid) ? Colors.red : null,
                  ),
                  onPressed: () {
                    if (currentUser != null) {
                      Provider.of<IssueProvider>(context, listen: false)
                          .toggleLike(issue.id!, currentUser.uid);
                    }
                  },
                ),
                Text('${issue.likes.length}'),
                const SizedBox(width: 16),
                
                // Comment Button
                IconButton(
                  icon: const Icon(Icons.comment_outlined),
                  onPressed: () {},
                ),
                Text('${issue.commentCount}'),
                const Spacer(),
                
                // Share Button
                IconButton(
                  icon: const Icon(Icons.share_outlined),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
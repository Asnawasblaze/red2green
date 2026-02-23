import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/models.dart';
import '../providers/auth_provider.dart';
import '../providers/issue_provider.dart';

class IssueCard extends StatelessWidget {
  final IssueModel issue;

  const IssueCard({Key? key, required this.issue}) : super(key: key);

  Color _getStatusColor() {
    switch (issue.status) {
      case IssueStatus.reported:
        return const Color(0xFFD97706);
      case IssueStatus.claimed:
        return const Color(0xFF2563EB);
      case IssueStatus.resolved:
        return const Color(0xFF059669);
    }
  }

  Color _getStatusBg() {
    switch (issue.status) {
      case IssueStatus.reported:
        return const Color(0xFFFEF3C7);
      case IssueStatus.claimed:
        return const Color(0xFFDBEAFE);
      case IssueStatus.resolved:
        return const Color(0xFFD1FAE5);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = authProvider.user;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1FAE5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      issue.reporterName[0].toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF059669),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        issue.reporterName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatDate(issue.createdAt),
                        style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _getStatusBg(),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    issue.statusText,
                    style: TextStyle(
                      color: _getStatusColor(),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Image
          if (issue.photoUrl.isNotEmpty && issue.photoUrl != 'placeholder_url')
            ClipRRect(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: CachedNetworkImage(
                  imageUrl: issue.photoUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: const Color(0xFFF3F4F6),
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF059669)),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: const Color(0xFFF3F4F6),
                    child: const Center(
                      child: Icon(Icons.broken_image_outlined, color: Color(0xFF9CA3AF), size: 40),
                    ),
                  ),
                ),
              ),
            )
          else if (issue.photoUrl == 'placeholder_url')
            Container(
              height: 180,
              width: double.infinity,
              color: const Color(0xFFF3F4F6),
              child: const Center(
                child: Icon(Icons.image_outlined, size: 40, color: Color(0xFF9CA3AF)),
              ),
            ),
          
          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  issue.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF9CA3AF)),
                    const SizedBox(width: 4),
                    Text(
                      'Reported nearby',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        issue.categoryText,
                        style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Actions
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Row(
              children: [
                // Like Button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      if (currentUser != null) {
                        Provider.of<IssueProvider>(context, listen: false)
                            .toggleLike(issue.id!, currentUser.uid);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      child: Row(
                        children: [
                          Icon(
                            issue.likes.contains(currentUser?.uid)
                                ? Icons.favorite
                                : Icons.favorite_outline,
                            color: issue.likes.contains(currentUser?.uid)
                                ? const Color(0xFFEF4444)
                                : const Color(0xFF9CA3AF),
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${issue.likes.length}',
                            style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                
                // Share Button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {},
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      child: Icon(Icons.share_outlined, color: Color(0xFF9CA3AF), size: 20),
                    ),
                  ),
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
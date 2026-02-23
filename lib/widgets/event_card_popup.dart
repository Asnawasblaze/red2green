import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/models.dart';

class EventCardPopup extends StatelessWidget {
  final IssueModel issue;
  final UserRole userRole;
  final String currentUserId;
  final VoidCallback onClose;
  final VoidCallback? onJoinEvent;
  final VoidCallback? onClaimEvent;

  const EventCardPopup({
    Key? key,
    required this.issue,
    required this.userRole,
    required this.currentUserId,
    required this.onClose,
    this.onJoinEvent,
    this.onClaimEvent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonText = _getButtonText();
    final buttonColor = _getButtonColor();
    final isEnabled = _isButtonEnabled();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image with status badge
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: issue.photoUrl.isNotEmpty && issue.photoUrl != 'placeholder_url'
                              ? CachedNetworkImage(
                                  imageUrl: issue.photoUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) => Center(
                                    child: Icon(Icons.broken_image, 
                                               color: Colors.grey[400], size: 48),
                                  ),
                                )
                              : Center(
                                  child: Icon(Icons.image, 
                                             color: Colors.grey[400], size: 48),
                                ),
                        ),
                      ),
                      // Status badge
                      Positioned(
                        top: 12,
                        left: 12,
                        child: _buildStatusBadge(),
                      ),
                      // Close button
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: onClose,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, 
                                            color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Title
                  Text(
                    issue.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Location
                  Row(
                    children: [
                      Icon(Icons.location_on, 
                           color: Colors.grey[600], size: 18),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${issue.location.latitude.toStringAsFixed(4)}, '
                          '${issue.location.longitude.toStringAsFixed(4)}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Stats row
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildStatItem(
                            Icons.people_outline,
                            '0 volunteers',
                            Colors.blue,
                          ),
                        ),
                        Container(height: 30, width: 1, color: Colors.grey[300]),
                        Expanded(
                          child: _buildStatItem(
                            Icons.calendar_today,
                            _formatDate(issue.createdAt),
                            Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Description
                  Text(
                    issue.description,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Action button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isEnabled ? _getButtonAction() : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBackgroundColor: Colors.grey[300],
                      ),
                      child: Text(
                        buttonText,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color bgColor;
    String text;
    IconData icon;

    switch (issue.status) {
      case IssueStatus.reported:
        bgColor = Colors.red;
        text = 'Urgent';
        icon = Icons.report_problem;
        break;
      case IssueStatus.claimed:
        bgColor = Colors.amber;
        text = 'In Progress';
        icon = Icons.work;
        break;
      case IssueStatus.resolved:
        bgColor = Colors.green;
        text = 'Resolved';
        icon = Icons.check_circle;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String text, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  bool _isButtonEnabled() {
    if (userRole == UserRole.ngo) {
      return issue.status == IssueStatus.reported;
    } else {
      return issue.status == IssueStatus.claimed;
    }
  }

  VoidCallback? _getButtonAction() {
    if (userRole == UserRole.ngo) {
      return onClaimEvent;
    } else {
      return onJoinEvent;
    }
  }

  Color _getButtonColor() {
    if (userRole == UserRole.ngo && issue.status == IssueStatus.reported) {
      return const Color(0xFF2ECC71);
    }
    if (issue.status == IssueStatus.claimed) {
      return const Color(0xFF2ECC71);
    }
    return Colors.grey;
  }

  String _getButtonText() {
    if (userRole == UserRole.ngo) {
      if (issue.status == IssueStatus.reported) {
        return 'Claim Event';
      } else if (issue.status == IssueStatus.claimed) {
        if (issue.claimedByNgoId == currentUserId) {
          return 'View Event Chat';
        }
        return 'Already Claimed';
      }
      return 'Resolved';
    } else {
      if (issue.status == IssueStatus.reported) {
        return 'Waiting for NGO';
      } else if (issue.status == IssueStatus.claimed) {
        return 'Join Cleanup Event';
      }
      return 'Resolved';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
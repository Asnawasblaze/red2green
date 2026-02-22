import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/models.dart';

class IssueDetailPopup extends StatelessWidget {
  final IssueModel issue;
  final UserRole userRole;
  final String currentUserId;
  final bool isProcessing;
  final VoidCallback? onJoinEvent;
  final VoidCallback? onClaimEvent;
  final VoidCallback onClose;

  const IssueDetailPopup({
    Key? key,
    required this.issue,
    required this.userRole,
    required this.currentUserId,
    this.isProcessing = false,
    this.onJoinEvent,
    this.onClaimEvent,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          
          // Content
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
                          height: 180,
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
                                    child: Icon(Icons.broken_image, color: Colors.grey[400], size: 48),
                                  ),
                                )
                              : Center(
                                  child: Icon(Icons.image, color: Colors.grey[400], size: 48),
                                ),
                        ),
                      ),
                      // Status badge
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getStatusColor().withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getStatusIcon(),
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                issue.statusText,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
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
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Location
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.grey[600], size: 18),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${issue.location.latitude.toStringAsFixed(4)}, ${issue.location.longitude.toStringAsFixed(4)}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Stats row
                  Row(
                    children: [
                      // Volunteers
                      Icon(Icons.people_outline, color: Colors.grey[600], size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '0 volunteers', // TODO: Update with actual count
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Date
                      Icon(Icons.calendar_today, color: Colors.grey[600], size: 16),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(issue.createdAt),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
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
                  
                  // Action button based on role
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isProcessing 
                          ? null 
                          : _getButtonAction(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _getButtonColor(),
                        foregroundColor: _getButtonTextColor(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBackgroundColor: Colors.grey[300],
                      ),
                      child: isProcessing
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              _getButtonText(),
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

  IconData _getStatusIcon() {
    switch (issue.status) {
      case IssueStatus.reported:
        return Icons.report_problem;
      case IssueStatus.claimed:
        return Icons.work;
      case IssueStatus.resolved:
        return Icons.check_circle;
    }
  }

  VoidCallback? _getButtonAction() {
    if (userRole == UserRole.ngo) {
      if (issue.status == IssueStatus.reported) {
        return onClaimEvent;
      } else if (issue.status == IssueStatus.claimed) {
        // Check if this NGO claimed it
        if (issue.claimedByNgoId == currentUserId) {
          return onJoinEvent; // They can view their event
        } else {
          return null; // Already claimed by another NGO
        }
      } else {
        return null; // Resolved
      }
    } else {
      // Public or Volunteer
      if (issue.status == IssueStatus.reported) {
        return null; // Can't join yet, not claimed
      } else if (issue.status == IssueStatus.claimed) {
        return onJoinEvent;
      } else {
        return null; // Resolved
      }
    }
  }

  Color _getButtonColor() {
    if (userRole == UserRole.ngo) {
      if (issue.status == IssueStatus.reported) {
        return const Color(0xFFF1C40F); // Yellow for claim
      } else if (issue.status == IssueStatus.claimed && issue.claimedByNgoId == currentUserId) {
        return const Color(0xFF2ECC71); // Green for their event
      } else {
        return Colors.grey; // Disabled
      }
    } else {
      // Public or Volunteer
      if (issue.status == IssueStatus.claimed) {
        return const Color(0xFF2ECC71); // Green to join
      } else {
        return Colors.grey; // Disabled
      }
    }
  }

  Color _getButtonTextColor() {
    if (userRole == UserRole.ngo && issue.status == IssueStatus.reported) {
      return Colors.black87;
    }
    return Colors.white;
  }

  String _getButtonText() {
    if (userRole == UserRole.ngo) {
      if (issue.status == IssueStatus.reported) {
        return 'Claim Event';
      } else if (issue.status == IssueStatus.claimed) {
        // Check if this NGO claimed it
        if (issue.claimedByNgoId == currentUserId) {
          return 'View My Event';
        } else {
          return 'Already Claimed by ${issue.claimedByNgoName ?? 'another NGO'}';
        }
      } else {
        return 'Resolved';
      }
    } else {
      // Public or Volunteer
      if (issue.status == IssueStatus.reported) {
        return 'Waiting for NGO';
      } else if (issue.status == IssueStatus.claimed) {
        return 'Join Cleanup Event';
      } else {
        return 'Resolved';
      }
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today, ${_formatTime(date)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday, ${_formatTime(date)}';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
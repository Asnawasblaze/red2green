import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/message_model.dart';

class ChatBubble extends StatelessWidget {
  final MessageModel message;
  final String currentUserId;
  final String? ngoId;
  final bool showAvatar;
  final bool isFirstMessage;
  final bool isLastMessage;

  const ChatBubble({
    super.key,
    required this.message,
    required this.currentUserId,
    this.ngoId,
    this.showAvatar = true,
    this.isFirstMessage = false,
    this.isLastMessage = false,
  });

  bool get isMe => message.senderId == currentUserId || message.senderId == 'system';
  bool get isNGO => message.senderId == ngoId;
  bool get isSystem => message.senderId == 'system';

  Color _getSenderColor() {
    if (isSystem) return Colors.grey;
    if (isNGO) return const Color(0xFF059669);
    
    final colors = [
      const Color(0xFF6366F1),
      const Color(0xFFEC4899),
      const Color(0xFF8B5CF6),
      const Color(0xFFF59E0B),
      const Color(0xFF10B981),
      const Color(0xFF3B82F6),
      const Color(0xFFEF4444),
      const Color(0xFF14B8A6),
    ];
    
    int index = message.senderName.hashCode.abs() % colors.length;
    return colors[index];
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    if (isSystem) {
      return _buildSystemMessage();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Sender name for others (not for my messages)
          if (!isMe && showAvatar)
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message.senderName,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: _getSenderColor(),
                    ),
                  ),
                  if (isNGO) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: const Color(0xFF059669),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'ORG',
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          
          // Message bubble
          Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Avatar for others
              if (!isMe && showAvatar) ...[
                CircleAvatar(
                  radius: 14,
                  backgroundColor: _getSenderColor().withOpacity(0.15),
                  child: Text(
                    _getInitials(message.senderName),
                    style: TextStyle(
                      color: _getSenderColor(),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              
              // Spacer for my messages to align right
              if (isMe) const Spacer(),
              
              // Bubble
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isMe ? const Color(0xFF059669) : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: isMe ? const Radius.circular(16) : (showAvatar ? const Radius.circular(4) : const Radius.circular(16)),
                    bottomRight: isMe ? (showAvatar ? const Radius.circular(4) : const Radius.circular(16)) : const Radius.circular(16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      message.text,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black87,
                        fontSize: 15.2,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatTime(message.timestamp),
                      style: TextStyle(
                        fontSize: 10.5,
                        color: isMe ? Colors.white70 : Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Spacer for others to align left
              if (!isMe) const Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSystemMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.info_outline, size: 13, color: Color(0xFF6B7280)),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  message.text,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF6B7280),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }
}

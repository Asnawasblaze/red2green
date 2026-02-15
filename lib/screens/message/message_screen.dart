import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/auth_provider.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = Provider.of<AuthProvider>(context, listen: false).user?.uid;
      if (userId != null) {
        Provider.of<ChatProvider>(context, listen: false).listenToEvents(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cleanup Coordination'),
      ),
      body: chatProvider.events.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    'No chatrooms yet',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Join a cleanup event to start chatting',
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: chatProvider.events.length,
              itemBuilder: (context, index) {
                final event = chatProvider.events[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: event.isActive 
                        ? Colors.green.shade100 
                        : Colors.grey.shade200,
                    child: Icon(
                      Icons.chat,
                      color: event.isActive ? Colors.green : Colors.grey,
                    ),
                  ),
                  title: Text('Cleanup Event ${index + 1}'),
                  subtitle: Text(event.ngoName),
                  trailing: event.isActive
                      ? Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        )
                      : null,
                  onTap: () {
                    // Navigate to chat room
                  },
                );
              },
            ),
    );
  }
}
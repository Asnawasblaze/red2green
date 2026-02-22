import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Issues Collection
  CollectionReference get issuesCollection => _firestore.collection('issues');
  
  // Events Collection
  CollectionReference get eventsCollection => _firestore.collection('events');
  
  // Chat Rooms Collection
  CollectionReference get chatRoomsCollection => _firestore.collection('chat_rooms');

  // Create new issue
  Future<String> createIssue(IssueModel issue) async {
    try {
      DocumentReference docRef = await issuesCollection.add(issue.toFirestore());
      return docRef.id;
    } catch (e) {
      print('Create issue error: $e');
      rethrow;
    }
  }

  // Get issues stream (for WATCH feed)
  Stream<List<IssueModel>> getIssuesStream({IssueStatus? statusFilter}) {
    Query query = issuesCollection.orderBy('createdAt', descending: true);
    
    if (statusFilter != null) {
      query = query.where('status', isEqualTo: statusFilter.toString().split('.').last);
    }
    
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => IssueModel.fromFirestore(doc)).toList();
    });
  }

  // Get issue by ID
  Future<IssueModel?> getIssueById(String issueId) async {
    try {
      DocumentSnapshot doc = await issuesCollection.doc(issueId).get();
      if (doc.exists) {
        return IssueModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Get issue error: $e');
      return null;
    }
  }

  // Update issue status
  Future<void> updateIssueStatus(String issueId, IssueStatus status) async {
    try {
      await issuesCollection.doc(issueId).update({
        'status': status.toString().split('.').last,
        if (status == IssueStatus.resolved) 
          'resolvedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      print('Update issue status error: $e');
      rethrow;
    }
  }

  // Claim issue (NGO only) - Creates event and chat room
  Future<Map<String, dynamic>?> claimIssue(String issueId, String ngoId, String ngoName) async {
    try {
      // Check if already claimed
      final issueDoc = await issuesCollection.doc(issueId).get();
      if (!issueDoc.exists) {
        return {'success': false, 'message': 'Issue not found'};
      }
      
      final issueData = issueDoc.data() as Map<String, dynamic>;
      final currentStatus = issueData['status'];
      
      if (currentStatus == 'claimed') {
        final claimedByNgoId = issueData['claimedByNgoId'];
        if (claimedByNgoId == ngoId) {
          return {'success': false, 'message': 'You already claimed this event'};
        } else {
          return {'success': false, 'message': 'Already claimed by another NGO'};
        }
      }
      
      if (currentStatus == 'resolved') {
        return {'success': false, 'message': 'This issue is already resolved'};
      }
      
      // Create event document
      final eventData = {
        'issueId': issueId,
        'ngoId': ngoId,
        'ngoName': ngoName,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'participants': [ngoId], // NGO is first participant
        'isActive': true,
        'scheduledTime': null,
        'meetingPoint': null,
      };
      
      final eventRef = await eventsCollection.add(eventData);
      final eventId = eventRef.id;
      
      // Create chat room for this event
      final chatRoomData = {
        'eventId': eventId,
        'issueId': issueId,
        'ngoId': ngoId,
        'ngoName': ngoName,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'participants': [ngoId],
        'lastMessage': null,
        'lastMessageTime': null,
      };
      
      final chatRoomRef = await chatRoomsCollection.add(chatRoomData);
      final chatRoomId = chatRoomRef.id;
      
      // Update event with chat room ID
      await eventRef.update({'chatRoomId': chatRoomId});
      
      // Update issue status
      await issuesCollection.doc(issueId).update({
        'status': 'claimed',
        'claimedByNgoId': ngoId,
        'claimedByNgoName': ngoName,
        'eventId': eventId,
      });
      
      // Add welcome message to chat
      final welcomeMessage = MessageModel(
        senderId: ngoId,
        senderName: ngoName,
        text: 'Welcome! This cleanup event has been created. Volunteers can join to coordinate.',
        timestamp: DateTime.now(),
      );
      
      await chatRoomsCollection
          .doc(chatRoomId)
          .collection('messages')
          .add(welcomeMessage.toFirestore());
      
      return {
        'success': true,
        'message': 'Event claimed successfully',
        'eventId': eventId,
        'chatRoomId': chatRoomId,
      };
    } catch (e) {
      print('Claim issue error: $e');
      return {'success': false, 'message': 'Error claiming event: $e'};
    }
  }

  // Like issue
  Future<void> toggleLike(String issueId, String userId) async {
    try {
      DocumentReference issueRef = issuesCollection.doc(issueId);
      DocumentSnapshot doc = await issueRef.get();
      
      if (doc.exists) {
        List<String> likes = List<String>.from((doc.data() as Map<String, dynamic>)['likes'] ?? []);
        
        if (likes.contains(userId)) {
          likes.remove(userId);
        } else {
          likes.add(userId);
        }
        
        await issueRef.update({'likes': likes});
      }
    } catch (e) {
      print('Toggle like error: $e');
      rethrow;
    }
  }

  // Get events for a user
  Stream<List<EventModel>> getUserEventsStream(String userId) {
    return eventsCollection
        .where('participants', arrayContains: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => EventModel.fromFirestore(doc)).toList();
    });
  }

  // Join event
  Future<void> joinEvent(String eventId, String userId) async {
    try {
      await eventsCollection.doc(eventId).update({
        'participants': FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      print('Join event error: $e');
      rethrow;
    }
  }

  // Get chat messages stream
  Stream<List<MessageModel>> getChatMessagesStream(String chatRoomId) {
    return chatRoomsCollection
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => MessageModel.fromFirestore(doc)).toList();
    });
  }

  // Send message
  Future<void> sendMessage(String chatRoomId, MessageModel message) async {
    try {
      await chatRoomsCollection
          .doc(chatRoomId)
          .collection('messages')
          .add(message.toFirestore());
    } catch (e) {
      print('Send message error: $e');
      rethrow;
    }
  }

  // Get user's reports
  Stream<List<IssueModel>> getUserReportsStream(String userId) {
    return issuesCollection
        .where('reporterId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => IssueModel.fromFirestore(doc)).toList();
    });
  }

  // Join chat room (add participant)
  Future<void> joinChatRoom(String eventId, String userId) async {
    try {
      // Get the event to find the chat room
      final eventDoc = await eventsCollection.doc(eventId).get();
      if (!eventDoc.exists) {
        throw Exception('Event not found');
      }
      
      final eventData = eventDoc.data() as Map<String, dynamic>;
      final chatRoomId = eventData['chatRoomId'];
      
      if (chatRoomId == null) {
        throw Exception('Chat room not found for this event');
      }
      
      // Add user to chat room participants
      await chatRoomsCollection.doc(chatRoomId).update({
        'participants': FieldValue.arrayUnion([userId]),
      });
      
      // Add welcome message
      final joinMessage = MessageModel(
        senderId: 'system',
        senderName: 'System',
        text: 'A new volunteer has joined the cleanup event!',
        timestamp: DateTime.now(),
      );
      
      await chatRoomsCollection
          .doc(chatRoomId)
          .collection('messages')
          .add(joinMessage.toFirestore());
    } catch (e) {
      print('Join chat room error: $e');
      rethrow;
    }
  }

  // Get chat room by event ID
  Future<String?> getChatRoomIdByEvent(String eventId) async {
    try {
      final eventDoc = await eventsCollection.doc(eventId).get();
      if (!eventDoc.exists) return null;
      
      final eventData = eventDoc.data() as Map<String, dynamic>;
      return eventData['chatRoomId'] as String?;
    } catch (e) {
      print('Get chat room error: $e');
      return null;
    }
  }
}
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

  // Claim issue (NGO only)
  Future<void> claimIssue(String issueId, String ngoId, String ngoName) async {
    try {
      await issuesCollection.doc(issueId).update({
        'status': 'claimed',
        'claimedByNgoId': ngoId,
        'claimedByNgoName': ngoName,
      });
    } catch (e) {
      print('Claim issue error: $e');
      rethrow;
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
}
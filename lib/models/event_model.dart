import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String? id;
  final String issueId;
  final String ngoId;
  final String ngoName;
  final String? chatRoomId;
  final DateTime? scheduledTime;
  final String? meetingPoint;
  final List<String> participants;
  final bool isActive;
  final DateTime createdAt;

  EventModel({
    this.id,
    required this.issueId,
    required this.ngoId,
    required this.ngoName,
    this.chatRoomId,
    this.scheduledTime,
    this.meetingPoint,
    this.participants = const [],
    this.isActive = true,
    required this.createdAt,
  });

  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return EventModel(
      id: doc.id,
      issueId: data['issueId'] ?? '',
      ngoId: data['ngoId'] ?? '',
      ngoName: data['ngoName'] ?? '',
      chatRoomId: data['chatRoomId'],
      scheduledTime: (data['scheduledTime'] as Timestamp?)?.toDate(),
      meetingPoint: data['meetingPoint'],
      participants: List<String>.from(data['participants'] ?? []),
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'issueId': issueId,
      'ngoId': ngoId,
      'ngoName': ngoName,
      'chatRoomId': chatRoomId,
      'scheduledTime': scheduledTime != null ? Timestamp.fromDate(scheduledTime!) : null,
      'meetingPoint': meetingPoint,
      'participants': participants,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  EventModel copyWith({
    String? id,
    String? issueId,
    String? ngoId,
    String? ngoName,
    String? chatRoomId,
    DateTime? scheduledTime,
    String? meetingPoint,
    List<String>? participants,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return EventModel(
      id: id ?? this.id,
      issueId: issueId ?? this.issueId,
      ngoId: ngoId ?? this.ngoId,
      ngoName: ngoName ?? this.ngoName,
      chatRoomId: chatRoomId ?? this.chatRoomId,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      meetingPoint: meetingPoint ?? this.meetingPoint,
      participants: participants ?? this.participants,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
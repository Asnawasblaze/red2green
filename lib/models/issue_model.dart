import 'package:cloud_firestore/cloud_firestore.dart';

enum IssueStatus { reported, claimed, resolved }

enum IssueCategory {
  garbage,
  pothole,
  drainage,
  brokenProperty,
  illegalPosters,
  strayAnimals,
  treeHazard,
  waterLeakage,
}

class IssueModel {
  final String? id;
  final String reporterId;
  final String reporterName;
  final String? reporterPhotoUrl;
  final GeoPoint location;
  final String photoUrl;
  final IssueCategory category;
  final String severity;
  final String title;
  final String description;
  final IssueStatus status;
  final String? claimedByNgoId;
  final String? claimedByNgoName;
  final String? eventId;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final bool isAnonymous;
  final List<String> likes;
  final int commentCount;

  IssueModel({
    this.id,
    required this.reporterId,
    required this.reporterName,
    this.reporterPhotoUrl,
    required this.location,
    required this.photoUrl,
    required this.category,
    required this.severity,
    required this.title,
    required this.description,
    this.status = IssueStatus.reported,
    this.claimedByNgoId,
    this.claimedByNgoName,
    this.eventId,
    required this.createdAt,
    this.resolvedAt,
    this.isAnonymous = false,
    this.likes = const [],
    this.commentCount = 0,
  });

  factory IssueModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return IssueModel(
      id: doc.id,
      reporterId: data['reporterId'] ?? '',
      reporterName: data['reporterName'] ?? 'Anonymous',
      reporterPhotoUrl: data['reporterPhotoUrl'],
      location: data['location'] ?? const GeoPoint(0, 0),
      photoUrl: data['photoUrl'] ?? '',
      category: _parseCategory(data['category']),
      severity: data['severity'] ?? 'Medium',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      status: _parseStatus(data['status']),
      claimedByNgoId: data['claimedByNgoId'],
      claimedByNgoName: data['claimedByNgoName'],
      eventId: data['eventId'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      resolvedAt: (data['resolvedAt'] as Timestamp?)?.toDate(),
      isAnonymous: data['isAnonymous'] ?? false,
      likes: List<String>.from(data['likes'] ?? []),
      commentCount: data['commentCount'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'reporterId': reporterId,
      'reporterName': reporterName,
      'reporterPhotoUrl': reporterPhotoUrl,
      'location': location,
      'photoUrl': photoUrl,
      'category': category.toString().split('.').last,
      'severity': severity,
      'title': title,
      'description': description,
      'status': status.toString().split('.').last,
      'claimedByNgoId': claimedByNgoId,
      'claimedByNgoName': claimedByNgoName,
      'eventId': eventId,
      'createdAt': Timestamp.fromDate(createdAt),
      'resolvedAt': resolvedAt != null ? Timestamp.fromDate(resolvedAt!) : null,
      'isAnonymous': isAnonymous,
      'likes': likes,
      'commentCount': commentCount,
    };
  }

  static IssueCategory _parseCategory(String? category) {
    switch (category) {
      case 'pothole':
        return IssueCategory.pothole;
      case 'drainage':
        return IssueCategory.drainage;
      case 'brokenProperty':
        return IssueCategory.brokenProperty;
      case 'illegalPosters':
        return IssueCategory.illegalPosters;
      case 'strayAnimals':
        return IssueCategory.strayAnimals;
      case 'treeHazard':
        return IssueCategory.treeHazard;
      case 'waterLeakage':
        return IssueCategory.waterLeakage;
      default:
        return IssueCategory.garbage;
    }
  }

  static IssueStatus _parseStatus(String? status) {
    switch (status) {
      case 'claimed':
        return IssueStatus.claimed;
      case 'resolved':
        return IssueStatus.resolved;
      default:
        return IssueStatus.reported;
    }
  }

  String get statusText {
    switch (status) {
      case IssueStatus.reported:
        return 'Reported';
      case IssueStatus.claimed:
        return 'Claimed';
      case IssueStatus.resolved:
        return 'Resolved';
    }
  }

  String get categoryText {
    switch (category) {
      case IssueCategory.garbage:
        return 'Garbage/Waste';
      case IssueCategory.pothole:
        return 'Pothole';
      case IssueCategory.drainage:
        return 'Drainage';
      case IssueCategory.brokenProperty:
        return 'Broken Property';
      case IssueCategory.illegalPosters:
        return 'Illegal Posters';
      case IssueCategory.strayAnimals:
        return 'Stray Animals';
      case IssueCategory.treeHazard:
        return 'Tree Hazard';
      case IssueCategory.waterLeakage:
        return 'Water Leakage';
    }
  }

  IssueModel copyWith({
    String? id,
    String? reporterId,
    String? reporterName,
    String? reporterPhotoUrl,
    GeoPoint? location,
    String? photoUrl,
    IssueCategory? category,
    String? severity,
    String? title,
    String? description,
    IssueStatus? status,
    String? claimedByNgoId,
    String? claimedByNgoName,
    String? eventId,
    DateTime? createdAt,
    DateTime? resolvedAt,
    bool? isAnonymous,
    List<String>? likes,
    int? commentCount,
  }) {
    return IssueModel(
      id: id ?? this.id,
      reporterId: reporterId ?? this.reporterId,
      reporterName: reporterName ?? this.reporterName,
      reporterPhotoUrl: reporterPhotoUrl ?? this.reporterPhotoUrl,
      location: location ?? this.location,
      photoUrl: photoUrl ?? this.photoUrl,
      category: category ?? this.category,
      severity: severity ?? this.severity,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      claimedByNgoId: claimedByNgoId ?? this.claimedByNgoId,
      claimedByNgoName: claimedByNgoName ?? this.claimedByNgoName,
      eventId: eventId ?? this.eventId,
      createdAt: createdAt ?? this.createdAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      likes: likes ?? this.likes,
      commentCount: commentCount ?? this.commentCount,
    );
  }
}
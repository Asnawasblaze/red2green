import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { public, volunteer, ngo }

class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  final UserRole role;
  final bool isVerified;
  final String? ngoUin;
  final String? ngoName;
  final String? phone;
  final String? fcmToken;
  final DateTime? createdAt;
  final Map<String, dynamic> stats;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.role = UserRole.public,
    this.isVerified = false,
    this.ngoUin,
    this.ngoName,
    this.phone,
    this.fcmToken,
    this.createdAt,
    this.stats = const {},
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      photoUrl: data['photoUrl'],
      role: _parseRole(data['role']),
      isVerified: data['isVerified'] ?? false,
      ngoUin: data['ngoUin'],
      ngoName: data['ngoName'],
      phone: data['phone'],
      fcmToken: data['fcmToken'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      stats: data['stats'] ?? {},
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'role': role.toString().split('.').last,
      'isVerified': isVerified,
      'ngoUin': ngoUin,
      'ngoName': ngoName,
      'phone': phone,
      'fcmToken': fcmToken,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'stats': stats,
    };
  }

  static UserRole _parseRole(String? role) {
    switch (role) {
      case 'volunteer':
        return UserRole.volunteer;
      case 'ngo':
        return UserRole.ngo;
      default:
        return UserRole.public;
    }
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoUrl,
    UserRole? role,
    bool? isVerified,
    String? ngoUin,
    String? ngoName,
    String? phone,
    String? fcmToken,
    DateTime? createdAt,
    Map<String, dynamic>? stats,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      isVerified: isVerified ?? this.isVerified,
      ngoUin: ngoUin ?? this.ngoUin,
      ngoName: ngoName ?? this.ngoName,
      phone: phone ?? this.phone,
      fcmToken: fcmToken ?? this.fcmToken,
      createdAt: createdAt ?? this.createdAt,
      stats: stats ?? this.stats,
    );
  }
}
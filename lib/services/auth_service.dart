import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserModel?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      if (user != null) {
        return await getUserData(user.uid);
      }
      return null;
    } catch (e) {
      print('Sign in error: $e');
      rethrow;
    }
  }

  // Register public user or volunteer
  Future<UserModel?> registerPublicUser({
    required String email,
    required String password,
    required String displayName,
    required UserRole role,
    String? phone,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      User? user = result.user;
      if (user != null) {
        // Update display name
        await user.updateDisplayName(displayName);
        
        // Create user document in Firestore
        UserModel userModel = UserModel(
          uid: user.uid,
          email: email,
          displayName: displayName,
          role: role,
          phone: phone,
          createdAt: DateTime.now(),
          stats: {
            'reports_count': 0,
            'events_joined': 0,
          },
        );
        
        await _firestore.collection('users').doc(user.uid).set(userModel.toFirestore());
        return userModel;
      }
      return null;
    } catch (e) {
      print('Registration error: $e');
      rethrow;
    }
  }

  // Register NGO
  Future<UserModel?> registerNGO({
    required String email,
    required String password,
    required String organizationName,
    required String contactPerson,
    required String ngoUin,
    String? phone,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      User? user = result.user;
      if (user != null) {
        // Update display name
        await user.updateDisplayName(organizationName);
        
        // Create NGO user document (not verified yet)
        UserModel userModel = UserModel(
          uid: user.uid,
          email: email,
          displayName: organizationName,
          role: UserRole.ngo,
          isVerified: false,
          ngoUin: ngoUin,
          phone: phone,
          createdAt: DateTime.now(),
          stats: {
            'issues_claimed': 0,
            'issues_resolved': 0,
            'volunteer_count': 0,
          },
        );
        
        await _firestore.collection('users').doc(user.uid).set(userModel.toFirestore());
        return userModel;
      }
      return null;
    } catch (e) {
      print('NGO registration error: $e');
      rethrow;
    }
  }

  // Get user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Get user data error: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print('Sign out error: $e');
      rethrow;
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Password reset error: $e');
      rethrow;
    }
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_local_model.dart';
import 'isar_service.dart';

class AuthService {
  late final FirebaseAuth _auth = FirebaseAuth.instance;
  late final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final IsarService _isarService = IsarService();

  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String username,
    required String birthday,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = userCredential.user!.uid;
    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'email': email,
      'username': username,
      'birthday': birthday,
      'createdAt': FieldValue.serverTimestamp(),
    });
    await _isarService.saveUserLocally(UserLocalModel(
      uid: uid,
      email: email,
      username: username,
      birthday: birthday,
    ));

    return userCredential;
  }

  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = userCredential.user!.uid;
      final userDoc = await _firestore.collection('users').doc(uid).get();
      final data = userDoc.data();

      if (data != null) {await _isarService.saveUserLocally(UserLocalModel(
          uid: uid,
          email: data['email'] ?? '',
          username: data['username'] ?? '',
          birthday: data['birthday'] ?? '',
        ));
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        final cachedUser = await _isarService.getUser();
        if (cachedUser != null && cachedUser.email == email) {
          return null;
        }
      }
      rethrow;
    }
  }

  Future<UserLocalModel?> getLoggedUser() async {
    return await _isarService.getUser();
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _isarService.clearDB();
  }
}

final authService = AuthService();

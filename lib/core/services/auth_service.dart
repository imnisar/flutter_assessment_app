import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_local_model.dart';
import 'isar_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final IsarService _isarService = IsarService();

  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String username,
    required String birthday,
  }) async {
    // 1. Create Firebase Auth User
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = userCredential.user!.uid;

    // 2. Save to Firestore
    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'email': email,
      'username': username,
      'birthday': birthday,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // 3. Cache locally in Isar
    await _isarService.saveUser(UserLocalModel(
      uid: uid,
      email: email,
      username: username,
      birthday: birthday,
    ));

    return userCredential;
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

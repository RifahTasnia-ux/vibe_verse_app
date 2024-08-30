import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseFireStore {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> createUser({
    required String email,
    required String userName,
    required String bio,
    required String profile,
  }) async {
    await _fireStore.collection('users').doc(_auth.currentUser?.uid ?? '').set({
      'email': email,
      'userName': userName,
      'bio': bio,
      'profile': profile,
      'followers': [],
      'following': [],
    });

    return true;
  }

  Future<void> addPost({
    required String caption,
    required String location,
    required List<String> imageUrls,
  }) async {
    final userId = _auth.currentUser?.uid;
    final userName = await _getUserName(); // Fetch the user's name

    if (userId != null) {
      await _fireStore.collection('posts').add({
        'userId': userId,
        'userName': userName,
        'caption': caption,
        'location': location,
        'imageUrls': imageUrls,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } else {
      throw Exception('User not logged in');
    }
  }

  Future<String> _getUserName() async {
    final userDoc = await _fireStore.collection('users').doc(_auth.currentUser?.uid).get();
    return userDoc.data()?['userName'] ?? 'Anonymous';
  }
}

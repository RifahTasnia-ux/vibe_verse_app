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
    final userName = await _getUserName();
    final userEmail = await _getUserEmail();
    final userProfile = await _getUserProfile();

    if (userId != null) {
      await _fireStore.collection('posts').add({
        'userId': userId,
        'userName': userName,
        'userEmail': userEmail,
        'userProfile': userProfile,
        'caption': caption,
        'location': location,
        'imageUrls': imageUrls,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } else {
      throw Exception('User not logged in');
    }
  }

  Future<List<Map<String, dynamic>>> fetchPosts() async {
    final querySnapshot = await _fireStore
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      print('Fetched Post Data: $data'); // Debugging print
      return {
        'profilePictureUrl': data['userProfile'] ?? '',
        'name': data['userName'] ?? '',
        'email': data['userEmail'] ?? '',
        'postImageUrls': List<String>.from(data['imageUrls'] ?? []),
        'location': data['location'] ?? 'Unknown Location',
        'comments': 0,
        'caption': data['caption'] ?? 'No Caption',
      };
    }).toList();
  }

  Future<String> _getUserName() async {
    final userDoc = await _fireStore.collection('users').doc(_auth.currentUser?.uid).get();
    return userDoc.data()?['userName'] ?? 'Anonymous';
  }

  Future<String> _getUserEmail() async {
    final userDoc = await _fireStore.collection('users').doc(_auth.currentUser?.uid).get();
    return userDoc.data()?['email'] ?? 'No Email';
  }

  Future<String> _getUserProfile() async {
    final userDoc = await _fireStore.collection('users').doc(_auth.currentUser?.uid).get();
    return userDoc.data()?['profile'] ?? 'https://via.placeholder.com/150';
  }
}

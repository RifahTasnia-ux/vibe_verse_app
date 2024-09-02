import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseFireStore {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> createUser({
    required String email,
    required String userName,
    required String fullName,
    required String bio,
    required String profile,
  }) async {
    await _fireStore.collection('users').doc(_auth.currentUser?.uid ?? '').set({
      'email': email,
      'fullName': fullName,
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
    final userName = await _fetchUserName();
    final userEmail = await _fetchUserEmail();
    final userProfile = await _fetchUserProfile();

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
      return {
        'profilePictureUrl': data['userProfile'] ?? 'https://via.placeholder.com/150',
        'name': data['userName'] ?? '',
        'email': data['userEmail'] ?? '',
        'postImageUrls': List<String>.from(data['imageUrls'] ?? []),
        'location': data['location'] ?? 'Unknown Location',
        'comments': 0,
        'caption': data['caption'] ?? 'No Caption',
      };
    }).toList();
  }

  Future<String> _fetchUserName() async {
    final userDoc = await _fireStore.collection('users').doc(_auth.currentUser?.uid).get();
    return userDoc.data()?['userName'] ?? 'Anonymous';
  }

  Future<String> _fetchUserEmail() async {
    final userDoc = await _fireStore.collection('users').doc(_auth.currentUser?.uid).get();
    return userDoc.data()?['email'] ?? 'No Email';
  }
  Future<String> _fetchUserProfile() async {
    final userDoc = await _fireStore.collection('users').doc(_auth.currentUser?.uid).get();
    return userDoc.data()?['profile'] ?? 'https://via.placeholder.com/150';
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not logged in');
      }
      final userDoc = await _fireStore.collection('users').doc(userId).get();
      if (!userDoc.exists) {
        throw Exception('User document does not exist');
      }
      final userData = userDoc.data() ?? {};
      userData['userId'] = userId;
      return userData;
    } catch (e) {
      print('Error fetching user profile: $e');
      return {};
    }
  }

  Future<List<Map<String, dynamic>>> getAllUserProfiles() async {
    try {
      final querySnapshot = await _fireStore.collection('users').get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'userId': doc.id,
          'userName': data['userName'] ?? 'Anonymous',
          'profile': data['profile'] ?? 'https://via.placeholder.com/150',
        };
      }).toList();
    } catch (e) {
      print('Error fetching all user profiles: $e');
      return [];
    }
  }

}

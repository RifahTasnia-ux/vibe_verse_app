import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../data/firebase_firestore.dart';

class PostDialog extends StatefulWidget {
  final List<File> selectedImages;
  final String? selectedLocation;
  final String postMessage;

  const PostDialog({
    super.key,
    required this.selectedImages,
    this.selectedLocation,
    required this.postMessage,
  });

  @override
  PostDialogState createState() => PostDialogState();
}

class PostDialogState extends State<PostDialog> {
  bool _isLoading = false;

  Future<void> _uploadPost() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Upload each image to Firebase Storage
      List<String> imageUrls = [];
      for (File image in widget.selectedImages) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('posts/${DateTime.now().millisecondsSinceEpoch}.jpg');
        final uploadTask = storageRef.putFile(image);
        final snapshot = await uploadTask;
        final downloadUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      }

      // Save the post details to Firestore
      await FirebaseFireStore().addPost(
        caption: widget.postMessage,
        location: widget.selectedLocation ?? '',
        imageUrls: imageUrls,
      );

      Navigator.of(context).pop(); // Dismiss the dialog after posting

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post shared successfully!')),
      );
    } catch (error) {
      Navigator.of(context).pop(); // Dismiss the dialog

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Dialog content
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          contentPadding: EdgeInsets.zero,
          content: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.info,
                  color: Colors.blue,
                  size: 40,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Do you want to post?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your post will share by clicking yes, if need any change click on edit.',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Dismiss the dialog
                      },
                      child: const Text(
                        'Edit',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _uploadPost,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        'Post Now',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Full-screen loader
        if (_isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }
}

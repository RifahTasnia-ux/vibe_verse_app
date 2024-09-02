import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
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

      await FirebaseFireStore().addPost(
        caption: widget.postMessage,
        location: widget.selectedLocation ?? '',
        imageUrls: imageUrls,
      );
      Navigator.of(context).pop();
      _showFlushbar(
        'Post shared successfully !',
        Colors.green,
      );
    } catch (error) {
      Navigator.of(context).pop();
      _showFlushbar(
        'Failed to post! Please Try Again with Proper Inputs.',
        Colors.redAccent,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  void _showFlushbar(String message, Color color) {
    Flushbar(
      message: message,
      duration: const Duration(seconds: 3),
      backgroundColor: color,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      flushbarPosition: FlushbarPosition.TOP,
    )..show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
                    fontFamily: "Satoshi",
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your post will share by clicking yes, if need any change click on edit.',
                  style: TextStyle(fontSize: 14,fontFamily: "Satoshi",),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Edit',
                        style: TextStyle(color: Colors.blue,fontFamily: "Satoshi",),
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
                        style: TextStyle(color: Colors.white,fontFamily: "Satoshi",),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final programController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  bool isSaving = false;
  File? _selectedImage;
  String? profileImageUrl; // At the top of the state

  Future<void> _loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get(const GetOptions(source: Source.server));

      if (doc.exists) {
        final data = doc.data()!;
        nameController.text = data['name'] ?? '';
        ageController.text = (data['age'] ?? '').toString();
        heightController.text = (data['height'] ?? '').toString();
        weightController.text = (data['weight'] ?? '').toString();
        programController.text = data['program'] ?? '';
        profileImageUrl = data['profileImage'];
        setState(() {});

        // Load profile image from network if not choosing a new one
        if (_selectedImage == null && data['profileImage'] != null) {
          setState(() {
            // no need to store URL now, already shown below via NetworkImage
          });
        }
      }
    } catch (e) {
      print('Error loading profile: $e');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    } else {
      print('❌ No image selected.');
    }
  }

  Future<String?> _uploadImageToStorage(File imageFile) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return null;

      final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = FirebaseStorage.instance.ref().child(
        'profile_images/$uid/$fileName',
      );

      await ref.putFile(imageFile);
      final downloadURL =
          '${await ref.getDownloadURL()}?v=${DateTime.now().millisecondsSinceEpoch}';

      return downloadURL;
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }

  Future<void> _saveProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    setState(() => isSaving = true);

    String imageUrl =
        profileImageUrl ??
        'https://i.imgur.com/BoN9kdC.png'; // ← existing or default

    if (_selectedImage != null && _selectedImage!.path.isNotEmpty) {
      final uploadedUrl = await _uploadImageToStorage(_selectedImage!);
      if (uploadedUrl != null) {
        imageUrl = uploadedUrl;
      }
    }

    final userData = {
      'name': nameController.text.trim(),
      'age': int.tryParse(ageController.text.trim()) ?? 0,
      'height': int.tryParse(heightController.text.trim()) ?? 0,
      'weight': int.tryParse(weightController.text.trim()) ?? 0,
      'program': programController.text.trim(),
      'profileImage': imageUrl, // ✅ updated correctly
    };

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(userData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully')),
      );
      Navigator.pop(context); // Return to ProfileScreen
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving profile: $e')));
    }

    setState(() => isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF5F6FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildAvatar(
              profileImageUrl,
            ), // You'll define `profileImageUrl` from Firestore data
            TextButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.photo),
              label: const Text('Choose Image'),
            ),
            const SizedBox(height: 12),
            _buildTextField(controller: nameController, label: 'Name'),
            _buildTextField(
              controller: ageController,
              label: 'Age',
              keyboardType: TextInputType.number,
            ),
            _buildTextField(
              controller: heightController,
              label: 'Height (cm)',
              keyboardType: TextInputType.number,
            ),
            _buildTextField(
              controller: weightController,
              label: 'Weight (kg)',
              keyboardType: TextInputType.number,
            ),
            _buildTextField(controller: programController, label: 'Program'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSaving ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9B88F2),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child:
                    isSaving
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          'Save Profile',
                          style: TextStyle(fontSize: 18),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildAvatar(String? imageUrl) {
    try {
      if (_selectedImage != null &&
          _selectedImage!.path.isNotEmpty &&
          File(_selectedImage!.path).existsSync()) {
        return CircleAvatar(
          radius: 50,
          backgroundImage: FileImage(_selectedImage!),
        );
      }
    } catch (e) {
      print('⚠️ Error loading local image: $e');
    }

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return CircleAvatar(radius: 50, backgroundImage: NetworkImage(imageUrl));
    }

    return const CircleAvatar(
      radius: 50,
      backgroundImage: NetworkImage('https://i.imgur.com/BoN9kdC.png'),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/features/profile/screens/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import '../../../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? userData;
  bool isLoading = true;
  bool notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    final uid = currentUser.uid;
    try {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (doc.exists) {
        setState(() {
          userData = UserModel.fromMap(doc.data()!);
          isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('User data not found')));
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('🔥 Firestore error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading profile: $e')));
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.more_horiz, color: Colors.black),
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : userData == null
              ? const Center(child: Text('No user data available'))
              : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundImage:
                            (userData!.profileImage.isNotEmpty)
                                ? NetworkImage(userData!.profileImage)
                                : const NetworkImage(
                                  'https://i.imgur.com/BoN9kdC.png',
                                ),
                      ),

                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userData!.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              userData!.program,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EditProfileScreen(),
                            ),
                          );
                          await _loadUserData();
                          // Reload profile after coming back
                          _loadUserData();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9B88F2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text('Edit'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _infoBox('${userData!.height}cm', 'Height'),
                      _infoBox('${userData!.weight}kg', 'Weight'),
                      _infoBox('${userData!.age}yo', 'Age'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _sectionTitle('Account'),
                  _settingsCard([
                    _settingsItem(Icons.person_outline, 'Personal Data'),
                    _settingsItem(Icons.emoji_events_outlined, 'Achievement'),
                    _settingsItem(Icons.history, 'Activity History'),
                    _settingsItem(Icons.bar_chart, 'Workout Progress'),
                  ]),
                  const SizedBox(height: 16),
                  _sectionTitle('Notification'),
                  _settingsCard([
                    SwitchListTile(
                      value: notificationsEnabled,
                      onChanged:
                          (val) => setState(() => notificationsEnabled = val),
                      title: Row(
                        children: const [
                          Icon(
                            Icons.notifications_none,
                            color: Color(0xFF9B88F2),
                          ),
                          SizedBox(width: 8),
                          Text('Pop-up Notification'),
                        ],
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                    ),
                  ]),
                  const SizedBox(height: 16),
                  _sectionTitle('Other'),
                  _settingsCard([
                    _settingsItem(Icons.settings_outlined, 'Settings'),
                  ]),
                ],
              ),
    );
  }

  Widget _infoBox(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _settingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  Widget _settingsItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF9B88F2)),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
}

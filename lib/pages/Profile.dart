import 'dart:io';
import 'package:book_app/database/auth.dart';
import 'package:book_app/database/shared-preference.dart';
import 'package:book_app/pages/terms&con.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? profile, name, email;
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  bool isUploading = false;

  final Color primaryColor = const Color(0xFF35ADAD);
  final Color backgroundColor = const Color(0xFFF5F5F5);
  final Color cardColor = Colors.white;
  final Color buttonColor = const Color(0xFF018786);

  @override
  void initState() {
    super.initState();
    _getSharedPrefData();
  }

  Future<void> _getSharedPrefData() async {
    profile = await SharedPreferenceHelper().getUserProfile();
    name = await SharedPreferenceHelper().getUserName();
    email = await SharedPreferenceHelper().getUserEmail();
    setState(() {});
  }

  Future<void> _getImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => selectedImage = File(image.path));
      _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (selectedImage == null) return;
    setState(() => isUploading = true);

    try {
      final String imageId = randomAlphaNumeric(10);
      final ref =
          FirebaseStorage.instance.ref().child("profileImages/$imageId");
      final task = ref.putFile(selectedImage!);

      final downloadUrl = await (await task).ref.getDownloadURL();
      await SharedPreferenceHelper().saveUserProfile(downloadUrl);

      setState(() {
        profile = downloadUrl;
        isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        _buildSnackBar('Profile pic updated successfully.', Colors.green),
      );
    } catch (e) {
      setState(() => isUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        _buildSnackBar('Image upload failed. Please try again.', Colors.red),
      );
    }
  }

  SnackBar _buildSnackBar(String message, Color color) {
    return SnackBar(
      content: Text(message, style: const TextStyle(fontSize: 18)),
      backgroundColor: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: name == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildProfileHeader(context),
                  const SizedBox(height: 25.0),
                  _buildProfileInfoCard(Icons.person, "Name", name!),
                  const SizedBox(height: 25.0),
                  _buildProfileInfoCard(Icons.email, "Email", email!),
                  const SizedBox(height: 25.0),
                  _buildTermsConditionsCard(context),
                  const SizedBox(height: 25.0),
                  _buildProfileActionCard(
                      Icons.logout, "Log Out", _handleLogout),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 45.0, left: 20.0, right: 20.0),
          height: MediaQuery.of(context).size.height / 4.0,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.vertical(
              bottom:
                  Radius.elliptical(MediaQuery.of(context).size.width, 105.0),
            ),
          ),
        ),
        Center(
          child: Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 6.5),
            child: Material(
              elevation: 10.0,
              borderRadius: BorderRadius.circular(60),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: GestureDetector(
                      onTap: _getImage,
                      onLongPress: () => _showFullImage(context),
                      child: _buildProfileImage(),
                    ),
                  ),
                  if (isUploading)
                    const Positioned.fill(
                        child: Center(child: CircularProgressIndicator())),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileImage() {
    if (selectedImage != null) {
      return Image.file(selectedImage!,
          height: 120, width: 120, fit: BoxFit.cover);
    } else if (profile != null) {
      return Image.network(profile!,
          height: 120, width: 120, fit: BoxFit.cover);
    } else {
      return Image.asset("assets/person0.png",
          height: 120, width: 120, fit: BoxFit.cover);
    }
  }

  Widget _buildProfileInfoCard(IconData icon, String label, String value) {
    return _buildCard(
      Row(
        children: [
          Icon(icon, color: const Color(0xff1c1b1b), size: 30),
          const SizedBox(width: 20.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Bitter",
                ),
              ),
              if (value.isNotEmpty)
                Text(
                  value,
                  style: const TextStyle(color: Colors.black54, fontSize: 16.0),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileActionCard(
      IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: _buildCard(
        Row(
          children: [
            Icon(icon, color: Colors.white, size: 30),
            const SizedBox(width: 20.0),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                fontFamily: "Bitter",
              ),
            ),
          ],
        ),
        color: buttonColor,
      ),
    );
  }

  Widget _buildTermsConditionsCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TermsConditionsPage()),
        );
      },
      child:
          _buildProfileInfoCard(Icons.description, "Terms and Condition", ""),
    );
  }

  Widget _buildCard(Widget child, {Color? color}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Material(
        borderRadius: BorderRadius.circular(15),
        elevation: 5.0,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          decoration: BoxDecoration(
            color: color ?? cardColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: child,
        ),
      ),
    );
  }

  void _handleLogout() {
    ScaffoldMessenger.of(context).showSnackBar(
      _buildSnackBar("Signed out successfully", Colors.red),
    );
    AuthMethods().SignOut(context);
  }

  void _showFullImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(10.0),
          child: Container(
              padding: const EdgeInsets.all(10.0),
              child: InteractiveViewer(
                minScale: 0.8,
                maxScale: 4.0,
                child: selectedImage == null
                    ? (profile == null
                        ? Image.asset("assets/person0.png")
                        : Image.network(profile!))
                    : Image.file(selectedImage!),
              )),
        );
      },
    );
  }
}

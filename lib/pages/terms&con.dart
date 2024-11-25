import 'package:flutter/material.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Color(0xFF03DAC6);
    final Color backgroundColor = Color(0xFFF5F5F5);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          'Terms & Conditions',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'lora'
          ),
        ),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Terms and Conditions',
              style: TextStyle(
                fontSize: 29,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontFamily: 'Bitter',
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/c1.jpg',
              height: 150,
            ),
            const SizedBox(height: 20),
            Text('1. Introduction',  style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF03DAC6),
              fontFamily: 'lora',
            ),),
            _buildSectionContent(
                'Welcome to [Fiction-Fusion App]. These Terms and Conditions outline the rules and regulations for the use of our app.'),
            const SizedBox(height: 20),
           Text('2. Intellectual Property Rights',  style: TextStyle(
             fontSize: 22,
             fontWeight: FontWeight.bold,
             color: Color(0xFF03DAC6),
             fontFamily: 'lora',
           ),),
            _buildSectionContent(
                'Other than the content you own, under these Terms, [Fiction-Fusion App] and/or its licensors own all the intellectual property rights and materials contained in this app.'),
            const SizedBox(height: 20),
            Image.asset(
              'assets/c2.jpg',
              height: 150,
            ),
            const SizedBox(height: 20),
           Text('3. Restrictions',  style: TextStyle(
             fontSize: 24,
             fontWeight: FontWeight.bold,
             color: Color(0xFF03DAC6),
             fontFamily: 'lora',
           ),),
            _buildSectionContent(
              'You are specifically restricted from all of the following:\n\n'
                  '• Publishing any app material in any other media\n'
                  '• Selling, sublicensing, and/or otherwise commercializing any app material\n'
                  '• Publicly performing and/or showing any app material\n'
                  '• Using this app in any way that is or may be damaging to this app\n'
                  '• Using this app in any way that impacts user access to this app\n'
                  '• Using this app contrary to applicable laws and regulations, or in any way may cause harm to the app, or to any person or business entity',
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/c3.jpg',
              height: 150,
            ),
            const SizedBox(height: 20),
            Text('4. Limitation of Liability',  style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF03DAC6),
              fontFamily: 'lora',
            ),),
            _buildSectionContent(
                '[Fiction-Fusion App] is not liable for any damages that may occur in connection with the use of this app.'),
            const SizedBox(height: 20),
            Text('5. Changes to these Terms',  style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF03DAC6),
              fontFamily: 'lora',
            ),),
            _buildSectionContent(
                '[Fiction-Fusion App] is permitted to revise these Terms at any time as it sees fit, and by using this app, you are expected to review these Terms on a regular basis.'),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color primaryColor) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: primaryColor,
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: const TextStyle(
        fontSize: 16,
        height: 1.5,
        color: Colors.black54,
      ),
    );
  }
}

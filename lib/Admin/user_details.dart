import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UsersListPage extends StatefulWidget {
  @override
  _UsersListPageState createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('user');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          'All Users',
          style: TextStyle(fontFamily: "Bitter", color: Color(0xFFF5F5F5)),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF03DAC6),
        elevation: 5.0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final users = snapshot.data!.docs;

          if (users.isEmpty) {
            return Center(
              child: Text('No users found'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12.0),
            itemCount: users.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> userData =
              users[index].data()! as Map<String, dynamic>;
              String userId = users[index].id;

              return Card(
                elevation: 5.0,
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(15.0),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFF018786),
                    child: Text(
                      userData['Name'] != null
                          ? userData['Name'][0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    userData['Name'] ?? 'No Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      userData['Email'] ?? 'No Email',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  onTap: () => _showUserDetails(context, userData),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit_rounded, color: Colors.blue),
                        onPressed: () => _editUser(context, userData, userId),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline_outlined,
                            color: Colors.red),
                        onPressed: () => _deleteUser(userId),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Function to show user details
  void _showUserDetails(BuildContext context, Map<String, dynamic> userData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Center(
            child: Text(
              '${userData['Name'] ?? 'User'}\'s Details',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                color: Color(0xFF03A9F4),
                fontSize: 22,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Name', userData['Name'] ?? 'No Name'),
              SizedBox(height: 10),
              _buildDetailRow('Email', userData['Email'] ?? 'No Email'),
              SizedBox(height: 10),
              _buildDetailRow('Phone', userData['Phone'] ?? 'No Phone Number'),
              SizedBox(height: 10),
              _buildDetailRow('Address', userData['Address'] ?? 'No Address'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Close', style: TextStyle(color: Colors.redAccent)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Helper method to build each detail row in the dialog
  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
            fontSize: 16,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16,
            ),
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Future<void> _deleteUser(String userId) async {
    try {
      await usersCollection.doc(userId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting user: $e')),
      );
    }
  }

  Future<void> _editUser(BuildContext context, Map<String, dynamic> userData,
      String userId) async {
    TextEditingController nameController =
    TextEditingController(text: userData['Name']);
    TextEditingController emailController =
    TextEditingController(text: userData['Email']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Center(
            child: Text(
              'Edit User Details',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                color: Color(0xFF03A9F4),
                fontSize: 22,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildStyledTextField(
                  controller: nameController,
                  labelText: 'Name',
                  icon: Icons.person,
                ),
                SizedBox(height: 15),
                _buildStyledTextField(
                  controller: emailController,
                  labelText: 'Email',
                  icon: Icons.email,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.redAccent)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF03DAC6),
              ),
              child: Text('Save'),
              onPressed: () async {
                try {
                  await usersCollection.doc(userId).update({
                    'Name': nameController.text,
                    'Email': emailController.text,
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('User updated successfully')),
                  );
                  Navigator.of(context).pop(); // Close the dialog
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error updating user: $e')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Color(0xFF03A9F4),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        prefixIcon: Icon(
          icon,
          color: Color(0xFF03A9F4),
        ),
        filled: true,
        fillColor: Color(0xFFE3F2FD),
        border: OutlineInputBorder(


        borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Color(0xFF03A9F4),
            width: 2.0,
          ),
        ),
      ),
    );
  }
}
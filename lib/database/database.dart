import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future adduserDetail(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('user')
        .doc(id)
        .set(userInfoMap);
  }

  Future addBookItem(Map<String, dynamic> userInfoMap, String name) async {
    return await FirebaseFirestore.instance.collection(name).add(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getBookitem(String name) async {
    return await FirebaseFirestore.instance.collection(name).snapshots();
  }

  // Future addBooktofav(Map<String, dynamic> userInfoMap, String id) async {
  //   return await FirebaseFirestore.instance
  //       .collection('user')
  //       .doc(id)
  //       .collection("Fav")
  //       .add(userInfoMap);
  // }
  //
  // Future<Stream<QuerySnapshot>> getBookfav(String id) async {
  //   return await FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(id)
  //       .collection("Fav")
  //       .snapshots();
  // }
}

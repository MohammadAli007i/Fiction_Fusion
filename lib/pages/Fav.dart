// import 'package:book_app/database/database.dart';
// import 'package:book_app/database/shared-preference.dart';
// import 'package:book_app/widget/widget_support.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class Fav extends StatefulWidget {
//   const Fav({super.key});
//
//   @override
//   State<Fav> createState() => _FavState();
// }
//
// class _FavState extends State<Fav> {
//   String? id;
//
//   getthesharedpref() async {
//     id = await SharedPreferenceHelper().getUserId();
//     setState(() {});
//   }
//
//   ontheload() async {
//     await getthesharedpref();
//     bookStream = await DatabaseMethods().getBookfav(id!);
//     setState(() {});
//   }
//
//   @override
//   void initState() {
//     ontheload();
//     super.initState();
//   }
//
//   Stream? bookStream;
//
//   Widget bookFav() {
//     return StreamBuilder(
//         stream: bookStream,
//         builder: (context, AsyncSnapshot snapshot) {
//           return snapshot.hasData
//               ? ListView.builder(
//                         padding: EdgeInsets.zero,
//                         itemCount: snapshot.data.docs.length,
//                         shrinkWrap: true,
//                         scrollDirection: Axis.vertical,
//                         itemBuilder: (context, index) {
//                           DocumentSnapshot ma = snapshot.data.docs[index];
//                           return Container(
//                             margin: EdgeInsets.only(
//                                 left: 20.0, right: 20.0, bottom:10.0 ),
//                             child: Material(
//                               elevation: 5.0,
//                               borderRadius: BorderRadius.circular(10),
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(10)),
//                                 padding: EdgeInsets.all(10),
//                                 child: Row(
//                                   children: [
//                                     Container(
//                                       height: 90,
//                                       width: 40,
//                                       decoration: BoxDecoration(
//                                           border: Border.all(),
//                                           borderRadius:
//                                               BorderRadius.circular(10)),
//                                       child: Center(
//                                         child: Text("2"),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       width: 20.0,
//                                     ),
//                                     ClipRRect(
//                                       borderRadius: BorderRadius.circular(60),
//                                       child: Image.network(
//                                         ma["Image"],
//                                         height: 90,
//                                         width: 90,
//                                         fit: BoxFit.cover,
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       width: 20.0,
//                                     ),
//                                     Column(
//                                       children: [
//                                         Text(
//                                           ma["Name"],
//                                           style: AppWidget
//                                               .SemiBoldTextFieldStyle(),
//                                         ),
//                                         Text(
//                                           ma['Detail'],
//                                           style: AppWidget
//                                               .SemiBoldTextFieldStyle(),
//                                         )
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//
//                 )
//               : CircularProgressIndicator();
//         });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         padding: EdgeInsets.only(top: 60.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Material(
//               elevation: 2.0,
//               child: Container(
//                 padding: EdgeInsets.only(bottom: 10.0),
//                 child: Center(
//                   child: Text(
//                     "Favourite",
//                     style: AppWidget.HeadlineTextFieldStyle(),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 20.0,
//             ),
//             Container(
//                 height: MediaQuery.of(context).size.height / 2,
//                 child: bookFav()),
//             Spacer(),
//             Divider(),
//             Padding(
//               padding: const EdgeInsets.only(left: 10.0, right: 10.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Books",
//                     style: AppWidget.SemiBoldTextFieldStyle(),
//                   ),
//                   Text(
//                     "Details",
//                     style: AppWidget.SemiBoldTextFieldStyle(),
//                   )
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 20.0,
//             ),
//             // Container(
//             //   padding: EdgeInsets.symmetric(vertical: 10.0),
//             //   width: MediaQuery.of(context).size.width,
//             //   decoration: BoxDecoration(
//             //       color: Colors.black87,
//             //       borderRadius: BorderRadius.circular(10)),
//             //   margin: EdgeInsets.only(left: 20.0, right: 20.0 , bottom: 20.0),
//             //   child: Center(
//             //     child: Text(
//             //       "Reminder",
//             //       style: TextStyle(color: Colors.white , fontSize: 20.0 , fontWeight: FontWeight.bold),
//             //     ),
//             //   ),
//             // )
//           ],
//         ),
//       ),
//     );
//   }
// }

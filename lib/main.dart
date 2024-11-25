import 'package:book_app/pages/Splash_Screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var app=await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyD7hxfKPVRWmEUDlQXALj5QA6IAntdgofk',
        appId: '1:57757279930:android:0a409ac383d22f4180c483',
        messagingSenderId: '57757279930',
        projectId: 'bookapp-5a0ee',
        storageBucket: 'gs://bookapp-5a0ee.appspot.com',
      )
  );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
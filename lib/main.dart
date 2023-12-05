import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:feedbackapp/pages/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

final firestore = FirebaseFirestore.instance;

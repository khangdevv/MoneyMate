import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:moneymate/firebase_options.dart';

void main() async {
  // Đảm bảo các liên kết framework của Flutter đã được khởi tạo đầy đủ
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Firebase dựa trên nền tảng hiện tại
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

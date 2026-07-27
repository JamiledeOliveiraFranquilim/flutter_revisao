import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/home_page.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://dusxpmyakayisizkhiuf.supabase.co',
    anonKey: 'sb_publishable_1Tq9VPZOPctG9_iWyJUS-w_oC5-0Zpy',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personagens Perdidos',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
      ),
      home: HomeScreen(),
    );
  }
}
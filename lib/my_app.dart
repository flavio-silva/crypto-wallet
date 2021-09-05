import 'package:crypto_coins/pages/coins_page.dart';
import 'package:crypto_coins/pages/home_page.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      title: 'Crypto Coins',
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

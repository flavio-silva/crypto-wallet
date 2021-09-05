import 'package:crypto_coins/config/app_settings.dart';
import 'package:crypto_coins/my_app.dart';
import 'package:crypto_coins/repositories/favorite_coins_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => FavoriteCoinsRepository()),
        ChangeNotifierProvider(create: (ctx) => AppSettings())
      ],
      child: MyApp(),
    ),
  );
}

import 'dart:collection';
import 'package:crypto_coins/models/coin.dart';
import 'package:flutter/material.dart';

class FavoriteCoinsRepository extends ChangeNotifier {
  List<Coin> _list = [];

  UnmodifiableListView<Coin> get list => UnmodifiableListView(_list);

  void saveAll(List<Coin> coins) {
    coins.forEach((coin) {
      if (!_list.contains(coin)) {
        _list.add(coin);
      }
    });

    notifyListeners();
  }

  void removeCoin(Coin coin) {
    _list.remove(coin);
    notifyListeners();
  }
}

import 'package:crypto_coins/components/coin_card.dart';
import 'package:crypto_coins/repositories/favorite_coins_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteCoinsPage extends StatelessWidget {
  const FavoriteCoinsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Coins'),
      ),
      body: Container(
        color: Colors.indigo.withOpacity(0.05),
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(12),
        child: Consumer<FavoriteCoinsRepository>(
          builder: (ctx, repo, child) {
            if (repo.list.isEmpty) {
              return ListTile(
                leading: Icon(Icons.star),
                title: Text('Ainda não há moedas favoritas'),
              );
            }

            return ListView.builder(
                itemCount: repo.list.length,
                itemBuilder: (ctx, index) {
                  return CoinCard(repo.list[index]);
                });
          },
        ),
      ),
    );
  }
}

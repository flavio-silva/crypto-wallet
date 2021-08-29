import 'package:crypto_coins/models/coin.dart';
import 'package:crypto_coins/pages/coin_details_page.dart';
import 'package:crypto_coins/repositories/coin_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CoinsPage extends StatefulWidget {
  const CoinsPage({Key? key}) : super(key: key);

  @override
  _CoinsPageState createState() => _CoinsPageState();
}

class _CoinsPageState extends State<CoinsPage> {
  List<Coin> _selectedCoins = [];
  List<Coin> coins = CoinRepository.all();
  NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'pt_BR', name: 'R\$');

  AppBar _buildAppBar() {
    bool hasSelectedCoins = _selectedCoins.length > 0;

    return AppBar(
      title: Text(hasSelectedCoins
          ? '${_selectedCoins.length} Selecionada(s)'
          : 'Cryptocurrencies'),
      leading: hasSelectedCoins
          ? IconButton(
              onPressed: () => setState(() => _selectedCoins = []),
              icon: Icon(Icons.arrow_back),
            )
          : null,
      iconTheme: IconThemeData(
        color: Colors.black87,
      ),
      textTheme: hasSelectedCoins
          ? TextTheme(
              headline6: TextStyle(
                fontSize: 18,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
      backgroundColor: hasSelectedCoins ? Colors.blueGrey.shade50 : null,
      elevation: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _selectedCoins.isNotEmpty
          ? FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.star),
            )
          : null,
      appBar: _buildAppBar(),
      body: Center(
        child: ListView.separated(
            padding: EdgeInsets.all(16),
            itemBuilder: (ctx, index) {
              var currentCoin = coins[index];

              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) {
                      return CoinDetailsPage(coin: currentCoin);
                    }),
                  );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                leading: _selectedCoins.contains(currentCoin)
                    ? CircleAvatar(child: Icon(Icons.check))
                    : Image.asset(
                        currentCoin.icon,
                        width: 40,
                      ),
                title: Text(
                  currentCoin.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(currentCoin.initials),
                trailing: Text(currencyFormat.format(currentCoin.price)),
                selected: _selectedCoins.contains(currentCoin),
                selectedTileColor: Colors.indigo.shade50,
                onLongPress: () {
                  setState(() {
                    _selectedCoins.contains(currentCoin)
                        ? _selectedCoins.remove(currentCoin)
                        : _selectedCoins.add(currentCoin);
                  });
                },
              );
            },
            separatorBuilder: (ctx, index) => Divider(),
            itemCount: coins.length),
      ),
    );
  }
}

import 'package:crypto_coins/config/app_settings.dart';
import 'package:crypto_coins/models/coin.dart';
import 'package:crypto_coins/pages/coin_details_page.dart';
import 'package:crypto_coins/repositories/coin_repository.dart';
import 'package:crypto_coins/repositories/favorite_coins_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CoinsPage extends StatefulWidget {
  const CoinsPage({Key? key}) : super(key: key);

  @override
  _CoinsPageState createState() => _CoinsPageState();
}

class _CoinsPageState extends State<CoinsPage> {
  List<Coin> _selectedCoins = [];
  final List<Coin> coins = CoinRepository.all();
  late FavoriteCoinsRepository favoriteCoinsRepository;
  late NumberFormat _currencyFormat;

  AppBar _buildAppBar() {
    bool hasSelectedCoins = _selectedCoins.isNotEmpty;

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
      actions: [
        PopupMenuButton<Map<String, String>>(
          icon: Icon(
            Icons.language,
            color: Colors.white,
          ),
          itemBuilder: (ctx) {
            return [
              PopupMenuItem(
                child: Text('Português Brasil'),
                value: {'locale': 'pt_BR', 'currencySymbol': 'R\$'},
              ),
              PopupMenuItem(
                child: Text('English'),
                value: {'locale': 'en', 'currencySymbol': '\$'},
              ),
            ];
          },
          onSelected: (selectedSetting) {
            context.read<AppSettings>().setSettings(
                  locale: selectedSetting['locale'] ?? '',
                  currencySymbol: selectedSetting['currencySymbol'] ?? '',
                );
          },
        )
      ],
    );
  }

  void _clearSelectedCoins() {
    setState(() {
      _selectedCoins.clear();
    });
  }

  void _readNumberFormat() {
    final settings = context.watch<AppSettings>().settings;

    _currencyFormat = NumberFormat.currency(
        locale: settings['locale'], name: settings['currencySymbol']);
  }

  @override
  Widget build(BuildContext context) {
    favoriteCoinsRepository = Provider.of<FavoriteCoinsRepository>(context);
    _readNumberFormat();
    return Scaffold(
      floatingActionButton: _selectedCoins.isNotEmpty
          ? FloatingActionButton(
              onPressed: () {
                favoriteCoinsRepository.saveAll(_selectedCoins);
                _clearSelectedCoins();
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Moedas favoritas com sucesso')));
              },
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
                    MaterialPageRoute(
                        builder: (_) => CoinDetailsPage(coin: currentCoin)),
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
                title: Row(
                  children: [
                    Text(
                      currentCoin.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (favoriteCoinsRepository.list
                        .any((element) => element.name == currentCoin.name))
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.circle, color: Colors.amber, size: 8),
                      ),
                  ],
                ),
                subtitle: Text(currentCoin.initials),
                trailing: Text(_currencyFormat.format(currentCoin.price)),
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

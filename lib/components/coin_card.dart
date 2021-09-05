import 'package:crypto_coins/config/app_settings.dart';
import 'package:crypto_coins/models/coin.dart';
import 'package:crypto_coins/pages/coin_details_page.dart';
import 'package:crypto_coins/repositories/favorite_coins_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CoinCard extends StatelessWidget {
  final Coin coin;
  late NumberFormat _numberFormat;

  CoinCard(this.coin, {Key? key}) : super(key: key);

  void _readLocaleSettings(BuildContext context) {
    final settings = context.watch<AppSettings>().settings;
    _numberFormat = NumberFormat.currency(
      locale: settings['locale'],
      name: settings['currencySymbol'],
    );
  }

  @override
  Widget build(BuildContext context) {
    _readLocaleSettings(context);

    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () => openDetail(context),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Image.asset(coin.icon, width: 48),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coin.name,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(coin.initials,
                      style: Theme.of(context).textTheme.caption)
                ],
              ),
              Spacer(),
              Chip(
                label: Text('${_numberFormat.format(coin.price)}'),
                backgroundColor: Colors.indigo.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.indigo.shade100),
                ),
              ),
              PopupMenuButton(
                  icon: Icon(Icons.more_vert),
                  onSelected: (value) {
                    if (value == 0) {
                      context.read<FavoriteCoinsRepository>().removeCoin(coin);
                    }
                  },
                  itemBuilder: (ctx) {
                    return [
                      PopupMenuItem(
                        child: Text('Remover dos favoritos'),
                        value: 0,
                      ),
                    ];
                  })
            ],
          ),
        ),
      ),
    );
  }

  void openDetail(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
      return CoinDetailsPage(coin: coin);
    }));
  }
}

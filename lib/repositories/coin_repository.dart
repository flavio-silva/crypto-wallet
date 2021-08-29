import 'package:crypto_coins/models/coin.dart';

class CoinRepository {
  static List<Coin> all() {
    return [
      Coin(
        icon: 'images/btc.png',
        name: 'Bitcoin',
        initials: 'BTC',
        price: 49013.02,
      ),
      Coin(
        icon: 'images/eth.png',
        name: 'Ethereum',
        initials: 'ETH',
        price: 3248.31,
      ),
      Coin(
        icon: 'images/ada.png',
        name: 'Cardano',
        initials: 'ADA',
        price: 2.84,
      ),
      Coin(
        icon: 'images/xrp.png',
        name: 'XRP',
        initials: 'XRP',
        price: 1.15,
      ),
      Coin(
        icon: 'images/ltc.png',
        name: 'Litecoin',
        initials: 'ltc',
        price: 173.92,
      ),
      Coin(
        icon: 'images/usdc.png',
        name: 'USDC',
        initials: 'usdc',
        price: 1.00,
      ),
    ];
  }
}

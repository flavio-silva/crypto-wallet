import 'package:crypto_coins/config/app_settings.dart';
import 'package:crypto_coins/models/coin.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CoinDetailsPage extends StatefulWidget {
  final Coin coin;

  const CoinDetailsPage({
    Key? key,
    required this.coin,
  }) : super(key: key);

  @override
  _CoinDetailsPageState createState() => _CoinDetailsPageState();
}

class _CoinDetailsPageState extends State<CoinDetailsPage> {
  final _form = GlobalKey<FormState>();
  double _cryptoQtde = 0.0;

  late NumberFormat _numberFormat;
  late NumberFormat _cryptoFormat;

  void _purchase() {
    if (_form.currentState!.validate()) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Compra realizada com sucesso!',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  _calculateCryptoQtde(double value) {
    setState(() {
      _cryptoQtde = value / widget.coin.price;
    });
  }

  void _readLocaleSettings() {
    final settings = context.watch<AppSettings>().settings;
    _numberFormat = NumberFormat.currency(
      locale: settings['locale'],
      name: settings['currencySymbol'],
    );

    _cryptoFormat = NumberFormat.currency(
        locale: settings['locale'], decimalDigits: 8, name: '');
  }

  @override
  Widget build(BuildContext context) {
    _readLocaleSettings();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.coin.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    widget.coin.icon,
                    width: 50,
                  ),
                  SizedBox(width: 8),
                  Text(
                    _numberFormat.format(widget.coin.price),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                      letterSpacing: -1,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Center(
                child: Text(
                  '${_cryptoFormat.format(_cryptoQtde)} ${widget.coin.initials}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.indigo.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Form(
              key: _form,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 5,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        TextInputMask(
                          mask:
                              '9+${_numberFormat.symbols.GROUP_SEP}999${_numberFormat.symbols.DECIMAL_SEP}99',
                          placeholder: '0',
                          maxPlaceHolders: 3,
                          reverse: true,
                        ),
                      ],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Valor',
                        prefixIcon: Icon(Icons.monetization_on),
                        suffixText: _numberFormat.currencyName,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe um valor';
                        }

                        if (_numberFormat.parse(value) < 50) {
                          return 'Valor mínimo é 50';
                        }
                      },
                      onChanged: (value) {
                        double newValue = _numberFormat.parse(value) as double;

                        _calculateCryptoQtde(newValue);
                      },
                      // initialValue: ' 0,00',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _purchase,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check),
                    SizedBox(width: 8),
                    Text(
                      'Comprar',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

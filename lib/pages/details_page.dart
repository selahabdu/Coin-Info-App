import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final Map exchangeRates;
  final String coinName;

  const DetailsPage(
      {super.key, required this.exchangeRates, required this.coinName});

  @override
  Widget build(BuildContext context) {
    double _deviceHeight = MediaQuery.of(context).size.height;
    double _deviceWidth = MediaQuery.of(context).size.width;
    List _currencies = exchangeRates.keys.toList();
    List _exchangeRates = exchangeRates.values.toList();
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Container(
          padding: EdgeInsets.only(
              top: _deviceHeight * 0.02, right: _deviceWidth * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Exchange Rates of $coinName',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
                textAlign: TextAlign.center,
              ),
              Container(
                height: _deviceHeight * 0.88,
                padding: EdgeInsets.only(
                  top: _deviceHeight * 0.01,
                ),
                child: ListView.builder(
                  itemCount: _currencies.length,
                  itemBuilder: ((context, index) {
                    String currency =
                        _currencies[index].toString().toUpperCase();
                    String exchangeRate =
                        _exchangeRates[index].toString().toUpperCase();
                    return ListTile(
                      title: Text('$currency:$exchangeRate'),
                      textColor: Colors.white,
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}

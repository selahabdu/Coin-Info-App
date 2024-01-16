import 'dart:convert';

import 'package:coininfo/pages/details_page.dart';
import 'package:coininfo/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> coins = [
    'Bitcoin',
    'Binancecoin',
    'Bittorrent',
    'Cardano',
    'Dogecoin',
    'Ethereum',
    'Ripple',
    'Solana',
    'Stellar',
    'Tether',
    'Tron',
    'Xrp',
  ];
  late String selected;
  double? _deviceHeight, _deviceWidth;
  HTTPService? _http;
  String coin = 'bitcoin';
  @override
  void initState() {
    super.initState();
    _http = GetIt.instance.get<HTTPService>();
    selected = coins.first;
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            selectedDownDropdown(),
            _dataWidgets(),
          ],
        ),
      )),
    );
  }

  Widget selectedDownDropdown() {
    List<DropdownMenuItem<String>> items = coins
        .map((e) => DropdownMenuItem(
              value: e,
              child: Text(
                e,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                ),
              ),
            ))
        .toList();
    return DropdownButton(
      value: selected,
      items: items,
      onChanged: (String? selectedCoin) {
        setState(() {
          selected = selectedCoin!;
          coin = selectedCoin.toString().toLowerCase();
        });
      },
      dropdownColor: const Color.fromARGB(255, 42, 55, 66),
      iconSize: 30,
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.white,
      ),
      underline: Container(),
    );
  }

  Widget _dataWidgets() {
    return FutureBuilder(
      future: _http!.get("/coins/$coin"),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Map data = jsonDecode(snapshot.data.toString());
          num dataUsd = data['market_data']['current_price']['usd'];
          num change24Hr = data['market_data']['price_change_percentage_24h'];
          Map exchangeRate = data['market_data']['current_price'];
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onDoubleTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) {
                      return DetailsPage(
                        exchangeRates: exchangeRate,
                        coinName: data['name'],
                      );
                    }),
                  );
                },
                child: coinImageWidget(data['image']['large']),
              ),
              currentPriceWidget(dataUsd),
              rateChangeWidget(change24Hr),
              coinDescription(data['description']['en']),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget currentPriceWidget(num rate) {
    return Text(
      "${rate.toStringAsFixed(2)} USD",
      style: const TextStyle(color: Colors.white, fontSize: 20),
    );
  }

  Widget rateChangeWidget(num rateChange) {
    return Text(
      "${rateChange.toStringAsFixed(2)}%",
      style: const TextStyle(color: Colors.white, fontSize: 15),
    );
  }

  Widget coinImageWidget(String imgURL) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: _deviceHeight! * 0.01),
      height: _deviceHeight! * 0.12,
      width: _deviceWidth! * 0.3,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imgURL),
        ),
      ),
    );
  }

  Widget coinDescription(String description) {
    return Container(
      padding: EdgeInsets.symmetric(
        // vertical: _deviceHeight! * 0.01,
        horizontal: _deviceWidth! * 0.01,
      ),
      // margin: EdgeInsets.symmetric(vertical: _deviceHeight! * 0.02),
      height: _deviceHeight! * 0.58,
      width: _deviceWidth! * 0.95,
      color: Color.fromARGB(255, 60, 59, 94),
      child: SingleChildScrollView(
        child: Text(
          description,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

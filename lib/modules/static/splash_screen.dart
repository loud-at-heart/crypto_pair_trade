import 'dart:async';

import 'package:crypto_pair_trade/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    Timer(const Duration(seconds: 3),
            ()=>Navigator.pushReplacementNamed(context, Routes.cryptoScreen)
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child:Lottie.asset(
          "assets/lottie/bitcoin.json",
        ),
    );
  }
}

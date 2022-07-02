import 'package:crypto_pair_trade/modules/crypto_trade_route/bloc/crypto_trade_bloc.dart';
import 'package:crypto_pair_trade/modules/crypto_trade_route/data/crypto_trade_repository.dart';
import 'package:crypto_pair_trade/modules/crypto_trade_route/view/crypto_trade_route.dart';
import 'package:crypto_pair_trade/modules/static/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';

class Routes {
  Routes._();

  static const cryptoScreen = '/crypto_trade_route';
  static const splashScreen = '/splash_screen';

  // get onGenerateRoute
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case cryptoScreen:
        return MaterialPageRoute(builder: (context) {
          return BlocProvider<CryptoTradeBloc>(
            create: (context) => CryptoTradeBloc(
              cryptoTradeRepository: Injector().get<CryptoTradeRepository>(),
            ),
            child: const CryptoDashboard(),
          );
        });
      default:
        return MaterialPageRoute(builder: (context) {
          return const SplashPage();
        });
    }
  }

// get Routes
  static Map<String, Widget Function(BuildContext context)> get appRoutes => {
        Routes.splashScreen: (BuildContext context) => const SplashPage(),
      };

  static Widget get splashPage => const SplashPage();
}

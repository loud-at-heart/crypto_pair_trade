import 'package:crypto_pair_trade/navigation/routes.dart';
import 'package:crypto_pair_trade/observer/app_bloc_observer.dart';
import 'package:crypto_pair_trade/resources/network/network_connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'di/di_initializer.dart';

void main() {
  defaultMain();
}

defaultMain() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocOverrides.runZoned(
    () {
      DI().initialize();
      runApp(const CryptoApp());
    },
    blocObserver: AppBlocObserver(),
  );
}

class CryptoApp extends StatefulWidget {
  const CryptoApp({Key? key}) : super(key: key);

  @override
  State<CryptoApp> createState() => _CryptoAppState();
}

class _CryptoAppState extends State<CryptoApp> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    CryptoConnectivity().monitorConnectivity(scaffoldKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop(animated: true);
        return true;
      },
      child: MaterialApp(
        home: Routes.splashPage,
        routes: Routes.appRoutes,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: const Color(0xFF6E00F8)),
        onGenerateRoute: (s) => Routes.onGenerateRoute(s),
      ),
    );
  }
}

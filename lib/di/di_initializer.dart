import 'package:crypto_pair_trade/modules/crypto_trade_route/data/crypto_trade_repository.dart';
import 'package:crypto_pair_trade/resources/network/network_connectivity.dart';
import 'package:crypto_pair_trade/webservice/http/http_client.dart';
import 'package:crypto_pair_trade/webservice/http/uri_builder.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';

class DI {
  initialize() {
    var injector = Injector();

    //Network Manager
    injector.map<CryptoConnectivity>(
      (injector) => CryptoConnectivity(),
      isSingleton: false,
    );

    //URI Builder
    injector.map<UriBuilder>(
      (injector) => UriBuilder(
          baseUrlAuthority: "www.bitstamp.net"),
      isSingleton: false,
    );

    //Http Client
    injector.map<HttpClient>(
      (injector) => AppHttpClient(uriBuilder: injector.get()),
      isSingleton: true,
    );

    //CryptoTrade Repository
    injector.map<CryptoTradeRepository>(
      (injector) => CryptoTradeRepositoryImpl(
        httpClient: injector.get(),
        uriBuilder: injector.get(),
        networkManager: injector.get(),
      ),
      isSingleton: false,
    );
  }
}

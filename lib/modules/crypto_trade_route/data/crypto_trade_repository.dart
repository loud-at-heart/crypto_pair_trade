import 'package:crypto_pair_trade/models/currency_data.dart';
import 'package:crypto_pair_trade/models/error_response.dart';
import 'package:crypto_pair_trade/models/order_book_data.dart';
import 'package:crypto_pair_trade/resources/network/network_connectivity.dart';
import 'package:crypto_pair_trade/webservice/base_repository.dart';
import 'package:crypto_pair_trade/webservice/data_load_result.dart';
import 'package:crypto_pair_trade/webservice/http/http_client.dart';
import 'package:crypto_pair_trade/webservice/http/uri_builder.dart';

abstract class CryptoTradeRepository extends BaseRepository {
  CryptoTradeRepository(CryptoConnectivity networkManager)
      : super(networkManager);

  Future<DataLoadResult<dynamic>> requestCurrencyData({
    String? currency,
  });

  Future<DataLoadResult<dynamic>> requestOrderBookData({
    String? currency,
  });
}

class CryptoTradeRepositoryImpl extends CryptoTradeRepository {
  final HttpClient httpClient;
  final UriBuilder uriBuilder;

  CryptoTradeRepositoryImpl({
    required this.httpClient,
    required CryptoConnectivity networkManager,
    required this.uriBuilder,
  }) : super(networkManager);

  @override
  Future<DataLoadResult<dynamic>> requestCurrencyData(
      {String? currency}) async {
    final uri = uriBuilder.getCurrencyData(currency: currency ?? '');

    final request = createJSONRequest(RequestMethods.GET, uri);

    final response = await httpClient.sendRequest(request);

    if (response.isSuccessful()) {
      return DataLoadResult(
          data: CurrencyData.fromJson(response.getBodyJsonMap()!));
    } else if (response.response!.statusCode == 477) {
      return DataLoadResult<ErrorResponse>(
          error: LoadingError.HTTP_INTERNAL_SERVER_ERROR,
          data: ErrorResponse.fromJson(response.getBodyJsonMap()!));
    } else {
      throw throwException(response);
    }
  }

  @override
  Future<DataLoadResult<dynamic>> requestOrderBookData(
      {String? currency}) async {
    final uri = uriBuilder.getOrderBookData(currency: currency ?? '');

    final request = createJSONRequest(RequestMethods.GET, uri);

    final response = await httpClient.sendRequest(request);

    if (response.isSuccessful()) {
      return DataLoadResult(
          data: OrderBookData.fromJson(response.getBodyJsonMap()!));
    } else if (response.response!.statusCode == 477) {
      return DataLoadResult<ErrorResponse>(
          error: LoadingError.HTTP_INTERNAL_SERVER_ERROR,
          data: ErrorResponse.fromJson(response.getBodyJsonMap()!));
    } else {
      throw throwException(response);
    }
  }

  throwException(ServerResponse response) {
    throw DataLoadResult<ErrorResponse>(
        error: LoadingError.HTTP_INTERNAL_SERVER_ERROR,
        data: ErrorResponse.fromJson(response.getBodyJsonMap()!));
  }
}

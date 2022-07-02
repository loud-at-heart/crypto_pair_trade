import 'package:crypto_pair_trade/resources/network/network_connectivity.dart';
import 'package:crypto_pair_trade/utils/mock_server.dart';

import 'data_load_result.dart';

class BaseRepository with MockServer {
  final CryptoConnectivity networkManager;

  BaseRepository(this.networkManager);

  Future<DataLoadResult<T>> getNoConnectionResult<T>() {
    return Future.value(
      DataLoadResult<T>(error: LoadingError.NO_CONNECTION),
    );
  }

  Future<DataLoadResult<T>> getRequestFailedResult<T>({
    String? errorMessage,
  }) {
    return Future.value(
      DataLoadResult<T>(
        error: LoadingError.SERVER_REQUEST_FAILED,
        errorMessage: errorMessage,
      ),
    );
  }

  Future<DataLoadResult<T>> getSpecificRequestFailedResult<T>(
      LoadingError error) {
    return Future.value(
      DataLoadResult<T>(error: error),
    );
  }

  Future<DataLoadResult<T>> errorSaveRequest<T>(
    Future<DataLoadResult<T>> Function()? requestBody,
  ) async {
    try {
      bool hasConnection = await hasConnectivity();
      if (!hasConnection) {
        return getNoConnectionResult<T>();
      }
      final result = await requestBody?.call();
      return Future.value(result);
    } catch (e) {
      return getRequestFailedResult<T>();
    }
  }
}

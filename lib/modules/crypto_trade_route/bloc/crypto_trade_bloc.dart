import 'package:crypto_pair_trade/models/currency_data.dart';
import 'package:crypto_pair_trade/models/order_book_data.dart';
import 'package:crypto_pair_trade/modules/crypto_trade_route/data/crypto_trade_repository.dart';
import 'package:crypto_pair_trade/webservice/data_load_result.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'crypto_trade_event.dart';

part 'crypto_trade_state.dart';

class CryptoTradeBloc extends Bloc<CryptoTradeEvent, CryptoTradeState> {
  CryptoTradeBloc({
    this.cryptoTradeRepository,
  }) : super(CryptoTradeInitial()) {
    on<CryptoTradeEvent>(_handleCurrencyDataFromServer);
  }

  final CryptoTradeRepository? cryptoTradeRepository;

  Future<void> _handleCurrencyDataFromServer(
    CryptoTradeEvent event,
    Emitter<CryptoTradeState> emit,
  ) async {
    if (event is GetCurrencyData) {
      if (event.currency.isNotEmpty) {
        emit(LoadingState(showLoader: true));
        var result = await cryptoTradeRepository!
            .requestCurrencyData(currency: event.currency);
        if (result.isSuccessful()) {
          var orderDataRes = await cryptoTradeRepository!
              .requestOrderBookData(currency: event.currency);
          if (orderDataRes.isSuccessful()) {
            emit(ServerResponse(
              currencyData: result.data,
              orderBookData: orderDataRes.data,
            ));
            emit(LoadingState(showLoader: false));
          } else {
            emit(LoadingState(showLoader: false));
            _handleErrorState(orderDataRes, emit);
          }
        } else {
          emit(LoadingState(showLoader: false));
          _handleErrorState(result, emit);
        }
      } else {
        emit(NoInputState());
      }
    }
  }

  Stream<CryptoTradeState> _handleErrorState(
    DataLoadResult result,
    Emitter<CryptoTradeState> emit,
  ) async* {
    if (result.error == LoadingError.NO_CONNECTION) {
      emit(NoInternetState());
    } else {
      emit(RequestFailedWithMessageState(errorMessage: result.errorMessage!));
    }
  }
}

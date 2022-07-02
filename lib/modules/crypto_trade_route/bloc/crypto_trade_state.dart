part of 'crypto_trade_bloc.dart';

@immutable
abstract class CryptoTradeState {}

class CryptoTradeInitial extends CryptoTradeState {}

class NoInternetState extends CryptoTradeState {}

class NoInputState extends CryptoTradeState {}

class RequestFailedWithMessageState extends CryptoTradeState {
  final String errorMessage;

  RequestFailedWithMessageState({required this.errorMessage});
}

class LoadingState extends CryptoTradeState {
  final bool showLoader;

  LoadingState({required this.showLoader});
}

class ServerResponse extends CryptoTradeState {
  final CurrencyData currencyData;
  final OrderBookData orderBookData;

  ServerResponse({required this.currencyData, required this.orderBookData});
}

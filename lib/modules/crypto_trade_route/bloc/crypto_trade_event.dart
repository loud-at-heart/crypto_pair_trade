part of 'crypto_trade_bloc.dart';

@immutable
abstract class CryptoTradeEvent {}

class GetCurrencyData extends CryptoTradeEvent {
  final String currency;

  GetCurrencyData({
    required this.currency,
  });
}

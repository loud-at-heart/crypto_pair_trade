// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrencyData _$CurrencyDataFromJson(Map<String, dynamic> json) => CurrencyData(
      high: json['high'] as String?,
      last: json['last'] as String?,
      timestamp: json['timestamp'] as String?,
      bid: json['bid'] as String?,
      vwap: json['vwap'] as String?,
      volume: json['volume'] as String?,
      low: json['low'] as String?,
      ask: json['ask'] as String?,
      open: json['open'] as String?,
    );

Map<String, dynamic> _$CurrencyDataToJson(CurrencyData instance) =>
    <String, dynamic>{
      'high': instance.high,
      'last': instance.last,
      'timestamp': instance.timestamp,
      'bid': instance.bid,
      'vwap': instance.vwap,
      'volume': instance.volume,
      'low': instance.low,
      'ask': instance.ask,
      'open': instance.open,
    };

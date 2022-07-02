// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_book_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderBookData _$OrderBookDataFromJson(Map<String, dynamic> json) =>
    OrderBookData(
      timestamp: json['timestamp'] as String?,
      microtimestamp: json['microtimestamp'] as String?,
      bids: (json['bids'] as List<dynamic>?)
          ?.map((e) => e as List<dynamic>)
          .toList(),
      asks: (json['asks'] as List<dynamic>?)
          ?.map((e) => e as List<dynamic>)
          .toList(),
    );

Map<String, dynamic> _$OrderBookDataToJson(OrderBookData instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp,
      'microtimestamp': instance.microtimestamp,
      'bids': instance.bids,
      'asks': instance.asks,
    };

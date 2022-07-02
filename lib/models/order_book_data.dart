import 'package:json_annotation/json_annotation.dart';

part 'order_book_data.g.dart';

@JsonSerializable()
class OrderBookData {
  String? timestamp;
  String? microtimestamp;
  List<List>? bids;
  List<List>? asks;

  OrderBookData({this.timestamp, this.microtimestamp, this.bids, this.asks});

  factory OrderBookData.fromJson(Map<String, dynamic> data) =>
      _$OrderBookDataFromJson(data);

  Map<String, dynamic> toJson() => _$OrderBookDataToJson(this);
}
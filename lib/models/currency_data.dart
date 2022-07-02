import 'package:json_annotation/json_annotation.dart';

part 'currency_data.g.dart';

@JsonSerializable()
class CurrencyData {
  String? high;
  String? last;
  String? timestamp;
  String? bid;
  String? vwap;
  String? volume;
  String? low;
  String? ask;
  String? open;

  CurrencyData(
      {this.high,
      this.last,
      this.timestamp,
      this.bid,
      this.vwap,
      this.volume,
      this.low,
      this.ask,
      this.open});

  factory CurrencyData.fromJson(Map<String, dynamic> data) =>
      _$CurrencyDataFromJson(data);

  Map<String, dynamic> toJson() => _$CurrencyDataToJson(this);
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'price_span.freezed.dart';

@freezed
class PriceSpan with _$PriceSpan {
  const factory PriceSpan({
    required double min,
    required double max,
    double? avg,
  }) = _PriceSpan;
}

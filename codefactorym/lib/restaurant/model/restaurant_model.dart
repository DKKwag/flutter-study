import 'package:codefactorym/common/const/data.dart';
import 'package:codefactorym/common/utils/data_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant_model.g.dart';

enum RestaurantPriceRange {
  expensive,
  medium,
  cheap,
}

//파일이 변경되었을때 터미널에 flutter pub run build_runner build
//프로젝트 파일이 수시로 변경될때에는 flutter pub run build_runner watch
@JsonSerializable()
class RestuarantModel {
  final String id;
  final String name;
  @JsonKey(
    fromJson: DataUtils.pathToURl,
  )
  final String thumbUrl;
  final List<String> tags;
  final RestaurantPriceRange priceRange;
  final double ratings;
  final int ratingsCount;
  final int deliveryTime;
  final int deliveryFee;

  RestuarantModel({
    required this.id,
    required this.name,
    required this.thumbUrl,
    required this.tags,
    required this.priceRange,
    required this.ratings,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
  });

  factory RestuarantModel.fromJson(Map<String, dynamic> json) =>
      _$RestuarantModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestuarantModelToJson(this);

  // 기존 방식
  // factory RestuarantModel.fromJson({
  //   required Map<String, dynamic> jsosn,
  // }) {
  //   return RestuarantModel(
  //     id: json['id'],
  //     name: json['name'],
  //     thumbUrl: 'http://$ip${json['thumbUrl']}',
  //     tags: List<String>.from(json['tags']),
  //     priceRange: RestaurantPriceRange.values
  //         .firstWhere((e) => e.name == json['priceRange']),
  //     ratings: json['ratings'],
  //     ratingsCount: json['ratingsCount'],
  //     deliveryTime: json['deliveryTime'],
  //     deliveryFee: json['deliveryFee'],
  //   );
  // }
}

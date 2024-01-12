import 'package:codefactorym/common/const/data.dart';
import 'package:codefactorym/common/dio/dio.dart';
import 'package:codefactorym/common/model/cursor_pagination_model.dart';
import 'package:codefactorym/common/model/pagination_params.dart';
import 'package:codefactorym/restaurant/model/restaurant_detail_model.dart';
import 'package:codefactorym/restaurant/model/restaurant_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'restaurant_repository.g.dart';

final restaurantRepositoryProvider = Provider<RestaurantRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final reposiotry =
      RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant');

  return reposiotry;
});

@RestApi()
abstract class RestaurantRepository {
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
      _RestaurantRepository;
  // http://$ip/restaurant/
  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPagination<RestaurantModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });

  // http://$ip/restaurant/{id}
  @GET('/{id}')
  @Headers({
    'accessToken': 'true',
  })
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id,
  });
}

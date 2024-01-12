import 'package:codefactorym/common/model/cursor_pagination_model.dart';
import 'package:codefactorym/common/model/pagination_params.dart';
import 'package:codefactorym/restaurant/model/restaurant_model.dart';
import 'package:codefactorym/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantDetailProvider =
    Provider.family<RestaurantModel?, String>((ref, id) {
  final state = ref.watch(restaurantProvider);

  if (state is! CursorPagination) {
    return null;
  }
  return state.data.firstWhere((element) => element.id == id);
});

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(restaurantRepositoryProvider);
  final notifier = RestaurantStateNotifier(repository: repository);
  return notifier;
});

class RestaurantStateNotifier extends StateNotifier<CursorPaginationBase> {
  final RestaurantRepository repository;
  RestaurantStateNotifier({
    required this.repository,
  }) : super(CursorPaginationLoading()) {
    paginate();
  }

  Future<void> paginate({
    int fetchCount = 20,
    // fetchMore은 추가로 데이터를 더 가져와라(true면) false면 새로고침(현재상태를 덮어씌움)
    bool fetchMore = false,
    // 강제로 다시 로딩
    //true일 경우 - CursorPaginationLoading()
    bool forceRefetch = false,
  }) async {
    // final resp = await repository.paginate();

    // state = resp;
    //State 상태에 대한 5가지 가능성이 있음

    //1. [상태] CursorPagination - 정상적으로 데이터가 있는 상태
    //2. [상태] CursorPaginationLoading - 데이터가 로딩중인 상태 (현재 캐시 없음)
    //3. [상태] CursorPaginationError - 에러가 있는 상태
    //4. [상태] CursorPaginationRefetching - 첫 번째 페이지부터 다시 데이터를 가져 올 때
    //5. [상태] CursorPaginationFetchMore - 추가 데이터를 paginate해오라는 요청을 받았을 때

    // 바로 반환하는 상황
    // 1) hasMore = false (기존 상태에서 이미 다음 데이터가 없다는 값을 들고있다면)
    // 2) fetchMore = true (로딩 중 일때)
    //    fetchMore가 아닐 때 - 새로고침의 의도가 있을 수 있다.
    // 1)에 대한 반환 상황
    try {
      if (state is CursorPagination && !forceRefetch) {
        final pState = state as CursorPagination;
        if (!pState.meta.hasMore) {
          return;
        }
      }
      // 2)에 대한 반환 상황
      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      //PaginationParams 생성
      PaginationParams paginationParams = PaginationParams(
        count: fetchCount,
      );

      //fetchMore 데이터를 추가로 더 가져오는 상황
      if (fetchMore) {
        final pState = state as CursorPagination;

        state = CursorPaginationFetchingMore(
          data: pState.data,
          meta: pState.meta,
        );

        paginationParams = paginationParams.copyWith(
          after: pState.data.last.id,
        );
      }
      //데이터를 처음부터 가져오는 상황
      else {
        //만약에 데이터가 있는 상황이라면, 기존 데이터를 보존한채로 Fetch (API요청)를 진행
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination;
          state = CursorPaginationRefetching(
            data: pState.data,
            meta: pState.meta,
          );
        }
        //그외 나머지 상황
        else {
          state = CursorPaginationLoading();
        }
      }

      final resp = await repository.paginate(
        paginationParams: paginationParams,
      );

      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore;

        //기존 데이터에 새로운 데이터 추가
        state = resp.copyWith(data: [
          ...pState.data,
          ...resp.data,
        ]);
      } else {
        state = resp;
      }
    } catch (e) {
      state = CursorPaginationError(message: '데이터를 가져오지 못했습니다.');
    }
  }

  getDetail({
    required String id,
  }) async {
    //만약에 아직 데이터가 하나도 없는 상태라면 (CursorPagination이 아니라면)
    //데이터를 가져오는 시도를 한다.
    if (state is! CursorPagination) {
      await paginate();
    }
    //state가 CursorPagination이 아닐때 그냥 리텅
    if (state is! CursorPagination) {
      return;
    }

    final pState = state as CursorPagination;
    final resp = await repository.getRestaurantDetail(id: id);

    state = pState.copyWith(
      data: pState.data
          .map<RestaurantModel>(
            (e) => e.id == id ? resp : e,
          )
          .toList(),
    );
  }
}

import 'package:actual/model/shopping_item_model.dart';
import 'package:actual/riverpod/state_notifier_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fillteredShoppingListProvider = Provider<List<ShoppingItemModel>>((ref) {
  final filterState = ref.watch(filterProvier);
  final shoppingListState = ref.watch(shoppingListProvider);

  if (filterState == FilterState.all) {
    return shoppingListState;
  }
  return shoppingListState
      .where((element) =>
          filterState == FilterState.spicy ? element.isSpicy : !element.isSpicy)
      .toList();
});

enum FilterState {
  //안매움
  notSpicy,
  //매움
  spicy,
  //전부
  all,
}

final filterProvier = StateProvider<FilterState>((ref) => FilterState.all);

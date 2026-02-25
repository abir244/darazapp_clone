// lib/viewmodels/product_viewmodel.dart
//
// Architecture note:
// All products are fetched once and held in [ProductViewModel].
// Category filtering happens in [categoryProductsProvider] on the client
// side, which avoids 3 separate network round-trips and keeps the
// refresh/loading logic in a single place.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../viewmodels/auth_viewmodel.dart'; // re-uses apiServiceProvider

// Tab categories shown in the UI.
// The empty string key "" means "All Products".
const List<({String label, String apiCategory})> kProductTabs = [
  (label: 'All', apiCategory: ''),
  (label: 'Electronics', apiCategory: 'electronics'),
  (label: 'Jewelery', apiCategory: 'jewelery'),
];

/// Owns all products and provides a manual refresh mechanism.
///
/// Vertical scroll owner justification (see README):
///   The single NestedScrollView in ProductScreen owns vertical scrolling.
///   ProductViewModel only owns DATA state, never scroll state.
class ProductViewModel extends AsyncNotifier<List<Product>> {
  @override
  Future<List<Product>> build() => _fetch();

  Future<List<Product>> _fetch() => ref.read(apiServiceProvider).getProducts();

  /// Pull-to-refresh: re-fetches and replaces state.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }
}

final productViewModelProvider =
    AsyncNotifierProvider<ProductViewModel, List<Product>>(
  ProductViewModel.new,
);

/// Derived provider: filters the master list by [apiCategory].
/// Empty string → all products.
final categoryProductsProvider =
    Provider.family<AsyncValue<List<Product>>, String>((ref, apiCategory) {
  final all = ref.watch(productViewModelProvider);
  if (apiCategory.isEmpty) return all;
  return all.whenData(
    (products) => products.where((p) => p.category == apiCategory).toList(),
  );
});

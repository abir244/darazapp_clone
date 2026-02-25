import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/product_viewmodel.dart';
import 'product_card.dart';

class ProductTabView extends ConsumerStatefulWidget {
  final String apiCategory;
  const ProductTabView({super.key, required this.apiCategory});
  @override
  ConsumerState<ProductTabView> createState() => _ProductTabViewState();
}

class _ProductTabViewState extends ConsumerState<ProductTabView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // Prevents scroll reset on tab switch

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final productsAsync =
        ref.watch(categoryProductsProvider(widget.apiCategory));

    return productsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
      data: (products) => CustomScrollView(
        primary: true, // Connects to NestedScrollView's outer controller
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ProductCard(product: products[index]),
              childCount: products.length,
            ),
          ),
        ],
      ),
    );
  }
}

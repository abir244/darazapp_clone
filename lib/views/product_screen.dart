// lib/views/product_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/product_viewmodel.dart';
import 'widgets/product_tab_view.dart';
import 'widgets/tab_bar_delegate.dart';
import 'profile_screen.dart'; // Ensure this import is added

class ProductScreen extends ConsumerStatefulWidget {
  const ProductScreen({super.key});
  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: kProductTabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        notificationPredicate: (n) => n.depth == 2,
        onRefresh: () => ref.read(productViewModelProvider.notifier).refresh(),
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              floating: true,
              snap: true,
              expandedHeight: 120,
              // --- ADDED ACTIONS HERE ---
              actions: [
                IconButton(
                  icon: const Icon(Icons.person_outline_rounded),
                  tooltip: 'Profile',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    );
                  },
                ),
                const SizedBox(width: 8),
              ],
              // --------------------------
              flexibleSpace: FlexibleSpaceBar(
                title: const Text("Daraz Shop",
                    style: TextStyle(color: Colors.white)),
                background: Container(color: Theme.of(context).primaryColor),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: StickyTabBarDelegate(
                TabBar(
                  controller: _tabController,
                  tabs: kProductTabs.map((t) => Tab(text: t.label)).toList(),
                ),
              ),
            ),
          ],
          body: TabBarView(
            controller: _tabController,
            children: kProductTabs
                .map((t) => ProductTabView(apiCategory: t.apiCategory))
                .toList(),
          ),
        ),
      ),
    );
  }
}

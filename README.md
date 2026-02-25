Daraz Clone — Flutter 2026 Hiring Task

A Daraz-style e-commerce product listing app built with Flutter, Riverpod, and MVVM architecture.
This project demonstrates Flutter skills such as nested scrolling, tabs, state management, and REST API integration with a real-world design pattern.

🔹 Demo Credentials

Pre-filled on login screen for easy testing:

Username: mor_2314

Password: 83r5^_

🚀 Quick Start
# Install dependencies
flutter pub get

# Run on device or emulator
flutter run

To build a release APK:

flutter build apk --release
📂 Project Structure
lib/
├── main.dart
├── models/
│   ├── product.dart          # Product + Rating data classes
│   └── user.dart             # UserProfile + nested classes
├── services/
│   └── api_service.dart      # Dio HTTP client (FakeStore API)
├── viewmodels/
│   ├── auth_viewmodel.dart   # Login, logout, register, token handling
│   └── product_viewmodel.dart # Product fetch, refresh, category filter
└── views/
    ├── login_screen.dart
    ├── register_screen.dart
    ├── product_screen.dart   # Core scroll + tab architecture
    ├── profile_screen.dart
    └── widgets/
        ├── product_card.dart
        └── tab_bar_delegate.dart
🏗 Architecture Decisions
1. Horizontal Swiping

Implemented with TabBarView (wraps PageView internally).

A single TabController keeps tabs and swipe gestures in sync.

Flutter automatically resolves horizontal vs vertical drags; no custom gestures required.

2. Vertical Scrolling

NestedScrollView is the single owner of vertical scroll.

Outer scroll drives the SliverAppBar (banner + search).

Inner scroll drives the product list (CustomScrollView).

Each tab’s inner scroll is registered with the parent automatically.

3. Pull-to-Refresh
RefreshIndicator(
  notificationPredicate: (notification) => notification.depth == 2,
)

Only vertical overscroll triggers refresh.

Horizontal swipes inside TabBarView don’t trigger refresh.

4. Tab Scroll Preservation

AutomaticKeepAliveClientMixin ensures each tab preserves its scroll position.

Switching tabs does not reset the list scroll.

5. Data Architecture

Fetch all 20 FakeStore products once in ProductViewModel.

Category filtering is client-side using Provider.family.

One network request → instant filtering → efficient UI updates.

⚖ Trade-offs & Limitations
Trade-off	Explanation
Shared header scroll	Switching between tabs may slightly re-expand the header.
NestedScrollView complexity	Internal coordination avoids scroll jitter but is more complex than naive solutions.
Client-side filtering	Fine for small datasets; large datasets would need server-side pagination.
Single user profile	JWT from /auth/login has no user ID; demo uses /users/1. In production, decode JWT.
🛠 Key Flutter APIs Used

NestedScrollView — coordinated scroll owner

SliverAppBar(floating: true, snap: true) — collapsible header

SliverPersistentHeader(pinned: true) — sticky tab bar

TabBarView / TabController — horizontal tab navigation

AutomaticKeepAliveClientMixin — scroll position preservation

RefreshIndicator(notificationPredicate:) — pull-to-refresh

CustomScrollView(primary: true) — inner scroll connection

AsyncNotifier (Riverpod 2.x) — async state management

Provider.family — parameterized derived providers

💡 Contributing

Fork the repo

Create a branch for your feature: git checkout -b feature-name

Make changes and commit: git commit -m "Description"

Push to your fork: git push origin feature-name

Open a pull request

📄 License

This project is for learning and hiring purposes only. Do not use commercially.

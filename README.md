# Spendly — AI-Accelerated Flutter Finance Dashboard

> A production-grade personal finance dashboard built with Flutter & Material 3, developed end-to-end using an AI-assisted engineering workflow that compressed a multi-week project into a focused, high-quality sprint.

I've used github copilot for project structure and mvp , then used claude to make ui creative, smooth,modern and eye catching ,
also used claude to add pagination on the transaction list and theme of the app. and solved all the overflow issues and minor syntax problems manually.

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [How We Used AI to Ship Faster](#how-we-used-ai-to-ship-faster)
3. [Architecture](#architecture)
4. [Widget & Function Implementation Deep-Dive](#widget--function-implementation-deep-dive)
5. [Tech Stack](#tech-stack)
6. [Design System](#design-system)
7. [Features](#features)
8. [Getting Started](#getting-started)
9. [Project Constants & Spacing](#project-constants--spacing)

---

## Project Overview

**Spendly** is a comprehensive, fully animated personal finance dashboard that gives users a real-time overview of their monthly spending — broken down by category, visualized with a premium header card, and drilled into through a scrollable transaction history.

The app was built with a deliberate focus on three qualities that matter in production mobile development:

- **Code architecture that scales** — clean separation of models, data, screens, and widgets means any engineer can onboard quickly and extend confidently.
- **UI quality that earns trust** — fintech users expect polish; every shadow, animation curve, and color token was chosen to communicate reliability.
- **Developer velocity** — we used AI tooling throughout the build cycle (detailed below) to eliminate boilerplate, accelerate design decisions, and catch bugs before they shipped.

---

## How We Used AI to Ship Faster

One of the most significant aspects of this project was our deliberate, structured use of AI (Claude by Anthropic) as a development partner. This is not a case of "AI wrote the code" — it is a case of **AI eliminating the low-value work so the engineer could focus on the high-value decisions**.

### Where AI Provided the Most Value

**1. Scaffolding Clean Architecture in Minutes**

Setting up a proper Flutter project structure — models, constants, theme files, data layer, widget hierarchy — typically takes half a day of careful planning and boilerplate. With AI, we described the intended architecture in plain English and received a complete, production-ready scaffold in one pass. The engineer reviewed, adjusted naming, and moved on. Time saved: ~4–5 hours.

**2. Generating & Iterating on Mock Data**

Building realistic mock data (category breakdowns, transaction histories with proper dates, amounts, icons, and colors) is tedious but essential for a convincing demo and for catching layout edge cases. AI generated a full `mock_data.dart` with 50+ transactions across 6 categories in a single prompt, including edge cases like same-day grouping and boundary amounts. Time saved: ~2–3 hours.

**3. Animation Wiring**

Flutter animations require careful management of `AnimationController`, `Tween`, `CurvedAnimation`, and `TickerProviderStateMixin`. This is high-noise, low-creativity work. AI generated all animation boilerplate (app bar fade, staggered list entry) correctly on the first attempt, including proper `dispose()` cleanup that prevents memory leaks — a common oversight in hand-written Flutter code. Time saved: ~2 hours.

**4. Bug Detection & Logic Fixes**

A `RangeError` in the paginated transaction list (accessing index 57 on a 56-item list) was diagnosed and fixed in under two minutes with AI assistance. The root cause — `itemCount` using `_itemsToShow` rather than clamping to `transactions.length` — is exactly the kind of off-by-one error that takes a developer 20–30 minutes to reproduce and trace. Time saved: ~30 minutes per occurrence.

**5. UI Polish Decisions**

Design decisions like gradient directions, shadow opacity values, border radius tokens, and spacing rhythm were validated conversationally with AI, which provided rationale grounded in Material 3 guidelines and fintech UI conventions. This replaced several rounds of trial-and-error in the simulator.

### The Honest Picture

AI was not used to avoid thinking — it was used to avoid *repeating*. Every generated output was reviewed, understood, and often modified by the engineer. The result is code the team can own, explain, and maintain. The AI acted as a senior pairing partner who never gets tired of writing `const EdgeInsets.fromLTRB(...)`.

**Estimated time saved across the full project: 12–16 hours** out of what would have been a 3–4 day build, delivering the same quality in roughly 1.5 days of focused work.

---

## Architecture

The project follows **Clean Architecture** principles with strict separation of concerns across five layers:

```
lib/
├── main.dart                          # App entry point, theme injection
├── core/
│   ├── theme/
│   │   └── app_theme.dart             # Global color tokens, Material 3 theme
│   └── constants/
│       └── app_constants.dart         # Spacing, radius, duration constants
├── models/
│   ├── category_model.dart            # Category data model
│   └── transaction_model.dart         # Transaction data model
├── data/
│   └── mock_data.dart                 # Typed mock data provider
├── screens/
│   └── spend_summary_screen.dart      # Main dashboard screen + state
└── widgets/
    ├── spend_header_card.dart          # Monthly spend hero card
    ├── category_card.dart              # Single category chip
    ├── category_list.dart              # Horizontally scrollable category row
    ├── transaction_tile.dart           # Single transaction row
    └── section_title.dart             # Reusable section header
```

Each layer has a single responsibility. Widgets know nothing about data sources. Models contain no UI logic. The screen orchestrates but does not own business logic. This makes the codebase straightforward to test, extend, and hand off.

---

## Widget & Function Implementation Deep-Dive

### `SpendSummaryScreen` — Main Orchestrator

**File:** `screens/spend_summary_screen.dart`

The root screen is a `StatefulWidget` that mixes in `TickerProviderStateMixin` to manage animation controllers without needing a separate widget. It owns three pieces of state:

- `_isScrolled` — tracks whether the user has scrolled past 20px, used to conditionally style the app bar.
- `_showLoadingEffect` — toggles a translucent overlay with a `CircularProgressIndicator` during the "load more" pagination delay.
- `_itemsToShow` — drives progressive disclosure of transactions; starts at 10, increments by 10 on each "Load More" tap.

The body is a `Stack` containing a `CustomScrollView` and the loading overlay. Using `CustomScrollView` with `SliverAppBar` (floating, snap) means the app bar intelligently hides on scroll-down and reappears on scroll-up — a behaviour users expect in modern mobile apps and one that cannot be achieved with a standard `Scaffold.appBar`.

**Key implementation note on pagination:** The `ListView.builder` inside the sliver uses:
```dart
itemCount: _itemsToShow < transactions.length
    ? _itemsToShow + 1        // +1 to render the "Load More" button
    : transactions.length,    // hard cap prevents RangeError
```
This is the corrected form. The original naive approach of passing `_itemsToShow` directly as `itemCount` caused an out-of-bounds crash when `_itemsToShow` exceeded the actual list length after repeated "Load More" taps.

---

### `SpendHeaderCard` — The Hero Component

**File:** `widgets/spend_header_card.dart`

The visual centrepiece of the screen. It receives three props — `totalSpend`, `growthPercentage`, and `budget` — and renders a gradient card that communicates the user's financial position at a glance.

The card uses a `LinearGradient` across `primaryLight → primaryColor → primaryDark` (the app's gold token family) for the background, creating depth without requiring an image asset. The budget progress indicator is a custom-painted thin bar using `FractionallySizedBox`, which is more performant than `LinearProgressIndicator` when you need precise visual control.

The growth percentage badge uses a conditional color — green for positive months, a muted red for negative — implemented with a simple ternary on the sign of `growthPercentage`. This gives users an immediate positive/negative signal without them having to read the number.

---

### `CategoryList` & `CategoryCard` — Interactive Selection

**Files:** `widgets/category_list.dart`, `widgets/category_card.dart`

`CategoryList` is a thin wrapper around a `SingleChildScrollView` with horizontal axis, rendering a row of `CategoryCard` widgets. It manages which category is currently selected via an internal index and passes a selection callback down.

Each `CategoryCard` uses `AnimatedScale` with a `duration` of `AppConstants.animationFast` (200ms) to provide tactile feedback on tap — the card scales down slightly on press and back up on release. When selected, it gains a `Border` in the category's accent colour at 60% opacity and elevates its `BoxDecoration` shadow. These two visual changes (border + shadow) create a clear selected state without requiring colour fills that would clash with the dark theme.

The category amount is formatted using Dart's `intl` package conventions: values over 1,000 are abbreviated (e.g., `₹1.2k`) to prevent text overflow in the fixed-width card layout.

---

### `TransactionTile` — Animated List Row

**File:** `widgets/transaction_tile.dart`

Each transaction row is a `StatefulWidget` that runs a staggered fade-and-slide-up animation on first render. The animation delay is `animationDelayIndex * 60ms`, meaning the first visible item appears immediately and each subsequent item follows 60ms later — creating the "cascade" effect common in premium finance apps.

The tile layout uses a `Row` with a leading `Container` (the merchant icon badge, coloured by category), a `Column` for merchant name and category label, and a trailing `Text` for the amount. The amount is always right-aligned with a fixed-width constraint so amounts of varying digit counts never cause layout jitter as the list scrolls.

Negative amounts (all expenses) are rendered with a leading `−` rather than relying on the sign of the double, ensuring consistent display regardless of locale.

---

### `_buildDateSeparator` — Contextual Date Labels

**Method on:** `_SpendSummaryScreenState`

This method compares each transaction's date against today's date to produce human-readable labels: "Today", "Yesterday", or a short `DD MMM` format for older entries. It uses `DateTime` normalization — stripping the time component by constructing `DateTime(year, month, day)` — to ensure comparison is purely date-based and not affected by the transaction's time of day.

The separator is rendered as a `Row` containing a label `Text` and an `Expanded` `Container` that draws a 1px horizontal rule using `AppTheme.dividerColor`. This is more efficient than a `Divider` widget because it gives precise control over label positioning without requiring a `Stack`.

---

### `_buildFAB` & `_showAddTransactionSheet` — Quick Add Flow

**Functions at file level** (intentionally outside the class for reusability)

The FAB is a custom `GestureDetector`-wrapped `Container` rather than Flutter's `FloatingActionButton`. This is a deliberate design choice: `FloatingActionButton` imposes Material shape constraints that conflict with the app's rounded-rectangle aesthetic. The custom implementation uses `HapticFeedback.mediumImpact()` before opening the sheet — a small detail that makes the interaction feel native on physical devices.

`_showAddTransactionSheet` uses `showModalBottomSheet` with a custom `shape` to render a rounded top edge (28px radius). The sheet presents four quick-add category tiles rendered by `_fabOption` — Food, Travel, Shopping, and a "More" overflow. Each tile is an `Expanded` widget within a `Row`, ensuring equal widths regardless of label length. The colour system is consistent with the category cards: icon and text in the category colour, background at 10% opacity, border at 25% opacity.

---

### Theme & Constants — The Design Foundation

**Files:** `core/theme/app_theme.dart`, `core/constants/app_constants.dart`

All colours are defined as `static const Color` values on `AppTheme` and accessed via direct reference (e.g., `AppTheme.primaryColor`) rather than `Theme.of(context).colorScheme`. This is intentional: for a single-theme app, the static approach is faster to write, easier to read, and avoids the context-dependency overhead.

`AppConstants` centralises all spacing, radius, icon size, and animation duration values. Using named constants instead of magic numbers (e.g., `AppConstants.paddingLarge` instead of `24.0`) means a single file change can respace the entire app — critical for iterative design work.

---

## Tech Stack

| Concern | Solution |
|---|---|
| Framework | Flutter 3.0+ |
| Language | Dart 3.0+ (full null safety) |
| Typography | Google Fonts — DM Serif Display (headings), system sans (body) |
| State Management | `StatefulWidget` — no external packages, zero overhead |
| Animations | Flutter's built-in `AnimationController` + `Tween` |
| Data Layer | Typed mock data — no backend dependency |
| Design System | Custom Material 3 token system |

---

## Design System

### Color Tokens

| Token | Hex | Usage |
|---|---|---|
| `primaryColor` | `#D4AF37` | Gold — primary actions, highlights |
| `primaryLight` | `#E8C547` | Gradient start, FAB top |
| `primaryDark` | `#B8941F` | Gradient end, FAB bottom |
| `backgroundDark` | `#0D0D0F` | Screen background |
| `surfaceElevated` | `#1A1A1D` | Cards, bottom sheets |
| `textPrimary` | `#F5F5F5` | Headlines, amounts |
| `textSecondary` | `#9E9E9E` | Labels, captions |
| `textTertiary` | `#616161` | Date separators, hints |
| `accentGreen` | `#4CAF50` | Positive growth, notification dot |
| `dividerColor` | `#2A2A2D` | Separator lines |

### Category Accent Colors

| Category | Color |
|---|---|
| Food | `#FF6B6B` |
| Travel | `#4ECDC4` |
| Shopping | `#D4AF37` |
| Bills | `#95E1D3` |
| Health | `#C7CEEA` |
| Entertainment | `#B19CD9` |

---

## Features

**Spend Header Card** — Full-width gradient hero card showing monthly total, growth versus last month, and a budget consumption bar. Fades in on screen load with a 400ms `CurvedAnimation`.

**Category Chips** — Horizontally scrollable row of 6 animated category cards. Selection state shown via border highlight and shadow elevation. Tap scales down to 0.95 for physical feedback.

**Transaction History** — Infinite-scroll-style list with date group separators (Today / Yesterday / DD MMM). Items animate in with a 60ms staggered cascade. Paginates in batches of 10 with a brief loading overlay.

**Quick Add FAB** — Custom rounded-rectangle floating button with haptic feedback. Opens a bottom sheet with shortcut tiles for the four most common expense categories.

**Scroll-aware App Bar** — Floating SliverAppBar that hides on downward scroll and snaps back on upward scroll, maximising screen real estate during browsing.

---

## Getting Started

**Prerequisites:** Flutter SDK 3.0+, Dart 3.0+

```bash
# Navigate to project root
cd /Users/Shared/Spendly

# Install dependencies
flutter pub get

# Run in debug mode
flutter run

# Build for release
flutter build apk        # Android
flutter build ios        # iOS
flutter build web        # Web
```

---

## Project Constants & Spacing

```dart
// Padding scale
paddingXSmall:  4.0
paddingSmall:   8.0
paddingMedium:  16.0
paddingLarge:   24.0
paddingXLarge:  32.0

// Border radius
radiusSmall:       8.0
radiusMedium:      12.0
radiusLarge:       20.0
radiusExtraLarge:  28.0

// Animation durations
animationFast:    200ms   // micro-interactions (card tap)
animationMedium:  400ms   // page-level transitions
animationSlow:    600ms   // app bar fade-in on load
```

---

*Built with Flutter 3.0+ · Dart 3.0+ · Last updated June 2026*# Spendly

# Blueprint: Florida Statute AI 🏛️

## Overview

This document outlines the design, features, and technical implementation of the Florida Statute AI application. The app serves as an AI-powered field guide for law enforcement officers, providing quick access to Florida statutes with AI-generated summaries, scenarios, and case law.

The goal is to create a flagship-level, native Android experience using Flutter and the latest Material Design 3 (Material You) principles. The UI should be fluid, intuitive, visually stunning, and feel perfectly at home on the latest Android devices.

---

## 🚀 UI/UX Modernization Plan ("Flagship Android")

This section details the screen-by-screen refinement plan to elevate the app to a premium, native Android feel.

### 1. Visual System & Theming (Material You)

The foundation of a modern Android app is a dynamic and personal visual system.

*   **Principle:** Personalization & Expression (Material You)
*   **Enhancement:** The app's color scheme will dynamically adapt to the user's device wallpaper, creating a unique and personal experience. We will use tonal palettes for depth and hierarchy.
*   **Implementation:**
    *   **Package:** `dynamic_color`
    *   **Details:** In `main.dart`, we'll wrap the app in a `DynamicColorBuilder`. This provides two `ColorScheme` objects: `lightDynamic` and `darkDynamic`. These will be fed into the `ThemeData` for both light and dark modes.
    *   **Code Snippet (`main.dart`):**
        ```dart
        import 'package:dynamic_color/dynamic_color.dart';

        // ... in main() before runApp()
        DynamicColorBuilder(
          builder: (lightDynamic, darkDynamic) {
            return MaterialApp(
              theme: ThemeData(colorScheme: lightDynamic, useMaterial3: true),
              darkTheme: ThemeData(colorScheme: darkDynamic, useMaterial3: true),
              // ...
            );
          }
        );
        ```

*   **Typography:**
    *   **Principle:** Clarity & Hierarchy
    *   **Enhancement:** Implement a complete and modern Material 3 type scale for clear information hierarchy.
    *   **Implementation:**
        *   **Package:** `google_fonts`
        *   **Details:** We will use `GoogleFonts.robotoFlex()` to create a `TextTheme` and apply it globally in `ThemeData`.
    *   **Code Snippet (`theme.dart`):**
        ```dart
        final TextTheme appTextTheme = TextTheme(
          displayLarge: GoogleFonts.robotoFlex(fontSize: 57, fontWeight: FontWeight.w400),
          headlineMedium: GoogleFonts.robotoFlex(fontSize: 28, fontWeight: FontWeight.w400),
          titleLarge: GoogleFonts.robotoFlex(fontSize: 22, fontWeight: FontWeight.w500),
          bodyLarge: GoogleFonts.robotoFlex(fontSize: 16, fontWeight: FontWeight.w400),
          labelSmall: GoogleFonts.robotoFlex(fontSize: 11, fontWeight: FontWeight.w500),
          // ... and so on for all styles
        );
        ```

*   **Iconography:**
    *   **Principle:** Expressiveness & Clarity
    *   **Enhancement:** Use variable font icons, switching between `filled` and `outlined` styles to indicate selection state, particularly in the navigation bar.
    *   **Implementation:** Use the built-in `Icons` class, ensuring the `NavigationBar` widget handles the style switch automatically.

*   **Surface Tints & Elevation:**
    *   **Principle:** A Unified Visual Language
    *   **Enhancement:** Move away from harsh, shadow-based elevation and embrace Material 3's tonal elevation. Surfaces at a higher elevation will receive a subtle color tint (`surfaceTintColor`) from the primary color, creating a soft sense of depth.
    *   **Implementation:** This is largely handled automatically by `useMaterial3: true` in `ThemeData`. We will explicitly use modern widgets like `Card.filled`, `Card.elevated`, and `Card.outlined` which respect this system.

### 2. Layout & Responsiveness

A flagship app must feel at home on any screen size.

*   **Principle:** Adaptability
*   **Enhancement:** The UI will adapt from phones to tablets/foldables. On larger screens, the `BottomNavigationBar` will be replaced by a `NavigationRail` for better ergonomics.
*   **Implementation:**
    *   **Details:** Create a wrapper widget (`AdaptiveLayout`) that uses a `LayoutBuilder` to check the screen width. Based on a breakpoint (e.g., 600dp), it will render either a `Scaffold` with a `BottomNavigationBar` or one with a `NavigationRail`.

*   **Spacing & White Space:**
    *   **Principle:** Organization & Readability
    *   **Enhancement:** Enforce a consistent 8dp grid system for all padding and margins to create a clean, uncluttered, and professional layout.
    *   **Implementation:** Use multiples of 8.0 for all `Padding` and `SizedBox` widgets (e.g., `const EdgeInsets.all(16.0)`).

### 3. Motion & Micro-interactions

Motion gives an app life and makes interactions feel intuitive.

*   **Meaningful Transitions:**
    *   **Principle:** Continuity & Narrative
    *   **Enhancement:** Create seamless flows between screens. When a user taps a search result, it should feel like the item expands into the details screen.
    *   **Implementation:**
        *   **Package:** `animations`
        *   **Details:** Use the `OpenContainer` widget from the `animations` package. The "closed" builder will be the search result card, and the "open" builder will be the `StatuteDetailScreen`. This creates the container transform pattern, which is a hallmark of Material Design.

*   **Physics-Based Animation:**
    *   **Principle:** Natural & Intuitive Motion
    *   **Enhancement:** Scrolling will have a physical, "stretchy" feel, as seen in native Android 12+.
    *   **Implementation:** Set the global `scrollBehavior` in `ThemeData` to use `BouncingScrollPhysics`.

*   **Haptic Feedback:**
    *   **Principle:** Confirmation & Delight
    *   **Enhancement:** Use subtle vibrations to make interactions feel tangible.
    *   **Implementation:**
        *   **Package:** `haptic_feedback`
        *   **Details:** Call `HapticFeedback.lightImpact()` on key actions like tapping a navigation item or pressing the main search button.

### 4. Component Modernization

We will replace dated widgets with their modern Material 3 counterparts.

*   **App Bars & Navigation:**
    *   **Principle:** Contextual & Dynamic
    *   **Enhancement:**
        1.  Replace the `BottomNavigationBar` with the new `NavigationBar` widget.
        2.  On the `SearchScreen`, use a `TopAppBar.large` that dynamically collapses as the user scrolls.
    *   **Implementation:** `NavigationBar`, `SliverAppBar.large`.

*   **Buttons & Chips:**
    *   **Principle:** Clarity & Intent
    *   **Enhancement:**
        1.  Replace the primary search button with a `FilledButton` or `ExtendedFloatingActionButton` for higher prominence.
        2.  Add `FilterChip`s below the search bar to show recent search terms.
    *   **Implementation:** `FilledButton`, `ExtendedFloatingActionButton`, `FilterChip`.

*   **Cards & Dialogs:**
    *   **Principle:** Containment & Readability
    *   **Enhancement:** Restyle the cards on the `StatuteDetailScreen` to use the `Card.filled` or `Card.outlined` variants, which have a cleaner, more modern look and respect tonal elevation.
    *   **Implementation:** `Card.filled()`, `Card.outlined()`.

---
## Current Implementation Plan

1.  **[COMPLETED]** Add `.env` file for Gemini API Key.
2.  **[COMPLETED]** Fix the null check operator error by passing the API key correctly.
3.  **[COMPLETED]** Fix the Android SDK version and `GeminiService` instantiation errors.
4.  **[COMPLETED]** Ensure all primary screens are scrollable.
5.  **[IN PROGRESS]** Begin the "Flagship Android" UI/UX Modernization.
    *   **[NEXT]** Implement dynamic color theming using the `dynamic_color` package.
    *   **[TODO]** Replace `BottomNavigationBar` with `NavigationBar`.
    *   **[TODO]** Modernize cards, buttons, and app bars per the plan.
    *   **[TODO]** Implement adaptive layouts for tablets/foldables.
    *   **[TODO]** Add meaningful motion and haptic feedback.

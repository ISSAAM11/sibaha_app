# Shibaha Design System

A comprehensive guide to the visual identity and design tokens used in the Shibaha Flutter application. This system ensures consistency across all screens and enables rapid, scalable development.

---

## 1. Overview

Shibaha's design system is built on the following principles:

- **Single Source of Truth**: All colors, typography, spacing, and border radius are defined once and referenced throughout the app
- **Material Design 3**: The app uses Flutter's Material 3 specifications for modern, accessible UI
- **Lexend Typography**: A custom sans-serif font (9 weights: Thin to Black) provides a clean, professional appearance
- **Accessible Color Palette**: High-contrast colors meet WCAG AA standards for text readability
- **Responsive Spacing**: A modular 4dp base unit scales consistently across all screen sizes

### File Structure

```
lib/core/theme/
├── app_colors.dart          # Color tokens
├── app_text_styles.dart     # Typography presets
├── app_spacing.dart         # Spacing scale
├── app_border_radius.dart   # Border radius tokens
└── app_theme.dart           # Unified ThemeData
```

---

## 2. Color Palette

All colors are defined in `app_colors.dart` and serve specific semantic purposes across the UI.

| Token Name | Hex Value | RGB | Usage |
|---|---|---|---|
| **primary** | `#0058BC` | (0, 88, 188) | Primary CTAs, active states, focused inputs, interactive elements |
| **primaryContainer** | `#0070EB` | (0, 112, 235) | Background highlights, gradient overlays, decorative blobs |
| **onPrimary** | `#FFFFFF` | (255, 255, 255) | Text/icons on primary-colored backgrounds (buttons, chips) |
| **onSurface** | `#1C1B1B` | (28, 27, 27) | Primary text, headings, body copy |
| **onSurfaceVariant** | `#414755` | (65, 71, 85) | Secondary text, captions, labels (reduced prominence) |
| **outline** | `#717786` | (113, 119, 134) | Input field borders (enabled state), dividers |
| **outlineVariant** | `#C1C6D7` | (193, 198, 215) | Subtle borders, placeholder text, disabled states |
| **surfaceContainerLow** | `#F6F3F2` | (246, 243, 242) | Input field backgrounds, subtle container fills |
| **errorColor** | `#BA1A1A` | (186, 26, 26) | Error text, error states, validation failures |
| **errorContainer** | `#FFADAD` | (255, 173, 173) | Error message backgrounds, soft error highlights |
| **secondaryFixedDim** | `#00DBE7` | (0, 219, 231) | Decorative elements, secondary gradient blobs (water theme) |

### Color Usage Guidelines

- **Buttons & CTAs**: `AppColors.primary` with `onPrimary` text
- **Text**: `onSurface` for primary, `onSurfaceVariant` for secondary
- **Input Borders**: `outline` (enabled), `primary` (focused), `errorColor` (error state)
- **Backgrounds**: `surfaceContainerLow` for input fields; white for cards
- **Errors**: `errorColor` for text, `errorContainer` for background
- **Decorative**: `primaryContainer` and `secondaryFixedDim` for blobs and gradients

---

## 3. Typography

Typography is defined in `app_text_styles.dart` using the **Lexend** font family (configured in `pubspec.yaml` with 9 weights).

### Text Styles

| Style Name | Font Size | Weight | Line Height | Letter Spacing | Usage |
|---|---|---|---|---|---|
| **screenTitle** | 32px | w600 | 1.0 | -0.32 | Page headlines (Verify Identity, Join Sibaha) |
| **subtitle** | 16px | w400 | 1.5 | 0 | Descriptive paragraphs beneath headlines |
| **fieldLabel** | 14px | w600 | 1.0 | 0.7 | Input labels (grey variant) |
| **fieldLabelPrimary** | 14px | w600 | 1.0 | 0.7 | Input labels (primary blue variant) |
| **fieldInput** | 16px | w400 | 1.0 | 0 | User-typed text inside inputs |
| **buttonLabel** | 14px | w600 | 1.0 | 0.7 | Button text |
| **linkPrimary** | 12px | w500 | 1.0 | 0 | Small action links (Resend Code, Forgot Password?) |
| **bodyLink** | 16px | w600 | 1.0 | 0 | Inline action links (Log In) |
| **caption** | 12px | w500 | 1.0 | 0 | Small captions (Didn't receive the code?) |
| **errorText** | 14px | w400 | 1.0 | 0 | Inline error messages |

### Material 3 Theme Styles

The following Material Design 3 text styles are also available via `Theme.of(context).textTheme`:

| Style | Size | Weight | Usage |
|---|---|---|---|
| `displayLarge` | 48px | w700 | Large display text (rare usage) |
| `headlineLarge` | 32px | w600 | Major headings |
| `headlineMedium` | 24px | w600 | Secondary headings |
| `titleLarge` | 16px | w600 | Card titles, section headers |
| `bodyLarge` | 18px | w400 | Large body text |
| `bodyMedium` | 16px | w400 | Standard body copy |
| `labelLarge` | 14px | w600 | Emphasis labels |
| `labelMedium` | 12px | w600 | Medium labels |
| `labelSmall` | 12px | w500 | Small labels |

### Typography Usage

- **Prefer `AppTextStyles` presets** over custom `TextStyle()` declarations
- All custom styles inherit the **Lexend** font family from `AppTheme.lightTheme`
- Letter spacing is tuned per style for optical balance (not uniform)

---

## 4. Spacing Scale

Spacing is defined in `app_spacing.dart` using a **4dp base unit** for responsive consistency.

| Token | Value (dp) | Multiplier | Typical Usage |
|---|---|---|---|
| **xs** | 4 | 1x | Tiny gaps (icon-text spacing within buttons) |
| **sm** | 8 | 2x | Small gaps between adjacent elements |
| **smMd** | 10 | 2.5x | Minor spacing adjustments |
| **md** | 12 | 3x | Standard gaps within form rows, small containers |
| **mdLg** | 14 | 3.5x | Subtle spacing increases |
| **lg** | 16 | 4x | Standard padding inside cards, margin between stacked inputs |
| **lgXl** | 20 | 5x | Breathing room between form sections |
| **xl** | 24 | 6x | Major padding (cards, screens), gaps between distinct sections |
| **xxl** | 32 | 8x | Large spacing (header margins, bottom spacing) |
| **xxxl** | 48 | 12x | Very large margins (between major screen sections) |
| **huge** | 64 | 16x | Maximum spacing (rarely used) |

### Spacing Patterns

```dart
// Input field padding
padding: EdgeInsets.symmetric(
  horizontal: AppSpacing.lg,  // 16dp sides
  vertical: AppSpacing.lg,     // 16dp top/bottom
)

// Card padding
padding: EdgeInsets.all(AppSpacing.xl),  // 24dp on all sides

// Gap between stacked form fields
SizedBox(height: AppSpacing.lg)  // 16dp

// Screen-level padding (safe from edges)
padding: EdgeInsets.fromLTRB(
  AppSpacing.xl, AppSpacing.xxxl,  // left: 24dp, top: 48dp
  AppSpacing.xl, AppSpacing.xl,    // right: 24dp, bottom: 24dp
)
```

---

## 5. Border Radius

Border radius tokens are defined in `app_border_radius.dart` for consistent corner rounding.

| Token | Value (dp) | Used On | Notes |
|---|---|---|---|
| **xs** | 4 | Small buttons, minor UI elements | Minimal rounding |
| **sm** | 8 | Input field borders, small cards | Subtle rounding |
| **md** | 12 | Input fields, form cards, chips | Standard rounding |
| **lg** | 16 | Glass cards, major containers | Prominent rounding |
| **xl** | 24 | Large decorative cards | Large rounded corners |
| **pill** | 50 | Button shapes (stadium border) | Fully rounded pill shape |

### BorderRadius Objects (Pre-made)

For convenience, pre-made `BorderRadius` objects are available:

| Object | Value |
|---|---|
| `zeroRadius` | `BorderRadius.zero` — no rounding |
| `xsRadius` | 4dp all corners |
| `smRadius` | 8dp all corners |
| `mdRadius` | 12dp all corners |
| `lgRadius` | 16dp all corners |
| `xlRadius` | 24dp all corners |
| `pillRadius` | 50dp all corners |

### Border Radius Usage

```dart
// Using numeric constant
BorderRadius.circular(AppBorderRadius.md)  // 12dp

// Using pre-made object
ClipRRect(borderRadius: AppBorderRadius.lgRadius)  // 16dp

// In DecoratedBox
decoration: BoxDecoration(
  borderRadius: AppBorderRadius.mdRadius,
  border: Border.all(color: AppColors.outline),
)
```

---

## 6. Theme Configuration

### `app_theme.dart` Overview

The `AppTheme` class centralizes all theme configuration in a single source of truth. It exports `lightTheme`, a complete `ThemeData` object that wires together:

- **Typography**: Custom text styles from `app_text_styles.dart`
- **Colors**: All colors from `app_colors.dart`
- **Spacing**: Referenced in layouts (not stored in ThemeData)
- **Border Radius**: Dialog theme and component shapes

### How Themes Are Applied

**In `main.dart` or app initialization:**

```dart
void main() {
  runApp(
    MaterialApp.router(
      title: 'Shibaha',
      theme: AppTheme.lightTheme,
      routerConfig: router,
    ),
  );
}
```

**In `initial_screen.dart` (current implementation):**

```dart
return MaterialApp.router(
  title: 'Sibaha',
  debugShowCheckedModeBanner: false,
  routerConfig: _router,
  theme: AppTheme.lightTheme,  // ← Single source of truth
);
```

### ThemeData Structure

```
AppTheme.lightTheme
├── Material 3 enabled (useMaterial3: true)
├── Font family: Lexend
├── Primary color: #0058BC
├── Color scheme (light):
│   ├── primary: AppColors.primary
│   └── onError: AppColors.onSurface
├── Text theme: 9 Material 3 styles (displayLarge → labelSmall)
├── Dialog shape: No rounding (BorderRadius.zero)
└── Hover color: Colors.grey[200]
```

### Future Enhancements

- **Dark Theme**: Add `darkTheme` getter to `AppTheme` for dark mode support
- **Dynamic Colors**: Integrate Material You (dynamic color extraction from wallpaper)
- **Custom Component Themes**: Define `InputDecorationTheme`, `ElevatedButtonThemeData`, etc. in `app_theme.dart`

---

## 7. Usage Examples

### Colors

**❌ Never do this:**
```dart
Text(
  'Welcome',
  style: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: Color(0xFF0058BC),  // Hardcoded color ❌
  ),
)
```

**✅ Always do this:**
```dart
import 'package:sibaha_app/core/theme/app_colors.dart';

Text(
  'Welcome',
  style: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,  // Reusable token ✅
  ),
)
```

### Text Styles

**❌ Never do this:**
```dart
Text(
  'Verify Identity',
  style: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
    letterSpacing: -0.32,
  ),
)
```

**✅ Always do this:**
```dart
import 'package:sibaha_app/core/theme/app_text_styles.dart';

Text(
  'Verify Identity',
  style: AppTextStyles.screenTitle,  // Reusable preset ✅
)
```

### Spacing

**❌ Never do this:**
```dart
Padding(
  padding: EdgeInsets.all(24),  // Magic number ❌
  child: Column(
    children: [
      Text('Email'),
      SizedBox(height: 16),  // Magic number ❌
      TextField(),
    ],
  ),
)
```

**✅ Always do this:**
```dart
import 'package:sibaha_app/core/theme/app_spacing.dart';

Padding(
  padding: EdgeInsets.all(AppSpacing.xl),  // 24dp ✅
  child: Column(
    children: [
      Text('Email'),
      SizedBox(height: AppSpacing.lg),  // 16dp ✅
      TextField(),
    ],
  ),
)
```

### Border Radius

**❌ Never do this:**
```dart
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12),  // Magic number ❌
    border: Border.all(color: Colors.grey),
  ),
)
```

**✅ Always do this:**
```dart
import 'package:sibaha_app/core/theme/app_border_radius.dart';

Container(
  decoration: BoxDecoration(
    borderRadius: AppBorderRadius.mdRadius,  // 12dp ✅
    border: Border.all(color: AppColors.outline),
  ),
)
```

### Combined Example: A Complete Form Card

```dart
import 'package:flutter/material.dart';
import 'package:sibaha_app/core/theme/app_colors.dart';
import 'package:sibaha_app/core/theme/app_text_styles.dart';
import 'package:sibaha_app/core/theme/app_spacing.dart';
import 'package:sibaha_app/core/theme/app_border_radius.dart';

class LoginCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppBorderRadius.lgRadius,
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Email', style: AppTextStyles.fieldLabelPrimary),
          SizedBox(height: AppSpacing.sm),
          TextField(
            decoration: InputDecoration(
              hintText: 'name@example.com',
              border: OutlineInputBorder(
                borderRadius: AppBorderRadius.mdRadius,
                borderSide: BorderSide(color: AppColors.outline),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                shape: StadiumBorder(),  // pill shape
              ),
              child: Text('Sign In', style: AppTextStyles.buttonLabel),
            ),
          ),
        ],
      ),
    );
  }
}
```

### Using Theme Text Styles in Custom Widgets

Material 3 theme styles are accessible via `Theme.of(context).textTheme`:

```dart
Text(
  'Page Title',
  style: Theme.of(context).textTheme.headlineLarge,  // 32px / w600
)

Text(
  'Section heading',
  style: Theme.of(context).textTheme.titleLarge,  // 16px / w600
)
```

---

## Checklist for Designers & Developers

- [ ] **Always import** the relevant theme file (`app_colors.dart`, `app_text_styles.dart`, etc.)
- [ ] **Never hardcode** colors, sizes, spacing, or border radius
- [ ] **Reuse presets** — if a style doesn't exist, create it in the appropriate theme file rather than defining inline
- [ ] **Use `const`** wherever possible for performance
- [ ] **Test in light mode** — dark mode support will be added in the future
- [ ] **Name tokens clearly** — a token name should indicate its purpose (e.g., `fieldLabelPrimary` vs. `fieldLabel`)

---

## Quick Reference

| Need | File | Example |
|---|---|---|
| A color | `app_colors.dart` | `AppColors.primary` |
| A text style | `app_text_styles.dart` | `AppTextStyles.screenTitle` |
| Padding/margin | `app_spacing.dart` | `EdgeInsets.all(AppSpacing.xl)` |
| Border radius | `app_border_radius.dart` | `BorderRadius.circular(AppBorderRadius.md)` |
| Complete theme | `app_theme.dart` | `theme: AppTheme.lightTheme` |

---

## Support

For questions, additions, or updates to the design system:

1. Update the relevant theme file in `lib/core/theme/`
2. Run `flutter analyze` to ensure no regressions
3. Update this documentation to reflect changes
4. Commit with a clear message (e.g., `"design: add new buttonSmall text style"`)

---

**Last Updated**: April 2026  
**Font**: Lexend (9 weights, Thin–Black)  
**Material Design Version**: Material 3  
**Flutter Version**: 3.6.1+

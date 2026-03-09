# Usability Testing Suite

This directory contains automated tests for all usability features (User Stories 7, 9, 10, 11, 14, 15).

## Test Files

### 1. `test_theme_toggle.dart` - US 9: Light/Dark Mode Toggle
**8 test cases** covering:
- Theme toggle visibility
- Theme switching functionality
- Theme persistence
- Readability in both modes
- Accessibility labels

### 2. `test_loading_indicators.dart` - US 14: Better Loading Indicators
**6 test cases** covering:
- Login loading indicator visibility
- Loading indicator timing (< 100ms)
- Button disabled state during loading
- Loading indicator styling
- Multiple loading prevention

### 3. `test_error_messages.dart` - US 15: Improved Error Messages
**8 test cases** covering:
- Validation error messages
- User-friendly messaging (no technical jargon)
- Error visibility and styling
- Error dismissal
- Actionable error content

### 4. `test_keyboard_navigation.dart` - US 10: Keyboard Navigation
**10 test cases** covering:
- Tab navigation through forms
- Enter key submission
- Keyboard types and input actions
- Focus indicators
- Logical navigation order

### 5. `test_accessibility.dart` - US 11: Accessibility Labels
**10 test cases** covering:
- Icon tooltips
- Form field labels
- Semantic widgets
- Screen reader compatibility
- Descriptive button text

### 6. `test_responsive_layout.dart` - US 7: Responsive Layout
**15 test cases** covering:
- Multiple screen sizes (600x800 to 1920x1080)
- Text scaling (1.0x to 2.0x)
- Portrait and landscape orientation
- No horizontal overflow
- Minimum touch target sizes

## Running the Tests

### Run All Usability Tests
```bash
flutter test test/test_theme_toggle.dart test/test_loading_indicators.dart test/test_error_messages.dart test/test_keyboard_navigation.dart test/test_accessibility.dart test/test_responsive_layout.dart
```

### Run Individual Test Files
```bash
# Theme Toggle Tests
flutter test test/test_theme_toggle.dart

# Loading Indicators Tests
flutter test test/test_loading_indicators.dart

# Error Messages Tests
flutter test test/test_error_messages.dart

# Keyboard Navigation Tests
flutter test test/test_keyboard_navigation.dart

# Accessibility Tests
flutter test test/test_accessibility.dart

# Responsive Layout Tests
flutter test test/test_responsive_layout.dart
```

### Run All Tests
```bash
flutter test
```

### Run Tests with Coverage
```bash
flutter test --coverage
```

## Test Summary

| User Story | Feature | Test File | Test Count |
|------------|---------|-----------|------------|
| US 9 | Light/Dark Mode Toggle | `test_theme_toggle.dart` | 8 |
| US 14 | Better Loading Indicators | `test_loading_indicators.dart` | 6 |
| US 15 | Improved Error Messages | `test_error_messages.dart` | 8 |
| US 10 | Keyboard Navigation | `test_keyboard_navigation.dart` | 10 |
| US 11 | Accessibility Labels | `test_accessibility.dart` | 10 |
| US 7 | Responsive Layout | `test_responsive_layout.dart` | 15 |
| **TOTAL** | | | **57** |

## Test Output

Each test prints a success message when it passes:
```
✓ Test X.X PASSED: [Description]
```

Some tests may be skipped if certain features are not implemented:
```
⚠ Test X.X SKIPPED: [Reason]
```

## Continuous Integration

These tests can be integrated into your CI/CD pipeline:

```yaml
# Example GitHub Actions workflow
- name: Run Usability Tests
  run: flutter test test/test_*.dart
```

## Notes

- Tests are designed to be **automated** and **repeatable**
- All tests follow Flutter widget testing best practices
- Tests verify both **functionality** and **accessibility**
- Some tests may require network connectivity (for login/register flows)
- Tests use `pumpAndSettle()` to wait for animations to complete

## Comparison with Manual Testing

These automated tests complement the manual `USABILITY_TESTING_CHECKLIST.md`:

| Aspect | Automated Tests | Manual Checklist |
|--------|----------------|------------------|
| Speed | Fast (seconds) | Slow (minutes) |
| Repeatability | 100% consistent | May vary |
| Coverage | Code-level verification | User experience |
| Subjective feedback | No | Yes |
| CI/CD Integration | Yes | No |

**Recommendation**: Use both automated tests for regression testing and manual checklist for UX evaluation.

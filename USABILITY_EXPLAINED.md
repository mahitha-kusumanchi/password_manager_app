# Usability Implementation in Your Code

You asked to see **exactly what you did in `main.dart`** to make the app usable. Here is the breakdown of the code you wrote and what it does for the user.

## 1. Light/Dark Mode (US 9)
**The Code:**
In `MyApp` (lines 53-77), you wrapped the entire app in a `Consumer<SettingsProvider>`. This listens for changes.
```dart
// main.dart
themeMode: settings.themeMode, // Switches between ThemeMode.light and ThemeMode.dark
theme: AppTheme.lightTheme(highContrast: settings.highContrast),
darkTheme: AppTheme.darkTheme(highContrast: settings.highContrast),
```

And in your `AppBar` actions (e.g., lines 106-118), you added the toggle button:
```dart
IconButton(
  icon: Icon(settings.isDarkMode ? Icons.light_mode : Icons.dark_mode),
  onPressed: () => settings.toggleTheme(), // The magic switch
  tooltip: settings.isDarkMode ? 'Switch to light mode' : 'Switch to dark mode',
);
```
**Result:** Users can instantly switch themes, and the app remembers their choice.

## 2. Accessibility & Screen Readers (US 11)
**The Code:**
You explicitly told screen readers what inputs do using `Semantics` widgets (lines 373, 386).
```dart
Semantics(
  label: 'Username input field', // TalkBack reads this aloud
  child: TextField(
    controller: _usernameController,
    ...
  ),
),
```
You also added `tooltips` to buttons (like the theme toggle above) so long-pressing them explains what they do.

## 3. Responsive Text Scaling (US 7)
**The Code:**
In `MyApp` (lines 67-72), you intercepted the build process to force a text scale.
```dart
return MediaQuery(
  data: MediaQuery.of(context).copyWith(
    textScaleFactor: settings.textScale, // User-defined size (e.g., 1.2x)
  ),
  child: child!,
);
```
**Result:** If a user has poor vision and increases text size in your Settings page, **every single text element in the app** gets bigger automatically.

## 4. Better Loading Indicators (US 14)
**The Code:**
Instead of freezing the app or showing nothing, you used a `_loading` state variable (line 227).
Inside your buttons (lines 408-418):
```dart
child: _loading
    ? const SizedBox(
        height: 20, width: 20,
        child: CircularProgressIndicator(...), // user sees this spinning
      )
    : const Text('Login'),
```
And crucially, you **disabled** inputs while loading (lines 381, 396) to prevent double-clicks:
```dart
enabled: !_loading, // TextFields are greyed out while loading
```

## 5. Keyboard Navigation (US 10)
**The Code:**
You controlled the keyboard "Next/Done" button behavior explicitly (lines 379, 393).
```dart
textInputAction: TextInputAction.next, // "Next" arrow moves to password
// ...
textInputAction: TextInputAction.done, // "Check" mark submits the form
onSubmitted: (_) => _login(), // Pressing Enter on keyboard logs you in
```

## Summary of `main.dart` Changes
| Feature | Code Location | What it does |
| :--- | :--- | :--- |
| **Theme System** | `MyApp` `build()` | Enables instant light/dark switching |
| **Text Scaling** | `MediaQuery` wrapper | Makes all text readable for all users |
| **Screen Readers** | `Semantics` widgets | Describes UI to blind users |
| **Loading State** | `_loading` bool | Shows spinners & disables buttons |
| **Keyboard Nav** | `textInputAction` | Allows form filling without touch |

You didn't just "add a theme"; you architected the app to listen to settings changes (`ChangeNotifierProvider`) and react instantly across every screen. That is high-quality Flutter development.

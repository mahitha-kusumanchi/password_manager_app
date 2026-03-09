# Usability Testing Checklist
## Password Manager Application

**Tester Name:** ___________________  
**Date:** ___________________  
**Device/Platform:** ___________________  
**Screen Resolution:** ___________________

---

## Test Instructions

For each test case below:
1. Follow the steps exactly as described
2. Mark the result: ✅ Pass | ❌ Fail | ⚠️ Partial
3. Add notes about any issues or observations
4. Rate the experience (1-5 stars) where applicable

---

## US 9: Light/Dark Mode Toggle

### Test Case 1.1: Theme Toggle Visibility
**Objective:** Verify theme toggle is easy to find

**Steps:**
1. Launch the application
2. Look for the theme toggle button (should be visible on login page)
3. Note the time taken to locate it

**Expected Result:**
- Theme toggle is clearly visible
- Icon/button is intuitive (sun/moon icon)
- Located in a logical position (top-right corner or settings)

**Result:** [ ] Pass | [ ] Fail | [ ] Partial  
**Time to locate:** _____ seconds  
**Notes:** ___________________________________

---

### Test Case 1.2: Theme Switching Functionality
**Objective:** Verify smooth transition between light and dark modes

**Steps:**
1. Click/tap the theme toggle button
2. Observe the transition animation
3. Check all UI elements for proper color changes
4. Toggle back to original theme

**Expected Result:**
- Smooth transition animation (no flickering)
- All text remains readable
- All icons/buttons adapt to new theme
- Transition completes within 1 second

**Result:** [ ] Pass | [ ] Fail | [ ] Partial  
**Transition smoothness (1-5):** ⭐⭐⭐⭐⭐  
**Notes:** ___________________________________

---

### Test Case 1.3: Theme Persistence
**Objective:** Verify theme preference is saved

**Steps:**
1. Switch to dark mode
2. Close the application completely
3. Reopen the application
4. Check if dark mode is still active

**Expected Result:**
- Theme preference is remembered
- App opens in the last selected theme

**Result:** [ ] Pass | [ ] Fail | [ ] Partial  
**Notes:** ___________________________________

---

### Test Case 1.4: Theme Readability
**Objective:** Ensure both themes are readable and comfortable

**Steps:**
1. Switch to light mode
2. Read all text on screen (login form, labels, buttons)
3. Switch to dark mode
4. Read all text again
5. Rate comfort level for each

**Expected Result:**
- All text is clearly readable in both modes
- Sufficient contrast between text and background
- No eye strain after 2 minutes of use

**Light Mode Readability (1-5):** ⭐⭐⭐⭐⭐  
**Dark Mode Readability (1-5):** ⭐⭐⭐⭐⭐  
**Result:** [ ] Pass | [ ] Fail | [ ] Partial  
**Notes:** ___________________________________

---

## US 14: Better Loading Indicators

### Test Case 2.1: Login Loading Indicator
**Objective:** Verify loading feedback during login

**Steps:**
1. Enter valid credentials
2. Click "Login" button
3. Observe loading indicator appearance
4. Wait for login to complete

**Expected Result:**
- Loading indicator appears immediately (< 100ms)
- Indicator is clearly visible
- User understands something is happening
- Login button is disabled during loading

**Result:** [ ] Pass | [ ] Fail | [ ] Partial  
**Indicator clarity (1-5):** ⭐⭐⭐⭐⭐  
**Notes:** ___________________________________

---

### Test Case 2.2: Password List Loading
**Objective:** Verify loading state when fetching passwords

**Steps:**
1. Successfully log in
2. Observe the password list loading
3. Note the loading indicator style

**Expected Result:**
- Loading indicator shows while fetching data
- Skeleton screens or spinner is displayed
- No blank screen during loading
- Smooth transition when data appears

**Result:** [ ] Pass | [ ] Fail | [ ] Partial  
**Loading experience (1-5):** ⭐⭐⭐⭐⭐  
**Notes:** ___________________________________

---

### Test Case 2.3: Add/Edit Password Loading
**Objective:** Verify loading feedback during save operations

**Steps:**
1. Click "Add Password" button
2. Fill in password details
3. Click "Save"
4. Observe loading indicator

**Expected Result:**
- Save button shows loading state
- User cannot click save again during operation
- Success/failure feedback appears after loading

**Result:** [ ] Pass | [ ] Fail | [ ] Partial  
**Notes:** ___________________________________

---

## US 15: Improved Error Messages

### Test Case 3.1: Login Error - Wrong Password
**Objective:** Verify clear error message for incorrect credentials

**Steps:**
1. Enter valid username
2. Enter incorrect password
3. Click "Login"
4. Read the error message

**Expected Result:**
- Error message is clearly visible
- Message is specific: "Incorrect password" or similar
- Message is not technical/cryptic
- User understands what went wrong

**Result:** [ ] Pass | [ ] Fail | [ ] Partial  
**Error message shown:** ___________________________________  
**Message clarity (1-5):** ⭐⭐⭐⭐⭐  
**Notes:** ___________________________________

---

### Test Case 3.2: Network Error Handling
**Objective:** Verify error message when server is unreachable

**Steps:**
1. Disconnect from network OR stop the vault-server
2. Try to log in
3. Read the error message

**Expected Result:**
- Error message explains connection issue
- Message suggests checking internet connection
- No technical jargon (no stack traces)
- Retry option is available

**Result:** [ ] Pass | [ ] Fail | [ ] Partial  
**Error message shown:** ___________________________________  
**Helpfulness (1-5):** ⭐⭐⭐⭐⭐  
**Notes:** ___________________________________

---

### Test Case 3.3: Validation Errors
**Objective:** Verify helpful validation messages

**Steps:**
1. Try to add a password with empty title
2. Try to add a password with empty password field
3. Read validation messages

**Expected Result:**
- Validation errors appear near the relevant field
- Messages are specific (e.g., "Title is required")
- Red color or icon indicates error
- User knows exactly what to fix

**Result:** [ ] Pass | [ ] Fail | [ ] Partial  
**Notes:** ___________________________________

---

### Test Case 3.4: Error Message Dismissal
**Objective:** Verify errors can be easily dismissed

**Steps:**
1. Trigger any error message
2. Look for a way to dismiss it
3. Dismiss the error

**Expected Result:**
- Error can be dismissed (X button or auto-dismiss)
- Error doesn't block the entire UI
- Dismissal is intuitive

**Result:** [ ] Pass | [ ] Fail | [ ] Partial  
**Notes:** ___________________________________

---

## US 10: Keyboard Navigation

### Test Case 4.1: Tab Navigation on Login
**Objective:** Verify keyboard navigation through login form

**Steps:**
1. Open the application
2. Press Tab key repeatedly
3. Observe focus moving through: Username → Password → Login Button

**Expected Result:**
- Tab key moves focus in logical order
- Current focused element is clearly highlighted
- All interactive elements are reachable via keyboard

**Result:** [ ] Pass | [ ] Fail | [ ] Partial  
**Tab order logical:** [ ] Yes | [ ] No  
**Focus indicators visible:** [ ] Yes | [ ] No  
**Notes:** ___________________________________

---

### Test Case 4.2: Enter Key Submission
**Objective:** Verify Enter key submits forms

**Steps:**
1. Enter username
2. Press Tab to move to password field
3. Enter password
4. Press Enter key (without clicking Login button)

**Expected Result:**
- Enter key submits the login form
- No need to use mouse to click Login

**Result:** [ ] Pass | [ ] Fail | [ ] Partial  
**Notes:** ___________________________________

---

### Test Case 4.3: Keyboard Navigation in Password List
**Objective:** Verify keyboard navigation through password entries

**Steps:**
1. Log in successfully
2. Use Tab/Arrow keys to navigate password list
3. Try to select a password using keyboard only

**Expected Result:**
- Can navigate through password list with keyboard
- Can select/open password details with Enter key
- Focus indicators are clear

**Result:** [ ] Pass | [ ] Fail | [ ] Partial  
**Notes:** ___________________________________

---

### Test Case 4.4: Escape Key Functionality
**Objective:** Verify Escape key closes dialogs/modals

**Steps:**
1. Open "Add Password" dialog
2. Press Escape key
3. Verify dialog closes

**Expected Result:**
- Escape key closes open dialogs
- Returns to previous screen
- No data is saved

**Result:** [ ] Pass | [ ] Fail | [ ] Partial  
**Notes:** ___________________________________

---

### Test Case 4.5: Keyboard Shortcuts
**Objective:** Test common keyboard shortcuts

**Steps:**
1. Try Ctrl+N or Cmd+N (New password)
2. Try Ctrl+F or Cmd+F (Search)
3. Try Ctrl+S or Cmd+S (Save)

**Expected Result:**
- At least basic shortcuts work
- Shortcuts are documented somewhere
- Shortcuts don't conflict with browser shortcuts

**Result:** [ ] Pass | [ ] Fail | [ ] Partial  
**Working shortcuts:** ___________________________________  
**Notes:** ___________________________________

---

## US 11: Accessibility Labels

### Test Case 5.1: Screen Reader - Login Page
**Objective:** Verify screen reader compatibility on login

**Steps:**
1. Enable screen reader (Windows Narrator / macOS VoiceOver)
2. Navigate through login page
3. Listen to announcements for each element

**Expected Result:**
- Username field is announced clearly
- Password field is announced as "password" field
- Login button is announced with its purpose
- All labels are meaningful

**Result:** [ ] Pass | [ ] Fail | [ ] Partial  
**Screen reader used:** ___________________________________  
**Notes:** ___________________________________

---

### Test Case 5.2: Icon Accessibility
**Objective:** Verify icons have text alternatives

**Steps:**
1. Enable screen reader
2. Navigate to icons (theme toggle, add button, etc.)
3. Listen to announcements

**Expected Result:**
- All icons have descriptive labels
- Labels describe the action (e.g., "Toggle dark mode")
- No icon is announced as just "button"

**Result:** [ ] Pass | [ ] Fail | [ ] Partial  
**Notes:** ___________________________________

---

### Test Case 5.3: Form Field Labels
**Objective:** Verify all form fields have proper labels

**Steps:**
1. Open "Add Password" form
2. Check each field has a visible label
3. Verify labels are associated with inputs

**Expected Result:**
- Every input field has a clear label
- Labels are positioned logically (above or beside field)
- Placeholder text doesn't replace labels

**Result:** [ ] Pass | [ ] Fail | [ ] Partial  
**Notes:** ___________________________________

---

## US 7: Responsive Layout

### Test Case 6.1: Window Resizing
**Objective:** Verify layout adapts to different window sizes

**Steps:**
1. Start with maximized window
2. Resize window to 1024x768
3. Resize to 800x600
4. Resize to minimum allowed size

**Expected Result:**
- Layout adjusts smoothly
- No horizontal scrolling
- All content remains accessible
- No overlapping elements

**Result:** [ ] Pass | [ ] Fail | [ ] Partial  
**Minimum usable width:** _____ px  
**Notes:** ___________________________________

---

### Test Case 6.2: Password List Responsiveness
**Objective:** Verify password list adapts to screen size

**Steps:**
1. View password list in full screen
2. Resize window to smaller size
3. Observe how password cards/items adjust

**Expected Result:**
- Cards stack or resize appropriately
- Text doesn't overflow
- All information remains visible
- Scrolling works smoothly

**Result:** [ ] Pass | [ ] Fail | [ ] Partial  
**Notes:** ___________________________________

---

### Test Case 6.3: Dialog/Modal Responsiveness
**Objective:** Verify dialogs work on small screens

**Steps:**
1. Resize window to small size (800x600)
2. Open "Add Password" dialog
3. Check if all fields are accessible

**Expected Result:**
- Dialog fits within viewport
- All fields are accessible without horizontal scroll
- Dialog can be scrolled if needed
- Close button is always visible

**Result:** [ ] Pass | [ ] Fail | [ ] Partial  
**Notes:** ___________________________________

---

### Test Case 6.4: Text Scaling
**Objective:** Verify layout works with larger text sizes

**Steps:**
1. Increase system text size / zoom to 125%
2. Navigate through the app
3. Check for text overflow or layout breaks

**Expected Result:**
- Text scales appropriately
- No text is cut off
- Layout adjusts to accommodate larger text
- Remains usable at 150% zoom

**Result:** [ ] Pass | [ ] Fail | [ ] Partial  
**Notes:** ___________________________________

---

## Overall Usability Assessment

### Ease of Use (1-5 stars)
**Login Process:** ⭐⭐⭐⭐⭐  
**Finding Passwords:** ⭐⭐⭐⭐⭐  
**Adding New Password:** ⭐⭐⭐⭐⭐  
**Overall Navigation:** ⭐⭐⭐⭐⭐  

### Intuitiveness Questions

**Q1: Could you complete login without instructions?**  
[ ] Yes, easily | [ ] Yes, with some trial | [ ] No

**Q2: Could you find and view a saved password easily?**  
[ ] Yes, easily | [ ] Yes, with some trial | [ ] No

**Q3: Were error messages helpful in resolving issues?**  
[ ] Very helpful | [ ] Somewhat helpful | [ ] Not helpful

**Q4: Did you feel confident using the application?**  
[ ] Very confident | [ ] Somewhat confident | [ ] Not confident

**Q5: Would you recommend this app to others?**  
[ ] Definitely | [ ] Probably | [ ] Probably not | [ ] Definitely not

---

## Critical Issues Found

List any critical usability issues that must be fixed:

1. ___________________________________
2. ___________________________________
3. ___________________________________

---

## Suggestions for Improvement

List any suggestions to enhance usability:

1. ___________________________________
2. ___________________________________
3. ___________________________________

---

## Summary

**Total Test Cases:** 25  
**Passed:** _____  
**Failed:** _____  
**Partial:** _____  

**Overall Usability Rating (1-5):** ⭐⭐⭐⭐⭐

**Tester Signature:** ___________________  
**Date Completed:** ___________________

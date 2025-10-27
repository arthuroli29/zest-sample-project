# Zest Sample Project

This project was built according to the five requirements described in the assessment instructions.

Below you will find architecture details, technical decisions, and improvement notes.

---

## Design Architecture

**Pattern:** MVVM  
**State Management:** Reactive, using Apple’s new **Observation** framework.

This approach allows for a clean separation between the **View**, **ViewModel**, and **Model**.

---

## State Management

The project leverages the **Observation framework** introduced by Apple to handle reactive state updates.  
This ensures that SwiftUI views automatically reflect changes in the observed data, while UIKit components can manually track those changes when needed using `withObservationTracking`.

Although not yet the most conventional setup, this pattern provides a forward‑looking approach, being more SwiftUI‑centric and reducing boilerplate compared to traditional reactive patterns.

**Current setup:**
- Supports **iOS 17.6+**
- Uses **Observation** for both SwiftUI and UIKit
- UIKit observation currently handled through manual tracking with `withObservationTracking`

**Production considerations:**
- For this project, I chose Observation to demonstrate modern Swift patterns. Starting with iOS 18+, UIKit gains native integration with Observation, removing the need for manual `withObservationTracking` and making this approach even cleaner.
- However, if targeting production code where iOS 18+ adoption is uncertain or years away, **Combine + `ObservableObject` would be equally valid**. It's a mature, well-established pattern with broader platform support.
- The architecture would remain the same (MVVM), just with different reactive primitives.

## What Could Be Improved

- **Unit Testing:**  
  Add a full set of unit and snapshot tests to ensure behavior stability and prevent regressions.

- **Accessibility:**  
  Implement accessibility labels, roles, and dynamic type support to ensure a more inclusive user experience.

- **Caching:**  
  Implement caching strategies to avoid having to refetch everything every time.

- **Code Style and Formatting:**  
  Integrate **SwiftLint** or **SwiftFormat** to enforce consistent code style, improve readability, and catch common issues automatically.
---
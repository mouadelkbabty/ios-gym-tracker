# GymTracker – SwiftUI iOS App

A minimal, offline-first iPhone app for logging workouts, tracking progress, and planning gym splits (Push / Pull / Legs or any custom rotation).

---

## Features

| Feature | Details |
|---|---|
| Workout Logging | Add type, sets, reps, weight, date, favourite flag |
| Workout List | Sorted by date, search, swipe to delete/edit/favourite |
| Workout Detail | Volume calc, stats at a glance, inline edit |
| Progress Dashboard | Total logged, this-week count, favourites, goal progress bar |
| Split Planner | Create named splits with exercise lists, delete, reorder |
| Daily Suggestion | "Today's Split" cycles automatically; advance with one tap |
| Persistence | `UserDefaults` + `Codable` – no server, no subscription |

---

## Project Structure

```
GymTracker/
├── GymTrackerApp.swift          ← @main entry point
├── ContentView.swift            ← TabView (Home / Workouts / Splits)
│
├── Models/
│   ├── Workout.swift            ← Codable struct
│   ├── WorkoutSplit.swift       ← Codable struct
│   └── WorkoutStore.swift       ← ObservableObject (all data + UserDefaults I/O)
│
└── Views/
    ├── HomeView.swift           ← Dashboard: today's split + progress
    ├── WorkoutsView.swift       ← Full workout list with search + swipe actions
    ├── AddWorkoutView.swift     ← Add / edit form with quick-pick chips
    ├── WorkoutDetailView.swift  ← Stats, volume, favourite toggle
    ├── SplitsView.swift         ← Split list (today highlighted)
    └── AddSplitView.swift       ← Create a new split with exercise rows
```

---

## How to Open in Xcode (Mac required)

### 1 – Create a new Xcode project

1. Open **Xcode → File → New → Project…**
2. Choose **App** under iOS.
3. Fill in:
   - **Product Name:** `GymTracker`
   - **Interface:** SwiftUI
   - **Language:** Swift
   - **Storage:** None *(we handle it ourselves)*
4. Save the project somewhere on your Mac.

### 2 – Replace / add source files

Delete the generated `ContentView.swift` and `<AppName>App.swift`, then drag **all files from this folder** into the Xcode project navigator, keeping the `Models/` and `Views/` group structure.

Make sure **"Copy items if needed"** is checked when prompted.

### 3 – Run on your iPhone (Free – no paid account needed)

1. Plug your iPhone in via USB.
2. Trust the Mac on the iPhone if prompted.
3. In Xcode, select your iPhone as the **build destination** (top toolbar).
4. Sign the app: **Signing & Capabilities → Team → add your Apple ID** (free personal team is fine).
5. Press **⌘ R** – Xcode builds and installs the app directly.
6. On first launch you may need to go to **Settings → General → VPN & Device Management** and trust your developer certificate.

> Free provisioning profiles expire after **7 days**. Just re-run from Xcode to renew.

---

## Deploy to a Friend's iPhone

### Option A – TestFlight (requires paid $99/yr Apple Developer account)
1. Archive the app (**Product → Archive**).
2. Upload to App Store Connect.
3. Add the friend as an internal/external tester in TestFlight.

### Option B – AltStore / Sideloadly (free, no paid account)
1. Build a `.ipa` in Xcode (**Product → Archive → Distribute App → Ad Hoc** or use a free profile).
2. Your friend installs [AltStore](https://altstore.io) or [Sideloadly](https://sideloadly.io) on their PC/Mac.
3. Sideload the `.ipa` – must be re-signed every 7 days.

---

## Building on Windows (Cloud Mac)

Since iOS apps require Xcode (macOS only), Windows users can:

| Service | Notes |
|---|---|
| **MacStadium** | Rent a cloud Mac by the hour |
| **GitHub Codespaces** | Not Xcode-capable; Swift CLI only |
| **Ask a friend with a Mac** | Hand them this folder; they open Xcode and run ⌘R |
| **iPad – Swift Playgrounds 4** | Can build simple SwiftUI apps; Xcode features limited |

---

## Minimum Requirements

- iOS 16+
- Xcode 15+
- Swift 5.9+

---

## Potential Future Improvements

- [ ] `Charts` framework for weight/volume over time
- [ ] CloudKit sync across devices
- [ ] HealthKit calories integration
- [ ] Home screen widget (WidgetKit) showing today's split
- [ ] Apple Watch companion app
- [ ] Streak / consistency tracking

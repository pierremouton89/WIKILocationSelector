# WIKILocationSelector

An iOS application that lets users browse and select geographic locations to open directly in the [Wikipedia](https://www.wikipedia.org/) app.

---

## Overview

WIKILocationSelector fetches a list of named locations from a remote JSON API, displays them in a scrollable list, and lets the user open any location in the Wikipedia app via a deep link. Users can also type in custom latitude/longitude coordinates, add them to the list, or open them straight in Wikipedia — all from one screen.

---

## Features

- **Remote location list** — fetches locations from a public JSON endpoint on app launch.
- **Wikipedia deep linking** — taps a row to open that location in the Wikipedia iOS app (`wikipedia://places?location=…`).
- **Custom coordinates** — enter a name (optional) plus latitude and longitude to create a new location.
- **Add to list** — save a custom location to the in-session list.
- **Open directly** — open a custom coordinate pair in Wikipedia without adding it to the list.
- **Input validation** — latitude is clamped to `[-90, 90]` and longitude to `[-180, 180]`; the keyboard shows only numeric input.
- **Graceful fallback** — shows an alert when the Wikipedia app is not installed.

---

## Architecture

The project follows **Clean Architecture** with strict separation between three layers:

```
Presentation  →  Repository (Domain)  →  Data
```

Each layer communicates through **protocols**, making every component independently testable.

### Layer breakdown

| Layer | Purpose |
|---|---|
| **Data** | Raw HTTP networking and JSON decoding |
| **Repository** | Maps data transfer objects to domain entities |
| **Presentation** | UI, view models, navigation, and formatting |

---

## Key Components

### Data Layer

| File | Responsibility |
|---|---|
| `HTTPClient.swift` | Protocol for async HTTP GET requests; `URLSessionHTTPClient` is the production implementation backed by `URLSession`. |
| `LocationService.swift` | Protocol for fetching remote locations; the implementation requests `https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json` and decodes the response. |
| `LocationData.swift` | `Decodable` data transfer object that maps the JSON fields `name`, `lat`, and `long` to Swift properties. |

### Repository Layer

| File | Responsibility |
|---|---|
| `Location.swift` | Core domain entity — an `Equatable` and `Encodable` struct with an optional `name`, a required `latitude`, and a required `longitude`. |
| `LocationRepository.swift` | Protocol `LocationsRepository` with `async throws func retrieveLocations() -> [Location]`; the implementation converts `[LocationData]` into `[Location]`. |

### Presentation Layer

| File | Responsibility |
|---|---|
| `LocationsListViewController.swift` | Main `UIViewController`; owns the table view and the coordinate-capture form; binds to the view model via `Box` observables. |
| `LocationsListViewModel.swift` | MVVM view model; holds observable state for the location list, form fields, and button-enabled flags; performs async data loading and handles all user actions. |
| `LocationDisplayModel.swift` | Converts a `Location` into display-ready strings (formatted coordinate values). |
| `LocationCaptureView.swift` | Custom `UIView` with three text fields (Name, Latitude, Longitude) and two action buttons (Add, Open). |
| `LocationDegreeInputFormatter.swift` | Validates and clamps coordinate input in real time (`whileEditing`) and on blur (`whenDoneEditing`). |
| `LocationTableViewCell.swift` | Custom `UITableViewCell` that shows the location name, latitude, and longitude with an icon. |
| `AppRouter.swift` | Coordinator for navigation; creates the initial screen, shows alerts, and builds the Wikipedia deep link (base-64-encoded JSON) for a selected location. |
| `Box.swift` | Lightweight generic observable: `Box<T>` triggers its `bind` listener on the main thread whenever `value` changes. |
| `Design.swift` | Shared design constants for spacing values and font styles. |
| `Dependencies.swift` | Singleton dependency container that wires `URLSessionHTTPClient` → `LocationServiceImplementation` → `LocationsRepositoryImplementation`. |

---

## Data Flow

```
App launch
  └─► SceneDelegate
        └─► AppRouter.presentListScreen()
              └─► LocationsListViewController + LocationsListViewModel
                    └─► viewModel.loadContent()
                          └─► LocationsRepository.retrieveLocations()
                                └─► LocationService.loadLocations()
                                      └─► HTTPClient.get(url)
                                            └─► URLSession → JSON
                                                  └─► [LocationData] → [Location]
                                                        └─► Box<[LocationDisplayModel]> triggers table reload

User taps row
  └─► viewModel.selectLocation(index)
        └─► AppRouter.presentSelected(location)
              └─► wikipedia://places?location=<base64-json>

User enters coordinates and taps "Open"
  └─► viewModel.openLocation()
        └─► AppRouter.presentSelected(location)

User enters coordinates and taps "Add"
  └─► viewModel.addLocation()
        └─► Appends Location to displayModels → table reload
```

---

## Project Structure

```
WIKILocationSelector/
├── WIKILocationSelector/          # App source code
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   ├── Dependencies.swift
│   ├── Repository/
│   │   ├── Location.swift
│   │   └── LocationRepository.swift
│   ├── Data/
│   │   ├── HTTPClient.swift
│   │   ├── LocationService.swift
│   │   └── LocationData.swift
│   └── Presentation/
│       ├── AppRouter.swift
│       ├── Box.swift
│       ├── Design.swift
│       └── LocationList/
│           ├── LocationsListViewController.swift
│           ├── LocationsListViewModel.swift
│           ├── LocationDisplayModel.swift
│           ├── LocationCaptureView.swift
│           ├── LocationDegreeInputFormatter.swift
│           └── LocationTableViewCell.swift
├── WIKILocationSelectorTests/     # Unit tests
│   ├── Data/
│   ├── Repository/
│   └── Presentation/
└── WIKILocationSelectorUITests/   # UI tests (disabled)
```

---

## Requirements

- Xcode 13+
- iOS 13+
- The [Wikipedia iOS app](https://apps.apple.com/app/wikipedia/id324715238) must be installed to follow deep links; the app shows an alert otherwise.

---

## Running the Tests

Open `WIKILocationSelector.xcodeproj` in Xcode and press **⌘U**. The active test plan (`WIKILocationSelector.xctestplan`) runs all unit tests. UI tests are present but disabled in the plan.

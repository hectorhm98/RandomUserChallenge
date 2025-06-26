# RandomUserChallenge APP

## Description

This iOS application, built with SwiftUI, consumes a public API providing random users and displays them in a scrolleable list. The app stores data locally using Core Data to persist data and avoid duplication from API calls.

---

## Architecture

- The app follows a modular architecture inspired by Clean Architecture:
  - **Domain**: Contains business entities, use cases and interfaces (to abstract communication with Data layer).
  - **Data**: Handles persistence (Core Data) and API consumption.
  - **Presentation**: Implements Views and ViewModels using SwiftUI.
- Mapping between DTOs, Core Data entities, and domain models is clearly separated to improve maintainability and testing.
- Dependency Injection is applied to facilitate unit testing. I obted to do manual DI to not overcomplicate it.

---

## Features

- Incrementally loads users from the API.
- Local persistence with Core Data for caching and offline support.
- Logic to handle repeated users in API responses.
- MVVM pattern with SwiftUI for clean, modular code.
- Unit tests covering critical parts such as repositories, use cases and mappers.
- Snapshot test covering the main UI layout.

---

## Design Decisions

- Separation of DTO, Domain Model, and Entity layers to decouple networking, business logic, and persistence.
        -> This allows for better maintainability and testable code. Specially makes it easier to switch to a different persistence or networking strategy in the future, without affecting the rest of the code.
- Use of Core Data over UserDefaults to manage potentially large lists and use of filters.
- Retry logic to fetch additional data when local cache is exhausted.
- Use of soft deletion for RandomUsers (using deleted flag) to avoid retrieving a copy of the same user from the API again.
- To avoid repetition I assumed the email must be unique, so to add and modify users, I will treat them as primary key in CoreData entity.
- Since data will always be persisted locally, the data flow will be the following: DTO (API) -> Entity (CoreData) <-> Domain.
        -> I decided to keep DTO to Domain mapping to show the separation of concerns.

---

## Requirements

- iOS 18.0+
- Xcode 16.4+
- Swift 5.7+

---

## Installation

1. Clone this repository
   ```bash
   git clone https://github.com/hectorhm98/RandomUserChallenge.git

2. Open the project in Xcode

3. Run the app on a simulator or device


## Usage

- The app displays a list of random users.
- More users load automatically when scrolling to the bottom.
- Users are stored locally to optimize subsequent loading.
- When a user is tapped/selected, it navigates to a detail view showing more information.
- A user can be deleted -> UI will not show it again
- //TODO Complete


## Credits
API used: [Random User Generator](https://randomuser.me/)

This project was developed as a technical challenge.

# Weather Mini-App

A Flutter-based mini weather application designed to demonstrate modular architecture, clean code principles, and several Flutter capabilities. This project was developed as part of a technical assessment.

## Features

* Displays current weather information based on latitude and longitude.
* Modularized structure using Melos for monorepo management and Flutter Modular.
* Implements Clean Architecture (Data, Domain, Presentation layers).
* Dependency Injection using GetIt.
* State management (User to specify: e.g., BLoC, Provider, GetX).
* Offline support with basic caching of weather data using Shared Preferences.
* Responsive UI for displaying weather information.
* Settings screen with a dark/light mode toggle (User to confirm implementation).
* Device battery level display on the settings screen via a Method Channel.

## Project Structure

This project is a monorepo managed by [Melos](https://melos.invertase.dev/). It's structured into:

* `apps/`: Contains the main Flutter application (`weather_app`).
* `packages/`: Contains reusable packages/modules.
    * `app_module`: Where the app begins.
    * `core`: Handles core functionalities like networking, utilities, and dependency injection.
    * `feature_weather` (or similar feature module): Contains all specific logic, UI, and data handling for the weather feature.

## Architecture Decisions

The application's architecture was designed based on the following principles and requirements:

* **Modular Architecture**:
    * **Melos**: Used to manage the multi-package repository, making it easier to develop and maintain different parts of the application independently or collaboratively. Melos helps in linking local packages, managing dependencies, and running scripts across the workspace.
    * **Flutter Modular**: Implemented for route management and dependency injection scoping within the Flutter application. It allows for a more organized and decoupled feature-based module structure. Each feature can control its own routes, dependencies, and business logic.

* **Clean Architecture**:
    * The project follows a basic separation of layers:
        * **Presentation**: Responsible for the UI (Widgets, State Management logic).
        * **Domain**: Contains business logic, use cases, and entities (models). This layer is independent of other layers.
        * **Data**: Responsible for data retrieval from remote (API) or local (cache) sources, and includes repository implementations.
    * This separation enhances testability, maintainability, and scalability.

* **Dependency Injection**:
    * **GetIt**: Used for service location and dependency injection. It helps in decoupling classes and managing dependencies across different layers and modules.

* **State Management**:
    * **BLoC**

* **Networking**:
    * **Dio**: Preferred for making HTTP requests due to its rich feature set, including interceptors, FormData support, and better error handling compared to the basic `http` package.

* **Offline Support**:
    * **Shared Preferences**: Used for basic caching of the last fetched weather data. This allows the app to display stale data when offline.

* **Method Channel**:
    * Implemented to access native device capabilities, specifically to retrieve the current battery level from both Android and iOS.

## Setup Instructions

### Prerequisites

* Flutter SDK: Ensure you have Flutter installed. Refer to the [official Flutter documentation](https://flutter.dev/docs/get-started/install).
* Dart SDK: Comes with Flutter.
* Melos: Install Melos globally by running:
    ```bash
    dart pub global activate melos
    ```


### Steps

1.  **Clone the Repository**:
    ```bash
    git clone [https://github.com/ashehata71/weather_mini_app.git](https://github.com/ashehata71/weather_mini_app.git)
    cd weather_mini_app
    ```

2.  **Configure API Key**:
    This application uses the OpenWeatherMap API to fetch weather data. You need to provide your own API key.
    * Locate the file where the API key is expected (e.g., in `WeatherRemoteDataSourceImpl` or a configuration file).
    * Replace the placeholder `YOUR_OPENWEATHERMAP_API_KEY` with your actual key.

3.  **Bootstrap the Project with Melos**:
    This command installs dependencies for all packages and links them locally.
    ```bash
    melos bootstrap
    ```
    (If you've configured `usePubspecOverrides: true` in `melos.yaml` and are using Dart 2.17+, this will use `pubspec_overrides.yaml` for linking.)

4.  **Run the Application**:
    Navigate to the main application directory and use the standard Flutter run command:
    ```bash
    cd apps/weather_app
    flutter run
    ```
    Alternatively, you might have Melos scripts configured in `melos.yaml` to run the app. For example:
    ```bash
    # If a script like 'run_app' is defined in melos.yaml
    # melos run run_app
    ```
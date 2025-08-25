# Premium Weather App (Flutter)

Modernized Flutter Weather app with Riverpod, GoRouter, clean-ish architecture, theming, and animations.

- Riverpod for state
- GoRouter for navigation
- Lottie background, glass cards, smooth transitions
- Dark/Light/System themes
- Units: °C / °F
- Manage cities: add, reorder, remove

Run:

1. Add your OpenWeather API key in `lib/secrets.dart` (already present).
2. Install deps and run tests.

# Weather App

## Overview
This Flutter app fetches weather data from an external API and displays it to the user.

## Features
- Display current weather information based on user location or selected city.
- Show detailed weather forecast for the upcoming days.
- Allow users to refresh weather data manually.

## Screens
### Home Screen
The home screen displays the current weather information and allows the user to refresh the data.

#### Widgets Used
- `FutureBuilder` to handle asynchronous fetching of weather data.
- `Column`, `Row`, and `Container` widgets to structure the UI.
- Custom widgets for displaying weather information (temperature, description, etc.).

#### API Integration
- Uses `http` package to fetch weather data from an API (e.g., OpenWeatherMap).
- Handles JSON parsing to extract relevant weather information.

#### Error Handling
- Displays error messages if there are issues with fetching data or if the API request fails.
- Provides a way for the user to retry fetching data.

### Forecast Screen
The forecast screen shows the weather forecast for the upcoming days.

#### Widgets Used
- `ListView` to display a scrollable list of forecasted weather.
- Custom widgets for displaying each day's weather forecast.

#### API Integration
- Similar to the Home Screen, fetches forecast data from the same API.
- Parses JSON to extract forecast information.

#### Navigation
- Allows the user to navigate between the Home and Forecast screens using bottom navigation or tabs.


## Conclusion
This Markdown file outlines the structure and functionality of a simple weather app built using Flutter. It covers the basic UI components, API integration for fetching weather data, error handling, and code snippet for data retrieval. Further enhancements could include more detailed weather displays, user settings, or integration with additional APIs for richer data.


In this example:

- **Overview** describes the purpose of the app.
- **Features** outline key functionalities.
- **Screens** section details the Home Screen and Forecast Screen, explaining the UI components and API integrations.
- **Code Snippet** provides a basic example of how to fetch weather data using the `http` package and parse JSON data.
- **Conclusion** summarizes the content and suggests potential future enhancements.

Replace placeholders like `YOUR_API_KEY` with your actual API key when implementing your app. This Markdown file can serve as documentation for developers or as a reference for further development and improvement of your Flutter weather app.
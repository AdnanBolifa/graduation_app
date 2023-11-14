# Ticket Documentation

## Table of Contents
- [Ticket Documentation](#ticket-documentation)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Installation](#installation)
  - [Project Structure](#project-structure)
  - [Advanced Code Structure Explanation](#advanced-code-structure-explanation)
    - [`api_service.dart`](#api_servicedart)
    - [`auth_service.dart`](#auth_servicedart)
    - [`location_services.dart`](#location_servicesdart)
    - [`data` directory](#data-directory)
    - [`screens` directory](#screens-directory)
    - [`services` directory](#services-directory)
    - [`themes` directory](#themes-directory)
    - [`widgets` directory](#widgets-directory)
    - [`main.dart`](#maindart)
    - [`docs.md`](#docsmd)
    - [`pubspec.yaml`](#pubspecyaml)
    - [`README.md`](#readmemd)
  - [Usage](#usage)
  - [Features](#features)
  - [Screenshots](#screenshots)
  - [Dependencies](#dependencies)
  - [Contributing](#contributing)
  - [License](#license)

## Introduction

MyApp is a Flutter-based mobile application designed to [brief description of your application].

## Getting Started

### Prerequisites

Before you begin, ensure you have the following installed on your development machine:

- [Flutter](https://flutter.dev/docs/get-started/install) - version  3.13.7
- [Dart](https://dart.dev/get-dart) - version 3.1.3

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/myapp.git
   ```
2. Navigate to the project directory:

   ```bash
   cd myapp
   ```
3. Install dependencies:
   ```bash
    flutter pub get
   ```
## Project Structure
Explain the organization of your project's source code. For example:
```lua
    Tickets/
    |-- lib/
    |   |-- assets/
    |   |   |-- hti_logo.png
    |   |   |-- icon.png
    |   |-- data/
    |   |   |-- api_config.dart
    |   |   |-- comment_config.dart
    |   |   |-- location_config.dart
    |   |   |-- multi_answer.dart
    |   |   |-- multi_survey_config.dart
    |   |   |-- problem_config.dart
    |   |   |-- sectors_config.dart
    |   |   |-- solution_config.dart
    |   |   |-- ticket_config.dart
    |   |   |-- towers_config.dart
    |   |-- screens/
    |   |   |-- download_dialog.dart
    |   |   |-- home.dart
    |   |   |-- login.dart
    |   |   |-- survey_page.dart
    |   |   |-- ticket_page.dart
    |   |-- services/
    |   |   |-- api_service.dart
    |   |   |-- auth_service.dart
    |   |   |-- check_permissions.dart
    |   |   |-- location_services.dart
    |   |   |-- ...
    |   |-- themes/
    |   |   | -- colors.dart
    |   |   | -- routes.dart
    |   |   | -- theme.dart
    |   |-- widgets/
    |   |   | -- comment_card.dart
    |   |   | -- comment_section.dart
    |   |   | -- map_box.dart
    |   |   | -- text_field.dart
    |   |   | -- ticket_card.dart
    |   |-- main.dart
    |-- docs.md
    |-- pubspec.yaml
    |-- README.md
```
## Advanced Code Structure Explanation

### `api_service.dart`

The `api_service.dart` module is the backbone of our application's communication with the backend API. It encapsulates functions and methods responsible for making HTTP requests, handling responses, and managing data transfer between the mobile app and the server.

### `auth_service.dart`

In the `auth_service.dart` module, we manage user authentication and authorization. This includes handling user login, registration, and maintaining user sessions. Additionally, it interfaces with the backend to ensure secure access to authenticated users.

### `location_services.dart`

The `location_services.dart` module is dedicated to location-related functionalities. It utilizes the device's geolocation capabilities to fetch the user's current location, ensuring accurate data for location-based features within the application.

### `data` directory

The `data` directory houses crucial configuration files that dictate the structure and behavior of our application. For example:
- `api_config.dart`: Configurations related to the backend API.
- `comment_config.dart`: Configuration for handling comments.
- `location_config.dart`: Configuration for managing location-based data.
- `multi_answer.dart`: Handling multiple-choice answers in surveys.
- `multi_survey_config.dart`: Configuration for multi-part surveys.
- `problem_config.dart`: Configuration for problem-related data.
- `sectors_config.dart`: Configuration related to different sectors.
- `solution_config.dart`: Configuration for handling solutions to reported issues.
- `ticket_config.dart`: Configuration for ticket-related data.
- `towers_config.dart`: Configuration related to towers in the application.

### `screens` directory

The `screens` directory contains Flutter widgets that represent various screens of our application. Some notable screens include:
- `download_dialog.dart`: Dialog for handling file downloads.
- `home.dart`: The main landing page of the application.
- `login.dart`: The login screen for user authentication.
- `survey_page.dart`: Page for conducting and submitting surveys.
- `ticket_page.dart`: Page for viewing and managing tickets.

### `services` directory

In the `services` directory, we encapsulate functionalities that are vital for the application's overall operation. For instance:
- `api_service.dart`: Communication with the backend API.
- `auth_service.dart`: User authentication services.
- `check_permissions.dart`: Services for checking and managing app permissions.
- `location_services.dart`: Handling location-related services.

### `themes` directory

The `themes` directory contains configurations related to the visual styling of our application. It includes:
- `colors.dart`: A centralized location for defining color schemes.
- `routes.dart`: Configuration of different routes within the app.
- `theme.dart`: The overall theme configuration for consistent styling.

### `widgets` directory

The `widgets` directory holds reusable Flutter widgets used throughout the application. These widgets include:
- `comment_card.dart`: A widget for displaying comment cards.
- `comment_section.dart`: A widget representing a section for comments.
- `map_box.dart`: A widget for displaying interactive maps.
- `text_field.dart`: A customizable text input field.
- `ticket_card.dart`: Widget for displaying ticket information.

### `main.dart`

The entry point of our Flutter application, `main.dart` initializes the app and sets up the initial screen for users.

### `docs.md`

The documentation file provides detailed information about the project, including usage instructions, features, and external dependencies.

### `pubspec.yaml`

The `pubspec.yaml` file lists all dependencies and configuration details for our Flutter project.

### `README.md`

The README file is a user-friendly guide providing essential information about the project, its structure, and how to get started.



## Usage
Provide instructions on how to run and use your application. For example:

1. Run the app on an emulator or a connected device:

   ```bash 
   flutter run
   ```
2. Navigate through different screens and explore the features.

## Features

1. [Feature 1]
2. [Feature 2]
3. ...

## Screenshots

Include screenshots to showcase different aspects of your application. 

![Screenshot 1](/screenshorts/screenshot_(1).jpg)
*Home page with 3 deffirent type of tickets notstated, inprogress and done*

![Screenshot 2](/screenshorts/screenshot_(2).jpg)
*Search bar*

![Screenshot 3](/screenshorts/screenshot_(3).jpg)
*Add new report page*

![Screenshot 4](/screenshorts/screenshot_(4).jpg)
*Update report page*

![Screenshot 5](/screenshorts/screenshot_(5).jpg)
*Location map of the customer*

![Screenshot 6](/screenshorts/screenshot_(6).jpg)
*Customer Survey*



## Dependencies
List the external dependencies used in your project. For example:

  ```yaml 
  cupertino_icons: ^1.0.2
  http: ^1.1.0
  flutter_secure_storage: ^9.0.0
  fluttertoast: ^8.2.2
  url_launcher: ^6.1.14
  geolocator: ^10.1.0
  permission_handler: ^11.0.1
  flutter_map: ^6.0.1
  connectivity: ^3.0.6
  flutter_rating_bar: ^4.0.1
  easy_localization: ^3.0.3
  flutter_localizations:
    sdk: flutter
  latlng: ^1.0.0
  latlong2: ^0.9.0
  flutter_launcher_icons: ^0.13.1
  package_info_plus: ^4.2.0
  flutter_file_downloader: ^1.1.4
  open_file_plus: ^3.4.1
  dio: ^5.3.3
  path_provider: ^2.1.1
  ```
## Contributing
If you'd like to contribute to this project, please follow the contribution guidelines.

## License
This project is licensed under the [MIT License.](https://en.wikipedia.org/wiki/MIT_License)


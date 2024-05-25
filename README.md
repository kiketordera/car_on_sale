# car_on_sale

A new Flutter project.

## Project Structure

### Explanation of Code Organization

#### 1. Models
- **Purpose:** Define data structures and models used through the app.
- **File:** `vehicle_options.dart` contains the `VehicleOption` class, which represents the vehicle options data model.

#### 2. Screens
- **Purpose:** Contains all the UI components of the app.
- **Files:**
  - `auction_data.dart`: Displays auction data to the user.
  - `home.dart`: The home screen of the app.
  - `signup.dart`: Allows users to enter their identification data.
  - `vehicle_selection.dart` and `vehicles_selection.dart`: Screens for selecting vehicles based on fetched data.

#### 3. Services
- **Purpose:** Handles business logic and data operations, including API calls and local storage.
- **Files:**
  - `api_service.dart`: Contains methods for making HTTP requests.
  - `local_storage.dart`: Manages data caching and retrieval using local storage.

#### 4. Utils
- **Purpose:** Contains utility classes and functions that can be used throughout the app.
- **Files:**
  - `error_handler.dart`: Utility for handling and displaying errors.
  - `regex_util.dart`: Utility for regex operations, including removing specific letters (QIO) from the input.

#### 5. Main
- **File:** `main.dart` initializes the app and sets up the navigation.

### Extra: VIN Validation

The Regex expresion in the `regex.dart` file contains functions for validating Vehicle Identification Numbers (VINs). VINs are 17 characters long and can include any alphanumeric characters except for the letters I, O, and Q, which are excluded to avoid confusion with numerals 1 and 0.

**Example Code:**

```dart
class VINValidator {
  static bool isValidVIN(String vin) {
    final regex = RegExp(r'^[A-HJ-NPR-Z0-9]{17}$');
    return regex.hasMatch(vin);
  }
}
```


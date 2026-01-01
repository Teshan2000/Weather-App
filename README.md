# Weather Forecast Mobile App 🌦️

This Weather Forecast Mobile App provides users with real-time weather data and forecasted conditions, including advanced features for air quality and precipitation insights. Built with Flutter and powered by the OpenWeather API, the app brings essential weather data to users' fingertips, enabling them to plan their day and track weather conditions with ease.

## Features

### 🌐 Real-Time Weather Data ⛅🌤☔
- **Current Weather Conditions**: Instantly fetches the current weather based on the user's location or a specified city, providing information such as temperature, humidity, pressure, wind speed, and cloudiness.
- **Dew Point and Wind Direction**: Displays the dew point, and wind direction with a visual arrow, providing context for current humidity and wind flow.

### 📅 5-Day Forecast with Page Navigation
- **Daily Forecast Details**: Displays detailed weather forecasts for the next five days, including the temperature, conditions, precipitation probability, and cloud cover.
- **Swipe & Navigation**: Users can easily navigate through daily forecasts using either swipe gestures or arrow buttons for a more user-friendly experience.

### 🌍 Interactive Weather Map
- **City-Based Weather Map**: Displays a live weather map centered on the user’s or selected city’s location, showing cloud cover, precipitation, temperature, or wind layers using the OpenWeather tile map service.
- **Multiple Map Layers**: Switch between various layers like cloud cover, temperature, and precipitation, to get a more comprehensive weather overview.

### 📊 Air Quality Monitoring
- **Air Quality Index (AQI)**: Provides real-time AQI values for the user's location, displaying data for pollutants like CO, NO2, PM2.5, PM10, and more.
- **AQI Visualization**: Uses `syncfusion_flutter_charts` to display air quality data through interactive charts and visual indicators, enabling users to understand pollution levels intuitively.

### 🔔 Alerts & Notifications
- **Rain Probability Notifications**: Displays a daily percentage chance of precipitation to alert users about potential rain or other weather changes.
- **Dynamic Weather Icons**: Animated icons that match the weather conditions, including clear, rainy, snowy, and cloudy conditions, for an engaging user experience.

### 📶 Connectivity Checker
- **Internet Connection Check**: Ensures seamless weather data updates by checking for internet connectivity, providing a friendly reminder when the device is offline.

### 🎨 Customizable Themes
- **Light & Dark Mode**: Users can switch between light and dark themes for a personalized app experience.

## Technology Stack

- **Flutter**: Front-end framework used for cross-platform development.
- **OpenWeather API**: Data source for real-time and forecasted weather, air quality, and weather map layers.
- **Syncfusion Charts**: Used for visualizing AQI and other complex data insights within the app.
- **Connectivity Plus**: Check for internet connectivity, providing a friendly reminder when the device is offline

## Setup and Installation

To set up the app locally, please follow these steps:
1. Clone the repository.
2. Obtain an OpenWeather API key and add it to the app configuration.
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

This Weather Forecast Mobile App is a complete solution for real-time weather updates, air quality insights, and a user-friendly design, making it a reliable daily tool for anyone on the go! 

--- 
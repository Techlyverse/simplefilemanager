# File Manager
### Overview
File Manager is designed to be a fast, responsive, and aesthetically pleasing file management solution for multiple platforms, using the Dart and Flutter framework. The goal is to provide a seamless, native-like experience for handling files, whether you are on mobile, desktop, or the web.

### Download on Google Play
[Experience the app firsthand](https://play.google.com/store/apps/details?id=com.raghv042.filemanager)

<img src="https://github.com/Techlyverse/simplefilemanager/blob/main/screenshots/ss_4.jpg" width="200"> <img src="https://github.com/Techlyverse/simplefilemanager/blob/main/screenshots/ss_5.jpg" width="200"><img src="https://github.com/Techlyverse/simplefilemanager/blob/main/screenshots/ss_1.jpg" width="200"> <img src="https://github.com/Techlyverse/simplefilemanager/blob/main/screenshots/ss_2.jpg" width="200">

# Contributions Welcome!
We are actively seeking contributions from the Flutter community to help make this project robust and feature-complete across all platforms. Whether you're interested in fixing bugs, improving performance, or implementing new features, your help is highly valued!

### Getting Started
Before starting make sure you have latest version of flutter installed

* Fork this repository.
* Clone your forked repository: git clone https://github.com/Techlyverse/simplefilemanager.git
* Get Dependencies: Run flutter pub get in the project root.
* Run the App: flutter run
* Create a Branch: Create a new branch for your feature or fix (e.g., git checkout -b feature/copy-paste or fix/ios-bug).
* Commit and Push: Commit your changes and push to your fork.
* Open a Pull Request: Submit a Pull Request targeting the main branch of this repository.

### Issues & Help Needed
We've identified key areas where contributions will make the biggest impact. Dive into one of these and make the app better!

**Robust File Operations:** The core file management functions (rename, copy, paste, delete, and move) are currently incomplete or contain bugs. We need robust, cross-platform implementations for these fundamental features.

**iOS / macOS Support:** The application struggles with file system access and permissions on Apple platforms. Help is needed to ensure compatibility and a native feel on iOS and macOS.

**Desktop Navigation:** Implement reliable "Navigate Back" functionality (history or parent directory traversal) to improve the user experience on desktop platforms (Linux, Windows, and macOS).

**Performance Tuning:** Continue optimizing file operations, specifically by leveraging Dart Isolates for background tasks (like file listing/sorting) to keep the UI responsive and "blazing fast."

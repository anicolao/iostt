# iostt
A full screen browser for iOS Tabletop

## Overview
This is a barebones Swift iOS application that displays a fullscreen webview loading https://launcherui.web.app/. The app provides a simple, distraction-free browsing experience for iOS Tabletop.

## Features
- Fullscreen WKWebView without navigation bars or toolbars
- Loads https://launcherui.web.app/ on launch
- Status bar hidden for true fullscreen experience
- Supports all device orientations (portrait and landscape)

## Requirements
- Xcode 14.0 or later
- iOS 15.0 or later
- macOS for development

## Project Structure
```
iostt/
├── iostt.xcodeproj/          # Xcode project file
│   └── project.pbxproj
├── iostt/                     # App source code
│   ├── AppDelegate.swift      # Application lifecycle
│   ├── SceneDelegate.swift    # Scene lifecycle and window setup
│   ├── ViewController.swift   # Main view with fullscreen webview
│   ├── Info.plist            # App configuration
│   ├── LaunchScreen.storyboard # Launch screen
│   └── Assets.xcassets/      # App icons and images
└── README.md                 # This file
```

## Building and Running
1. Open `iostt.xcodeproj` in Xcode
2. Select a target device or simulator
3. Press ⌘+R to build and run

## Code Overview

### ViewController.swift
The main view controller creates a fullscreen WKWebView and loads the launcher UI:
- Uses `WKWebView` for modern web content rendering
- Sets the webview as the entire view (fullscreen)
- Loads https://launcherui.web.app/ on launch

### SceneDelegate.swift
Manages the window and scene lifecycle:
- Creates the main window
- Sets up the ViewController as the root view controller

### AppDelegate.swift
Handles application lifecycle events and scene configuration.

## License
See LICENSE file for details.

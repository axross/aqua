# Aqua

[![Build Status](https://app.bitrise.io/app/c991d5e40b6ae077/status.svg?token=fLXSCW4kXWgtw8BAcH-kLA&branch=master)](https://app.bitrise.io/app/c991d5e40b6ae077)

♠️ Beautiful Texas Hold'em poker odds calculator made of Flutter.

- 🎛 State Management
  - Effectively uses [ChangeNotifier](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html)/[ValueNotifier](https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html) with [AnimatedBuilder](https://api.flutter.dev/flutter/widgets/AnimatedBuilder-class.html)/[ValueListenableBuilder](https://api.flutter.dev/flutter/widgets/ValueListenableBuilder-class.html)
  - No [provider](https://pub.dev/packages/provider) or BLoC pattern used
- 🧩 [Isolate](https://api.dart.dev/stable/2.9.0/dart-isolate/dart-isolate-library.html) and [Stream](https://api.dart.dev/stable/2.9.0/dart-async/Stream-class.html) are used for multithreading calculation and communication between main thread and isolates
- 💅 Built of an original [theme](lib/src/constants/theme.dart) class and corresponding [widgets](lib/src/common_widgets)
  - Dark theme is supported

![Aqua](https://user-images.githubusercontent.com/4289883/89248433-9a76ba80-d5c4-11ea-9b23-b4d0a4dcc867.gif)

## Download

[<img src="https://user-images.githubusercontent.com/4289883/68385703-35fafd80-010f-11ea-8433-2c8e9994b023.png" alt="Get it on Google Play" height="40" />](https://play.google.com/store/apps/details?id=app.axross.aqua&hl=en) [<img src="https://user-images.githubusercontent.com/4289883/68385704-35fafd80-010f-11ea-83ce-6bd8b7eff5d1.png" alt="Download on the App Store" height="40" />](https://apps.apple.com/us/app/odds-calculator-for-poker/id1485519383)

If you want an access of the beta program, feel free to contact at [yo@kohei.dev](mailto:yo@kohei.dev)!

## Bug Report / Feature Request / Contribution

Feel free to open an issue or pull request! Everything you do would be grateful!

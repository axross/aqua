import 'package:aqua/common_widgets/analytics.dart';
import 'package:aqua/common_widgets/app.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(
      Analytics(
        analytics: FirebaseAnalytics(),
        child: AquaApp(),
      ),
    );

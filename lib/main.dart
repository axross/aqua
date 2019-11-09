import 'package:aqua/common_widgets/app.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(AquaApp(analytics: FirebaseAnalytics()));

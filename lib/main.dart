import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:Konexea/Controllers/Services/Feed%20Database/feed_services.dart';
import 'package:Konexea/Controllers/Services/P-Hub%20Interface/interface_controllers.dart';
import 'package:Konexea/Controllers/Services/API/Thrift%20Store/phub_api_services.dart';
import 'package:Konexea/Controllers/Services/Cart%20Services/cart_service.dart';
import 'package:Konexea/Controllers/Services/Chat/chat_services.dart';
import 'dart:developer';
import 'package:Konexea/Utils/animation_utils.dart';
import 'package:Konexea/Utils/consts.dart';
import 'package:Konexea/controllers/Services/API/News API/api_services.dart';
import 'package:Konexea/controllers/Services/API/Chatbot/chatbot_services.dart';
import 'package:Konexea/firebase_options.dart';
import 'package:Konexea/utils/theme.dart';
import 'package:Konexea/views/Auth Gate/auth_gate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style for a more immersive experience
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) {
    log("Firebase Initialization Completed");

    // Initialize Supabase
    Supabase.initialize(url: url, anonKey: anonKey).then((value) {
      log("Supabase Initialized");

      runApp(
        // Providers
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => ApiServices()),
            ChangeNotifierProvider(create: (context) => PHubApiServices()),
            ChangeNotifierProvider(create: (context) => FeedServices()),
            ChangeNotifierProvider(create: (context) => CartServices()),
            ChangeNotifierProvider(create: (context) => ChatServices()),
            ChangeNotifierProvider(create: (context) => ChatbotController()),
            ChangeNotifierProvider(create: (context) => InterfaceController()),
          ],
          child: const MainApp(),
        ),
      );
    }).onError((error, stackTrace) {
      log("Supabase initialization error: ${error.toString()}");
      log(stackTrace.toString());
    });
  }).onError((error, stackTrace) {
    log("Firebase initialization error: ${error.toString()}");
    log(stackTrace.toString());
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Social Swap',
      theme: lightMode,
      home: const AppStartupAnimation(),
      // Custom page transitions for the entire app
      onGenerateRoute: (settings) {
        // Default transition for all routes
        Widget page = const AuthGate();

        // Add specific route handling here if needed
        // if (settings.name == SomePage.routeName) {
        //   page = const SomePage();
        // }

        return CustomPageRoute(
          page: page,
          duration: const Duration(milliseconds: 350),
        );
      },
    );
  }
}

/// A startup animation wrapper for the app
class AppStartupAnimation extends StatefulWidget {
  const AppStartupAnimation({super.key});

  @override
  State<AppStartupAnimation> createState() => _AppStartupAnimationState();
}

class _AppStartupAnimationState extends State<AppStartupAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Start the animation after a short delay
    Future.delayed(const Duration(milliseconds: 200), () {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Create animations for the startup sequence
    final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    final scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Scaffold(
          body: FadeTransition(
            opacity: fadeAnimation,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: const AuthGate(),
            ),
          ),
        );
      },
    );
  }
}

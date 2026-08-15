import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'screens/upload_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/pro_screen.dart';
import 'screens/test_screen.dart';
import 'screens/statistics_screen.dart';
import 'screens/flashcard_screen.dart';
import 'screens/exam_screen.dart';
import 'screens/schedule_screen.dart';
import 'screens/legal_screen.dart';
import 'services/theme_service.dart';
import 'services/demo_lecture.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // При первом запуске загружаем демо-лекцию
  final prefs = await SharedPreferences.getInstance();
  final isFirstLaunch = prefs.getBool('is_first_launch') ?? true;
  
  if (isFirstLaunch) {
    await prefs.setString('lecture_text', DemoLecture.text);
    await prefs.setString('lecture_name', DemoLecture.name);
    await prefs.setBool('is_first_launch', false);
    print('📚 Демо-лекция загружена при первом запуске');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDark = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final isDark = await ThemeService.isDarkMode();
    setState(() {
      _isDark = isDark;
    });
  }

  void _toggleTheme() async {
    await ThemeService.toggleTheme();
    setState(() {
      _isDark = !_isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Умный помощник',
      theme: ThemeService.getLightTheme(),
      darkTheme: ThemeService.getDarkTheme(),
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(
          onThemeToggle: _toggleTheme,
          isDarkMode: _isDark,
        ),
        '/upload': (context) => const UploadScreen(),
        '/chat': (context) => const ChatScreen(),
        '/pro': (context) => const ProScreen(),
        '/test': (context) => const TestScreen(),
        '/statistics': (context) => const StatisticsScreen(),
        '/flashcards': (context) => const FlashcardScreen(),
        '/exam': (context) => const ExamScreen(),
        '/schedule': (context) => const ScheduleScreen(),
        '/legal': (context) => const LegalScreen(),
      },
    );
  }
}

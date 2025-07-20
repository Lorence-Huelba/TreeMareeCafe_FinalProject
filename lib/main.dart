import 'package:flutter/material.dart';
import 'login_page.dart';

void main() => runApp(const CoffeeShopApp());

class CoffeeShopApp extends StatelessWidget {
  const CoffeeShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: const Color(0xFFFFF8F0),
        fontFamily: 'Poppins',
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16),
        ),
      ),
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginPage(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeInAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeInAnimation,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Stylish Logo Container
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(120),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.brown.shade200,
                        blurRadius: 15,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 180,
                      width: 180,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.local_cafe,
                          size: 80,
                          color: Colors.brown,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Tree Maree Cafe POS',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.brown,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Your cozy POS experience starts here.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.brown,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                const CircularProgressIndicator(
                  color: Colors.brown,
                  strokeWidth: 4,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Loading...',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.brown,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

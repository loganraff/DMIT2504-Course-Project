import 'package:flutter/material.dart';
import 'package:bball_stats_application/pages/home_page.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller);
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BBall Stats'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to BBall Stats!', // Add a title welcoming the user
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _controller.value * 2 * 3.14, // Rotate 360 degrees
                  child: Icon(
                    Icons.sports_basketball,
                    size: 50.0,
                    color: Colors.orange,
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Set the background color to orange
              ),
              child: Text(
                'View your Stats',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

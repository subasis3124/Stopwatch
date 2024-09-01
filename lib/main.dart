import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(StopwatchApp());
}

class StopwatchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Stopwatch',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.robotoMonoTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      home: StopwatchScreen(),
    );
  }
}

class StopwatchScreen extends StatefulWidget {
  @override
  _StopwatchScreenState createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  List<String> _laps = [];

  void _startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 30), (timer) {
      setState(() {});
    });
  }

  void _startStopwatch() {
    setState(() {
      _stopwatch.start();
      _startTimer();
    });
  }

  void _pauseStopwatch() {
    setState(() {
      _stopwatch.stop();
      _timer?.cancel();
    });
  }

  void _resetStopwatch() {
    setState(() {
      _stopwatch.reset();
      _stopwatch.stop();
      _timer?.cancel();
      _laps.clear();
    });
  }

  void _recordLap() {
    if (_stopwatch.isRunning) {
      setState(() {
        _laps.add(_formatTime(_stopwatch.elapsedMilliseconds));
      });
    }
  }

  String _formatTime(int milliseconds) {
    int hours = (milliseconds ~/ (1000 * 60 * 60)) % 24;
    int minutes = (milliseconds ~/ (1000 * 60)) % 60;
    int seconds = (milliseconds ~/ 1000) % 60;
    int milliSeconds = (milliseconds % 1000) ~/ 10;

    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');
    String milliSecondsStr = milliSeconds.toString().padLeft(2, '0');

    return "$hoursStr:$minutesStr:$secondsStr:$milliSecondsStr";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final buttonWidth = size.width * 0.25;

    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        title: Text('Stopwatch'),
        centerTitle: true,
        backgroundColor: Colors.grey,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                _formatTime(_stopwatch.elapsedMilliseconds),
                style: TextStyle(
                  fontSize: size.width * 0.15, // Responsive font size
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildButton(
                icon: _stopwatch.isRunning ? Icons.pause : Icons.play_arrow,
                label: _stopwatch.isRunning ? 'Pause' : 'Start',
                onPressed: _stopwatch.isRunning ? _pauseStopwatch : _startStopwatch,
                color: Colors.greenAccent,
                width: buttonWidth,
              ),
              SizedBox(width: 16),
              _buildButton(
                icon: Icons.stop,
                label: 'Reset',
                onPressed: _resetStopwatch,
                color: Colors.redAccent,
                width: buttonWidth,
              ),
              SizedBox(width: 16),
              _buildButton(
                icon: Icons.flag,
                label: 'Lap',
                onPressed: _recordLap,
                color: Colors.yellowAccent,
                width: buttonWidth,
              ),
            ],
          ),
          if (_laps.isNotEmpty)
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.grey[800],
                child: Column(
                  children: [
                    Divider(color: Colors.grey),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        itemCount: _laps.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            child: ListTile(
                              tileColor: Colors.blueGrey[900],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              title: Text(
                                'Lap ${index + 1}',
                                style: TextStyle(color: Colors.white70),
                              ),
                              trailing: Text(
                                _laps[index],
                                style: TextStyle(color: Colors.lightBlueAccent),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    required Color color,
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 24),
        label: Text(label, style: TextStyle(fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

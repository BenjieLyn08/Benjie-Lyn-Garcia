import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const RegistrationForm(),
    );
  }
}

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Color color;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: color),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: color),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: color),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class _RegistrationFormState extends State<RegistrationForm> {
  final TextEditingController _textController = TextEditingController();
  final List<String> _todoList = [];

  Color primaryColor = Colors.pink.shade700;
  Color secondaryColor = Colors.pink.shade100;
  Color backgroundColor = const Color.fromARGB(255, 248, 170, 209);

  void _saveText() {
    if (_textController.text.isNotEmpty) {
      setState(() {
        _todoList.add(_textController.text);
        _textController.clear();
      });
    }
  }

  void _deleteItem(int index) {
    setState(() {
      _todoList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'MIDTERM PROJECT',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextField(controller: _textController, hintText: 'Enter Text', color: primaryColor),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveText,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'SAVE',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_todoList.isNotEmpty)
              Column(
                children: _todoList.asMap().entries.map((entry) {
                  int index = entry.key;
                  String item = entry.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: primaryColor, size: 24),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              item,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _deleteItem(index),
                            child: Icon(Icons.close, color: primaryColor, size: 24),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: primaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.checklist), label: 'To-Do'),
          BottomNavigationBarItem(icon: Icon(Icons.palette), label: 'Color'),
          BottomNavigationBarItem(icon: Icon(Icons.audiotrack), label: 'Audio'),
        ],
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const BgColorScreen()));
          } else if (index == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AudioPlayerPage()));
          }
        },
      ),
    );
  }
}

// PAGE FOR CHANGING COLORS WITH SWIPE
class BgColorScreen extends StatefulWidget {
  const BgColorScreen({super.key});

  @override
  _BgColorScreenState createState() => _BgColorScreenState();
}

class _BgColorScreenState extends State<BgColorScreen> {
  Color _bgColor = Colors.pinkAccent; // Default background color

  void _changeColor(String direction) {
    setState(() {
      if (direction == "left") {
        _bgColor = const Color.fromARGB(255, 0, 94, 255); // Swipe left
      } else if (direction == "right") {
        _bgColor = const Color.fromARGB(255, 207, 223, 66); // Swipe right
      } else if (direction == "up") {
        _bgColor = const Color.fromARGB(255, 103, 2, 219); // Swipe up
      } else if (direction == "down") {
        _bgColor = Colors.purpleAccent; // Swipe down
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Change Background Color")),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            _changeColor("left"); // Swipe left
          } else if (details.primaryVelocity! > 0) {
            _changeColor("right"); // Swipe right
          }
        },
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            _changeColor("up"); // Swipe up
          } else if (details.primaryVelocity! > 0) {
            _changeColor("down"); // Swipe down
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          color: _bgColor,
          alignment: Alignment.center,
          child: const Text(
            "Swipe Left, Right, Up, or Down\nto Change Background Color",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// PAGE FOR AUDIO SELECTION
class AudioPlayerPage extends StatefulWidget {
  const AudioPlayerPage({super.key});

  @override
  State<AudioPlayerPage> createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  String currentTrack = "";

  Future<void> _playMusic(String filePath, String trackName) async {
    if (isPlaying && currentTrack == trackName) {
      await _audioPlayer.pause();
      setState(() {
        isPlaying = false;
      });
    } else {
      await _audioPlayer.play(AssetSource(filePath));
      setState(() {
        isPlaying = true;
        currentTrack = trackName;
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Audio Player")),
      body: Column(
        children: [
          ListTile(
            title: const Text("TRIBES"),
            onTap: () => _playMusic("audio/tribes.mp3", "TRIBES"),
          ),
          ListTile(
            title: const Text("GOODNESS OF GOD"),
            onTap: () => _playMusic("audio/goodness_of_god.mp3", "GOODNESS OF GOD"),
          ),
        ],
      ),
    );
  }
}

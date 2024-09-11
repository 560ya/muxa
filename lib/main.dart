import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:intl/intl.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: BottomNavScreen(toggleTheme: toggleTheme),
    );
  }
}

class BottomNavScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  const BottomNavScreen({super.key, required this.toggleTheme});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late List<AnimationController> _controllers;
  late List<Animation<double>> _rotations;

  final List<Widget> _pages = [
    Birs(),
    Ikki(),
    Uch(),
    Turt(),
    Besh(),
  ];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(5, (index) {
      final controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2),
        lowerBound: 0.0,
        upperBound: 1.0,
      );
      return controller;
    });

    _rotations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(controller);
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        color: Theme.of(context).primaryColor,
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Theme.of(context).primaryColorLight,
        index: _currentIndex,
        items: <Widget>[
          _buildRotatingIcon(Icons.layers, 0),
          _buildRotatingIcon(Icons.account_balance, 1),
          _buildRotatingIcon(Icons.bookmark, 2),
          _buildRotatingIcon(Icons.person, 3),
          _buildRotatingIcon(Icons.sms_failed, 4),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            for (int i = 0; i < _controllers.length; i++) {
              if (i == _currentIndex) {
                _controllers[i].repeat(reverse: false);
              } else {
                _controllers[i].stop();
                _controllers[i].value = 0;
              }
            }
          });
        },
      ),
    );
  }

  Widget _buildRotatingIcon(IconData icon, int index) {
    return AnimatedBuilder(
      animation: _rotations[index],
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotations[index].value * 2 * 3.14159,
          child: Icon(icon, size: 30),
        );
      },
    );
  }
}

class Birs extends StatefulWidget {
  @override
  _BirsState createState() => _BirsState();
}

class _BirsState extends State<Birs> {
  bool _isTextVisible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isTextVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isTextVisible
            ? Text(
                "1-sahifa szga bonus",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              )
            : SizedBox.shrink(),
      ),
    );
  }
}
class Ikki extends StatefulWidget {
  @override
  _IkkiState createState() => _IkkiState();
}

class _IkkiState extends State<Ikki> {
  List<String> _userInputs = [];
  List<String> _entryTimes = [];

  void _showInputDialog({int? index}) {
    TextEditingController _textController = TextEditingController();

    if (index != null) {
      // Editing existing message
      _textController.text = _userInputs[index];
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(index == null ? 'Enter your message' : 'Edit your message'),
          content: TextField(
            controller: _textController,
            decoration: InputDecoration(hintText: 'Enter your text here'),
            keyboardType: TextInputType.text,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                setState(() {
                  if (index == null) {
                    // Adding new message
                    _userInputs.insert(0, _textController.text);
                    _entryTimes.insert(0, DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()));
                  } else {
                    // Editing existing message
                    _userInputs[index] = _textController.text;
                    _entryTimes[index] = DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());
                  }
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteMessage(int index) {
    setState(() {
      _userInputs.removeAt(index);
      _entryTimes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("rasm/rasm565.webp"),
                fit: BoxFit.cover,
              ),
            ),
            height: double.infinity,
            width: double.infinity,
          ),
          Positioned(
            bottom: 50, // Adjusted to avoid overlap with the floating action button
            left: 20,
            right: 20,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _userInputs.isNotEmpty
                  ? SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(_userInputs.length, (index) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 20), // Space between each entry
                            padding: EdgeInsets.all(10),
                            color: Colors.white.withOpacity(0.6), // Slightly different color for better distinction
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'malumot: ${_userInputs[index]}',
                                        style: TextStyle(color: Colors.black, fontSize: 18),
                                      ),
                                      SizedBox(height: 10), // Space between texts
                                      Text(
                                        'yozilgan sana: ${_entryTimes[index]}',
                                        style: TextStyle(color: Colors.black, fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.black),
                                  onPressed: () => _showInputDialog(index: index),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.black),
                                  onPressed: () => _deleteMessage(index),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    )
                  : Text(
                      'No messages yet.',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showInputDialog(),
        child: Icon(Icons.edit),
      ),
    );
  }
}

class Uch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Generate a list of strings with increasing numbers of 'X' characters
    List<String> lines = List.generate(1000, (index) => 'X' * (index + 1));

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Center the first line
          Container(
            alignment: Alignment.center,
            child: Text(
              lines[0],
           
            ),
          ),
          // Create the rest of the lines with left alignment
          Expanded(
            child: SingleChildScrollView(
              child: Column(mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: lines.skip(1).map((line) {
                  return Text(
                    line,
                   
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Turt extends StatefulWidget {
  @override
  _TurtState createState() => _TurtState();
}

class _TurtState extends State<Turt> {
  late Timer _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime endOfYear = DateTime(2024, 12, 31, 23, 59, 59);
    Duration difference = endOfYear.difference(_now);

    int days = difference.inDays;
    int hours = difference.inHours % 24;
    int minutes = difference.inMinutes % 60;
    int seconds = difference.inSeconds % 60;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Center the text properly
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("rasm/soat.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center( // Use Center widget to center the text
                child: Padding(
                  padding: const EdgeInsets.all(16.0), // Added padding to avoid overflow
                  child: Text(
                    "Time remaining until the end of 2024:\n"
                    "$days kun\n"
                    "$hours soat\n"
                    "$minutes minut\n"
                    "$seconds sekund",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Ensure text is visible on background image
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class Besh extends StatefulWidget {
  @override
  _BeshState createState() => _BeshState();
}

class _BeshState extends State<Besh> {
  List<String> _images = [
    'rasm/q1.png',
    'rasm/q2.png',
    'rasm/q3.png',
    'rasm/q4.png',
    'rasm/q5.png',
    'rasm/q6.png',
    'rasm/q7.png',
    'rasm/q8.png',
    'rasm/q9.png',
    'rasm/q10.png',
    'rasm/q11.png',
    'rasm/q12.png',
    'rasm/q13.png',
    'rasm/q14.png',
    'rasm/q15.png',
    'rasm/q16.png',
    'rasm/q17.png',
    'rasm/q18.png',
    'rasm/q19.png',
    'rasm/q20.png',
    'rasm/q21.png',
    'rasm/q22.png',
    'rasm/q23.png',
    'rasm/q24.png',
    'rasm/q25.png',
    'rasm/q26.png',
    'rasm/q27.png',
    'rasm/q28.png',
    'rasm/q29.png',
    'rasm/q30.png',
  ];

  final Map<String, bool> _imageVisibility = {};
  String? _firstSelectedImage;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeImages();
  }

  void _initializeImages() {
    for (var image in _images) {
      _imageVisibility[image] = false;
    }
  }

  void _shuffleImages() {
    setState(() {
      _images.shuffle();
      _initializeImages();
      _firstSelectedImage = null;
      _isProcessing = false;
    });
  }

  void _handleImageTap(String image) {
    if (_isProcessing) return;

    setState(() {
      _imageVisibility[image] = true;

      if (_firstSelectedImage == null) {
        _firstSelectedImage = image;
      } else {
        if (_firstSelectedImage == image) {
          // Same image tapped, do nothing
        } else {
          _firstSelectedImage = null;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color appBarColor = Theme.of(context).primaryColor;
    final Color containerColor = Color.fromARGB(255, 1, 118, 81);

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "1989",
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: appBarColor,
        toolbarHeight: 80,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, size: 50, color: Colors.black),
            onPressed: _shuffleImages,
          ),
        ],
      ),
      body: Center(
        child: Container(
          height: 500,
          width: 500,
          padding: EdgeInsets.all(10),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: _images.length,
            itemBuilder: (context, index) {
              final image = _images[index];
              return InkWell(
                onTap: () => _handleImageTap(image),
                child: Container(
                  width: 70,
                  height: 70,
                  color: containerColor,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: _imageVisibility[image] == true
                        ? Image.asset(
                            image,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          )
                        : Container(color: containerColor),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

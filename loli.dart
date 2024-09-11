import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _inputController = TextEditingController();
  bool _isPasswordVisible = false; // Ko'zcha icon uchun
  bool _isLoading = false; // Yuklanish holatini ko'rsatish uchun
  String _savedData = ''; // Yozilgan ma'lumotni saqlash uchun
  String errorMessage = ''; // Xato xabari uchun o'zgaruvchi

  void validateInput() {
    setState(() {
      _isLoading = true; // Yuklanayotgan holatni yoqish
    });

    String username = _inputController.text;

    if (username == "abdulazizxon") {
      setState(() {
        errorMessage = ''; 
      });

      // 5 soniya kutib, ikkinchi sahifaga o'tamiz
      Future.delayed(Duration(seconds: 5), () {
        setState(() {
          _isLoading = false; // Yuklanish holatini o'chirish
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SecondPage()), // Ikkinchi sahifa
        );
      });
    } else {
      setState(() {
        errorMessage = 'Username xato!';
        _isLoading = false; // Yuklanish holatini o'chirish
      });
    }
  }

  void _showMyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Input Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _inputController,
                decoration: InputDecoration(
                  labelText: 'Enter data',
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                color: Colors.amber,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _savedData = _inputController.text; // Ma'lumotni saqlash
                    });
                    Navigator.of(context).pop(); // Dialogni yopish
                  },
                  child: Text('Save', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialogni yopish
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Example'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               
                SizedBox(height: 20),
                // Yozilgan ma'lumotni ko'rsatish uchun Container
                if (_savedData.isNotEmpty) 
                  Container(
                    width: 200,
                    height: 200,
                    color: Colors.amber,
                    child: Center(
                      child: Text(
                        _savedData,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                // Xato xabarini ko'rsatish uchun
                if (errorMessage.isNotEmpty) 
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      errorMessage,
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
              ],
            ),
          ),
          if (_isLoading) // Agar yuklanayotgan bo'lsa, progress indicator ko'rsatiladi
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showMyDialog,
        child: Icon(Icons.add),
        tooltip: 'Show Dialog',
      ),
    );
  }
}

// Bu ikkinchi sahifa uchun oddiy misol
class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ikkinchi Sahifa'),
      ),
      body: Center(
        child: Text(
          'Xush kelibsiz!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_notetakingapp_uas/homepage.dart';
import 'package:flutter_notetakingapp_uas/register.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userPIN = Hive.box('mypinuser');
  List<bool> _pinFilled = List.generate(6, (index) => false);
  String _currentPin = '';
  bool _pinError = false;

  @override
  void initState() {
    super.initState();
    checkStatus();
  }

  void checkStatus() {
    if (_userPIN.isEmpty) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RegistPage(),
          ),
        );
      });
    }
  }

  void clearPin() {
    _currentPin = '';
    _pinFilled = List.generate(6, (index) => false);
  }

  void checkPin(String pin) {
    var checked = _userPIN.get('pin');

    if (pin == checked) {
      _showPinMatchNotification();
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      });
    } else {
      setState(() {
        _pinError = true;
      });
    }
  }

  void _showPinMatchNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('PIN matched!'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.green,
      ),
    );
  }

  void addDigit(String digit) {
    if (_currentPin.length < 6) {
      setState(() {
        _currentPin += digit;
        _pinFilled[_currentPin.length - 1] = true;
        _pinError = false;
      });

      if (_currentPin.length == 6) {
        checkPin(_currentPin);
        clearPin();
      }
    }
  }

  void deleteDigit() {
    if (_currentPin.isNotEmpty) {
      setState(() {
        _currentPin = _currentPin.substring(0, _currentPin.length - 1);
        _pinFilled[_currentPin.length] = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
          child: Text(
            'Login',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  6,
                  (index) => PinDot(
                    filled: _pinFilled[index],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Enter your PIN',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              _pinError
                  ? Text(
                      'Your PIN doesn\'t match. Please try again.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    )
                  : SizedBox.shrink(),
              SizedBox(height: 10),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 15.0,
                  crossAxisSpacing: 20.0,
                  children: [
                    PinKey(number: '1', onPressed: () => addDigit('1')),
                    PinKey(number: '2', onPressed: () => addDigit('2')),
                    PinKey(number: '3', onPressed: () => addDigit('3')),
                    PinKey(number: '4', onPressed: () => addDigit('4')),
                    PinKey(number: '5', onPressed: () => addDigit('5')),
                    PinKey(number: '6', onPressed: () => addDigit('6')),
                    PinKey(number: '7', onPressed: () => addDigit('7')),
                    PinKey(number: '8', onPressed: () => addDigit('8')),
                    PinKey(number: '9', onPressed: () => addDigit('9')),
                    SizedBox.shrink(),
                    PinKey(number: '0', onPressed: () => addDigit('0')),
                    GestureDetector(
                      onTap: () {
                        deleteDigit();
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        child: Icon(Icons.backspace, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PinDot extends StatelessWidget {
  final bool filled;

  const PinDot({Key? key, required this.filled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? Colors.white : Colors.transparent,
        border: Border.all(color: Colors.grey),
      ),
    );
  }
}

class PinKey extends StatelessWidget {
  final String number;
  final VoidCallback onPressed;

  const PinKey({Key? key, required this.number, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: null,
        child: Center(
          child: Text(
            number,
            style: TextStyle(fontSize: 28, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const CalculatorPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({Key? key}) : super(key: key);

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {

  String _input = '';
  String _output = '';

  void _callback(String textButton){
    _output = '';

    switch (textButton){
      case 'DEL': 
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length-1);
        }
        break;
      case 'CLR': 
        _input = '';
        break;
      default: _input += textButton; 
    }
    String input = _input;

    // operasi pembagian & perkalian
    while (input.contains(RegExp(r'[\d\.]+[×÷][\d\.]+'))){
      var match = RegExp(r'([\d\.]+)([×÷])([\d\.]+)').firstMatch(input)!;
      String operat = match.group(2)!; 
      double num1 = double.parse(match.group(1)!);
      double num2 = double.parse(match.group(3)!);
      switch (operat){
        case '÷': _output = (num1 / num2).toString(); break;
        case '×': _output = (num1 * num2).toString(); break;
      }
      input = input.substring(0, match.start) + _output + input.substring(match.end);
    }

    // operasi pengurangan & pertambahan
    while (input.contains(RegExp(r'[\d\.]+[+−][\d\.]+'))){
      var match = RegExp(r'([\d\.]+)([+−])([\d\.]+)').firstMatch(input)!;
      String operat = match.group(2)!; 
      double num1 = double.parse(match.group(1)!);
      double num2 = double.parse(match.group(3)!);
      switch (operat){
        case '−': _output = (num1 - num2).toString(); break;
        case '+': _output = (num1 + num2).toString(); break;
      }
      input = input.substring(0, match.start) + _output + input.substring(match.end);
    }

    // update widget
    setState(() {
      _input = _input;
      _output = double.tryParse(input) != null? _output : '';
    });
  }

  @override
  Widget build(BuildContext context) {

    List<List<String>> textButton = [
      ['7', '8', '9', 'DEL'], 
      ['4', '5', '6', '÷'  ], 
      ['1', '2', '3', '×'  ], 
      ['.', '0', '+', '−'  ]
    ];

    Widget buttons = Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.grey[200],
      constraints: const BoxConstraints(maxHeight: 80 * 4),
      child: Column(children: List.generate(4, (index1) => Expanded(
        child: Row(children: List.generate(4, (index2) {

          bool isNumber = int.tryParse(textButton[index1][index2]) != null;
          bool isBackspace = textButton[index1][index2] == 'DEL';
          Widget child = textButton[index1][index2] == 'DEL'
            ? const Icon(Icons.backspace_outlined, size: 36) 
            : Text(
              textButton[index1][index2], 
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w400),
            );
          var primaryColor = isNumber
            ? Colors.green[900]
            : isBackspace
              ? Colors.red
              : Colors.black;

          return Expanded(child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: TextButton(
              onPressed: () => _callback(textButton[index1][index2]), 
              onLongPress: () => _callback('CLR'),
              style: TextButton.styleFrom(
                primary: primaryColor,
                backgroundColor: isNumber? Colors.green[100] : null,
                minimumSize: const Size(double.infinity, double.infinity), 
                shape: const CircleBorder()
              ), 
              child: child
            ),
          ));
        })),
      )))
    );

    Widget inputOutput(String text, [Color? color]){
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          text, 
          style: TextStyle(fontSize: 36, color: color), 
          textAlign: TextAlign.end,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          inputOutput(_input), 
          inputOutput(_output, Colors.green[900]), 
          const SizedBox(height: 16.0),
          buttons
        ]
      )
    );
  }
}
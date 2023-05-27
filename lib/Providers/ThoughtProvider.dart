import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ThoughtProvider with ChangeNotifier {
  final List<String> _adviceList = [];
  List<String> get adviceList => _adviceList;

  String _toDisplay =
      ""; // we need to have it equal to previous searched thought
  String get thought => _toDisplay;

  bool _isloading = false;
  bool get isloading => _isloading;

  void getNewThought() async {
    _isloading = true;
    notifyListeners();
    final response =
        await http.get(Uri.parse("https://api.adviceslip.com/advice"));
    if (response.statusCode == 200) {
      _toDisplay = jsonDecode(response.body)["slip"]["advice"].toString();
      _adviceList.add(_toDisplay);
    }
    _isloading = false;
    notifyListeners();
  }

  void deleteAll() {
    _adviceList.clear();
    notifyListeners();
  }
}

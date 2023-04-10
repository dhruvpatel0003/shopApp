import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  late String? _token;
  DateTime? _expiryDate;
  String? _userId;
  late Timer? _authTimer;

  bool get isAuth {
    print("inside auth");
    print(token != null);
    return token != null;
  }

  String? get token {
    if (_expiryDate != null && _expiryDate!.isAfter(DateTime.now())) {
      return _token!;
    }
    return null;
  }

  String? get userId{
    // print("user id is"+userId);
    if(_userId!=null){
      return _userId;
    }
    print("outside if");
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {

    print("inside authenticate");
    final url = Uri.parse(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/$urlSegment?key=AIzaSyA7n5T4W44TtmZfF3B2TK5VkbdYzPAqTBs');
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        print("inside the responsedata error in auth.dart");
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      print("user_id"+_userId.toString());
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      // _autoLogout();
      notifyListeners();

        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode({'token':_token,"userId":_userId,"expiryDate":_expiryDate?.toIso8601String()});
        print("The user id inside _authenticate");
        print(userData);

        prefs.setString('userData', userData);

    } catch (error) {
      print("inside the catch error in auth.dart");
      print(error);
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signupNewUser');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'verifyPassword');
  }

  Future<bool> tryAutoLogin() async {
    print("inside tryauto login");
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')){
      print("inside if state");
      return false;
    }
    print("user data");
    print(prefs.getString('userData')! );
    final extractedUserData = await json.decode(prefs.getString('userData')!);
    // print("After first state");
    final expiryDate = DateTime.parse(extractedUserData['expiryDate'] as String);
    print("After checking");
    // print("inside the auto login, expiryDate "+expiryDate.toString());
    // print("inside the auto login, userData "+extractedUserData.toString());

    if(expiryDate.isBefore(DateTime.now())){
      return false;
    }
    _token = extractedUserData['token'] as String;
    _userId = extractedUserData['userId'] as String;
    _expiryDate = expiryDate;
    notifyListeners();
    return true;
  }

  Future<void> logout() async{
    print("inside logout");
    _token=null;
    _userId=null;
    _expiryDate=null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }



}

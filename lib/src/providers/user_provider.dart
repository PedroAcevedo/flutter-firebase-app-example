import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:test_app/src/preferences/user_preferences.dart';

class UserProvider {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _firebaseToken = 'AIzaSyBIENmBW-xipU7SeZK62CFirOSCs9L2G5w';
  final _prefs = new UserPreference();

  Future<Map<String, dynamic>> login(String email, String password) async{

  final FirebaseUser user = (await 
      _auth.signInWithEmailAndPassword(
        email: email,
        password: password, 
      )
  ).user;

  print(user);

  if (user != null) {
    
    final idToken = await user.getIdToken();
    final token = idToken.token;
    _prefs.token = token;

    return {'ok': true, 'token': token};

  } else {
    
    print(user);
    return {'ok': false, 'message': 'error'};
  }

  }

  Future<Map<String, dynamic>> newUser(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final resp = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken',
        body: json.encode(authData));

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    print(decodedResp);

    if (decodedResp.containsKey('idToken')) {
      
      _prefs.token = decodedResp['idToken'];

      return {'ok': true, 'token': decodedResp['idToken']};
    } else {
      return {'ok': false, 'message': decodedResp['error']['message']};
    }
  }
}

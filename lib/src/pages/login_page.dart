import 'package:flutter/material.dart';
import 'package:test_app/src/bloc/login_bloc.dart';
import 'package:test_app/src/bloc/provider_bloc.dart';
import 'package:test_app/src/providers/user_provider.dart';
import 'package:test_app/src/utils/util.dart';

class LoginPage extends StatelessWidget {
  final userProvider = UserProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[_background(context), _loginForm(context)],
      ),
    );
  }

  Widget _background(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final background = Container(
      width: double.infinity,
      height: size.height * 0.4,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Color.fromARGB(44, 87, 107, 1),
        Color.fromRGBO(115, 187, 181, 1)
      ])),
    );

    final circle = Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Color.fromRGBO(232, 223, 185, 1),
        ));

    return Stack(
      children: <Widget>[
        background,
        Positioned(top: 90.0, left: 30.0, child: circle),
        Positioned(top: -40.0, right: -30.0, child: circle),
        Container(
          padding: EdgeInsets.only(top: 80.0),
          child: Column(
            children: <Widget>[
              Icon(
                Icons.person_pin_circle,
                color: Colors.white,
                size: 100.0,
              ),
              SizedBox(
                height: 10.0,
                width: double.infinity,
              ),
              Text(
                'Pedro Acevedo',
                style: TextStyle(color: Colors.white, fontSize: 25.0),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _loginForm(BuildContext context) {
    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(child: Container(height: 180.0)),
          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 30),
            padding: EdgeInsets.symmetric(vertical: 50),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 30,
                    offset: Offset(0.0, 5.0),
                    spreadRadius: 3.0),
              ],
            ),
            child: Column(
              children: <Widget>[
                Text('Login', style: TextStyle(fontSize: 20.0)),
                SizedBox(
                  height: 60.0,
                ),
                _createEmail(bloc),
                SizedBox(
                  height: 30.0,
                ),
                _createPassword(bloc),
                SizedBox(
                  height: 30.0,
                ),
                _createButtom(bloc)
              ],
            ),
          ),
          FlatButton(
              child: Text('Create a new account'),
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, 'register')),
          SizedBox(
            height: 100.0,
          )
        ],
      ),
    );
  }

  Widget _createEmail(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'example@gmail.con',
                labelText: 'Email address',
                counterText: snapshot.data,
                errorText: snapshot.error,
                icon: Icon(
                  Icons.alternate_email,
                  color: Colors.greenAccent,
                ),
              ),
              onChanged: bloc.changeEmail,
            ));
      },
    );
  }

  Widget _createPassword(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                counterText: snapshot.data,
                errorText: snapshot.error,
                icon: Icon(
                  Icons.lock_outline,
                  color: Colors.greenAccent,
                ),
              ),
              onChanged: bloc.changePassword,
            ));
      },
    );
  }

  Widget _createButtom(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.formValidation,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          child: RaisedButton(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 20.0),
                child: Text('Login'),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              elevation: 0.0,
              color: Colors.greenAccent,
              textColor: Colors.white,
              onPressed: snapshot.hasData ? () => _login(bloc, context) : null),
        );
      },
    );
  }

  _login(LoginBloc bloc, BuildContext context) async {
    Map result = await userProvider.login(bloc.email, bloc.password);

    if (result['ok']) {
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      showAlert(context, result['message']);
    }
  }
}

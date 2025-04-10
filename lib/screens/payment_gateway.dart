import 'package:flutter/material.dart';

import '../Payment_methods/debit.dart';
import '../Payment_methods/upi.dart';



enum PageOptions { home, settings, profile }

class Check extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Radio Navigation',
      home: RadioNavigationPage(),
      routes: {
        '/home': (context) => UPI(),
        '/settings': (context) => CreditCardFormPage(),
        '/profile': (context) => CreditCardFormPage(),
      },
    );
  }
}

class RadioNavigationPage extends StatefulWidget {
  @override
  _RadioNavigationPageState createState() => _RadioNavigationPageState();
}

class _RadioNavigationPageState extends State<RadioNavigationPage> {
  PageOptions? _selectedOption;

  void _navigate(PageOptions? value) {
    setState(() {
      _selectedOption = value;
    });

    switch (value) {
      case PageOptions.home:
        Navigator.pushNamed(context, '/home');
        break;
      case PageOptions.settings:
        Navigator.pushNamed(context, '/settings');
        break;
      case PageOptions.profile:
        Navigator.pushNamed(context, '/profile');
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Payment method')),
      body: Column(
        children: <Widget>[

          Container(


            height: 447,
            child: Stack(
              children: <Widget>[
                Positioned(

                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/AI logo.png'),
                          fit: BoxFit.fill

                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 25,),
          ListTile(
            title: Text('UPI'),
            leading: Radio<PageOptions>(
              value: PageOptions.home,
              groupValue: _selectedOption,
              onChanged: _navigate,
            ),
          ),
          ListTile(
            title: Text('Debit Card'),
            leading: Radio<PageOptions>(
              value: PageOptions.settings,
              groupValue: _selectedOption,
              onChanged: _navigate,
            ),
          ),
          ListTile(
            title: Text('Credit Card'),
            leading: Radio<PageOptions>(
              value: PageOptions.profile,
              groupValue: _selectedOption,
              onChanged: _navigate,
            ),
          ),
        ],
      ),
    );
  }
}

// --------- Pages ---------

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(child: Text('This is the Home Page')),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Center(child: Text('This is the Settings Page')),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(child: Text('This is the Profile Page')),
    );
  }
}

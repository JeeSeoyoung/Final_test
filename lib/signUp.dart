import 'package:flutter/material.dart';

class CorrectWordParameter {
  bool is3Str = false;
  bool is3Num = false;
  CorrectWordParameter({this.is3Num = false, this.is3Str = false});
  bool get isCorrectId => (is3Num && is3Str);
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String _password = '';
  String _confirmPassword = '';
  bool _isValid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: [
            const SizedBox(height: 40.0),
            TextFormField(
              decoration:
                  const InputDecoration(filled: true, labelText: 'Username'),
              onChanged: (text) {
                RegExp idStrPattern = RegExp(r'\w{3,}');
                RegExp idNumPattern = RegExp(r'\d{3,}');
                if (idNumPattern.hasMatch(text) &&
                    idStrPattern.hasMatch(text)) {
                  _isValid = true;
                } else {
                  _isValid = false;
                }
              },
              validator: (value) {
                if (value!.isEmpty || value.length < 6 || _isValid == false) {
                  return 'Username is invalid';
                }
                // if (!idNumPattern.hasMatch(value)) {
                //   return 'Username is invalid';
                // }
                return null;
              },
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              obscureText: true,
              decoration:
                  const InputDecoration(filled: true, labelText: 'Password'),
              // onSaved: (value) {
              //   _password = value as String;
              // },
              onChanged: (text) {
                _password = text;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Enter Password';
                }
                return null;
              },
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                  filled: true, labelText: 'Confirm Password'),
              // onSaved: (value) {
              //   _confirmPassword = value as String;
              // },
              onChanged: (text) {
                _confirmPassword = text;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Enter Confirm Password';
                } else if (_confirmPassword != _password) {
                  return 'Confirm Password doesn\'t match Password';
                }
                return null;
              },
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              decoration: const InputDecoration(
                  filled: true, labelText: 'Email Address'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Email Address';
                }
                return null;
              },
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                const Expanded(child: SizedBox()),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white54,
                    onPrimary: Colors.black,
                  ),
                  child: const Text('SIGN UP'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

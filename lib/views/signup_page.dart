import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_voca/providers/auth_provider.dart';

class SignupPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('회원가입')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: '이메일'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: '비밀번호'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await authProvider.signUp(
                  _emailController.text,
                  _passwordController.text,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('회원가입 성공')),
                );
                Navigator.of(context).pop();
              },
              child: Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}

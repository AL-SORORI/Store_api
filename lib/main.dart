import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  final _key = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login' , style: TextStyle(color: Colors.white, fontSize: 33 , fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: Form(
            key: _key, 
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadiusGeometry.circular(20) ,
                      border: BoxBorder.all(color: Colors.teal)
                      ),
                    child: const Icon(Icons.lock, size: 80, color: Colors.teal),
                  ),
                  
                  const SizedBox(height: 30),
                  TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'\s'))
                    ],
                    controller: _name,
                    decoration: const InputDecoration(
                      labelText: 'User Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person, color: Colors.teal),
                      
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Do not leave the field empty';
                      }
                      if (value.length < 3) {
                        return 'Write at least three letters';
                      }
                      return null; 
                    },
                  ),
                  
                  const SizedBox(height: 20),

                  TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'\s'))
                    ],
                    controller: _pass,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Passowrd',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock, color: Colors.teal),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Do not leave the field empty';
                      }
                      if (value.length < 8) {
                        return 'Write at least eight letters';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 40),


                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      if (_key.currentState!.validate()) {
                        String name = _name.text;
                                                
                        _name.clear();
                        _pass.clear();

                        // انتقل بأمان واحترافية
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SuccessScreen(userName: name),
                          ),
                        );
                      } else {
                        debugPrint("Eroor in Fields");
                      }
                    },
                    child: const Text('Log in', style: TextStyle(fontSize: 19 , fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  final String userName;
  const SuccessScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 120, color: Colors.teal),
            const SizedBox(height: 20),
            Text(
              'Hello  $userName! ',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 170, 242, 236)
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Go back' , style: TextStyle(color: Colors.teal),),
            )
          ],
        ),
      ),
    );
  }
}
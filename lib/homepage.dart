import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final messageController = TextEditingController();

  bool isLoading = false;

  Future sendEmail(
      {required String name,
      required String message,
      required String email}) async {
    setState(() {
      isLoading = true;
    });
    const serviceId = 'service_8rzu50k';
    const templateId = 'template_3d5ldol';
    const userId = 'BKURIHeDcquF9efEC';
    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(
        {
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'to_email': email,
            'reply_to': 'ritesh.bhalerao.11603@gmail.com',
            'from_name': name,
            'message': message,
          }
        },
      ),
    );
    setState(() {
      isLoading = false;
    });
    return response.statusCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5fd),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: 450,
            width: 400,
            margin: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 20,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 20,
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0, 5),
                      blurRadius: 10,
                      spreadRadius: 1,
                      color: Colors.grey[300]!)
                ]),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('Contact Us',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(hintText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*Required';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(hintText: 'Email'),
                    validator: (email) {
                      if (email == null || email.isEmpty) {
                        return 'Required*';
                      } else if (!EmailValidator.validate(email)) {
                        return 'Please enter a valid Email';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: messageController,
                    decoration: const InputDecoration(hintText: 'Message'),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*Required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 45,
                    width: 110,
                    child: isLoading
                        ? Center(child: const CircularProgressIndicator())
                        : TextButton(
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: const Color(0xff151534),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40))),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final response = await sendEmail(
                                  name: nameController.value.text,
                                  email: emailController.value.text,
                                  message: messageController.value.text,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  response == 200
                                      ? const SnackBar(
                                          content: Text('Message Sent!'),
                                          backgroundColor: Colors.green)
                                      : const SnackBar(
                                          content:
                                              Text('Failed to send message!'),
                                          backgroundColor: Colors.red),
                                );
                                nameController.clear();
                                emailController.clear();
                                messageController.clear();
                              }
                            },
                            child: const Text('Send',
                                style: TextStyle(fontSize: 16)),
                          ),
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

import 'package:flutter/material.dart';
import 'package:whatsapp_clone_app/presentation/screens/home_screen.dart';
import 'package:whatsapp_clone_app/presentation/widgets/theme/style.dart';

class SetInitialProfilePage extends StatefulWidget {
  const SetInitialProfilePage({super.key});

  @override
  State<SetInitialProfilePage> createState() => _SetInitialProfilePageState();
}

class _SetInitialProfilePageState extends State<SetInitialProfilePage> {
  TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          children: <Widget>[
            // NOTE: Top Text and Description
            const Text(
              "Profile Info",
              style: TextStyle(
                color: greenColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Please provide your name and an optional Profile photo",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 30),

            // NOTE: Row image, name, etc.
            _rowWidget(),

            // NOTE: Next Button
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: MaterialButton(
                  color: greenColor,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Next",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _rowWidget() {
    return SizedBox(
      child: Row(
        children: <Widget>[
          // Image Picker
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: textIconColorGray,
              borderRadius: const BorderRadius.all(Radius.circular(25)),
            ),
            child: const Icon(Icons.camera_alt),
          ),
          const SizedBox(width: 8),

          // Name
          Expanded(
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: "Enter your name",
              ),
            ),
          ),
          const SizedBox(width: 8.0),

          // Emoticon
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: textIconColorGray,
              borderRadius: const BorderRadius.all(Radius.circular(25)),
            ),
            child: const Icon(Icons.insert_emoticon),
          ),
        ],
      ),
    );
  }
}
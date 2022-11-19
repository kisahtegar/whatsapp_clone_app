import 'package:flutter/material.dart';
import 'package:whatsapp_clone_app/presentation/pages/sub_pages/single_item_chat_user_page.dart';
import 'package:whatsapp_clone_app/presentation/widgets/theme/style.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (_, index) {
                return const SingleItemChatUserPage();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {},
        child: const Icon(Icons.chat),
      ),
    );
  }
}

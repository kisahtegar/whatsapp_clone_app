import 'package:flutter/material.dart';

class SingleItemChatUserPage extends StatelessWidget {
  const SingleItemChatUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: <Widget>[
                  SizedBox(
                    height: 55,
                    width: 55,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                      child: Image.asset("assets/profile_default.png"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Text(
                        "name",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "recent message",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ],
              ),
              const Text("10:00 AM"),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 60, right: 10),
            child: Divider(
              thickness: 1.50,
            ),
          ),
        ],
      ),
    );
  }
}

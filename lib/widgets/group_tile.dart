// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:groupchat_app/pages/chat_page.dart';
import 'package:groupchat_app/widgets/widget.dart';

class GroupTile extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;
  const GroupTile({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.userName,
  }) : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        nextScreen(
            context,
            ChatPage(
              groupId: widget.groupId,
              groupName: widget.groupName,
              userName: widget.userName,
            ));
      },
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      leading: CircleAvatar(
        backgroundColor: Color.fromRGBO(238, 122, 101, 1),
        radius: 30,
        child: Text(
          widget.groupName.substring(0, 1),
          style: TextStyle(
              color: Colors.white, fontSize: 23, fontWeight: FontWeight.w500),
        ),
      ),
      title: Text(
        widget.groupName,
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text("Join the conversation as ${widget.userName}"),
    );
  }
}

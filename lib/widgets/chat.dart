import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class Chat extends StatefulWidget {
  final List messages;
  const Chat({super.key, required this.messages});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return ListView.separated(
      separatorBuilder: (context, index) =>
          const Padding(padding: EdgeInsets.only(top: 10)),
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        if (widget.messages[index]['isUserMessage']) {
          return Container(
            margin: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(0),
                      topLeft: Radius.circular(20),
                      // color: Colors.deepPurple,
                    ),
                    color: Color.fromARGB(255, 255, 224, 224),
                  ),
                  constraints: BoxConstraints(maxWidth: width * 2 / 3),
                  child: Text(
                    widget.messages[index]['message'],
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                  ),
                )
              ],
            ),
          );
        } else {
          return Container(
            margin: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                        topLeft: Radius.circular(0),
                      ),
                      color: Color.fromARGB(255, 255, 121, 121)),
                  constraints: BoxConstraints(maxWidth: width * 2 / 3),
                  child: Html(
                    data: widget.messages[index]['message'],
                    style: {
                      'h3': Style(
                        fontSize: FontSize(16),
                        fontFamily: 'Arial',
                        fontWeight: FontWeight.bold,
                      ),
                      'p': Style(
                        fontSize: FontSize(14),
                        fontFamily: 'Arial',
                        fontWeight: FontWeight.normal,
                      ),
                      'ul': Style(
                        fontSize: FontSize(12),
                        fontFamily: 'Arial',
                        fontWeight: FontWeight.normal,
                      ),
                      'ol': Style(
                        fontSize: FontSize(10),
                        fontFamily: 'Arial',
                        fontWeight: FontWeight.normal,
                      ),
                    },
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }
}

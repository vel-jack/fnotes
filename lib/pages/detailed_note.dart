import 'package:flutter/material.dart';

class DetailedNote extends StatefulWidget {
  const DetailedNote({Key? key}) : super(key: key);

  @override
  State<DetailedNote> createState() => _DetailedNoteState();
}

class _DetailedNoteState extends State<DetailedNote> {
  final TextEditingController _textEditingController = TextEditingController();
  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: (context),
                    builder: (builder) {
                      return AlertDialog(
                        title: const Text('Tag'),
                        content: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [1, 2, 3, 4, 5]
                              .map((e) => IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.fiber_manual_record)))
                              .toList(),
                        ),
                      );
                    });
              },
              icon: const Icon(Icons.fiber_manual_record)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.done)),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TextField(
          maxLines: 50,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(border: InputBorder.none),
          controller: _textEditingController,
        ),
      ),
    );
  }
}

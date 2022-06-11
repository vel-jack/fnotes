import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fnotes/utils/auth_service.dart';
import 'package:provider/provider.dart';

class DetailedNote extends StatefulWidget {
  const DetailedNote({Key? key, this.note}) : super(key: key);
  final QueryDocumentSnapshot<Map<String, dynamic>>? note;
  @override
  State<DetailedNote> createState() => _DetailedNoteState();
}

class _DetailedNoteState extends State<DetailedNote> {
  final TextEditingController _textEditingController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.note != null) {
      _textEditingController.text = widget.note!['hi'];
    }

    super.initState();
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
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.fiber_manual_record)))
                              .toList(),
                        ),
                      );
                    });
              },
              icon: const Icon(Icons.fiber_manual_record)),
          IconButton(
              onPressed: () async {
                if (_textEditingController.text.isEmpty) return;
                if (widget.note == null) {
                  final ref = getNotePath().doc();
                  ref.set({
                    'hi': _textEditingController.text,
                    'id': ref.id,
                  });
                } else {
                  getNotePath().doc(widget.note!.id).update({
                    'hi': _textEditingController.text,
                    'id': widget.note!.id
                  });
                }
                Navigator.pop(context);
              },
              icon: const Icon(Icons.done)),
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

  CollectionReference getNotePath() {
    return _firestore
        .collection('users')
        .doc(context.read<AuthService>().userId)
        .collection('notes');
  }
}

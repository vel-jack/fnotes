import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fnotes/utils/auth_service.dart';
import 'package:fnotes/utils/constants.dart';
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
  int currentTag = 0;
  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.note != null) {
      _textEditingController.text = widget.note!['note'];
      currentTag = widget.note!['tag'];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (widget.note != null)
            IconButton(
              onPressed: () {
                getNotePath()
                    .doc(widget.note!.id)
                    .delete()
                    .then((value) => Navigator.pop(context));
              },
              icon: const Icon(Icons.delete),
              tooltip: 'Delete Note',
            ),
          IconButton(
              onPressed: () {
                showDialog(
                    context: (context),
                    builder: (builder) {
                      return AlertDialog(
                        backgroundColor: tileColor,
                        title: const Text(
                          'Tag',
                          style: TextStyle(color: Colors.white),
                        ),
                        content: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(tagColors.length, (index) {
                              return IconButton(
                                  onPressed: () {
                                    setState(() => currentTag = index);
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.fiber_manual_record,
                                    color: tagColors[index],
                                  ));
                            })),
                      );
                    });
              },
              tooltip: 'Change TAG',
              icon: Icon(Icons.fiber_manual_record,
                  color: tagColors[currentTag])),
          IconButton(
              onPressed: () async {
                if (_textEditingController.text.isEmpty) return;
                if (widget.note == null) {
                  final ref = getNotePath().doc();
                  ref.set({
                    'note': _textEditingController.text,
                    'id': ref.id,
                    'tag': currentTag,
                    'time': DateTime.now().millisecondsSinceEpoch
                  });
                } else {
                  getNotePath().doc(widget.note!.id).update({
                    'note': _textEditingController.text,
                    'id': widget.note!.id,
                    'tag': currentTag,
                    'time': DateTime.now().millisecondsSinceEpoch
                  });
                }
                Navigator.pop(context);
              },
              tooltip: 'Save',
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
          decoration:
              const InputDecoration(border: InputBorder.none, filled: true),
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

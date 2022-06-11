import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fnotes/pages/detailed_note.dart';
import 'package:fnotes/utils/auth_service.dart';
import 'package:fnotes/utils/constants.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User _user;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    _user = context.read<User>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (builder) {
                      return AlertDialog(
                        title: const Text('Flutter Notes'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                                height: 100,
                                child: Text(
                                  'Hello! ${_user.displayName}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )),
                            const SizedBox(
                              height: 40,
                              child: Text('Want to sign out?'),
                            ),
                            MaterialButton(
                                color: secondary,
                                height: 45,
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                onPressed: () {
                                  context.read<AuthService>().signOut();
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Text(
                                      'Sign out',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(
                                      Icons.exit_to_app,
                                      color: Colors.white,
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      );
                    });
              },
              icon: CircleAvatar(
                backgroundColor: secondary,
                foregroundImage: NetworkImage('${_user.photoURL}'),
              )),
          const SizedBox(width: 10),
        ],
      ),
      body: StreamBuilder(
        stream: getNotes(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: tileColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (ctx) {
                            return DetailedNote(
                              note: snapshot.data!.docs[index],
                            );
                          }));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(children: [
                                WidgetSpan(
                                    child: Icon(
                                  Icons.play_arrow,
                                  color: tagColors[snapshot.data!.docs[index]
                                      ['tag']],
                                  size: 20,
                                )),
                                const TextSpan(text: ' '),
                                TextSpan(
                                  text: '${snapshot.data!.docs[index]['note']}',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                )
                              ]),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            // SizedBox(
                            //   width: double.infinity,
                            //   child: Text(
                            //     DateTime.fromMillisecondsSinceEpoch(
                            //             snapshot.data!.docs[index]['time'])
                            //         .toString(),
                            //     style: const TextStyle(
                            //         color: Colors.white, fontSize: 10),
                            //     textAlign: TextAlign.end,
                            //   ),
                            // )
                          ],
                        )
                        // '${snapshot.data!.docs[index]['hi']}',
                        // style: const TextStyle(color: Colors.white),
                        // overflow: TextOverflow.ellipsis,
                        // maxLines: 2,

                        ),
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
            return const DetailedNote();
          }));
        },
        icon: const Icon(Icons.add),
        label: const Text('NEW NOTE'),
      ),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getNotes() {
    return _firestore
        .collection('users')
        .doc(context.read<AuthService>().userId)
        .collection('notes')
        .snapshots();
  }
}

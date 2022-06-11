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
      body: Container(),
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
}

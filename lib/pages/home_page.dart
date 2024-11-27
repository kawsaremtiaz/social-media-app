import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/components/my_drawer.dart';
import 'package:social_media_app/components/my_list_tile.dart';
import 'package:social_media_app/components/my_post_button.dart';
import 'package:social_media_app/components/my_textfield.dart';
import 'package:social_media_app/database/firestore.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  HomePage({super.key});

  // user textfield controller
  TextEditingController userTextfieldController = TextEditingController();

  // firestore access
  final FirestoreDatabase database = FirestoreDatabase();

  // post message
  void postMessage() {
    // only post message if there is something in the textfield
    if (userTextfieldController.text.isNotEmpty) {
      String message = userTextfieldController.text;
      database.addPost(message);
    }
    // clear the controller
    userTextfieldController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        title: const Text(
          "W A L L",
        ),
      ),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          // testfield box for user to type
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                // textfield
                Expanded(
                  child: MyTextfield(
                    hintText: "Say something..",
                    onscureText: false,
                    controller: userTextfieldController,
                  ),
                ),

                // button
                MyPostButton(
                  onTap: postMessage,
                )
              ],
            ),
          ),

          // posts list
          StreamBuilder(
            stream: database.getPostsStream(),
            builder: (context, snapshot) {
              // show loading circle
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              // get all posts
              final posts = snapshot.data!.docs;

              // no data
              if (snapshot.data == null || posts.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Text("No Posts.. Post something!"),
                  ),
                );
              }

              // return data as a list
              return Expanded(
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    // get each individual post
                    final post = posts[index];

                    // get data from each post
                    String message = post['PostMessage'];
                    String userEmail = post['UserEmail'];
                    // ignore: unused_local_variable
                    Timestamp timestamp = post['TimeStamp'];

                    // return as a list tile
                    return MyListTile(
                      title: message,
                      subTitle: userEmail,
                    );
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

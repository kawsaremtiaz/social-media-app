import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/components/my_back_button.dart';
import 'package:social_media_app/components/my_list_tile.dart';
import 'package:social_media_app/helper/helper_function.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   title: const Text("Users"),
      //   elevation: 0,
      // ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Users").snapshots(),
          builder: (context, snapshot) {
            // any errors
            if (snapshot.hasError) {
              displayMessageToUser("Something went wrong", context);
            }

            // show loading circle
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.data == null) {
              return const Text("No Data");
            }

            // get all users
            final users = snapshot.data!.docs;

            return Column(
              children: [
                // back button
                const Padding(
                  padding: EdgeInsets.only(
                    left: 25,
                    top: 50,
                    bottom: 25,
                  ),
                  child: Row(
                    children: [
                      MyBackButton(),
                    ],
                  ),
                ),
                // list of users
                Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.all(0),
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        // get individual user
                        final user = users[index];

                        return MyListTile(
                          title: user['username'],
                          subTitle: user['email'],
                        );
                      }),
                ),
              ],
            );
          }),
    );
  }
}

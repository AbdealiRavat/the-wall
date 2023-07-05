import 'package:WallApp/components/loader.dart';
import 'package:WallApp/components/text_field.dart';
import 'package:WallApp/pages/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/drawer.dart';
import '../components/wall_post.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  final textController = TextEditingController();

  void postMessage() {
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
      });
      print('message posted');
      textController.clear();
    }
  }

  void openProfilePage() {
    Navigator.pop(context);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ProfilePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Wall App'),
        backgroundColor: Colors.grey[900],
        elevation: 0,
      ),
      drawer: MyDrawer(
          signOut: signOut,
          openProfile: openProfilePage,
          openHome: () => Navigator.pop(context)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("User Posts")
                  .orderBy("TimeStamp", descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final post = snapshot.data!.docs[index];
                        return WallPost(
                          message: post['Message'],
                          user: post['UserEmail'],
                          timeStamp: post['TimeStamp'],
                          postId: post.id,
                          likes: List<String>.from(post['Likes'] ?? []),
                        );
                      });
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error'));
                }
                return const Center(child: Loader());
              },
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          // RatingBar(
          //   initialRating: 3,
          //   minRating: 0,
          //   direction: Axis.horizontal,
          //   allowHalfRating: true,
          //   itemCount: 5,
          //   glow: true,
          //   // ignoreGestures: true,
          //   ratingWidget: RatingWidget(
          //     full: Icon(
          //       Icons.star,
          //       color: Colors.amber,
          //     ),
          //     half: Icon(
          //       Icons.star_half,
          //       color: Colors.amber,
          //     ),
          //     empty: Icon(
          //       Icons.star_border,
          //       color: Colors.amber,
          //     ),
          //   ),
          //   onRatingUpdate: (rating) {
          //     print(rating);
          //   },
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: MyTextField(
                    controller: textController,
                    hintText: 'Post to the Wall',
                    tColor: Colors.black,
                    obscureText: false),
              ),
              IconButton(
                  onPressed: postMessage, icon: const Icon(Icons.arrow_upward))
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     const Text('Hello'),
          //     const SizedBox(
          //       width: 20,
          //     ),
          //     Text(currentUser.email.toString()),
          //   ],
          // ),
        ],
      ),
    );
  }
}

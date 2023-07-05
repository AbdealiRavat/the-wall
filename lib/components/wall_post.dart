import 'package:WallApp/components/likes_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final List<String> likes;
  final Timestamp timeStamp;

  const WallPost({
    super.key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,
    required this.timeStamp,
  });

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);
    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width * 0.85,
      // height: 40,
      margin: const EdgeInsets.only(top: 25, right: 25, left: 25),
      padding: const EdgeInsets.all(25),
      // alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Column(
            children: [
              LikesButton(isLiked: isLiked, onTap: toggleLike),
              const SizedBox(
                height: 5,
              ),
              Text(
                widget.likes.length.toString(),
                style: const TextStyle(fontSize: 12),
              )
            ],
          ),
          // Container(
          //   padding: EdgeInsets.all(10),
          //   decoration:
          //       BoxDecoration(shape: BoxShape.circle, color: Colors.grey[400]),
          //   child: Icon(
          //     Icons.person_rounded,
          //     color: Colors.white,
          //     size: 30,
          //   ),
          // ),
          const SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.user, style: TextStyle(color: Colors.grey[500])),
              const SizedBox(
                height: 20,
              ),
              Text(
                widget.message,
                style: TextStyle(
                    fontWeight: FontWeight.w400, color: Colors.grey[800]),
              ),
              // SizedBox(
              //   height: 20,
              // ),
              // Text(
              //     // timeago.format(timeStamp.toDate()),
              //   DateFormat.yMEd().format(widget.timeStamp.toDate()),
              //   style: TextStyle(fontWeight: FontWeight.w700),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}

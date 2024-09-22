import 'package:flutter/material.dart';

class CommentCard extends StatelessWidget {
  final Comment comment;
  final bool showFullEmail;

  const CommentCard({required this.comment, required this.showFullEmail, super.key});

  String _maskEmail(String email) {
    int atIndex = email.indexOf('@');
    return '${email.substring(0, 1)}****${email.substring(atIndex)}';
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListTile(
          leading: CircleAvatar(
            maxRadius: height * 0.03,
            backgroundColor: Colors.grey,
            child: Text(
              comment.name[0].toUpperCase(),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: height * 0.023,
              ),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: 'Name: ',
                  style:TextStyle(color: Colors.grey,fontSize: height*0.018),
                  children: [
                    TextSpan(
                      text: comment.name,
                      style: TextStyle(
                        color: Colors.black, 
                        fontWeight: FontWeight.bold,
                        fontSize: height*0.018
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    'Email: ',
                    style: TextStyle(color: Colors.grey,fontSize: height*0.018),
                  ),
                  Expanded(
                    child: Text(
                      showFullEmail ? comment.email : _maskEmail(comment.email),
                      style: TextStyle(color: Colors.black,fontWeight:FontWeight.bold,fontSize:height*0.018),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(comment.body),
            ],
          ),
        ),
      ),
    );
  }
}

class Comment {
  final String name;
  final String email;
  final String body;

  Comment({
    required this.name,
    required this.email,
    required this.body,
  });
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      name: json['name'],
      email: json['email'],
      body: json['body'],
    );
  }
}

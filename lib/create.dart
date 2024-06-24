import 'package:flutter/material.dart';

class CreatePage extends StatelessWidget {
  final Function(String, String) onCreateNote;

  CreatePage({required this.onCreateNote});

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: "Title...",
                hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w300, fontSize: 20),
                labelStyle: TextStyle(color: Colors.white),
                border: InputBorder.none,
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.check),
              color: Colors.white,
              onPressed: () {
                onCreateNote(_titleController.text, _contentController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.black,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _contentController,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Type your note here...', // Hint text for content
                        hintStyle: TextStyle(color: Colors.grey),
                        labelStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none, // Remove border
                        contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

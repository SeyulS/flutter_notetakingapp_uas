import 'package:flutter/material.dart';
import 'package:flutter_notetakingapp_uas/homepage.dart';

class EditPage extends StatefulWidget {
  final String id;
  final String title;
  final String content;
  final String date;
  final String modified_date;
  final Function(String) onUpdateContent;
  final Function(String) onUpdateTitle;
  final VoidCallback onDelete;

  EditPage({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.modified_date,
    required this.onUpdateContent,
    required this.onUpdateTitle,
    required this.onDelete,
  });

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TextEditingController contentController;
  late TextEditingController titleController;

  @override
  void initState() {
    super.initState();
    contentController = TextEditingController(text: widget.content);
    titleController = TextEditingController(text: widget.title);
  }

  String timeAgo(String timestamp) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(DateTime.parse(timestamp));

    if (difference.inDays >= 365) {
      int years = (difference.inDays / 365).floor();
      return "${years}y ago";
    } else if (difference.inDays >= 30) {
      int months = (difference.inDays / 30).floor();
      return "${months}m ago";
    } else if (difference.inDays >= 7) {
      int weeks = (difference.inDays / 7).floor();
      return "${weeks}w ago";
    } else if (difference.inDays >= 1) {
      return "${difference.inDays}d ago";
    } else if (difference.inHours >= 1) {
      return "${difference.inHours}h ago";
    } else if (difference.inMinutes >= 1) {
      return "${difference.inMinutes}m ago";
    } else {
      return "${difference.inSeconds}s ago";
    }
  }

  String formatDate(String dateStr) {
    final DateTime date = DateTime.parse(dateStr);
    final List<String> monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    String formattedDate =
        '${date.day} ${monthNames[date.month - 1]} ${date.year}';
    formattedDate +=
        ' ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Tooltip(
          message: widget.title, 
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  controller: titleController,
                  onChanged: (newText) {
                    widget.onUpdateTitle(newText);
                  },
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  decoration: InputDecoration(
                    hintText: 'Title',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.white),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Delete Note'),
                        content:
                            Text('Are you sure you want to delete this note?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              widget.onDelete();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()),
                                (Route<dynamic> route) => false,
                              );
                            },
                            child: Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Created on ${formatDate(widget.date)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
              ),
            ),
            SizedBox(height: 10),
            Divider(
              color: Colors.grey,
              thickness: 0.2,
            ),
            SizedBox(height: 2),
            Expanded(
              child: SingleChildScrollView(
                child: TextField(
                  controller: contentController,
                  onChanged: (newText) {
                    widget.onUpdateContent(newText);
                  },
                  maxLines: null,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Edit your note here...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_notetakingapp_uas/confirmation.dart';
import 'package:flutter_notetakingapp_uas/create.dart';
import 'package:flutter_notetakingapp_uas/edit.dart';
import 'package:flutter_notetakingapp_uas/settings.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box('myBox');
  final _key = TextEditingController();
  final _val = TextEditingController();
  String data = "";
  int _crossAxisCount = 2;
  bool _isAscending = true;
  bool _sortByModifiedDate = true; // True for modified date, false for created date
  List<String> sortedKeys = [];

  @override
  void initState() {
    sortedKeys = _myBox.keys.cast<String>().toList();
    sortByDate();
  }

  void writeData(String title, String content) {
    String _date = DateTime.now().toString();
    _myBox.put(
        title, {'content': content, 'date': _date, 'modified_date': _date});
    setState(() {
      data = content;
      sortedKeys = _myBox.keys.cast<String>().toList();
      sortByDate();
    });
    _key.clear();
    _val.clear();
    setState(() {});
  }

  void deleteData(String key) {
    _myBox.delete(key);
    setState(() {
      data = "";
      sortedKeys = _myBox.keys.cast<String>().toList();
      sortByDate();
    });
  }

  void updateContent(String key, String newContent) {
    String _date = DateTime.now().toString();
    var note = _myBox.get(key);
    var created = note['date'];
    note['content'] = newContent;
    _myBox.put(key,
        {'content': note['content'], 'date': created, 'modified_date': _date});
    setState(() {
      sortedKeys = _myBox.keys.cast<String>().toList();
      sortByDate();
    });
  }

  void sortByDate() {
    sortedKeys.sort((a, b) {
      DateTime dateA = DateTime.parse(_myBox.get(a)[_sortByModifiedDate ? 'modified_date' : 'date']);
      DateTime dateB = DateTime.parse(_myBox.get(b)[_sortByModifiedDate ? 'modified_date' : 'date']);
      return _isAscending ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
    });
  }

  String formatDate(String dateStr) {
    final DateTime date = DateTime.parse(dateStr);
    final List<String> monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${monthNames[date.month - 1]} ${date.day}';
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

  void _setCrossAxisCount(int count) {
    setState(() {
      _crossAxisCount = count;
    });
  }

  void _toggleSortOrder() {
    setState(() {
      _isAscending = !_isAscending;
      sortByDate();
    });
  }

  void _toggleSortBy() {
    setState(() {
      _sortByModifiedDate = !_sortByModifiedDate;
      sortByDate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "My Notes",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ConfirmPage(),
                ),
              );
            },
            child: Icon(Icons.lock_person_outlined),
          ),
          PopupMenuButton<int>(
            icon: Icon(Icons.grid_view_sharp),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 2,
                child: Text('2 Grid'),
              ),
              PopupMenuItem<int>(
                value: 3,
                child: Text('3 Grid'),
              ),
            ],
            onSelected: (value) {
              _setCrossAxisCount(value);
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.date_range,color: Colors.white, size: 17,),
                      TextButton(
                        onPressed: _toggleSortBy,
                        child: Text(_sortByModifiedDate ? 'Sort by Modified Date' : 'Sort by Created Date',style: TextStyle(fontSize: 14,color: Colors.white),),
                      ),
                      Text('|', style: TextStyle(color: Colors.white, fontSize: 16),),
                      IconButton(
                        icon: Icon(_isAscending ? Icons.arrow_upward : Icons.arrow_downward, size: 17, color: Colors.white,),
                        onPressed: _toggleSortOrder,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                itemCount: sortedKeys.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _crossAxisCount,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 10,
                  childAspectRatio: _crossAxisCount == 2 ? 0.6 : 0.4,
                ),
                itemBuilder: (context, index) {
                  String key = sortedKeys[index];
                  var value = _myBox.get(key);
                  if (value is Map) {
                    String content = value['content']!;
                    String date = value['date']!;
                    String modified_date = value['modified_date']!;
                    return GestureDetector(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPage(
                              title: key,
                              content: content,
                              date: date,
                              modified_date: modified_date,
                              onUpdateContent: (newContent) {
                                updateContent(key, newContent);
                              },
                              onDelete: () {
                                deleteData(key);
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 250,
                            width: double.infinity,
                            child: Card(
                              color: Color.fromARGB(171, 19, 18, 18),
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        content,
                                        maxLines: 10,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Center(
                            child: Text(
                              key,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.date_range, color: Colors.white, size: 13),
                                SizedBox(width: 5),
                                Text(
                                  '${formatDate(modified_date)} (${timeAgo(modified_date)})',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePage(
                onCreateNote: (title, content) {
                  writeData(title, content);
                },
              ),
            ),
          );
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}




import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financialapp/views/tracker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/firestore.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // firestore
  final FirestoreService firestoreService = FirestoreService();

  // text controller
  final TextEditingController textController = TextEditingController();

  // open a dialog box to add a note
  void openNoteBox({String? docID}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // text user input
        content: TextField(
          controller: textController,
        ),
        actions: [
          // button to save
          ElevatedButton(
            onPressed: () {
              // add a new note
              if (docID == null) {
                addNote();
              } else {
                updateNote(docID);
              }

              // clear the text controller
              textController.clear();

              // close the box
              Navigator.pop(context);
            },
            child: const Text("Add"),
          )
        ],
      ),
    );
  }

  // add a new note
  void addNote() {
    DateTime now = DateTime.now();
    String formattedDateTime =
        "${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}";

    // add note with date and time
    firestoreService.addNote(
      "${textController.text} - $formattedDateTime",
    );
  }

  // update an existing note
  void updateNote(String docID) {
    DateTime now = DateTime.now();
    String formattedDateTime =
        "${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}";

    // update note with new date and time
    firestoreService.updateNote(
      docID,
      "${textController.text} - $formattedDateTime",
    );
  }

  final user = FirebaseAuth.instance.currentUser!;

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: const Color(0xFF04102A),
          title: Row(
            children: [
              Image.asset(
                'images/galaxy-logo.jpg',
                width: 40,
                height: 40,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Galaxy Ray',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFC201F2),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: signUserOut,
              icon: const Icon(Icons.logout, color: Colors.red),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Color(0xFF0FF8FF),
            tabs: [
              Tab(
                child: Text(
                  'List',
                  style: TextStyle(color: Color(0xFF0FF8FF)),
                ),
              ),
              Tab(
                child: Text(
                  'Tracker',
                  style: TextStyle(color: Color(0xFF0FF8FF)),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          color: const Color(0xFF04102A).withOpacity(0.9),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 25.0),
            child: TabBarView(
              children: [
                // Tab 1: List of Notes
                StreamBuilder<QuerySnapshot>(
                  stream: firestoreService.getNotesStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<DocumentSnapshot> notesList = snapshot.data!.docs;

                      return Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: notesList.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot document = notesList[index];
                                String docID = document.id;
                                Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
                                String noteText = data?['note'] ?? '';

                                // Splitting the note into text and date-time parts
                                List<String> noteParts = noteText.split(' - ');

                                // Extracting the text and date-time
                                String text = noteParts[0];
                                String dateTime = noteParts.length > 1 ? noteParts[1] : '';

                                return Container(
                                  height: 50,
                                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: const Color(0xFF213A71),
                                  ),
                                  child: Center(
                                    child: ListTile(
                                      title: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            text,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16, // Adjust the font size as needed
                                            ),
                                          ),
                                          if (dateTime.isNotEmpty)
                                            Text(
                                              dateTime,
                                              style: const TextStyle(
                                                color: Colors.grey, // Adjust the color as needed
                                                fontSize: 12, // Adjust the font size as needed
                                              ),
                                            ),
                                        ],
                                      ),
                                      trailing: Padding(
                                        padding: const EdgeInsets.only(bottom: 10),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              onPressed: () => openNoteBox(docID: docID),
                                              icon: const Icon(
                                                Icons.edit_note,
                                                color: Colors.lightBlue,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () => firestoreService.deleteNote(docID),
                                              icon: const Icon(Icons.delete, color: Colors.red),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          FloatingActionButton(
                            onPressed: () => openNoteBox(),
                            child: const Icon(Icons.add),
                          ),
                        ],
                      );
                    } else {
                      return const Text(
                        "No notes...",
                        style: TextStyle(color: Colors.white),
                      );
                    }
                  },
                ),

                // Tab 2: Tracker Page
                const trackerPage(),
              ],
            ),
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //  onPressed: openNoteBox,
        //  child: const Icon(Icons.add),
        //  ),
      ),
    );
  }
}

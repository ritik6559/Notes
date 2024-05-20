import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mynotes/database/notes_database.dart';
import 'package:mynotes/pages/notes_details_page.dart';
import 'package:mynotes/widget/note_card_widget.dart';
import '../model/note.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();
    super.dispose();
  }

  Future refreshNotes() async {
    setState(() {
      isLoading = true;
    });

    notes = await NotesDatabase.instance.readAllNotes();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          Icon(Icons.search),
          SizedBox(
            width: 12,
          )
        ],
        title: const Text(
          'Notes',
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : notes.isEmpty
                ? const Text(
                    'Add notes',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  )
                : buildNotes(),
      ),
    );
  }

  Widget buildNotes() => StaggeredGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        children: List.generate(
          notes.length,
          (index) {
            final note = notes[index];

            return StaggeredGridTile.fit(
              crossAxisCellCount: 1,
              child: GestureDetector(
                onTap: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NoteDetailPage(noteId: note.id!),
                  ));
                  refreshNotes();
                },
                child: NoteCardWidget(note: note, index: index),
              ),
            );
          },
        ),
      );
}

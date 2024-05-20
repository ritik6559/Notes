import 'package:flutter/material.dart';
import 'package:mynotes/model/note.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;
  
  const AddEditNotePage({
    super.key, 
    this.note
    });

  @override
  State<AddEditNotePage> createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

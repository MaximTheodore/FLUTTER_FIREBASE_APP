import 'package:flutter_firebase_app/features/home/data/models/note_model.dart';

abstract class NoteRepository {
  Future<void> add(NoteModel note);
  Future<void> update(String id, NoteModel note);
  Future<void> delete(String id);
  Future<NoteModel?> getNoteById(String id);
  Future<List<NoteModel>> getAllNotes();
}
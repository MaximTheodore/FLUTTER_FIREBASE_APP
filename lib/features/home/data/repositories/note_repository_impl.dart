import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_app/features/home/data/models/note_model.dart';
import 'package:flutter_firebase_app/features/home/domain/repositories/note_repository.dart';

class NoteRepositoryImpl implements NoteRepository {
  final CollectionReference _noteCollection = 
    FirebaseFirestore.instance.collection('notes');

  @override
  Future<List<NoteModel>> getAllNotes() async{
    final snapshot = await _noteCollection.get();
    return snapshot.docs.map((doc)=> NoteModel.fromFirestore(doc)).toList();
  }

  @override
  Future<NoteModel?> getNoteById(String id) async{
    final doc = await _noteCollection.doc(id).get();
    if (doc.exists) return NoteModel.fromFirestore(doc);
    return null;
  }
  @override
  Future<void> add(NoteModel note) async{
    await _noteCollection.add(note.toMap());
  }

  @override
  Future<void> delete(String id) async{
    await _noteCollection.doc(id).delete(); 
  }


  @override
  Future<void> update(String id, NoteModel note) async{
    await _noteCollection.doc(id).update(note.toMap());
  }

}
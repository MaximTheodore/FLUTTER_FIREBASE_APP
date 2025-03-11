import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  final String? id;
  final String note;

  NoteModel({
    this.id,
    required this.note
  });

  factory NoteModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NoteModel(
      id: doc.id,
      note: data['note'] as String,
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'note': note
    };
  }
}
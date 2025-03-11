import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_app/features/auth/presentation/blocs/auth_cubit.dart';
import 'package:flutter_firebase_app/features/home/data/models/note_model.dart';
import 'package:go_router/go_router.dart';
import '../blocs/cubit/note_cubit.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _noteController = TextEditingController();
  String? _editingNoteId;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список заметок'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async{
              await context.read<AuthCubit>().signOut();
              context.go('/auth');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<NoteCubit, NoteState>(
              builder: (context, state) {
                if (state is NoteInitial) {
                  context.read<NoteCubit>().loadNotes();
                  return Center(child: CircularProgressIndicator());
                } else if (state is NoteLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is NoteLoaded) {
                  return ListView.builder(
                    itemCount: state.notes.length,
                    itemBuilder: (context, index) {
                      final note = state.notes[index];
                      return ListTile(
                        title: Text(note.note),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                setState(() {
                                  _editingNoteId = note.id;
                                  _noteController.text = note.note;
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                context.read<NoteCubit>().deleteNote(note.id!);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (state is NoteError) {
                  return Center(child: Text(state.message));
                }
                return Center(child: Text('Ничего'));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _noteController,
                    decoration: InputDecoration(
                      labelText: 'Введите заметку',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    final noteText = _noteController.text.trim();
                    if (noteText.isNotEmpty) {
                      if (_editingNoteId != null) {
                        // Режим редактирования
                        context.read<NoteCubit>().updateNote(
                              _editingNoteId!,
                              NoteModel(note: noteText),
                            );
                        setState(() {
                          _editingNoteId = null;
                        });
                      } else {
                        // Режим добавления
                        context.read<NoteCubit>().addNote(
                              NoteModel(note: noteText),
                            );
                      }
                      _noteController.clear();
                    }
                  },
                  icon: Icon(_editingNoteId != null ? Icons.edit : Icons.add),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
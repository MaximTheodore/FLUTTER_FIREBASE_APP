import 'package:bloc/bloc.dart';
import 'package:flutter_firebase_app/features/home/data/models/note_model.dart';
import 'package:flutter_firebase_app/features/home/domain/repositories/note_repository.dart';
import 'package:meta/meta.dart';

part 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  final NoteRepository _noteRepository;

  NoteCubit(this._noteRepository) : super(NoteInitial());
  Future<void> loadNotes() async {
    emit(NoteLoading());
    try {
      final notes = await _noteRepository.getAllNotes();
      emit(NoteLoaded(notes));
    } catch (e) {
      emit(NoteError('Ошибка загрузки заметок: $e'));
    }
  }

  Future<void> addNote(NoteModel note) async {
    emit(NoteLoading());
    try {
      await _noteRepository.add(note);
      loadNotes();
    } catch (e) {
      emit(NoteError('Ошибка добавления заметки: $e'));
    }
  }

  Future<void> updateNote(String id, NoteModel note) async {
    emit(NoteLoading());
    try {
      await _noteRepository.update(id, note);
      loadNotes();
    } catch (e) {
      emit(NoteError('Ошибка обновления заметки: $e'));
    }
  }

  Future<void> deleteNote(String id) async {
    emit(NoteLoading());
    try {
      await _noteRepository.delete(id);
      loadNotes();
    } catch (e) {
      emit(NoteError('Ошибка удаления заметки: $e'));
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Note {
  final String id;
  String title;
  String content;
  Color color;
  NoteState state;
  final DateTime createdAt;
  DateTime modifiedAt;

  /// Instantiates a [Note].
  Note({
    this.id,
    this.title,
    this.content,
    this.color,
    this.state,
    DateTime createdAt,
    DateTime modifiedAt,
  })  : this.createdAt = createdAt ?? DateTime.now(),
        this.modifiedAt = modifiedAt ?? DateTime.now();

  /// Transforms the Firestore query [snapshot] into a list of [Note] instances.
  static List<Note> fromQuery(QuerySnapshot snapshot) =>
      snapshot != null ? toNotes(snapshot) : [];
}

/// State enum for a note.
enum NoteState {
  unspecified,
  pinned,
  archived,
  deleted,
}

/// Transforms the query result into a list of notes.
List<Note> toNotes(QuerySnapshot query) =>
    query.documents.map((d) => toNote(d)).where((n) => n != null).toList();

/// Transforms a document into a single note.
Note toNote(DocumentSnapshot doc) => doc.exists
    ? Note(
        id: doc.id,
        title: doc.data()['title'],
        content: doc.data()['content'],
        state: NoteState.values[doc.data()['state'] ?? 0],
        color: _parseColor(doc.data()['color']),
        createdAt:
            DateTime.fromMillisecondsSinceEpoch(doc.data()['createdAt'] ?? 0),
        modifiedAt:
            DateTime.fromMillisecondsSinceEpoch(doc.data()['modifiedAt'] ?? 0),
      )
    : null;

Color _parseColor(num colorInt) => Color(colorInt ?? 0xFFFFFFFF);

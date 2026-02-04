import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/document.dart';

class DocumentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<Document>> getUserDocuments(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('documents')
          .orderBy('uploadedAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => Document.fromMap(doc.data())).toList();
    } catch (e) {
      print('Error fetching documents: $e');
      return [];
    }
  }

  Future<String> uploadDocument(
    String userId,
    String fileName,
    DocumentType type,
    DateTime? issueDate,
    DateTime? expiryDate,
    String notes,
  ) async {
    try {
      // This is a mock implementation for demo purposes
      // In a real app, you would upload the file to Firebase Storage
      // and get the download URL

      final documentId = DateTime.now().millisecondsSinceEpoch.toString();
      final documentRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('documents')
          .doc(documentId);

      final document = Document(
        id: documentId,
        userId: userId,
        fileName: fileName,
        fileUrl: 'https://example.com/documents/$documentId',
        type: type,
        issueDate: issueDate,
        expiryDate: expiryDate,
        status: expiryDate != null
            ? DocumentStatus.values.first
            : DocumentStatus.valid,
        uploadedAt: DateTime.now(),
        notes: notes,
      );

      await documentRef.set(document.toMap());
      return documentId;
    } catch (e) {
      print('Error uploading document: $e');
      return '';
    }
  }

  Future<bool> deleteDocument(String userId, String documentId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('documents')
          .doc(documentId)
          .delete();
      return true;
    } catch (e) {
      print('Error deleting document: $e');
      return false;
    }
  }
}

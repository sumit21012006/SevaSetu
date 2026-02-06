import 'package:flutter/foundation.dart';
import '../models/models.dart';

class DocumentProvider extends ChangeNotifier {
  final List<DocumentModel> _documents = [
    DocumentModel(
      id: '1',
      userId: 'demo',
      type: 'Aadhaar Card',
      issueDate: DateTime(2020, 1, 15),
      expiryDate: DateTime(2030, 1, 15),
      status: 'Valid',
    ),
    DocumentModel(
      id: '2',
      userId: 'demo',
      type: 'Driving License',
      issueDate: DateTime(2022, 6, 10),
      expiryDate: DateTime(2025, 6, 10),
      status: 'Valid',
    ),
    DocumentModel(
      id: '3',
      userId: 'demo',
      type: 'Income Certificate',
      issueDate: DateTime(2023, 3, 20),
      expiryDate: DateTime(2024, 3, 20),
      status: 'Expired',
    ),
    DocumentModel(
      id: '4',
      userId: 'demo',
      type: 'PAN Card',
      issueDate: DateTime(2018, 11, 5),
      expiryDate: null,
      status: 'Valid',
    ),
  ];

  List<DocumentModel> get documents => _documents;

  void addDocument(DocumentModel document) {
    _documents.add(document);
    notifyListeners();
  }

  void removeDocument(String id) {
    _documents.removeWhere((doc) => doc.id == id);
    notifyListeners();
  }
}

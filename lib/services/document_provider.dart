import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';

class DocumentProvider with ChangeNotifier {
  FirebaseFirestore? _firestore;
  List<DocumentModel> _documents = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDemoMode = true;

  List<DocumentModel> get documents => _documents;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isDemoMode => _isDemoMode;

  // Demo documents for fallback
  final List<DocumentModel> _demoDocuments = [
    DocumentModel(
      id: '1',
      userId: 'demo',
      type: 'Aadhaar Card',
      issueDate: DateTime(2020, 1, 15),
      expiryDate: DateTime(2030, 1, 15),
      status: 'Valid',
      isPdf: false,
    ),
    DocumentModel(
      id: '2',
      userId: 'demo',
      type: 'Driving License',
      issueDate: DateTime(2022, 6, 10),
      expiryDate: DateTime(2025, 6, 10),
      status: 'Valid',
      isPdf: false,
    ),
    DocumentModel(
      id: '3',
      userId: 'demo',
      type: 'Income Certificate',
      issueDate: DateTime(2023, 3, 20),
      expiryDate: DateTime(2024, 3, 20),
      status: 'Expired',
      isPdf: false,
    ),
    DocumentModel(
      id: '4',
      userId: 'demo',
      type: 'Birth Certificate',
      issueDate: DateTime(2010, 5, 15),
      expiryDate: null,
      status: 'Valid',
      isPdf: true,
      fileName: 'birth_certificate.pdf',
    ),
  ];

  DocumentProvider() {
    _initFirestore();
  }

  void _initFirestore() {
    if (kIsWeb) {
      // Use demo mode for web
      _isDemoMode = true;
      _documents = _demoDocuments;
      print('ℹ️ DocumentProvider: Demo mode (web)');
    } else {
      // Try to initialize Firestore for mobile
      try {
        _firestore = FirebaseFirestore.instance;
        _isDemoMode = false;
        _loadDocuments();
      } catch (e) {
        _isDemoMode = true;
        _documents = _demoDocuments;
        print('⚠️ Firestore failed, using demo mode: $e');
      }
    }
  }

  Future<void> _loadDocuments() async {
    if (_isDemoMode) {
      _documents = _demoDocuments;
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Try to load from Firestore
      final snapshot = await _firestore!
          .collection('documents')
          .where('userId', isEqualTo: 'current_user')
          .get();

      if (snapshot.docs.isNotEmpty) {
        _documents = snapshot.docs
            .map((doc) => DocumentModel.fromJson(doc.data()))
            .toList();
      } else {
        _documents = _demoDocuments;
      }
    } catch (e) {
      _documents = _demoDocuments;
      _errorMessage = 'Using demo mode';
    }

    _isLoading = false;
    notifyListeners();
  }

  void addDocument(DocumentModel document) {
    _documents.insert(0, document);
    notifyListeners();
    
    // Try to save to Firestore (non-blocking)
    if (!_isDemoMode) {
      _saveToFirestore(document);
    }
  }

  Future<void> _saveToFirestore(DocumentModel document) async {
    try {
      await _firestore!.collection('documents').doc(document.id).set(
        document.toJson(),
      );
    } catch (e) {
      print('Firestore save error: $e');
    }
  }

  void removeDocument(String id) {
    _documents.removeWhere((doc) => doc.id == id);
    notifyListeners();
    
    // Try to delete from Firestore (non-blocking)
    if (!_isDemoMode) {
      _deleteFromFirestore(id);
    }
  }

  Future<void> _deleteFromFirestore(String id) async {
    try {
      await _firestore!.collection('documents').doc(id).delete();
    } catch (e) {
      print('Firestore delete error: $e');
    }
  }

  void updateDocument(DocumentModel document) {
    final index = _documents.indexWhere((doc) => doc.id == document.id);
    if (index != -1) {
      _documents[index] = document;
      notifyListeners();
      
      if (!_isDemoMode) {
        _saveToFirestore(document);
      }
    }
  }

  List<DocumentModel> getPdfDocuments() {
    return _documents.where((doc) => doc.isPdf).toList();
  }

  List<DocumentModel> getImageDocuments() {
    return _documents.where((doc) => !doc.isPdf).toList();
  }

  List<DocumentModel> getExpiredDocuments() {
    return _documents.where((doc) => doc.status == 'Expired').toList();
  }

  List<DocumentModel> getValidDocuments() {
    return _documents.where((doc) => doc.status == 'Valid').toList();
  }

  void refreshDocuments() {
    if (!_isDemoMode) {
      _loadDocuments();
    }
  }
}

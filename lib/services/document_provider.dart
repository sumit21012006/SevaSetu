import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';

class DocumentProvider with ChangeNotifier {
  FirebaseFirestore? _firestore;
  List<DocumentModel> _documents = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDemoMode = true;
  String? _currentUserId;

  List<DocumentModel> get documents => _documents;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isDemoMode => _isDemoMode;

  // Demo documents for fallback
  final List<DocumentModel> _demoDocuments = [
    DocumentModel(
      id: '1',
      userId: 'demo-user',
      type: 'Aadhaar Card',
      issueDate: DateTime(2020, 1, 15),
      expiryDate: DateTime(2030, 1, 15),
      status: 'Valid',
      isPdf: false,
    ),
    DocumentModel(
      id: '2',
      userId: 'demo-user',
      type: 'Driving License',
      issueDate: DateTime(2022, 6, 10),
      expiryDate: DateTime(2025, 6, 10),
      status: 'Valid',
      isPdf: false,
    ),
    DocumentModel(
      id: '3',
      userId: 'demo-user',
      type: 'Income Certificate',
      issueDate: DateTime(2023, 3, 20),
      expiryDate: DateTime(2024, 3, 20),
      status: 'Expired',
      isPdf: false,
    ),
    DocumentModel(
      id: '4',
      userId: 'demo-user',
      type: 'Birth Certificate',
      issueDate: DateTime(2010, 5, 15),
      expiryDate: null,
      status: 'Valid',
      isPdf: true,
      fileName: 'birth_certificate.pdf',
    ),
    DocumentModel(
      id: '5',
      userId: 'demo-user',
      type: 'PAN Card',
      issueDate: DateTime(2020, 1, 15),
      expiryDate: DateTime(2025, 2, 20), // Expiring within 30 days
      status: 'Expiring Soon',
      isPdf: false,
    ),
    DocumentModel(
      id: '6',
      userId: 'demo-user',
      type: 'Passport',
      issueDate: DateTime(2020, 1, 15),
      expiryDate: DateTime(2025, 2, 15), // Expiring today
      status: 'Expiring Soon',
      isPdf: false,
    ),
  ];

  DocumentProvider() {
    _initFirestore();
  }

  void _initFirestore() {
    try {
      _firestore = FirebaseFirestore.instance;
      _isDemoMode = false;
      print('✅ Firestore initialized');
      _loadDocuments();
    } catch (e) {
      _isDemoMode = true;
      _documents = _demoDocuments;
      print('⚠️ Firestore error: $e');
    }
  }

  Future<void> _loadDocuments() async {
    if (_isDemoMode) {
      print('📚 Using demo documents (demo mode)');
      _documents = _demoDocuments;
      return;
    }

    if (_firestore == null) {
      print('❌ Firestore not initialized');
      _documents = _demoDocuments;
      return;
    }

    if (_currentUserId == null) {
      print('⚠️ No user ID set, cannot load documents');
      _documents = [];
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      print('📥 Loading documents for user: $_currentUserId');
      // Filter documents by current user ID
      final snapshot = await _firestore!
          .collection('documents')
          .where('userId', isEqualTo: _currentUserId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        _documents = snapshot.docs
            .map((doc) => DocumentModel.fromJson(doc.data()))
            .toList();
        print('✅ Loaded ${_documents.length} documents from Firestore');
      } else {
        print('ℹ️ No documents found in Firestore for user $_currentUserId');
        _documents = [];
      }
    } catch (e) {
      print('❌ Error loading from Firestore: $e');
      _documents = [];
      _errorMessage = 'Failed to load: $e';
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
    if (_firestore == null) {
      print('❌ Firestore not initialized');
      return;
    }

    try {
      print('💾 Saving document metadata to Firestore: ${document.id}');
      // Save only metadata, not image data
      await _firestore!.collection('documents').doc(document.id).set(
            document.toFirestoreJson(),
          );
      print('✅ Document saved successfully: ${document.id}');

      // TODO: If there's image data, upload to Cloud Storage separately
      if (document.imageData != null) {
        print('📸 Image data detected - should upload to Cloud Storage');
        // _uploadImageToStorage(document);
      }
    } catch (e) {
      print('❌ Firestore save error: $e');
      _errorMessage = 'Failed to save: $e';
      notifyListeners();
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

  List<DocumentModel> getExpiringSoonDocuments() {
    return _documents.where((doc) => doc.status == 'Expiring Soon').toList();
  }

  List<DocumentModel> getValidDocuments() {
    return _documents.where((doc) => doc.status == 'Valid').toList();
  }

  /// Get all documents that need attention (expired or expiring soon)
  List<DocumentModel> getDocumentsNeedingAttention() {
    return _documents
        .where(
            (doc) => doc.status == 'Expired' || doc.status == 'Expiring Soon')
        .toList();
  }

  void refreshDocuments() {
    if (!_isDemoMode) {
      _loadDocuments();
    }
  }

  // Set the current user ID and reload documents
  void setUserId(String? userId) {
    if (_currentUserId != userId) {
      _currentUserId = userId;
      if (userId != null) {
        _loadDocuments();
      } else {
        _documents = [];
        notifyListeners();
      }
    }
  }

  // Getter for current user ID
  String? get currentUserId => _currentUserId;
}

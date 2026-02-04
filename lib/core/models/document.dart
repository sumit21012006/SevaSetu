import 'package:cloud_firestore/cloud_firestore.dart';

enum DocumentStatus { valid, expiringSoon, expired, unknown }

enum DocumentType {
  income,
  caste,
  aadhaar,
  pan,
  drivingLicense,
  voterId,
  rationCard,
  bankPassbook,
  education,
  other,
}

class Document {
  final String id;
  final String userId;
  final String fileName;
  final String fileUrl;
  final DocumentType type;
  final DateTime? issueDate;
  final DateTime? expiryDate;
  final DocumentStatus status;
  final DateTime uploadedAt;
  final String? notes;

  Document({
    required this.id,
    required this.userId,
    required this.fileName,
    required this.fileUrl,
    required this.type,
    this.issueDate,
    this.expiryDate,
    required this.status,
    required this.uploadedAt,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'fileName': fileName,
      'fileUrl': fileUrl,
      'type': type.name,
      'issueDate': issueDate?.toIso8601String(),
      'expiryDate': expiryDate?.toIso8601String(),
      'status': status.name,
      'uploadedAt': Timestamp.fromDate(uploadedAt),
      'notes': notes,
    };
  }

  factory Document.fromMap(Map<String, dynamic> map) {
    return Document(
      id: map['id'],
      userId: map['userId'],
      fileName: map['fileName'],
      fileUrl: map['fileUrl'],
      type: DocumentType.values.firstWhere(
        (type) => type.name == map['type'],
        orElse: () => DocumentType.other,
      ),
      issueDate: map['issueDate'] != null
          ? DateTime.parse(map['issueDate'])
          : null,
      expiryDate: map['expiryDate'] != null
          ? DateTime.parse(map['expiryDate'])
          : null,
      status: DocumentStatus.values.firstWhere(
        (status) => status.name == map['status'],
        orElse: () => DocumentStatus.unknown,
      ),
      uploadedAt: (map['uploadedAt'] as Timestamp).toDate(),
      notes: map['notes'],
    );
  }

  DocumentStatus calculateStatus() {
    if (expiryDate == null) return DocumentStatus.unknown;

    final today = DateTime.now();
    final daysUntilExpiry = expiryDate!.difference(today).inDays;

    if (daysUntilExpiry < 0) {
      return DocumentStatus.expired;
    } else if (daysUntilExpiry <= 30) {
      return DocumentStatus.expiringSoon;
    } else {
      return DocumentStatus.valid;
    }
  }
}

class UserModel {
  final String uid;
  final String name;
  final String language;

  UserModel({required this.uid, required this.name, this.language = 'en'});

  Map<String, dynamic> toJson() => {'uid': uid, 'name': name, 'language': language};
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel(uid: json['uid'], name: json['name'], language: json['language'] ?? 'en');
}

class DocumentModel {
  final String id;
  final String userId;
  final String type;
  final DateTime? issueDate;
  final DateTime? expiryDate;
  final String status;

  DocumentModel({
    required this.id,
    required this.userId,
    required this.type,
    this.issueDate,
    this.expiryDate,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'type': type,
        'issueDate': issueDate?.toIso8601String(),
        'expiryDate': expiryDate?.toIso8601String(),
        'status': status,
      };

  factory DocumentModel.fromJson(Map<String, dynamic> json) => DocumentModel(
        id: json['id'],
        userId: json['userId'],
        type: json['type'],
        issueDate: json['issueDate'] != null ? DateTime.parse(json['issueDate']) : null,
        expiryDate: json['expiryDate'] != null ? DateTime.parse(json['expiryDate']) : null,
        status: json['status'],
      );
}

class ServiceModel {
  final String serviceId;
  final String name;
  final List<String> requiredDocuments;
  final String eligibilityRules;

  ServiceModel({
    required this.serviceId,
    required this.name,
    required this.requiredDocuments,
    required this.eligibilityRules,
  });

  Map<String, dynamic> toJson() => {
        'serviceId': serviceId,
        'name': name,
        'requiredDocuments': requiredDocuments,
        'eligibilityRules': eligibilityRules,
      };

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
        serviceId: json['serviceId'],
        name: json['name'],
        requiredDocuments: List<String>.from(json['requiredDocuments']),
        eligibilityRules: json['eligibilityRules'],
      );
}

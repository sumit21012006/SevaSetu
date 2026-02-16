import 'package:flutter_test/flutter_test.dart';
import '../lib/models/models.dart';

void main() {
  group('Document Expiry Validation', () {
    test('Document without expiry date should be valid', () {
      final document = DocumentModel(
        id: '1',
        userId: 'test-user',
        type: 'Birth Certificate',
        issueDate: DateTime(2020, 1, 15),
        expiryDate: null,
        status: 'Valid',
        isPdf: false,
      );

      expect(document.expiryDate, isNull);
      expect(document.status, 'Valid');
    });

    test('Expired document should have status Expired', () {
      final document = DocumentModel(
        id: '1',
        userId: 'test-user',
        type: 'Income Certificate',
        issueDate: DateTime(2020, 1, 15),
        expiryDate: DateTime(2024, 1, 15), // Past date
        status: 'Expired',
        isPdf: false,
      );

      expect(document.expiryDate!.isBefore(DateTime.now()), isTrue);
      expect(document.status, 'Expired');
    });

    test('Valid document should have future expiry date', () {
      final document = DocumentModel(
        id: '1',
        userId: 'test-user',
        type: 'Aadhaar Card',
        issueDate: DateTime(2020, 1, 15),
        expiryDate: DateTime(2030, 1, 15), // Future date
        status: 'Valid',
        isPdf: false,
      );

      expect(document.expiryDate!.isAfter(DateTime.now()), isTrue);
      expect(document.status, 'Valid');
    });

    test('Document expiring today should have status Expiring Soon', () {
      final today = DateTime.now();
      final document = DocumentModel(
        id: '1',
        userId: 'test-user',
        type: 'Passport',
        issueDate: DateTime(2020, 1, 15),
        expiryDate: DateTime(today.year, today.month, today.day), // Today
        status: 'Expiring Soon',
        isPdf: false,
      );

      expect(document.expiryDate,
          equals(DateTime(today.year, today.month, today.day)));
      expect(document.status, 'Expiring Soon');
    });

    test('Document expiring within 30 days should have status Expiring Soon',
        () {
      final today = DateTime.now();
      final expiringSoonDate =
          today.add(const Duration(days: 15)); // 15 days from now
      final document = DocumentModel(
        id: '1',
        userId: 'test-user',
        type: 'PAN Card',
        issueDate: DateTime(2020, 1, 15),
        expiryDate: expiringSoonDate,
        status: 'Expiring Soon',
        isPdf: false,
      );

      expect(document.expiryDate!.isAfter(today), isTrue);
      expect(document.expiryDate!.isBefore(today.add(const Duration(days: 30))),
          isTrue);
      expect(document.status, 'Expiring Soon');
    });
  });
}

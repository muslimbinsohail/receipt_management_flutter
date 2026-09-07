import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:receipt_management_flutter/core/constants/firestore_constants.dart';
import 'package:receipt_management_flutter/core/exceptions/app_exception.dart';
import 'package:receipt_management_flutter/data/models/receipt_model.dart';

/// Firestore service for cloud CRUD operations
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get user-scoped receipts collection reference
  CollectionReference<Map<String, dynamic>> _receiptsRef(String userId) {
    return _firestore
        .collection(FirestoreConstants.usersCollection)
        .doc(userId)
        .collection(FirestoreConstants.receiptsCollection);
  }

  /// Create or update a receipt in Firestore
  Future<void> upsertReceipt(String userId, ReceiptModel receipt) async {
    try {
      await _receiptsRef(userId)
          .doc(receipt.id)
          .set(receipt.toFirestore(), SetOptions(merge: true));
    } on FirebaseException catch (e) {
      throw NetworkException.serverError(
          'Firestore write failed: ${e.message}');
    } catch (e) {
      throw NetworkException.serverError('Failed to sync receipt: $e');
    }
  }

  /// Delete a receipt from Firestore
  Future<void> deleteReceipt(String userId, String receiptId) async {
    try {
      await _receiptsRef(userId).doc(receiptId).delete();
    } on FirebaseException catch (e) {
      throw NetworkException.serverError(
          'Firestore delete failed: ${e.message}');
    } catch (e) {
      throw NetworkException.serverError('Failed to delete receipt: $e');
    }
  }

  /// Get all receipts from Firestore
  Future<List<ReceiptModel>> getAllReceipts(String userId) async {
    try {
      final snapshot = await _receiptsRef(userId)
          .orderBy(FirestoreConstants.fieldCreatedAt, descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ReceiptModel.fromFirestore(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw NetworkException.serverError(
          'Firestore read failed: ${e.message}');
    } catch (e) {
      throw NetworkException.serverError('Failed to fetch receipts: $e');
    }
  }

  /// Get receipts updated after a specific timestamp
  Future<List<ReceiptModel>> getReceiptsUpdatedAfter(
    String userId,
    DateTime after,
  ) async {
    try {
      final snapshot = await _receiptsRef(userId)
          .where(
            FirestoreConstants.fieldUpdatedAt,
            isGreaterThan: after.toIso8601String(),
          )
          .get();

      return snapshot.docs
          .map((doc) => ReceiptModel.fromFirestore(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw NetworkException.serverError(
          'Firestore read failed: ${e.message}');
    } catch (e) {
      throw NetworkException.serverError('Failed to fetch updated receipts: $e');
    }
  }

  /// Batch write receipts to Firestore
  Future<void> batchUpsert(
      String userId, List<ReceiptModel> receipts) async {
    try {
      // Firestore batch limit is 500
      final batches = <WriteBatch>[];
      var currentBatch = _firestore.batch();
      var count = 0;

      for (final receipt in receipts) {
        final ref = _receiptsRef(userId).doc(receipt.id);
        currentBatch.set(ref, receipt.toFirestore(), SetOptions(merge: true));
        count++;

        if (count >= 500) {
          batches.add(currentBatch);
          currentBatch = _firestore.batch();
          count = 0;
        }
      }

      if (count > 0) {
        batches.add(currentBatch);
      }

      for (final batch in batches) {
        await batch.commit();
      }
    } on FirebaseException catch (e) {
      throw NetworkException.serverError(
          'Batch write failed: ${e.message}');
    } catch (e) {
      throw NetworkException.serverError('Failed to batch sync: $e');
    }
  }

  /// Batch delete receipts from Firestore
  Future<void> batchDelete(String userId, List<String> receiptIds) async {
    try {
      final batch = _firestore.batch();
      for (final id in receiptIds) {
        batch.delete(_receiptsRef(userId).doc(id));
      }
      await batch.commit();
    } on FirebaseException catch (e) {
      throw NetworkException.serverError(
          'Batch delete failed: ${e.message}');
    } catch (e) {
      throw NetworkException.serverError('Failed to batch delete: $e');
    }
  }

  /// Get single receipt
  Future<ReceiptModel?> getReceipt(String userId, String receiptId) async {
    try {
      final doc = await _receiptsRef(userId).doc(receiptId).get();
      if (doc.exists && doc.data() != null) {
        return ReceiptModel.fromFirestore(doc.data()!);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

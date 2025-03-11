// lib/services/transaction_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:minigl/models/transaction.dart';
import '../utils/logger.dart'; // Import our logger

class TransactionService {
  static const String _key = 'transactions';

  Future<void> addTransaction(Transaction transaction) async {
    AppLogger.debug('Adding transaction: ${transaction.title}');
    try {
      final transactions = await getTransactions();
      transactions.add(transaction);
      await _saveTransactions(transactions);
      AppLogger.info('Transaction added successfully');
    } catch (e) {
      AppLogger.error('Failed to add transaction', e);
      rethrow;
    }
  }

  Future<List<Transaction>> getTransactions() async {
    AppLogger.debug('Loading transactions from storage');
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? transactionsJson = prefs.getString(_key);

      if (transactionsJson == null) {
        AppLogger.warning('No transactions found in storage');
        return [];
      }

      final List<dynamic> jsonList = json.decode(transactionsJson);
      AppLogger.info('Loaded ${jsonList.length} transactions');
      return jsonList
          .map((json) => Transaction.fromJson(json))
          .toList()
          .reversed
          .toList();
    } catch (e) {
      AppLogger.error('Error loading transactions', e);
      return [];
    }
  }

  Future<void> deleteTransaction(String id) async {
    AppLogger.debug('Deleting transaction with ID: $id');
    try {
      final transactions = await getTransactions();
      final initialCount = transactions.length;
      transactions.removeWhere((t) => t.id == id);
      await _saveTransactions(transactions);
      
      if (transactions.length < initialCount) {
        AppLogger.info('Transaction deleted successfully');
      } else {
        AppLogger.warning('Transaction with ID $id not found');
      }
    } catch (e) {
      AppLogger.error('Failed to delete transaction', e);
      rethrow;
    }
  }

  Future<void> _saveTransactions(List<Transaction> transactions) async {
    AppLogger.debug('Saving ${transactions.length} transactions');
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = transactions.map((t) => t.toJson()).toList();
      await prefs.setString(_key, json.encode(jsonList));
      AppLogger.info('Transactions saved successfully');
    } catch (e) {
      AppLogger.error('Failed to save transactions', e);
      rethrow;
    }
  }
}
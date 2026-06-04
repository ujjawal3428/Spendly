import 'package:flutter/material.dart';

class TransactionModel {
  TransactionModel({
    required this.id,
    required this.merchantName,
    required this.category,
    required this.amount,
    required this.date,
    required this.icon,
    required this.categoryColor,
  });

  final String id;
  final String merchantName;
  final String category;
  final double amount;
  final DateTime date;
  final IconData icon;
  final Color categoryColor;

  String get formattedAmount {
    if (amount >= 1000) {
      return '₹${(amount / 1000).toStringAsFixed(amount % 1000 == 0 ? 0 : 1)}K';
    }
    return '₹${amount.toStringAsFixed(0)}';
  }

  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final transactionDate = DateTime(date.year, date.month, date.day);

    final hour = date.hour;
    final min = date.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

    if (transactionDate == today) {
      return 'Today, $displayHour:$min $period';
    } else if (transactionDate == yesterday) {
      return 'Yesterday, $displayHour:$min $period';
    } else {
      final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      return '${date.day} ${months[date.month - 1]}';
    }
  }

  TransactionModel copyWith({
    String? id,
    String? merchantName,
    String? category,
    double? amount,
    DateTime? date,
    IconData? icon,
    Color? categoryColor,
  }) =>
      TransactionModel(
        id: id ?? this.id,
        merchantName: merchantName ?? this.merchantName,
        category: category ?? this.category,
        amount: amount ?? this.amount,
        date: date ?? this.date,
        icon: icon ?? this.icon,
        categoryColor: categoryColor ?? this.categoryColor,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
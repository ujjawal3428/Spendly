import 'package:flutter/material.dart';

class CategoryModel {
  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.amountSpent,
    required this.totalBudget,
    required this.color,
  });

  final String id;
  final String name;
  final IconData icon;
  final double amountSpent;
  final double totalBudget;
  final Color color;

  double get spendRatio => (amountSpent / totalBudget).clamp(0, 1);

  CategoryModel copyWith({
    String? id,
    String? name,
    IconData? icon,
    double? amountSpent,
    double? totalBudget,
    Color? color,
  }) =>
      CategoryModel(
        id: id ?? this.id,
        name: name ?? this.name,
        icon: icon ?? this.icon,
        amountSpent: amountSpent ?? this.amountSpent,
        totalBudget: totalBudget ?? this.totalBudget,
        color: color ?? this.color,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
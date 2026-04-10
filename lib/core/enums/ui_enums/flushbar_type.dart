import 'package:flutter/material.dart';

enum FlushbarType {
  success(name: 'Success', color: Colors.green),
  error(name: 'Error', color: Colors.red),
  info(name: 'Info', color: Colors.blue),
  warning(name: 'Warning', color: Colors.orange);

  final String name;
  final Color color;

  const FlushbarType({required this.name, required this.color});
}

import 'package:flutter/material.dart';

abstract class ModelFactory {
  @factory
  T createObject<T>(Map<String, dynamic> json);

  Map<String, String> toMap();
}
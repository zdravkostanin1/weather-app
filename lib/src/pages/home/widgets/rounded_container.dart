import 'package:flutter/material.dart';

class RoundedContainer extends StatelessWidget {
  final List<Widget>? children;

  const RoundedContainer({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 28.0,
        right: 28.0,
        top: 10.0,
      ),
      child: Container(
        width: double.infinity,
        height: 100.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children ?? [],
        ),
      ),
    );
  }
}

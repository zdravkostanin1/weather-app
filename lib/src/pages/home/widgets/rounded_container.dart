import 'package:flutter/material.dart';

class RoundedContainer extends StatelessWidget {
  final List<Widget>? children;

  const RoundedContainer({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 50.0,
        right: 50.0,
        top: 10.0,
      ),
      child: Container(
        width: double.infinity,
        height: 100.0,
        decoration: BoxDecoration(
          color: const Color(0xffFAF7F0),
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            width: 2,
            color: Colors.black,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children ?? [],
        ),
      ),
    );
  }
}

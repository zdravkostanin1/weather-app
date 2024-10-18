import 'package:flutter/material.dart';

class RoundedContainer extends StatelessWidget {
  final List<Widget>? children;

  const RoundedContainer({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 10.0,
      ),
      child: Container(
        width: double.infinity,
        height: 130.0,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            width: 1,
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

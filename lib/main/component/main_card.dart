import 'package:flutter/material.dart';

class MainCard extends StatelessWidget {
  final Widget image;
  final String name;

  const MainCard({
    super.key,
    required this.image,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100.0),
          child: image,
        ),
        const SizedBox(
          height: 16.0,
        ),
        Text(
          name,
        )
      ],
    );
  }
}

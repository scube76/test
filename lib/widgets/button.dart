import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool loading;
  const Button(
      {required this.title,
      required this.onTap,
      this.loading = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onTap,
      child: Center(
        child: loading
            ? const CircularProgressIndicator(
                strokeWidth: 1,
                color: Colors.green,
              )
            : Text(
                title,
                style: const TextStyle(color: Colors.black),
              ),
      ),
    );
  }
}

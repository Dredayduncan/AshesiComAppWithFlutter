import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  final String hint;
  final TextEditingController controller;

  const CustomSearchBar({
    Key? key,
    required this.controller,
    required this.hint
  }) : super(key: key);

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: TextField(
        onChanged: (value) {
          setState(() {});
        },
        controller: widget.controller,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(25.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(25.0),
            ),
            filled: true,
            contentPadding: const EdgeInsets.all(5),
            hintStyle: const TextStyle(color: Color(0xFF808083)),
            hintText: widget.hint,
            fillColor: const Color(0xFFD397A3),
            prefixIcon: const Icon(Icons.search),
            suffixIcon: widget.controller.text.isEmpty ? null : IconButton(
              color: const Color(0xFF808083),
              onPressed: () {
                widget.controller.clear();
                setState(() {});
              },
              icon: const Icon(Icons.clear),
              iconSize: 20,
              padding: const EdgeInsets.only(bottom: 1.0),
            )
        ),
      ),
    );
  }
}

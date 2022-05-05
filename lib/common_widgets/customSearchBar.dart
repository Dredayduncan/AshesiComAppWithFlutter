import 'package:ashesicom/views/newPost.dart';
import 'package:ashesicom/views/screenManager.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final VoidCallback? onSearch;
  final String authID;

  const CustomSearchBar({
    Key? key,
    required this.authID,
    required this.controller,
    required this.hint,
    required this.onSearch
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
        textInputAction: TextInputAction.search,
        onSubmitted: (value) => widget.onSearch,
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

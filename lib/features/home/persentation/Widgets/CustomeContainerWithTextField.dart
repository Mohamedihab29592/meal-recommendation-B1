import 'package:flutter/material.dart';

class CustomContainerWithTextfield extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;

  const CustomContainerWithTextfield({
    super.key,
    this.hintText,
    this.controller,
    this.keyboardType,
    this.onChanged,
    this.validator,
  });

  @override
  CustomContainerWithTextfieldState createState() => CustomContainerWithTextfieldState();
}

class CustomContainerWithTextfieldState extends State<CustomContainerWithTextfield> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    // Use provided controller or create a new one
    _controller = widget.controller ?? TextEditingController();
    _focusNode = FocusNode();

    // Listen to focus changes
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    // Only dispose if we created the controller
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CustomContainerWithTextfield oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle controller changes
    if (widget.controller != oldWidget.controller) {
      _controller = widget.controller ?? TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 96,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: _isFocused
                ? Colors.blueAccent.withOpacity(0.3)
                : Colors.black26,
            blurRadius: _isFocused ? 12 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        key: ValueKey(widget.hintText), // Unique key to prevent unnecessary rebuilds
        controller: _controller,
        focusNode: _focusNode,
        keyboardType: widget.keyboardType ?? TextInputType.text,
        style: const TextStyle(fontSize: 16, color: Colors.black),
        cursorColor: Colors.blueAccent,

        // Minimize rebuild triggers
        onChanged: (value) {
          widget.onChanged?.call(value);
        },

        // Add validator support
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: widget.validator,

        // Keyboard interaction improvements
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },

        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
          focusedBorder: _buildOutlineInputBorder(Colors.blueAccent, 1.5),
          border: _buildOutlineInputBorder(Colors.grey, 1),
          enabledBorder: _buildOutlineInputBorder(Colors.grey, 1),
          hintText: widget.hintText,
          hintStyle: const TextStyle(fontSize: 15, color: Colors.grey),
          errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
        ),
      ),
    );
  }

  // Helper method to create consistent OutlineInputBorder
  OutlineInputBorder _buildOutlineInputBorder(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

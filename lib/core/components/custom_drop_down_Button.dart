import 'package:flutter/material.dart';

class CustomDropdownField extends StatefulWidget {
  final String hintText;
  final String? prefixIcon;
  final TextEditingController controller;
  final List<String> items;
  final String? errorText;
  final Function(String)? onChanged;
  final String? Function(String? value)? validator;
  final bool enabled;
  final Color? fillColor;
  final Color? textColor;
  final Color? hintColor;
  final Color? iconColor;

  const CustomDropdownField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    required this.controller,
    required this.items,
    this.errorText,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.fillColor,
    this.textColor,
    this.hintColor,
    this.iconColor,
  });

  @override
  CustomDropdownFieldState createState() => CustomDropdownFieldState();
}

class CustomDropdownFieldState extends State<CustomDropdownField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultFillColor = widget.fillColor ?? Colors.black54;
    final defaultTextColor = widget.textColor ?? Colors.white;
    final defaultHintColor = widget.hintColor ?? Colors.grey;
    final defaultIconColor = widget.iconColor ?? Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: _isFocused
                ? [
              BoxShadow(
                color: Colors.blueAccent.withOpacity(0.3),
                blurRadius: 12,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              )
            ]
                : [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: DropdownButtonFormField<String>(
            key: ValueKey(widget.hintText),
            decoration: InputDecoration(
              filled: true,
              fillColor: defaultFillColor,
              prefixIcon: widget.prefixIcon != null
                  ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  widget.prefixIcon!,
                  color: defaultIconColor,
                  fit: BoxFit.contain,
                  width: 42,
                ),
              )
                  : null,
              hintText: widget.hintText,
              hintStyle: TextStyle(color: defaultHintColor),
              border: _buildOutlineInputBorder(Colors.transparent),
              enabledBorder: _buildOutlineInputBorder(Colors.transparent),
              focusedBorder: _buildOutlineInputBorder(Colors.blueAccent),
              errorBorder: _buildOutlineInputBorder(Colors.red),
              focusedErrorBorder: _buildOutlineInputBorder(Colors.red),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 20,
              ),
              errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
            ),
            items: widget.items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: widget.enabled
                ? (String? newValue) {
              widget.controller.text = newValue!;
              if (widget.onChanged != null) {
                widget.onChanged!(newValue);
              }
            }
                : null,
            validator: widget.validator,
          ),
        ),
        if (widget.errorText != null || widget.validator != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0),
            child: Text(
              widget.errorText ?? '',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  OutlineInputBorder _buildOutlineInputBorder(Color borderColor) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: borderColor, width: 2),
    );
  }
}
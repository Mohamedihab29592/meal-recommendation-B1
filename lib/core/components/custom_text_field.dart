import 'package:flutter/material.dart';


class CustomTextField extends StatefulWidget {
  final String hintText;
  final String? prefixIcon;
  final Widget? suffixIcon;
  final bool isPassword;
  final TextInputType inputType;
  final TextEditingController controller;
  final String? errorText;
  final Function(String)? onChanged;
  final String? Function(String? value)? validator;
  final bool enabled;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final Color? fillColor;
  final Color? textColor;
  final Color? hintColor;
  final Color? iconColor;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    required this.inputType,
    required this.controller,
    this.errorText,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.textInputAction,
    this.focusNode,
    this.onEditingComplete,
    this.fillColor,
    this.textColor,
    this.hintColor,
    this.iconColor,
  });

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  late bool _isObscure;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.isPassword;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  @override
  void didUpdateWidget(CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle focus node changes
    if (widget.focusNode != oldWidget.focusNode) {
      _focusNode.removeListener(_onFocusChange);
      _focusNode = widget.focusNode ?? FocusNode();
      _focusNode.addListener(_onFocusChange);
    }
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
          child: TextFormField(
            key: ValueKey(widget.hintText), // Unique key to prevent unnecessary rebuilds
            controller: widget.controller,
            focusNode: _focusNode,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: widget.validator,
            cursorColor: defaultTextColor,
            obscureText: _isObscure,
            keyboardType: widget.inputType,
            style: TextStyle(color: defaultTextColor),
            onChanged: widget.onChanged,
            enabled: widget.enabled,
            textInputAction: widget.textInputAction,
            onEditingComplete: widget.onEditingComplete,

            // Keyboard interaction improvements
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },

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
              suffixIcon: widget.isPassword
                  ? IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility : Icons.visibility_off,
                  color: defaultIconColor,
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              )
                  : widget.suffixIcon,
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
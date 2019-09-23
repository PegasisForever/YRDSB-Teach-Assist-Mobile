import 'package:flutter/material.dart';

class EditText extends StatefulWidget {
  EditText(
      {this.controller,
      this.errorText,
      this.hint,
      this.maxWidth,
      this.isPassword,
      this.icon,
      this.expandable,
      this.inputType});

  final TextEditingController controller;
  final ErrorText errorText;
  final String hint;
  final double maxWidth;
  final bool isPassword;
  final IconData icon;
  final bool expandable;
  final TextInputType inputType;

  @override
  _EditTextState createState() => _EditTextState();
}

class _EditTextState extends State<EditText> {
  TextEditingController _controller;
  ErrorText _errorText;
  String _hint;
  double _maxWidth;
  final _focusNode = FocusNode();
  bool _clearBtnVisibility;
  Icon _icon;
  bool _expandable;
  TextInputType _inputType;

  @override
  Widget build(BuildContext context) {
    _controller = widget.controller;
    _errorText = widget.errorText;
    _hint = widget.hint ?? "";
    _maxWidth = widget.maxWidth ?? double.infinity;
    _icon = widget.icon != null ? Icon(widget.icon) : null;
    _expandable=widget.expandable == true;
    _inputType=widget.inputType ?? TextInputType.text;

    _clearBtnVisibility = _controller?.text?.isNotEmpty ?? false;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: _maxWidth),
      child: TextField(
        keyboardType: _inputType,
        maxLines: _expandable?null:1,
        obscureText: widget.isPassword ?? false,
        focusNode: _focusNode,
        controller: _controller,
        onChanged: (str) {
          setState(() {
            _errorText.text = null;
            _clearBtnVisibility = str != "";
          });
        },
        decoration: InputDecoration(
            prefixIcon: _icon,
            suffixIcon: _clearBtnVisibility
                ? IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      FocusScope.of(context).requestFocus(_focusNode);
                      setState(() {
                        _clearBtnVisibility = false;
                      });
                    },
                  )
                : null,
            filled: true,
            labelText: _hint,
            errorText: _errorText.text),
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}

class ErrorText {
  ErrorText(this.text);

  String text;
}

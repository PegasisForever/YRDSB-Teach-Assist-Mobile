import 'package:flutter/material.dart';

class EditText extends StatefulWidget {
  EditText(
      {this.controller,
      this.errorText,
      this.hint,
      this.isPassword,
      this.icon,
      this.expandable,
      this.inputType,
      this.focusNode,
      this.nextFocusNode,
      this.textInputAction,
        this.onSubmitted,
        this.autoFocus = false});

  final TextEditingController controller;
  final ErrorText errorText;
  final String hint;
  final bool isPassword;
  final IconData icon;
  final bool expandable;
  final TextInputType inputType;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;
  final TextInputAction textInputAction;
  final ValueChanged<String> onSubmitted;
  final bool autoFocus;

  @override
  _EditTextState createState() => _EditTextState();
}

class _EditTextState extends State<EditText> {
  TextEditingController _controller;
  ErrorText _errorText;
  String _hint;
  FocusNode _focusNode;
  bool _clearBtnVisibility;
  Icon _icon;
  bool _expandable;
  TextInputType _inputType;
  TextInputAction _textInputAction;
  ValueChanged<String> _onSubmitted;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode == null ? FocusNode() : widget.focusNode;
    if (widget.onSubmitted!=null){
      _onSubmitted=widget.onSubmitted;
    }else if (widget.nextFocusNode!=null){
      _onSubmitted=(s){
        _changeFocusChange(context,_focusNode,widget.nextFocusNode);
      };
    }
    _controller = widget.controller;
    _hint = widget.hint ?? "";
    _icon = widget.icon != null ? Icon(widget.icon) : null;
    _expandable = widget.expandable == true;
    _inputType = widget.inputType ?? TextInputType.text;
    _textInputAction = widget.textInputAction == null
        ? TextInputAction.unspecified
        : widget.textInputAction;
  }

  @override
  Widget build(BuildContext context) {
    _errorText = widget.errorText;
    _clearBtnVisibility = _controller?.text?.isNotEmpty ?? false;

    return TextField(
      autofocus: widget.autoFocus,
      textInputAction: _textInputAction,
      onSubmitted: _onSubmitted,
      keyboardType: _inputType,
      maxLines: _expandable ? null : 1,
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
              FocusScope.of(context).requestFocus(_focusNode);
              _controller.clear();

              setState(() {
                _clearBtnVisibility = false;
              });
            },
          )
              : null,
          filled: true,
          labelText: _hint,
          errorText: _errorText.text),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  _changeFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}

class ErrorText {
  ErrorText(this.text);

  String text;
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ta/tools.dart';

class AccountDetails extends StatefulWidget {
  const AccountDetails({
    this.accountName,
    this.accountSubName,
    this.onTap,
    this.isOpened,
  });

  final String accountName;
  final String accountSubName;
  final VoidCallback onTap;
  final bool isOpened;

  @override
  AccountDetailsState createState() => AccountDetailsState();
}

class AccountDetailsState extends State<AccountDetails> with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      value: widget.isOpened ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
      reverseCurve: Curves.easeInOutCubic.flipped,
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AccountDetails oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isOpened != widget.isOpened) {
      if (widget.isOpened) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: getTopPadding(context) + 4,
      ),
      child: InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.accountName,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  if (widget.accountSubName != null)
                    Text(
                      widget.accountSubName,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                ],
              ),
              SizedBox(
                height: 56,
                width: 56,
                child: Center(
                  child: Transform.rotate(
                    angle: _animation.value * pi,
                    child: Icon(
                      Icons.arrow_drop_down,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
 * Copyright (c) Pegasis 2019. Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to use, copy, modify,
 * merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
 * to whom the Software is furnished to do so, subject to the following conditions:
 *
 *    The above copyright notice and this permission notice shall be included in all copies
 *    or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 *  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
 *  PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 *  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
 *  AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 *  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import 'dart:math';

import 'package:flutter/material.dart';

typedef ItemBuilder = Widget Function(BuildContext context, dynamic itemData);

class BetterAnimatedList extends StatefulWidget {
  BetterAnimatedList({@required this.list, @required this.itemBuilder, this.header,this.padding});

  final List list;
  final Widget header;
  final ItemBuilder itemBuilder;
  final EdgeInsetsGeometry padding;

  @override
  _BetterAnimatedListState createState() => _BetterAnimatedListState();
}

class _BetterAnimatedListState extends State<BetterAnimatedList> {
  var key = GlobalKey<AnimatedListState>();
  List list;

  @override
  void initState() {
    super.initState();
    list = List.from(widget.list);
  }

  @override
  Widget build(BuildContext context) {
    var newList = widget.list;

    var i = 0;
    while (i < max(list.length, newList.length)) {
      if (i >= list.length) {
        addItem(list, i, newList[i]);
        i++;
      } else if (i >= newList.length) {
        removeItem(list, i);
      } else {
        var item = list[i];
        var newItem = newList[i];
        if (newItem != item) {
          if (newList.contains(item)) {
            addItem(list, i, newItem);
            i++;
          } else {
            removeItem(list, i);
          }
        } else {
          i++;
        }
      }
    }

    return AnimatedList(
      key: key,
      padding: widget.padding,
      initialItemCount: list.length + 1,
      itemBuilder: (context, index, animation) {
        if (index == 0) {
          return widget.header ?? Container();
        }
        return buildListItem(context, list[index - 1], animation);
      },
    );
  }

  Widget buildListItem(context, itemData, animation) {
    return SizeTransition(
      key: Key(itemData.hashCode.toString()),
      sizeFactor: CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic),
      child: FadeTransition(
        opacity: animation,
        child: widget.itemBuilder(context, itemData),
      ),
    );
  }

  removeItem(list, index) {
    var state = key.currentState;
    var item = list[index];
    state.removeItem(index + 1, (context, animation) {
      return buildListItem(context, item, animation);
    });

    list.removeAt(index);
  }

  addItem(list, index, item) {
    var state = key.currentState;
    list.insert(index, item);
    state.insertItem(index + 1);
  }
}

import 'dart:async';

class _Operation<T> {
  final completer = Completer<T>();
  final job;

  _Operation(this.job);
}

class _OperationQueue {
  List<_Operation> _queue = [];
  bool _active = false;

  void _check() async {
    if (!_active && _queue.length > 0) {
      this._active = true;
      var item = _queue.removeAt(0);
      try {
        item.completer.complete(await item.job());
      } catch (e) {
        item.completer.completeError(e);
      }
      this._active = false;
      this._check();
    }
  }

  Future<T> add<T>(Function job) {
    var op = _Operation<T>(job);
    this._queue.add(op);
    this._check();
    return op.completer.future;
  }
}

var operationQueue = _OperationQueue();

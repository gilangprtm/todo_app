import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utils/mahas_format.dart';
import 'input_box_component.dart';

class InputDatetimeController {
  late bool _required;
  late InputDatetimeType _type;
  late BuildContext _context;
  late Function(VoidCallback fn) setState;
  bool _isInit = false;

  DateTime? _date;
  TimeOfDay? _time;
  String? _errorMessage;

  InputDatetimeController({
    this.onChanged,
    this.onCheck,
    this.onClear,
  });

  Function()? onChanged;
  bool Function(DateTime? date)? onCheck;
  Function()? onClear;

  set value(dynamic val) {
    if (val is DateTime) {
      _date = val;
    } else if (val is TimeOfDay) {
      _time = val;
    }
    if (_isInit) {
      setState(() {});
    }
  }

  dynamic get value {
    if (_type == InputDatetimeType.date) {
      return _date;
    } else {
      return _time;
    }
  }

  bool get isValid {
    setState(() {
      _errorMessage = null;
    });

    if (_required &&
        ((_type == InputDatetimeType.date && _date == null) ||
            (_type == InputDatetimeType.time && _time == null))) {
      setState(() {
        _errorMessage = 'The field is required';
      });
      return false;
    }
    return true;
  }

  void _onTab(bool editable) async {
    if (!editable) return;
    if (_type == InputDatetimeType.date) {
      final DateTime? picked = await showDatePicker(
        context: _context,
        initialDate: _date ?? DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(3000),
      );
      if (onCheck != null) {
        if (!onCheck!(picked)) return;
      }
      if (picked != null && _date != picked) {
        setState(() {
          _date = picked;
          isValid;
        });
      }
    } else {
      final TimeOfDay? picked = await showTimePicker(
        context: _context,
        initialTime: _time ?? TimeOfDay.now(),
      );
      if (picked != null && _time != picked) {
        setState(() {
          _time = picked;
          isValid;
        });
      }
    }
    if (onChanged != null) {
      onChanged!();
    }
  }

  void _init(
    Function(VoidCallback fn) setStateX,
    BuildContext contextX,
    bool requiredX,
    InputDatetimeType typeX,
  ) {
    setState = setStateX;
    _context = contextX;
    _required = requiredX;
    _type = typeX;
    _isInit = true;
  }

  void _clearOnTab() {
    setState(() {
      _date = null;
      _time = null;
    });
    if (onClear != null) {
      onClear!();
    }
  }
}

enum InputDatetimeType {
  date,
  time,
}

class InputDatetimeComponent extends StatefulWidget {
  final String? label;
  final bool editable;
  final double? marginBottom;
  final bool required;
  final InputDatetimeController controller;
  final InputDatetimeType type;

  const InputDatetimeComponent({
    super.key,
    this.label,
    this.marginBottom,
    required this.controller,
    this.editable = true,
    this.required = false,
    this.type = InputDatetimeType.date,
  });

  @override
  State<InputDatetimeComponent> createState() => _InputDatetimeComponentState();
}

class _InputDatetimeComponentState extends State<InputDatetimeComponent> {
  @override
  void initState() {
    widget.controller._init((fn) {
      if (mounted) {
        setState(fn);
      }
    }, context, widget.required, widget.type);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InputBoxComponent(
      label: widget.label,
      editable: widget.editable,
      isRequired: widget.required,
      icon: widget.controller._type == InputDatetimeType.date
          ? FontAwesomeIcons.calendar
          : FontAwesomeIcons.clock,
      alowClear: widget.editable &&
          ((widget.controller._type == InputDatetimeType.date &&
                  widget.controller._date != null) ||
              (widget.controller._type == InputDatetimeType.time &&
                  widget.controller._time != null)),
      errorMessage: widget.controller._errorMessage,
      clearOnTab: widget.controller._clearOnTab,
      marginBottom: widget.marginBottom,
      onTap: () => widget.controller._onTab(widget.editable),
      childText: widget.controller._type == InputDatetimeType.date
          ? MahasFormat.displayDate(widget.controller._date)
          : widget.controller._time?.format(context) ?? '',
    );
  }
}

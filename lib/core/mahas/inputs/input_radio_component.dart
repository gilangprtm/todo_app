import 'package:flutter/material.dart';
import '../../helper/helper.dart';
import 'input_box_component.dart';

class RadioButtonItem {
  dynamic id;
  String text;
  dynamic value;

  RadioButtonItem({
    this.id,
    required this.text,
    this.value,
  });

  RadioButtonItem.autoId(String text, dynamic value)
      : this(
          id: Helper.idGenerator,
          text: text,
          value: value,
        );

  RadioButtonItem.simple(String value) : this.autoId(value, value);
}

class InputRadioController {
  late Function(VoidCallback fn) setState;

  List<RadioButtonItem> items;
  RadioButtonItem? _value;
  Function(RadioButtonItem item)? onChanged;
  bool required = false;
  String? _errorMessage;
  bool _isInit = false;

  InputRadioController({
    this.items = const [],
    this.onChanged,
  });

  void _onChanged(RadioButtonItem v, bool editable) {
    if (!editable) return;
    setState(() {
      _value = v;
      isValid;
      if (onChanged != null) {
        onChanged!(v);
      }
    });
  }

  set setItems(List<RadioButtonItem> val) {
    if (val.where((e) => e.value == _value?.value).isEmpty) {
      _value = null;
    }
    items = val;
  }

  dynamic get value {
    return _value?.value;
  }

  set value(dynamic val) {
    if (items.where((e) => e.value == val).isEmpty) {
      _value = null;
    } else {
      _value = items.firstWhere((e) => e.value == val);
    }
    if (_isInit) {
      setState(() {});
    }
  }

  void _init(Function(VoidCallback fn) setStateX) {
    setState = setStateX;
    _isInit = true;
  }

  bool get isValid {
    setState(() {
      _errorMessage = null;
    });
    if (required && _value == null) {
      setState(() {
        _errorMessage = 'The field is required';
      });
      return false;
    }
    return true;
  }
}

class InputRadioComponent extends StatefulWidget {
  final InputRadioController controller;
  final bool editable;
  final bool required;
  final String? label;

  const InputRadioComponent({
    super.key,
    required this.controller,
    this.editable = true,
    this.label,
    this.required = false,
  });

  @override
  State<InputRadioComponent> createState() => _InputRadioComponentState();
}

class _InputRadioComponentState extends State<InputRadioComponent> {
  @override
  void initState() {
    widget.controller._init((fn) {
      if (mounted) {
        setState(fn);
      }
    });
    widget.controller.required = widget.required;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => InputBoxComponent(
        isRequired: widget.required,
        label: widget.label,
        errorMessage: widget.controller._errorMessage,
        children: Column(
          children: widget.controller.items
              .map(
                (e) => InkWell(
                  onTap: () => widget.controller._onChanged(e, widget.editable),
                  child: SizedBox(
                    height: 30,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Radio<RadioButtonItem>(
                          value: e,
                          groupValue: widget.controller._value,
                          onChanged: (value) => {
                            widget.controller.isValid,
                            widget.controller._onChanged(
                              value!,
                              widget.editable,
                            ),
                          },
                        ),
                        const Padding(padding: EdgeInsets.only(left: 5)),
                        Text(
                          e.text,
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      );
}

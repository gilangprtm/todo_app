import 'package:flutter/material.dart';

import '../../helper/helper.dart';
import 'input_box_component.dart';

class CheckboxMultipleItem {
  dynamic id;
  String text;
  bool checked;

  CheckboxMultipleItem({
    this.id,
    required this.text,
    this.checked = false,
  });

  CheckboxMultipleItem.autoId(String text, bool checked)
      : this(
          id: Helper.idGenerator,
          text: text,
          checked: checked,
        );

  CheckboxMultipleItem.simple(String text)
      : this(
          id: Helper.idGenerator,
          text: text,
          checked: false,
        );
}

class InputCheckboxMultipleController {
  List<CheckboxMultipleItem> items;
  late Function(VoidCallback fn) setState;
  Function(CheckboxMultipleItem item)? onChanged;

  InputCheckboxMultipleController({
    required this.items,
  });

  void _onChanged(CheckboxMultipleItem v, bool editable) {
    if (!editable) return;
    setState(() {
      v.checked = !v.checked;
      if (onChanged != null) {
        onChanged!(v);
      }
    });
  }

  void refresh() {
    setState(() {});
  }

  void _init(Function(VoidCallback fn) setStateX) {
    setState = setStateX;
  }
}

class InputCheckboxMultipleComponent extends StatefulWidget {
  final InputCheckboxMultipleController controller;
  final bool editable;
  final String? label;

  const InputCheckboxMultipleComponent({
    super.key,
    required this.controller,
    this.editable = true,
    this.label,
  });

  @override
  State<InputCheckboxMultipleComponent> createState() =>
      _InputCheckboxMultipleComponentState();
}

class _InputCheckboxMultipleComponentState
    extends State<InputCheckboxMultipleComponent> {
  @override
  void initState() {
    widget.controller._init((fn) {
      if (mounted) {
        setState(fn);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => InputBoxComponent(
        label: widget.label,
        children: Column(
          children: widget.controller.items
              .map((e) => InkWell(
                    onTap: () =>
                        widget.controller._onChanged(e, widget.editable),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: e.checked,
                          onChanged: (v) =>
                              widget.controller._onChanged(e, widget.editable),
                        ),
                        const Padding(padding: EdgeInsets.only(left: 5)),
                        InkWell(
                          child: Text(
                            e.text,
                          ),
                          onTap: () =>
                              widget.controller._onChanged(e, widget.editable),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      );
}

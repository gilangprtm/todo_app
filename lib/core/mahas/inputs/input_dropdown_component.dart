import 'package:flutter/material.dart';

import '../../theme/app_color.dart';
import '../../theme/app_theme.dart';
import 'input_box_component.dart';

class DropdownItem {
  String text;
  dynamic value;
  String? label;
  dynamic additionalValue;

  DropdownItem({
    required this.text,
    this.value,
    this.label,
    this.additionalValue,
  });

  DropdownItem.init(String? text, dynamic value, {String? label})
      : this(
          text: text ?? "",
          value: value,
          label: label,
        );

  DropdownItem.simple(String? value) : this.init(value, value);
}

class InputDropdownController {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  late Function(VoidCallback fn) setState;

  DropdownItem? _value;
  List<DropdownItem> items;
  Function(DropdownItem? value)? onChanged;
  Function()? onChangedVoid;
  bool _isInit = false;

  late bool _required = false;

  dynamic get value {
    return _value?.value;
  }

  String? get text {
    return _value?.text;
  }

  String? get label {
    return _value?.label;
  }

  dynamic get additionalValue {
    return _value?.additionalValue;
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

  set setItems(List<DropdownItem> val) {
    if (val.where((e) => e.value == _value?.value).isEmpty) {
      _value = null;
    }
    items = val;
  }

  InputDropdownController({
    this.items = const [],
    this.onChanged,
  });

  void _rootOnChanged(e) {
    _value = e;
    isValid;
    if (onChanged != null) {
      onChanged!(e);
    }
    if (_isInit) {
      setState(() {});
    }
    if (onChangedVoid != null) {
      onChangedVoid!();
    }
  }

  String? _validator(v) {
    if (_required && v == null) {
      return 'The field is required';
    }
    return null;
  }

  bool get isValid {
    bool? valid = _key.currentState?.validate();
    if (valid == null) {
      return true;
    }
    return valid;
  }

  void _init(Function(VoidCallback fn) setStateX, bool requiredX) {
    setState = setStateX;
    _required = requiredX;
    _isInit = true;
  }
}

class InputDropdownComponent extends StatefulWidget {
  final String? label;
  final double? marginBottom;
  final bool required;
  final bool editable;
  final InputDropdownController controller;
  final Radius? borderRadius;

  const InputDropdownComponent({
    super.key,
    this.label,
    this.marginBottom,
    this.editable = true,
    required this.controller,
    this.required = false,
    this.borderRadius,
  });

  @override
  State<InputDropdownComponent> createState() => _InputDropdownComponentState();
}

class _InputDropdownComponentState extends State<InputDropdownComponent> {
  @override
  void initState() {
    widget.controller._init(
      (fn) {
        if (mounted) {
          setState(fn);
        }
      },
      widget.required,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final decoration = InputDecoration(
      filled: true,
      contentPadding:
          const EdgeInsets.only(top: 12, bottom: 12, left: 10, right: 10),
      fillColor: AppColors.black.withValues(alpha: .01),
      isDense: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(widget.borderRadius ??
            const Radius.circular(AppTheme.borderRadius)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(widget.borderRadius ??
            const Radius.circular(AppTheme.borderRadius)),
        borderSide: const BorderSide(color: AppColors.black, width: .1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(widget.borderRadius ??
            const Radius.circular(AppTheme.borderRadius)),
        borderSide: const BorderSide(color: AppColors.black, width: .1),
      ),
      prefixStyle: TextStyle(
        color: AppColors.white.withValues(alpha: 0.6),
      ),
      suffixIconConstraints: const BoxConstraints(
        minHeight: 30,
        minWidth: 30,
      ),
    );

    return InputBoxComponent(
      label: widget.label,
      isRequired: widget.required,
      marginBottom: widget.marginBottom,
      childText: widget.controller._value == null
          ? ""
          : widget.controller._value?.text ?? "",
      children: widget.editable
          ? Form(
              key: widget.controller._key,
              child: DropdownButtonFormField(
                decoration: decoration,
                isExpanded: true,
                focusColor: Colors.transparent,
                validator: widget.controller._validator,
                value: widget.controller._value,
                onChanged: widget.controller._rootOnChanged,
                items: widget.controller.items
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.text),
                        ))
                    .toList(),
                style: TextStyle(
                  color: AppColors.black.withValues(alpha: .7),
                ),
                dropdownColor: AppColors.white,
                menuMaxHeight: 300,
              ),
            )
          : null,
    );
  }
}

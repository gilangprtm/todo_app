import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'input_box_component.dart';
import 'lookup_component.dart';

class InputLookupController<T> {
  T? _value;
  bool _required = false;
  String? _errorMessage;

  final String Function(T e) itemText;
  final String? Function(T? e)? subtitleText;
  final Function(T e) itemValue;
  final String Function(int index, String filter) urlApi;
  final T Function(dynamic e) fromDynamic;
  late LookupController<T, T> _lookupCon;
  late Function(VoidCallback fn) setState;
  late bool Function()? beforeOnOpenModal;
  late BuildContext context;
  String? label;
  Widget Function(T e, void Function() onClick, Color? color)? itemBuilder;
  bool _isInit = false;

  InputLookupController({
    required this.itemText,
    required this.itemValue,
    required this.urlApi,
    required this.fromDynamic,
    this.subtitleText,
    this.itemBuilder,
    this.beforeOnOpenModal,
  });

  String get text {
    return _value == null ? "" : itemText(_value as T);
  }

  T? get value {
    return _value;
  }

  set value(T? val) {
    _value = val;
    if (_isInit) {
      setState(() {});
    }
  }

  Function()? onChanged;
  Function()? clearOnTab;

  bool get isValid {
    setState(() {
      _errorMessage = null;
    });
    if (_required && _value == null) {
      setState(() {
        _errorMessage = 'The field is required';
      });
      return false;
    }
    return true;
  }

  void _onTab(bool editable) async {
    if (!editable) return;
    if (beforeOnOpenModal != null && beforeOnOpenModal!() == false) return;
    _lookupCon.clearSelectedItems();

    FocusScope.of(context).unfocus();
    await showMaterialModalBottomSheet(
      context: context,
      builder: (context) => LookupComponent<T, T>(
        controller: _lookupCon,
        title: label,
      ),
    );
  }

  void _init(
    Function(VoidCallback fn) setStateX,
    BuildContext contextX,
    String? labelX,
  ) {
    setState = setStateX;
    context = contextX;
    label = labelX;
    _lookupCon = LookupController<T, T>(
      multiple: false,
    );
    _lookupCon.urlApi = urlApi;
    _lookupCon.fromDynamic = fromDynamic;
    _lookupCon.itemText = itemText;
    _lookupCon.itemValue = itemValue;
    _lookupCon.itemSubtitleText = subtitleText;
    _lookupCon.itemBuilder = itemBuilder;
    _lookupCon.insertFromListOnPress = () {
      setState(() {
        _value = _lookupCon.selectedItems.isNotEmpty
            ? _lookupCon.selectedItems.elementAt(0)
            : null;
      });
      _lookupCon.close();
      if (onChanged != null) {
        onChanged!();
        isValid;
      }
    };
    _isInit = true;
  }

  void _clearOnTab() {
    setState(() {
      _value = null;
    });
    if (clearOnTab != null) {
      clearOnTab!();
    }
  }
}

class InputLookupComponent<T> extends StatefulWidget {
  final String? label;
  final bool editable;
  final double? marginBottom;
  final InputLookupController controller;
  final bool required;

  const InputLookupComponent({
    super.key,
    this.label,
    this.marginBottom,
    required this.controller,
    this.editable = true,
    this.required = false,
  });

  @override
  State<InputLookupComponent<T>> createState() =>
      _InputLookupComponentState<T>();
}

class _InputLookupComponentState<T> extends State<InputLookupComponent<T>> {
  @override
  void initState() {
    widget.controller._init((fn) {
      if (mounted) {
        setState(fn);
      }
    }, context, widget.label);
    widget.controller._required = widget.required;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InputBoxComponent(
      label: widget.label,
      isRequired: widget.required,
      editable: widget.editable,
      alowClear: widget.editable && widget.controller._value != null,
      errorMessage: widget.controller._errorMessage,
      clearOnTab: widget.controller._clearOnTab,
      marginBottom: widget.marginBottom,
      onTap: !widget.editable
          ? null
          : () => widget.controller._onTab(widget.editable),
      icon: !widget.editable ? null : FontAwesomeIcons.magnifyingGlass,
      childText: widget.controller.text,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../theme/app_color.dart';
import '../../theme/app_typografi.dart';
import '../pages/empty_component.dart';
import 'lookup_component.dart';

class InputDetailControler<T> {
  bool _required = false;
  String? _errorMessage;
  late LookupController<T, T> _lookupCon;
  Widget Function(T e, bool editable, void Function() deleteOnPress)? _builder;
  bool _isInit = false;

  late BuildContext context;
  late Function(VoidCallback fn) setState;
  String? label;

  final Function(T e) itemKey;
  final String Function(int index, String filter) urlApi;
  T Function(dynamic e)? fromDynamic;
  late final String Function(T e) itemText;
  Widget Function(T e, void Function() onClick, Color? color)? itemBuilder;
  Function()? onChanged;

  InputDetailControler({
    required this.itemKey,
    required this.urlApi,
    required this.fromDynamic,
    required this.itemText,
    this.itemBuilder,
    this.onChanged,
  });

  final List<T> _values = [];

  void clear() {
    _values.clear();
    if (_isInit) {
      setState(() {});
    }
  }

  List<T> get values => _values;

  void addValue(T e) {
    _values.add(e);
    if (_isInit) {
      setState(() {});
    }
  }

  void updateValue(dynamic id, T e) {
    for (var element in _values) {
      if (itemKey(element) == id) {
        element = e;
      }
    }
    if (_isInit) {
      setState(() {});
    }
  }

  void refresh() {
    if (_isInit) {
      setState(() {});
    }
  }

  bool get isValid {
    setState(() {
      _errorMessage = null;
    });
    if (_required && _values.isEmpty) {
      setState(() {
        _errorMessage = 'The field is required';
      });
      return false;
    }
    return true;
  }

  void _itemDeleteOnPress(e) {
    setState(() {
      _values.removeWhere((element) => itemKey(element) == itemKey(e));
    });
    if (onChanged != null) {
      onChanged!();
    }
  }

  void _addOnPressed() async {
    if (EasyLoading.isShow) return;
    FocusScope.of(context).unfocus();
    _lookupCon.clearSelectedItems();
    await showMaterialModalBottomSheet(
      context: context,
      builder: (context) => LookupComponent<T, T>(
        controller: _lookupCon,
        title: label,
      ),
    );
  }

  Widget _itemWidget(T element, bool editable) => _builder != null
      ? _builder!(element, editable, () => _itemDeleteOnPress(element))
      : Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(itemText(element)),
                  Expanded(child: Container()),
                  Visibility(
                    visible: editable,
                    child: InkWell(
                      onTap: () => _itemDeleteOnPress(element),
                      child: const Icon(
                        Icons.delete_forever,
                        color: AppColors.errorColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

  void _init(
    Function(VoidCallback fn) setStateX,
    BuildContext contextX,
    String? labelX,
  ) {
    setState = setStateX;
    context = contextX;
    label = labelX;

    _lookupCon = LookupController<T, T>();
    _lookupCon.urlApi = urlApi;
    _lookupCon.fromDynamic = fromDynamic;
    _lookupCon.itemText = itemText;
    _lookupCon.itemBuilder = itemBuilder;
    _lookupCon.itemValue = itemKey;
    _lookupCon.insertFromListOnPress = () {
      setState(() {
        for (var m in _lookupCon.selectedItems) {
          if (_values
              .where((element) => itemKey(element) == itemKey(m))
              .isEmpty) {
            _values.add(m);
          }
        }
      });
      _lookupCon.close();
      if (onChanged != null) {
        onChanged!();
      }
    };

    _isInit = true;
  }
}

class InputDetailComponent<T> extends StatefulWidget {
  final InputDetailControler<T> controller;
  final String? label;
  final bool editable;
  final bool required;
  final Widget Function(T e, bool editable, void Function() deleteOnPress)?
      builder;

  const InputDetailComponent({
    super.key,
    this.label,
    this.editable = true,
    this.required = false,
    required this.controller,
    this.builder,
  });

  @override
  State<InputDetailComponent<T>> createState() =>
      _InputDetailComponentState<T>();
}

class _InputDetailComponentState<T> extends State<InputDetailComponent<T>> {
  @override
  void initState() {
    widget.controller._builder = widget.builder;
    widget.controller._required = widget.required;
    widget.controller._init((fn) {
      if (mounted) {
        setState(fn);
      }
    }, context, widget.label);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
            child: Text(
              widget.label ?? "",
              style: AppTypography.muted,
            ),
          ),
          Container(
            color: AppColors.black.withValues(alpha: .05),
            child: Column(
              children: [
                Visibility(
                  visible: !widget.editable,
                  child: const Padding(padding: EdgeInsets.all(2)),
                ),
                Visibility(
                  visible:
                      widget.controller._values.isEmpty && !widget.editable,
                  child: Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: const EmptyComponent(),
                  ),
                ),
                Column(
                  children: widget.controller._values
                      .map((e) =>
                          widget.controller._itemWidget(e, widget.editable))
                      .toList(),
                ),
                Visibility(
                  visible: widget.editable,
                  child: const Padding(padding: EdgeInsets.all(5)),
                ),
                Visibility(
                  visible: widget.editable,
                  child: TextButton(
                    onPressed: widget.controller._addOnPressed,
                    child: const Icon(FontAwesomeIcons.circlePlus),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(5)),
              ],
            ),
          ),
          Visibility(
            visible: widget.controller._errorMessage != null,
            child: Container(
              margin: const EdgeInsets.only(
                top: 8,
                left: 12,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.controller._errorMessage ?? "",
                  style: const TextStyle(color: AppColors.errorColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

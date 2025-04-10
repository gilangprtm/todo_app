import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../helper/helper.dart';
import '../../theme/app_color.dart';
import '../../theme/app_typografi.dart';
import '../pages/empty_component.dart';
import 'lookup_component.dart';

class DetailSetupItemModel<T> {
  String key;
  T value;

  DetailSetupItemModel({
    required this.key,
    required this.value,
  });

  DetailSetupItemModel.init(String key, T value)
      : this(
          key: key,
          value: value,
        );
}

class InputDetailSetupControler<T> {
  bool _required = false;
  String? _errorMessage;
  late BuildContext context;
  late Function(VoidCallback fn) setState;
  String? label;
  bool _isInit = false;

  final Function(T e) itemKey;
  T Function(dynamic e)? fromDynamic;
  late final String Function(T e) itemText;
  Widget Function(T e, bool editable, void Function() deleteOnPress,
      void Function() editOnPress)? _builder;
  Function()? onChanged;
  bool Function()? onBeforeSubmit;
  Function(dynamic id, T? e) onOpenForm;
  T? Function(dynamic id) onFormInsert;

  late LookupController<T, T> _formCon;
  late Widget Function(dynamic) _formBuilder;

  String? _keyActive;

  InputDetailSetupControler({
    required this.itemKey,
    required this.fromDynamic,
    required this.itemText,
    required this.onOpenForm,
    required this.onFormInsert,
    this.onChanged,
    this.onBeforeSubmit,
  });

  void clear() {
    _values.clear();
    if (_isInit) {
      setState(() {});
    }
  }

  final Map<String, T> _values = {};

  List<DetailSetupItemModel<T>> get values => _values.entries
      .map((e) => DetailSetupItemModel<T>.init(e.key, e.value))
      .toList();

  void updateValue(String key, T e) {
    _values[key] = e;
    if (_isInit) {
      setState(() {});
    }
  }

  void addValue(T e) {
    _values[Helper.idGenerator()] = e;
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
    if (_required && _values.isEmpty) {
      setState(() {
        _errorMessage = 'The field is required';
      });
      return false;
    } else {
      _errorMessage = null;
      return true;
    }
  }

  void _itemDeleteOnPress(String e) {
    _keyActive = null;
    setState(() {
      _values.remove(e);
    });
    if (onChanged != null) {
      onChanged!();
    }
  }

  void _itemEditOnPress(String key) async {
    if (EasyLoading.isShow) return;
    FocusScope.of(context).unfocus();
    var model = _values[key];
    if (model != null) {
      onOpenForm(itemKey(model), model);
      _keyActive = key;
      await showMaterialModalBottomSheet(
        context: context,
        builder: (context) => LookupComponent<T, T>(
          controller: _formCon,
          title: label,
        ),
      );
    }
  }

  void _addOnPressed() async {
    if (EasyLoading.isShow) return;
    FocusScope.of(context).unfocus();
    onOpenForm(null, null);
    _keyActive = null;
    await showMaterialModalBottomSheet(
      context: context,
      builder: (context) => LookupComponent<T, T>(
        controller: _formCon,
        title: label,
      ),
    );
  }

  Widget _itemWidget(String key, T element, bool editable) {
    return _builder != null
        ? _builder!(element, editable, () => _itemDeleteOnPress(key),
            () => _itemEditOnPress(key))
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
                        onTap: () => _itemDeleteOnPress(key),
                        child: const Icon(
                          Icons.delete_forever,
                          color: AppColors.errorColor,
                        ),
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () => _itemEditOnPress(key),
                  child: const Text(
                    "Edit",
                    style: TextStyle(color: AppColors.primaryColor),
                  ),
                )
              ],
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

    _formCon = LookupController<T, T>(
      insertOnPress: () {
        if (onBeforeSubmit != null) {
          if (!onBeforeSubmit!()) return;
        }
        if (_keyActive == null) {
          // add
          var model = onFormInsert(null);
          if (model != null) {
            setState(() {
              _values[Helper.idGenerator()] = model;
            });
          }
        } else {
          // update
          var oldModel = _values[_keyActive];
          if (oldModel != null) {
            var model = onFormInsert(itemKey(oldModel));
            if (model != null) {
              setState(() {
                _values[_keyActive!] = model;
              });
            }
          }
        }
        // close
        _formCon.close();
        if (onChanged != null) {
          onChanged!();
        }
      },
    );
    _formCon.isSetup = true;
    _formCon.builder = _formBuilder;
    _isInit = true;
  }
}

class InputDetailSetupComponent<T> extends StatefulWidget {
  final InputDetailSetupControler<T> controller;
  final String? label;
  final bool editable;
  final bool required;
  final Widget Function(dynamic e) formBuilder;
  final Widget Function(T e, bool editable, void Function() deleteOnPress,
      void Function() editOnPress)? builder;

  const InputDetailSetupComponent({
    super.key,
    this.label,
    this.editable = true,
    this.required = false,
    required this.controller,
    this.builder,
    required this.formBuilder,
  });

  @override
  State<InputDetailSetupComponent> createState() =>
      _InputDetailSetupComponentState<T>();
}

class _InputDetailSetupComponentState<T>
    extends State<InputDetailSetupComponent<T>> {
  @override
  void initState() {
    widget.controller._formBuilder = widget.formBuilder;
    widget.controller._builder = widget.builder;
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
    if (widget.controller.values.isNotEmpty) {
      setState(() => widget.controller._errorMessage = null);
    }
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
                  children: widget.controller._values.entries
                      .map((e) => widget.controller
                          ._itemWidget(e.key, e.value, widget.editable))
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

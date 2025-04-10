import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../theme/app_color.dart';
import '../../theme/app_typografi.dart';
import '../pages/empty_component.dart';
import 'lookup_component.dart';

class InputDetailSetupListControler<T, U> {
  bool _required = false;
  String? _errorMessage;
  late BuildContext context;
  late Function(VoidCallback fn) setState;
  String? label;

  final Function(T e) itemKey;
  final Function(U e) itemKeyU;
  T Function(dynamic e)? fromDynamic;
  late final String Function(T e) itemText;
  late final String Function(U e) itemTextU;
  Widget Function(U e, bool editable, void Function() deleteOnPress,
      void Function() editOnPress)? _builder;
  Function()? onChanged;
  Function(T e) onOpenForm;
  Function(U e) onOpenFormEdit;
  U? Function(T e) onFormInsert;
  U? Function(U e) onFormUpdate;
  final String Function(int index, String filter) urlApi;
  final U Function(U oldModel, U newModel)? readd;
  bool _isInit = false;

  late LookupController<T, U> _formCon;
  late Widget Function(dynamic) _formBuilder;
  Widget Function(T e, void Function() onClick, Color? color)? itemBuilder;

  InputDetailSetupListControler({
    required this.urlApi,
    required this.itemKey,
    required this.itemKeyU,
    required this.fromDynamic,
    required this.itemText,
    required this.itemTextU,
    required this.onOpenForm,
    required this.onFormInsert,
    required this.onOpenFormEdit,
    required this.onFormUpdate,
    this.onChanged,
    this.itemBuilder,
    this.readd,
  });

  void clear() {
    _values.clear();
    if (_isInit) {
      setState(() {});
    }
  }

  final List<U> _values = [];

  List<U> get values => _values;

  void addValue(U e) {
    _values.add(e);
    if (_isInit) {
      setState(() {});
    }
  }

  void updateValue(dynamic id, U e) {
    for (var element in _values) {
      if (itemKeyU(element) == id) {
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

  void _itemDeleteOnPress(U e) {
    setState(() {
      _values.removeWhere((element) => itemKeyU(element) == itemKeyU(e));
    });
    if (onChanged != null) {
      onChanged!();
    }
  }

  void _itemEditOnPress(U e) async {
    if (EasyLoading.isShow) return;
    FocusScope.of(context).unfocus();
    onOpenFormEdit(e);
    _formCon.isSetup = true;
    _formCon.itemUActive = e;
    _formCon.itemsSelectedActive = null;
    await showMaterialModalBottomSheet(
      context: context,
      builder: (context) => LookupComponent<T, U>(
        controller: _formCon,
        title: label,
      ),
    );
  }

  void _addOnPressed() async {
    if (EasyLoading.isShow) return;
    FocusScope.of(context).unfocus();
    _formCon.isSetup = false;
    _formCon.itemUActive = null;
    _formCon.itemsSelectedActive = null;
    _formCon.selectedItems.clear();
    _formCon.selectedItemsU.clear();
    await showMaterialModalBottomSheet(
      context: context,
      builder: (context) => LookupComponent<T, U>(
        controller: _formCon,
        title: label,
      ),
    );
  }

  Widget _itemWidget(U element, bool editable) => _builder != null
      ? _builder!(element, editable, () => _itemDeleteOnPress(element),
          () => _itemEditOnPress(element))
      : Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(itemTextU(element)),
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
              InkWell(
                onTap: () => _itemEditOnPress(element),
                child: const Text(
                  "Edit",
                  style: TextStyle(color: AppColors.primaryColor),
                ),
              )
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

    _formCon = LookupController<T, U>();
    _formCon.builder = _formBuilder;
    _formCon.urlApi = urlApi;
    _formCon.fromDynamic = fromDynamic;
    _formCon.itemText = itemText;
    _formCon.itemBuilder = itemBuilder;
    _formCon.itemValue = itemKey;
    _formCon.withSetup = true;
    _formCon.onOpenForm = onOpenForm;
    _formCon.insertOnPress = () {
      if (_formCon.itemUActive != null) {
        // update
        var model = onFormUpdate(_formCon.itemUActive as U);
        if (model != null) {
          setState(() {
            for (var e in _values) {
              if (itemKeyU(e) == itemKeyU(model)) {
                e = model;
              }
            }
          });
        }
        _formCon.close();
        if (onChanged != null) {
          onChanged!();
        }
      } else if (_formCon.itemsSelectedActive != null) {
        // add
        var item = _formCon.itemsSelectedActive as T;
        var newU = onFormInsert(item);
        if (newU != null) {
          _formCon.selectedItems
              .removeWhere((element) => itemKey(element) == itemKey(item));
          _formCon.selectedItemsU
              .removeWhere((element) => itemKeyU(element) == itemKeyU(newU));
          _formCon.setState(() {
            _formCon.selectedItems.add(_formCon.itemsSelectedActive as T);
            _formCon.selectedItemsU.add(newU);
            _formCon.isSetup = false;
          });
        }
      }
    };
    _formCon.insertFromListOnPress = () {
      setState(() {
        var itemsKeys = _formCon.selectedItems.map((e) => itemKey(e)).toList();
        var itemsU = _formCon.selectedItemsU
            .where((e) => itemsKeys.contains(itemKeyU(e)));
        for (var m in itemsU) {
          if (_values
              .where((element) => itemKeyU(element) == itemKeyU(m))
              .isEmpty) {
            _values.add(m);
          } else {
            if (readd != null) {
              for (var element in _values) {
                if (itemKeyU(element) == itemKeyU(m)) {
                  element = readd!(element, m);
                }
              }
            }
          }
        }
      });
      _formCon.close();
      if (onChanged != null) {
        onChanged!();
      }
    };
    _isInit = true;
  }
}

class InputDetailSetupListComponent<T, U> extends StatefulWidget {
  final InputDetailSetupListControler<T, U> controller;
  final String? label;
  final bool editable;
  final bool required;
  final Widget Function(dynamic e) formBuilder;
  final Widget Function(U e, bool editable, void Function() deleteOnPress,
      void Function() editOnPress)? builder;

  const InputDetailSetupListComponent({
    super.key,
    this.label,
    this.editable = true,
    this.required = false,
    required this.controller,
    this.builder,
    required this.formBuilder,
  });

  @override
  State<InputDetailSetupListComponent> createState() =>
      _InputDetailSetupListComponentState<T, U>();
}

class _InputDetailSetupListComponentState<T, U>
    extends State<InputDetailSetupListComponent<T, U>> {
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

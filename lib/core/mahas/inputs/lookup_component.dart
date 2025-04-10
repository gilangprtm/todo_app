import 'package:flutter/material.dart';
import '../../../data/datasource/network/db/http_api.dart';
import '../../helper/dialog_helper.dart';
import '../../theme/app_color.dart';
import '../mahas_config.dart';
import '../models/api_list_resut_model.dart';
import '../pages/empty_component.dart';
import '../pages/shimmer_component.dart';
import 'input_text_component.dart';

class LookupController<T, U> extends ChangeNotifier {
  final bool multiple;
  final _listViewController = ScrollController();
  final _filterController = InputTextController();

  late final Function(T e) itemValue;
  late final List<T> _items;
  late final String Function(T e) itemText;
  late final String? Function(T e)? itemSubtitleText;

  late BuildContext context;
  late Function(VoidCallback fn) setState;

  String Function(int index, String filter)? urlApi;
  T Function(dynamic e)? fromDynamic;
  Function()? insertOnPress;
  Function()? insertFromListOnPress;
  Function(T e)? onOpenForm;
  Widget Function(T e, void Function() onClick, Color? color)? itemBuilder;
  late Widget Function(dynamic) builder;
  T? model;

  List<T> _itemsSelected = [];
  final List<U> _itemsUSelected = [];
  bool _loadingBottom = false;
  bool _isItemRefresh = false;
  int _pageIndex = 0;
  int _maxPage = 0;
  bool isSetup = false;
  bool allowFilter = true;
  U? itemUActive;

  set items(List<T> value) {
    _items.clear();
    _items.addAll(value);
  }

  List<T> get selectedItems {
    return _itemsSelected;
  }

  List<U> get selectedItemsU {
    return _itemsUSelected;
  }

  void clearSelectedItems() {
    _itemsSelected.clear();
    _itemsUSelected.clear();
  }

  T? itemsSelectedActive;
  bool withSetup = false;

  LookupController({
    this.urlApi,
    this.fromDynamic,
    this.insertOnPress,
    this.multiple = true,
  }) : _items = [];

  void clearItems() {
    _items.clear();
    _pageIndex = 0;
    _maxPage = 0;
  }

  void _unfocus() {
    FocusScope.of(context).unfocus();
  }

  Future refreshItems() async {
    if (urlApi != null) {
      clearItems();
      await refreshBottom();
      _unfocus();
    }
    setState(() {});
  }

  Future refreshBottom({nextPage = false}) async {
    final itemsX = await getItems(nextPage: nextPage);
    if (itemsX != null) {
      _items.addAll(itemsX);
    }
  }

  Future<List<T>?> getItems({nextPage = false}) async {
    if (urlApi == null) return [];
    if (!_loadingBottom) {
      setState(() {
        _isItemRefresh = true;
      });
    }
    try {
      final pageIndexX = nextPage ? _pageIndex + 1 : _pageIndex;
      final filterX = _filterController.value as String;
      final query =
          urlApi!(pageIndexX + (MahasConfig.isLaravelBackend ? 1 : 0), filterX);
      final apiModel = await HttpApi.get(query);
      final List<T> result = [];
      if (!_loadingBottom) {
        setState(() {
          _isItemRefresh = false;
        });
      }
      if (apiModel.success) {
        ApiResultListModel listModel =
            ApiResultListModel.fromJson(apiModel.body);
        _maxPage = listModel.maxPage!;
        _pageIndex = pageIndexX;
        for (var i = 0; i < (listModel.datas ?? []).length; i++) {
          if (fromDynamic != null) {
            result.add(fromDynamic!(listModel.datas![i]));
          }
          setState(() {});
        }
      } else {
        DialogHelper.showErrorDialog(apiModel.message ?? "");
      }
      return result;
    } catch (ex) {
      DialogHelper.showErrorDialog(ex.toString());
      setState(() {
        _isItemRefresh = false;
      });
      return null;
    }
  }

  void _init(Function(VoidCallback fn) setStateX, BuildContext contextX) {
    setState = setStateX;
    context = contextX;
    _filterController.onEditingComplete = () => refreshItems();
    _listViewController.addListener(() async {
      if (_loadingBottom) return;
      final maxScroll = _listViewController.position.maxScrollExtent;
      final currentScroll = _listViewController.position.pixels;
      const delta = 0.0;
      if (maxScroll - currentScroll <= delta && _pageIndex != _maxPage) {
        _loadingBottom = true;
        await refreshBottom(nextPage: true);
        _loadingBottom = false;
      }
    });
    refreshItems();
  }

  Future<bool> backOnPressed() async {
    if (withSetup && isSetup && itemsSelectedActive != null) {
      setState(() {
        isSetup = false;
      });
      return false;
    } else {
      return true;
    }
  }

  void itemOnTab(T e) {
    final item =
        _itemsSelected.where((element) => itemValue(element) == itemValue(e));

    setState(() {
      if (item.isEmpty) {
        if (!multiple) {
          _itemsSelected = [];
        }
        if (withSetup) {
          isSetup = true;
          itemsSelectedActive = e;
          onOpenForm!(e);
        } else {
          _itemsSelected.add(e);
        }
      } else {
        if (!multiple) {
          insertFromListOnPress!();
        }
        _itemsSelected.removeAt(_itemsSelected
            .indexWhere((element) => itemValue(element) == itemValue(e)));
      }
    });
  }

  Color? _itemColor(int index) {
    return _itemsSelected
            .where((element) => itemValue(element) == itemValue(_items[index]))
            .isEmpty
        ? null
        : AppColors.primaryColor.withValues(alpha: .2);
  }

  String _itemText(int index) {
    return itemText(_items[index]);
  }

  String _itemSubtitleText(int index) {
    if (itemSubtitleText == null) {
      return "";
    }
    return itemSubtitleText!(_items[index]) ?? "";
  }

  void close() {
    Navigator.pop(context);
  }

  Widget _itemBuilder(int index) {
    if (itemBuilder != null) {
      return itemBuilder!(
        _items[index],
        () => itemOnTab(_items[index]),
        _itemColor(index),
      );
    } else {
      return ListTile(
        tileColor: _itemColor(index),
        title: Text(
          _itemText(index),
        ),
        subtitle: itemSubtitleText == null
            ? null
            : Text(
                _itemSubtitleText(index),
              ),
        onTap: () => itemOnTab(_items[index]),
      );
    }
  }
}

class LookupComponent<T, U> extends StatefulWidget {
  final String? title;
  final LookupController<T, U> controller;
  final Widget Function(dynamic)? setup;

  const LookupComponent({
    super.key,
    this.title,
    required this.controller,
    this.setup,
  });

  @override
  State<LookupComponent> createState() => _LookupComponentState();
}

class _LookupComponentState<T, U> extends State<LookupComponent<T, U>> {
  @override
  void initState() {
    widget.controller._init((fn) {
      if (mounted) {
        setState(fn);
      }
    }, context!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        widget.controller.backOnPressed();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? ""),
          centerTitle: true,
        ),
        body: StatefulBuilder(
          builder: (
            context,
            setState,
          ) =>
              widget.controller.isSetup
                  ? Container(
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          widget.controller.builder(widget.controller.model),
                          ElevatedButton(
                            onPressed: widget.controller.insertOnPress,
                            child: const Text("Masukan"),
                          )
                        ],
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Visibility(
                          visible: widget.controller.allowFilter,
                          child: InputTextComponent(
                            borderRadius: Radius.zero,
                            placeHolder: 'Search',
                            marginBottom: 0,
                            controller: widget.controller._filterController,
                          ),
                        ),
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: widget.controller.refreshItems,
                            child: widget.controller._isItemRefresh
                                ? const ShimmerComponent()
                                : widget.controller._items.isEmpty &&
                                        !widget.controller._isItemRefresh
                                    ? EmptyComponent(
                                        onPressed:
                                            widget.controller.refreshItems)
                                    : ListView.separated(
                                        separatorBuilder: (context, index) =>
                                            const Divider(height: 0),
                                        controller: widget
                                            .controller._listViewController,
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        itemCount:
                                            widget.controller._items.length +
                                                (MahasConfig.isLaravelBackend
                                                    ? 1
                                                    : 0),
                                        itemBuilder: (context, index) {
                                          if (index ==
                                              widget.controller._items.length) {
                                            return Visibility(
                                              visible: widget.controller
                                                          ._pageIndex !=
                                                      widget.controller
                                                          ._maxPage &&
                                                  widget.controller._items
                                                      .isNotEmpty,
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.all(10),
                                                child: const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Container(
                                              child: widget.controller
                                                  ._itemBuilder(index),
                                            );
                                          }
                                        },
                                      ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: widget.controller.insertFromListOnPress,
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text("Masukan"),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}

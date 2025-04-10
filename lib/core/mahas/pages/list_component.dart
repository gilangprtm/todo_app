import 'package:flutter/material.dart';
import '../../../data/datasource/network/db/http_api.dart';
import '../../helper/dialog_helper.dart';
import '../inputs/input_text_component.dart';
import '../mahas_config.dart';
import '../models/api_list_resut_model.dart';
import 'empty_component.dart';
import 'shimmer_component.dart';

class ListComponentController<T> {
  final Function(int index, String filter) urlApi;
  final T Function(dynamic e) fromDynamic;
  final bool allowSearch;
  final bool autoRefresh;
  late Function(VoidCallback fn) setState;

  final _listViewController = ScrollController();
  final _filterController = InputTextController();
  final List<T> _items = [];

  ListComponentController({
    required this.urlApi,
    required this.fromDynamic,
    this.allowSearch = true,
    this.autoRefresh = true,
  });

  bool _loadingBottom = false;
  bool _isItemRefresh = true;
  int _pageIndex = 0;
  int _maxPage = 0;

  void clear() {
    _items.clear();
    _pageIndex = 0;
    _maxPage = 0;
  }

  Future refresh() async {
    clear();
    await _refreshBottom();
    setState(() {});
  }

  Future _refreshBottom({nextPage = false}) async {
    final itemsX = await _getItems(nextPage: nextPage);
    if (itemsX != null) {
      _items.addAll(itemsX);
    }
  }

  Future<List<T>?> _getItems({nextPage = false}) async {
    if (!nextPage) {
      setState(() {
        _isItemRefresh = true;
      });
    }
    try {
      final pageIndexX = nextPage ? _pageIndex + 1 : _pageIndex;
      final filterX = _filterController.value;
      final query =
          urlApi(pageIndexX + (MahasConfig.isLaravelBackend ? 1 : 0), filterX);
      final apiModel = await HttpApi.get(query);
      final List<T> result = [];
      setState(() {
        _isItemRefresh = false;
      });
      if (apiModel.success) {
        ApiResultListModel listModel =
            ApiResultListModel.fromJson(apiModel.body);
        _maxPage = listModel.maxPage!;
        _pageIndex = pageIndexX;
        for (var obj in (listModel.datas ?? [])) {
          result.add(fromDynamic(obj));
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

  void init(Function(VoidCallback fn) setStateX) {
    setState = setStateX;
    _filterController.onEditingComplete = () => refresh();
    _listViewController.addListener(() async {
      if (_loadingBottom) return;
      final maxScroll = _listViewController.position.maxScrollExtent;
      final currentScroll = _listViewController.position.pixels;
      const delta = 0.0;
      if (maxScroll - currentScroll <= delta && _pageIndex != _maxPage) {
        _loadingBottom = true;
        await _refreshBottom(nextPage: true);
        _loadingBottom = false;
      }
    });
    if (autoRefresh) {
      refresh();
    }
  }
}

class ListComponent<T> extends StatefulWidget {
  final ListComponentController<T> controller;
  final Widget Function(T e) itemBuilder;
  final bool allowMenuAction;
  final List<Widget>? listMenuAction;
  final Widget Function(BuildContext context, int index, int length)?
      separatorBuilder;
  final Widget? emptyBuilder;

  const ListComponent({
    super.key,
    required this.controller,
    required this.itemBuilder,
    this.allowMenuAction = false,
    this.listMenuAction,
    this.separatorBuilder,
    this.emptyBuilder,
  });

  @override
  State<ListComponent<T>> createState() => _ListComponentState<T>();
}

class _ListComponentState<T> extends State<ListComponent<T>> {
  @override
  void initState() {
    widget.controller.init((fn) {
      if (mounted) {
        setState(fn);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: widget.controller.allowSearch,
          child: InputTextComponent(
            borderRadius: Radius.zero,
            placeHolder: 'Search',
            marginBottom: 0,
            controller: widget.controller._filterController,
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: widget.controller.refresh,
            child: widget.controller._isItemRefresh
                ? const ShimmerComponent()
                : widget.controller._items.isEmpty &&
                        !widget.controller._isItemRefresh
                    ? widget.emptyBuilder != null
                        ? widget.emptyBuilder!
                        : EmptyComponent(onPressed: widget.controller.refresh)
                    : ListView.separated(
                        separatorBuilder: widget.separatorBuilder != null
                            ? (context, index) => widget.separatorBuilder!(
                                context, index, widget.controller._items.length)
                            : (context, index) => const Divider(height: 0),
                        controller: widget.controller._listViewController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: widget.controller._items.length +
                            (MahasConfig.isLaravelBackend ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == widget.controller._items.length) {
                            return Visibility(
                              visible: widget.controller._pageIndex !=
                                      widget.controller._maxPage &&
                                  widget.controller._items.isNotEmpty,
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            );
                          } else {
                            return widget
                                .itemBuilder(widget.controller._items[index]);
                          }
                        },
                      ),
          ),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:skeleton_test/src/global_widgets/molecules/cross_fade.dart';
import 'package:skeleton_test/src/global_widgets/molecules/statefull_wrapper.dart';
import 'package:skeleton_test/src/todos/todos_controller.dart';

class ListTodosItem extends StatefulWidget {
  final TodosController controller;
  const ListTodosItem({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<ListTodosItem> createState() => _ListTodosItemState();
}

class _ListTodosItemState extends State<ListTodosItem> {
  late final ScrollController _scrollController;
  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.hasClients &&
          _scrollController.offset ==
              _scrollController.position.maxScrollExtent) {
        widget.controller.loadNewItem();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
      onInit: () => widget.controller.initialLoad(),
      child: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, _) => CrossFade<bool>(
          initialData: true,
          data: widget.controller.isLoading,
          builder: (isLoading) => isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  controller: _scrollController,
                  itemExtent: 75,
                  itemCount: widget.controller.todos.length + 1,
                  itemBuilder: (ctx, index) {
                    if (index >= widget.controller.todos.length) {
                      return CrossFade<bool>(
                        initialData: true,
                        data: widget.controller.isLoadingNewItem,
                        builder: (data) => data
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : const SizedBox(),
                      );
                    }
                    var currentItem = widget.controller.todos.elementAt(index);
                    return ListTile(
                      subtitle: Text('${currentItem.title}'),
                      title: Text('${currentItem.title?.split(" ").first}'),
                      trailing: currentItem.completed ?? false
                          ? const Icon(
                              Icons.check_circle_outlined,
                              color: Colors.blue,
                            )
                          : const Icon(
                              Icons.check_box_outline_blank,
                            ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}

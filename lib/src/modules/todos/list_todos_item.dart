import 'package:flutter/material.dart';
import 'package:skeleton_test/src/global_widgets/molecules/cross_fade.dart';
import 'package:skeleton_test/src/global_widgets/molecules/statefull_wrapper.dart';
import 'package:skeleton_test/src/modules/todos/todos_controller.dart';

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
        widget.controller.loadNewItem(context: context);
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
      ///trigger initialLoad when widget has initialized
      onInit: () => widget.controller.initialLoad(context: context),
      child: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, _) => CrossFade<bool>(
          initialData: true,
          data: widget.controller.isLoading,
          //when controller state isLoading active
          //circular progress will show
          //when isloading changed to false
          //will replaced with listview builder
          builder: (isLoading) => isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  controller: _scrollController,
                  itemExtent: 75,
                  itemCount: widget.controller.todos.length + 1,
                  itemBuilder: (ctx, index) {
                    ///create listview builder thats itemcount is
                    ///todos length plus 1 when index is >=
                    ///length its will show an crossfade animation widget
                    ///when isLoadingNewItem is active
                    ///at child is will show circularprogressindicator
                    ///when false will show sizedbox
                    ///if index same as index at list item
                    ///its will show listtile which contain list item
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

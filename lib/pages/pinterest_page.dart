import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:flutter_pinterest_layout/widgets/pinterest_menu.dart';

class PinterestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _MenuModel(),
      child: Scaffold(
        // body: PinterestMenu(),
        // body: PinterestGrid(),
        body: Stack(children: [
          PinterestGrid(),
          _PinterestMenuLocation(),
        ]),
      ),
    );
  }
}

class _PinterestMenuLocation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.of(context).size.width;
    final show = Provider.of<_MenuModel>(context, listen: false).show;

    return Positioned(
        bottom: 30,
        child: Container(
            width: widthScreen,
            child: Align(
                child: PinterestMenu(show: show, items: [
              PinterestButton(
                  onPressed: () => print('Icon Pie chart'),
                  icon: Icons.pie_chart),
              PinterestButton(
                  onPressed: () => print('Icon Search'), icon: Icons.search),
              PinterestButton(
                  onPressed: () => print('Icon notifications'),
                  icon: Icons.notifications),
              PinterestButton(
                  onPressed: () => print('Icon supervised_user_circle'),
                  icon: Icons.supervised_user_circle),
            ]
                    // backgroundColor: Colors.red,
                    // activeColor: Colors.white,
                    // inactiveColor: Colors.blue,
                    ))));
  }
}

class PinterestGrid extends StatefulWidget {
  @override
  _PinterestGridState createState() => _PinterestGridState();
}

class _PinterestGridState extends State<PinterestGrid> {
  final List<int> items = List.generate(200, (index) => index);
  double scrollBeforeValue = 0;
  ScrollController controller = ScrollController();

  @override
  void initState() {
    controller.addListener(() {
      // print('Offset: ${controller.offset}');
      // print('ScrollBeforeValue: $scrollBeforeValue');
      // print(
      //     'controller.offset > scrollBeforeValue:  ${controller.offset > scrollBeforeValue}');
      if (controller.offset > scrollBeforeValue && controller.offset > 150) {
        Provider.of<_MenuModel>(context, listen: false).show = false;
      } else {
        Provider.of<_MenuModel>(context, listen: false).show = true;
      }

      scrollBeforeValue = controller.offset;
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      controller: controller,
      crossAxisCount: 4,
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) => _PinterestItem(index),
      staggeredTileBuilder: (int index) =>
          new StaggeredTile.count(2, index.isEven ? 2 : 3),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }
}

class _PinterestItem extends StatelessWidget {
  final int index;

  const _PinterestItem(this.index);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.all(Radius.circular(30))),
        child: Center(
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Text('${this.index}'),
          ),
        ));
  }
}

class _MenuModel with ChangeNotifier {
  bool _show = true;

  bool get show => this._show;

  set show(bool value) {
    this._show = value;
    notifyListeners();
  }
}

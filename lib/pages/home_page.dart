import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shopkeeper/blocs/orders_bloc.dart';
import 'package:shopkeeper/blocs/user_bloc.dart';
import 'package:shopkeeper/tabs/orders_tab.dart';
import 'package:shopkeeper/tabs/products_tab.dart';
import 'package:shopkeeper/tabs/users_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  int _page = 0;
  late UserBloc _userBloc;
  late OrdersBloc _ordersBloc;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _userBloc = UserBloc();
    _ordersBloc = OrdersBloc();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Colors.pinkAccent,
            primaryColor: Colors.white,
            textTheme: Theme.of(context).textTheme.copyWith(
                  bodySmall: const TextStyle(color: Colors.white54),
                )),
        child: BottomNavigationBar(
          currentIndex: _page,
          onTap: (p) {
            _pageController.animateToPage(p,
                duration: const Duration(milliseconds: 250),
                curve: Curves.decelerate);
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: 'Clientes'),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), label: 'Pedidos'),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Produtos'),
          ],
        ),
      ),
      body: SafeArea(
        child: BlocProvider(
          blocs: [Bloc((i) => _userBloc)],
          dependencies: const [],
          child: BlocProvider(
            blocs: [Bloc((i) => _ordersBloc)],
            dependencies: [],
            child: PageView(
              onPageChanged: (p) {
                setState(() {
                  _page = p;
                });
              },
              controller: _pageController,
              children: const [
                UsersTab(),
                OrdersTab(),
                ProductsTab(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFloating(),
    );
  }

  Widget? _buildFloating() {
    switch (_page) {
      case 0:
        return null;
      case 1:
        return SpeedDial(
          backgroundColor: Colors.pinkAccent,
          overlayOpacity: 0.4,
          overlayColor: Colors.black,
          children: [
            SpeedDialChild(
                child: const Icon(
                  Icons.arrow_downward,
                  color: Colors.pinkAccent,
                ),
                backgroundColor: Colors.white,
                label: "Concluídos Abaixo",
                labelStyle: const TextStyle(fontSize: 14),
                onTap: () {
                  // _ordersBloc.setOrderCriteria(SortCriteria.READY_LAST);
                }),
            SpeedDialChild(
                child: const Icon(
                  Icons.arrow_upward,
                  color: Colors.pinkAccent,
                ),
                backgroundColor: Colors.white,
                label: "Concluídos Acima",
                labelStyle: const TextStyle(fontSize: 14),
                onTap: () {
                  // _ordersBloc.setOrderCriteria(SortCriteria.READY_FIRST);
                })
          ],
          child: const Icon(Icons.sort),
        );
      case 2:
        return FloatingActionButton(
          backgroundColor: Colors.pinkAccent,
          onPressed: () {
            // showDialog(context: context,
            //     builder: (context) => EditCategoryDialog()
            // );
          },
          child: const Icon(Icons.add),
        );
    }
    return null;
  }
}

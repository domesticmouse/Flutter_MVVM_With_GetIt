import 'package:flutter/material.dart';
import 'package:flutter_mvvm_with_getit/provider/base_view.dart';
import 'package:flutter_mvvm_with_getit/view/home_screen_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseView<HomeScreenViewModel>(
      builder: (context, model, _) => Scaffold(
        appBar: AppBar(
          title: const Text("Flutter MVVM"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                model.counter.toString(),
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => model.incrementCounter(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

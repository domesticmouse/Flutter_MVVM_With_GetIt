# Architecturing Flutter Application with MVVM using GetIt

# Starting with Basics 🧑‍💻

- ### Flutter: 
Flutter is an open-source framework by Google for building beautiful, natively compiled, multi-platform applications from a single codebase.

#### Features of Flutter:

1. **Fast**: Flutter code compiles to ARM or Intel machine code as well as JavaScript, for fast performance on any device.

2. **Productive**: Build and iterate quickly with Hot Reload. Update code and see changes almost instantly, without losing state.

3. **Flexible**: Build and iterate quickly with Hot Reload. Update code and see changes almost instantly, without losing state.


- ### GetIt:
As your App grows, at some point you will need to put your app's logic in classes that are separated from your Widgets. Keeping your widgets from having direct dependencies makes your code better organized and easier to test and maintain. But now you need a way to access these objects from your UI code.

This is where GetIt comes into play. GetIt is a simple **Service Locator** for Dart and Flutter projects. It can be used instead of **Inherited Widget** or **Provider** to access objects from your UI.

Since it is not a state management solution. It's a locator for your objects, so in some other way you need to notify your UI about changes like **Streams** it **ValueNotifier**.

Many of us get confused about how to use notify UI, and how to integrate it with MVVM Architecture.  This tutorial will help you set up architecture to boilerplate for your big projects.

- ### MVVM - (Model-View-ViewModel)
MVVM is a very popular architectural pattern when it comes to software development, to separate out presentation layers with business logic, and bind them together with ViewModels.

#### Features of MVVM:

1. **Easy to Maintain**: The presentation layer and Business Logic layer are separated, due to which the code is easily maintainable and you can reuse the code or widgets. This may not seem useful for a short project. But you will see its power when creating a big project, where you constantly need to use reuse the code.

2. **Easy to Test**: Since all the function logic is written in a separate file, it is easier to unit test for the functions, than event-driven code.


**I guess that's enough for the basics, lets's see some cool stuff.** 😎


- ### Directory Structure


![structure.png](https://cdn.hashnode.com/res/hashnode/image/upload/v1644992967704/Yt7yzAMKr.png)

Let's go through all the sections one by one-

- **config**: contains the configuration of the app, for a responsive application.
- **constant**: directory to store app constants, such as any common textStyle, flutter_toasts, etc.
- **enum**: directory to store enumeration of app, here it contains only one Enums for now.
```dart 
enum ViewState { Idle, Busy }
```

This Enum identifies when the app is contacting servers or DB, and then it can be helped to show ProgressIndicator on UI, according to ViewState.

- **provider**: This directory contains some important configs regarding the setup of GetIt, registering ViewModel with GetIt, and ValueNotifier for notifying changes to UI.

```dart
GetIt getIt = GetIt.instance;
void setupLocator() {
  getIt.registerLazySingleton(() => NavigationService());
  getIt.registerFactory(() => ApiService());
  getIt.registerFactory(() => HomeScreenViewModel());
}
```

- **services**: If You are using FIrebase for the app, then you can skip this directory, otherwise if you are planning to use your own server, like Express, Django, Flask. This directory will be very useful, as it contains methods for RESTFUL Apis, converting response to easy-to-understand class **ApiResponse**, etc.
You make take a look at it inside it.

- **src**: It will contain all your source files. It is briefly divided into 3 sections:
   1. **models**: To store your business classes.
   2. **screens**: To store all your UI screens.
   3. **widgets**: To store reusable components.

Let's go over the last two files, which will be the entry points of our app.

1. **main.dart**

```dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: getIt<NavigationService>().navigatorKey,
      title: 'Flutter MVVM',
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
```

2. **route_generator.dart**

```dart
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments as dynamic;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }
```


### Kudos to you for a long way down here. Let's run the app ! 🎉

![app.gif](https://cdn.hashnode.com/res/hashnode/image/upload/v1644994637262/PTRS5Pbut.gif)

That looks the same as starting of new flutter project. So what are we doing extra here?

Let's go through the important files, to understand the underlying process.

- **lib/src/screens/home_screen.dart**
This is a presentation layer, i.e. UI Screen, where you do your designing.
Notice we wrapped Scaffold with **BasView Builder** of type HomeScreenModel. This binds our UI, with ViewModel, and notifies UI, when any changes occur.

```dart 
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
```

 - **lib/src/view/home_screen_viewmodel.dart**

This file is our ViewModel Layer, which is bonded by UI. Here we write the logic of our function, and any changes to variables, are notified to UI, and UI rebuilds accordingly.

Notice, we have a variable counter, which is used in home_screen, and a method to increase counter is also used in home_screen.

```dart
import 'package:flutter_mvvm_with_getit/provider/base_model.dart';

class HomeScreenViewModel extends BaseModel {
  int counter = 0;

  void incrementCounter() {
    counter++;
    notifyListeners();
  }
}
```

On this last line, there is a function - **notifyListeners**, this function notifies UI that some variable is changed, and rebuild your UI, according to the changes.

### That's it, folks, for Archutecturing Flutter Application with MVVM Architecture using GetIt.
#### I hope you will be able to learn something new from this tutorial and will create something fantastic with this boilerplate.

I am also attaching Github Repo, which you may fork it, and use as a boilerplate for your application.
This Repo will have all the important folders and files that you will use while creating any large application.


Still Doubt? Let me know in comments section ;)

Github Repo: [Flutter MMVM with GetIt](https://github.com/ViAsmit/Flutter_MVVM_With_GetIt)

Connect with me: [Linkedin](https://www.linkedin.com/in/asmit-vimal-415719199/)
  

// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'other_page.dart';

class CounterState {
  final int counter;
  const CounterState({
    required this.counter,
  });

  factory CounterState.initial() {
    return const CounterState(counter: 0);
  }

  @override
  String toString() => "CounterState(counter: $counter )";

  CounterState copyWith({int? counter}) {
    return CounterState(counter: counter ?? this.counter);
  }
}

class IncrementAction {
  final int payload;
  const IncrementAction({
    required this.payload,
  });
  @override
  String toString() => "IncrementAction(payload: $payload)";
}

class DecrementAction {
  final int payload;
  const DecrementAction({
    required this.payload,
  });
  @override
  String toString() => "DecrementAction(payload: $payload)";
}

CounterState counterReducer(CounterState state, dynamic action) {
  print("called");
  if (action is IncrementAction) {
    return CounterState(counter: state.counter + action.payload);
  } else if (action is DecrementAction) {
    return CounterState(counter: state.counter - action.payload);
  }
  return state;
}

late final Store<CounterState> store;
Future<void> main(List<String> arguments) async {
  store =
      Store<CounterState>(counterReducer, initialState: CounterState.initial());

  final subscription = store.onChange.listen((CounterState state) {
    print('counter state: $state');
  });
  print("getHere1");
  await store.dispatch(const IncrementAction(payload: 2));
  print("getHere2");
  await store.dispatch(const IncrementAction(payload: 3));
  print("getHere3");
  await store.dispatch(const DecrementAction(payload: 10));
  print("getHere4");

  await subscription.cancel();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<CounterState, ViewModel>(
        converter: (Store<CounterState> store) => ViewModel.fromStore(store),
        onInitialBuild: (ViewModel vm) {
          if (vm.counter == 3) {
            showDialog(
                context: context,
                builder: (__) => AlertDialog(
                      content: Text("counter: ${vm.counter}"),
                    ));
          } else if (vm.counter == 5) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const OtherPage(),
              ),
            );
          }
        },
        builder: (context, ViewModel vm) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: const Text("reduxCourse"),
            ),
            body: Center(
              child: Text(
                '${store.state.counter}',
                style:
                    const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
              ),
            ),
            floatingActionButton: Row(
              children: [
                FloatingActionButton(
                  onPressed: () async {
                    vm.incrementCounter(1);
                  },
                  tooltip: 'Increment',
                  child: const Icon(Icons.add),
                ),
                FloatingActionButton(
                  onPressed: () async {
                    vm.decrementCounter(1);
                  },
                  tooltip: 'Decrement',
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          );
        });
  }
}

class ViewModel {
  final int counter;
  final void Function(int payload) incrementCounter;
  final void Function(int payload) decrementCounter;

  ViewModel(
      {required this.counter,
      required this.incrementCounter,
      required this.decrementCounter});

  static fromStore(Store<CounterState> store) {
    return ViewModel(
      counter: store.state.counter,
      incrementCounter: (payload) {
        IncrementAction(payload: payload);
      },
      decrementCounter: (payload) {
        DecrementAction(payload: payload);
      },
    );
  }
}

// class MyHomePage extends StatelessWidget {
//   const MyHomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StoreBuilder(builder: (context, Store<CounterState> store) {
//       return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//           title: const Text("reduxCourse"),
//         ),
//         body: Center(
//           child: Text(
//             '${store.state.counter}',
//             style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
//           ),
//         ),
//         floatingActionButton: Row(
//           children: [
//             FloatingActionButton(
//               onPressed: () async {
//                 await store.dispatch(const IncrementAction(payload: 1));
//               },
//               tooltip: 'Increment',
//               child: const Icon(Icons.add),
//             ),
//             FloatingActionButton(
//               onPressed: () async {
//                 await store.dispatch(const DecrementAction(payload: 1));
//               },
//               tooltip: 'Decrement',
//               child: const Icon(Icons.remove),
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }

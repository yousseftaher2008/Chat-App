// ignore_for_file: deprecated_member_use, unused_field
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'widgets/chart.dart';
import 'widgets/list_transaction.dart';
import 'widgets/new_transaction.dart';
import 'models/transaction.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //   [
  //     DeviceOrientation.portraitDown,
  //     DeviceOrientation.portraitUp,
  //   ],
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          fontFamily: "OpenSans",
          textTheme: ThemeData.light().textTheme.copyWith(
                button: const TextStyle(color: Colors.white),
              )),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [];
  bool _switch = true;
  void _addTx(String inputTitle, double inputAmount, DateTime inputDate) {
    final Transaction newTx = Transaction(
      "t${(_transactions.length) + 1}",
      inputTitle,
      inputAmount,
      inputDate,
    );
    setState(() {
      _transactions.add(newTx);
    });
  }

  void _removeTx(index) {
    setState(() {
      _transactions.removeAt(index);
    });
  }

  List<Transaction> get _recentTx {
    return _transactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _startAddTx(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: NewTransaction(_addTx));
      },
    );
  }

  List<Widget> _landScape(
    MediaQueryData mediaQuery,
    AppBar appBar,
    ObstructingPreferredSizeWidget appBar1,
    Widget txList,
  ) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Show Chart",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          Switch.adaptive(
            value: _switch,
            
            onChanged: (value) {
              setState(() {
                _switch = value;
              });
            },
          ),
        ],
      ),
      _switch
          ? SizedBox(
              height: (mediaQuery.size.height -
                      (Platform.isIOS
                          ? appBar1.preferredSize.height
                          : appBar.preferredSize.height) -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(_recentTx),
            )
          : txList,
    ];
  }

  List<Widget> _portraitContent(
    MediaQueryData mediaQuery,
    AppBar appBar,
    ObstructingPreferredSizeWidget appBar1,
    Widget txList,
  ) {
    return [
      SizedBox(
        height: (mediaQuery.size.height -
                (Platform.isIOS
                    ? appBar1.preferredSize.height
                    : appBar.preferredSize.height) -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(_recentTx),
      ),
      txList,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final landScape = mediaQuery.orientation == Orientation.landscape;
    final ObstructingPreferredSizeWidget appBar1 = CupertinoNavigationBar(
      trailing: Row(
        children: [
          GestureDetector(
            onTap: () => _startAddTx(context),
            child: const Icon(Icons.add),
          ),
        ],
      ),
      middle: const Text("My Home Page"),
    );
    final appBar = AppBar(
      title: const Text("My Home Page"),
      actions: [
        IconButton(
            onPressed: () => _startAddTx(context), icon: const Icon(Icons.add))
      ],
    );
    final txList = SizedBox(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: ListTransaction(_transactions, _removeTx),
    );
    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (landScape)
              ..._landScape(
                mediaQuery,
                appBar,
                appBar1,
                txList,
              ),
            if (!landScape)
              ..._portraitContent(
                mediaQuery,
                appBar,
                appBar1,
                txList,
              )
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar1,
            child: pageBody,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => _startAddTx(context),
                    child: const Icon(Icons.add),
                  ), // This trailing comma makes auto-formatting nicer for build methods.
          );
  }
}

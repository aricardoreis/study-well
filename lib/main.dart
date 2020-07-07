import 'package:flutter_cubit/flutter_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:study_well/pages/matter_dialog.dart';
import 'package:study_well/pages/timer_dialog.dart';
import 'package:study_well/service_locator.dart';
import 'package:study_well/services/matter_service.dart';
import 'package:study_well/util/themes.dart';
import 'package:study_well/viewmodels/matter/matter_cubit.dart';

import 'pages/matter_page.dart';
import 'viewmodels/timer/timer_cubit.dart';
import 'package:study_well/util/timer_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupServiceLocator();

  // await clearData();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

Future clearData() async {
  sl<TimerService>().clear();
  var list = await sl<MatterService>().getAll();
  list.forEach((element) async {
    sl<MatterService>().delete(element.id);
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = ThoriumTheme();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // primarySwatch: Colors.purple,
        dialogBackgroundColor: theme.successDark,
        primaryColor: theme.backgroundDark,
        accentColor: theme.backgroundDark,
        backgroundColor: theme.background,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'NunitoSans',
        brightness: Brightness.dark,
      ),
      //home: MyHomePage(title: 'Study Well'),
      home: CubitProvider(
        create: (_) => sl<MatterCubit>(),
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              CubitBuilder<TimerCubit, TimerState>(
                cubit: sl<TimerCubit>(),
                builder: (context, state) {
                  if (state is Running) {
                    return Row(
                      children: <Widget>[
                        Center(
                          child: Text(state.fullTimerFormat),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.stop,
                            color: Colors.red,
                          ),
                          onPressed: () => sl<TimerCubit>().stop(),
                        )
                      ],
                    );
                  } else {
                    return IconButton(
                      icon: Icon(Icons.play_arrow),
                      onPressed: () => _showPlayTimerActionView(),
                    );
                  }
                },
              ),
            ],
            bottom: TabBar(
              onTap: (index) {
                setState(() {
                  _tabIndex = index;
                });
              },
              tabs: [
                Tab(icon: Icon(Icons.library_books)),
                Tab(icon: Icon(Icons.directions_bus)),
                Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
            title: Text('Study Well'),
          ),
          body: TabBarView(
            children: [
              MatterPage(),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      ),
      floatingActionButton: CubitBuilder<TimerCubit, TimerState>(
        cubit: sl<TimerCubit>(),
        builder: (context, state) => _buildFab(state),
      ),
    );
  }

  FloatingActionButton _buildFab(TimerState state) {
    String text;
    Icon icon = Icon(Icons.add);
    Function onPressed = () {};

    switch (_tabIndex) {
      case 0:
        text = 'Adicionar matéria';
        onPressed = () => _showMatterActionView();
        break;
      case 1:
        text = 'Adicionar estudo';
        if (state is Running) {
          icon = Icon(Icons.stop);
          onPressed = () => sl<TimerCubit>().stop();
        } else {
          icon = Icon(Icons.play_arrow);
          onPressed = () => _showPlayTimerActionView();
        }
        break;
      case 2:
        text = 'Adicionar tipo';
        break;
    }

    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: text,
      child: icon,
    );
  }

  void _showMatterActionView() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MatterDialog();
      },
    ).then((value) async {
      if (value) {
        await sl<MatterCubit>().loadList();
      }
    });
  }

  void _showPlayTimerActionView() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TimerDialog();
      },
    ).then((value) async {
      if (!(value != null && value)) {
        sl<TimerCubit>().stop();
      }
    });
  }
}

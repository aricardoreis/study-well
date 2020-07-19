import 'package:flutter_cubit/flutter_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_cubit/hydrated_cubit.dart';
import 'package:study_well/pages/study_record_dialog.dart';
import 'package:study_well/pages/study_record_page.dart';
import 'package:study_well/pages/subject_dialog.dart';
import 'package:study_well/pages/timer_dialog.dart';
import 'package:study_well/service_locator.dart';
import 'package:study_well/services/subject_service.dart';
import 'package:study_well/util/themes.dart';
import 'package:study_well/viewmodels/subject/subject_cubit.dart';

import 'pages/subject_page.dart';
import 'viewmodels/timer/timer_cubit.dart';
import 'viewmodels/timer/timer_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedCubit.storage = await HydratedStorage.build();

  await setupServiceLocator();

  // await clearData();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) async {
    runApp(MyApp());
  });
}

Future clearData() async {
  var list = await sl<SubjectService>().getAll();
  list.forEach((element) async {
    sl<SubjectService>().delete(element.id);
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
      home: CubitProvider(
        create: (_) => sl<SubjectCubit>(),
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

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _tabIndex = 0;

  @override
  void initState() {
    _tabController =
        new TabController(length: 3, vsync: this, initialIndex: _tabIndex);

    _tabController.addListener(() {
      setState(() {
        _tabIndex = _tabController.index;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        initialIndex: _tabIndex,
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              CubitListener<TimerCubit, TimerState>(
                cubit: sl<TimerCubit>(),
                listenWhen: (previous, current) =>
                    current is Finished && current.info.subjectId != null,
                listener: (context, state) {
                  _showTimerResumeDialog(state as Finished);
                },
                child: CubitBuilder<TimerCubit, TimerState>(
                  cubit: sl<TimerCubit>(),
                  builder: (context, state) {
                    if (state is Running || state is Paused) {
                      var currentState = state as Working;
                      return Row(
                        children: <Widget>[
                          Center(
                            child: Text(currentState.fullTimerFormat),
                          ),
                          state is Running
                              ? IconButton(
                                  tooltip: 'Pausar',
                                  icon: Icon(
                                    Icons.pause,
                                    color: Colors.yellow,
                                  ),
                                  onPressed: () => sl<TimerCubit>().pause(),
                                )
                              : Row(
                                  children: <Widget>[
                                    IconButton(
                                      constraints: BoxConstraints.tight(
                                          Size.fromWidth(30)),
                                      tooltip: 'Continuar',
                                      icon: Icon(
                                        Icons.play_arrow,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () =>
                                          sl<TimerCubit>().resume(),
                                    ),
                                    IconButton(
                                      tooltip: 'Parar',
                                      icon: Icon(
                                        Icons.stop,
                                        color: Colors.red,
                                      ),
                                      onPressed: () => sl<TimerCubit>().stop(),
                                    )
                                  ],
                                )
                        ],
                      );
                    } else {
                      return IconButton(
                        tooltip: 'Iniciar',
                        icon: Icon(Icons.play_arrow),
                        onPressed: () => _showPlayTimerActionView(),
                      );
                    }
                  },
                ),
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(icon: Icon(Icons.library_books)),
                Tab(icon: Icon(Icons.timer)),
                Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
            title: Text('Study Well'),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              SubjectPage(),
              StudyRecordPage(),
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

  Widget _buildFab(TimerState state) {
    String text;
    Icon icon = Icon(Icons.add);
    Function onPressed = () {};

    switch (_tabIndex) {
      case 0:
        text = 'Adicionar matéria';
        onPressed = () => _showSubjectActionView();
        break;
      case 1:
        return Container();
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

  void _showSubjectActionView() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SubjectDialog();
      },
    ).then((value) async {
      if (value) {
        await sl<SubjectCubit>().loadList();
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

  void _showTimerResumeDialog(Finished state) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StudyRecordDialog(
          subject: state.info.subjectId,
          duration: state.info.duration,
        );
      },
    ).then((value) async {
      // TODO: Update items
    });
  }
}

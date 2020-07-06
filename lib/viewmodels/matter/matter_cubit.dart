import 'package:cubit/cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:study_well/models/matter_model.dart';
import 'package:study_well/services/matter_service.dart';

class MatterCubit extends Cubit<MatterState> {
  final MatterService service;

  MatterCubit({@required this.service}) : super(MatterInitialState()) {
    _getMatterList();
  }

  Future<void> loadList() async {
    await _getMatterList();
  }

  Future<void> add(String name) async {
    await service.insert(name);
  }

  Future<void> _getMatterList() async {
    try {
      emit(MatterLoadingState());
      final items = await service.getAll();
      emit(MatterLoadedState(items));
    } catch (e) {
      emit(MatterErrorState(e.toString()));
    }
  }

  @override
  void onTransition(Transition<MatterState> transition) {
    print(transition);
    super.onTransition(transition);
  }
}

@immutable
abstract class MatterState extends Equatable {}

class MatterInitialState extends MatterState {
  @override
  List<Object> get props => [];
}

class MatterLoadingState extends MatterState {
  @override
  List<Object> get props => [];
}

class MatterLoadedState extends MatterState {
  MatterLoadedState(this.list);

  final List<MatterModel> list;

  @override
  List<Object> get props => [list];
}

class MatterErrorState extends MatterState {
  final String message;

  MatterErrorState(this.message);

  @override
  List<Object> get props => [];
}

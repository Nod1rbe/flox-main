import 'package:equatable/equatable.dart';
import 'package:flox/core/enums/submission_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'core_state.dart';

@lazySingleton
class CoreCubit extends Cubit<CoreState> {
  CoreCubit() : super(const CoreState());
}

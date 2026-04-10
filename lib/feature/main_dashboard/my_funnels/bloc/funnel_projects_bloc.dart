import 'package:equatable/equatable.dart';
import 'package:flox/core/enums/submission_status.dart';
import 'package:flox/feature/main_dashboard/my_funnels/data/models/funnel_projects_model.dart';
import 'package:flox/feature/main_dashboard/my_funnels/data/repository/funnels_projects_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'funnel_projects_event.dart';
part 'funnel_projects_state.dart';

@injectable
class FunnelProjectsBloc extends Bloc<FunnelProjectsEvent, FunnelProjectsState> {
  final FunnelsProjectsRepository _projectsRepository;
  FunnelProjectsBloc(this._projectsRepository) : super(const FunnelProjectsState()) {
    on<GetFunnelsEvent>((event, emit) async {
      emit(state.copyWith(getStatus: SubmissionStatus.loading));
      final result = await _projectsRepository.getFunnels();
      result.fold(
        (l) {
          emit(state.copyWith(
            getStatus: SubmissionStatus.failure,
            getErrorMessage: l,
          ));
        },
        (r) {
          emit(state.copyWith(
            getStatus: SubmissionStatus.success,
            funnels: r,
          ));
        },
      );
    });

    on<CreateFunnelEvent>((event, emit) async {
      emit(state.copyWith(createStatus: SubmissionStatus.loading));
      final result = await _projectsRepository.createFunnel(
        name: event.name,
        description: event.description,
      );
      result.fold(
        (l) {
          emit(state.copyWith(
            createStatus: SubmissionStatus.failure,
            createErrorMessage: l,
          ));
        },
        (r) {
          List<FunnelProjectsModel> updatedFunnels = [...state.funnels];
          updatedFunnels.add(r);
          emit(state.copyWith(
            createStatus: SubmissionStatus.success,
            funnels: updatedFunnels,
          ));
        },
      );
    });

    on<UpdateFunnelEvent>((event, emit) async {
      emit(state.copyWith(updateStatus: SubmissionStatus.loading));
      List<FunnelProjectsModel> copiedFunnels = [...state.funnels];

      final response = await _projectsRepository.updateFunnel(
        id: event.id,
        name: event.name,
        description: event.description,
        pageCount: event.pageCount,
      );

      response.fold(
        (l) {
          emit(state.copyWith(
            updateStatus: SubmissionStatus.failure,
            updateErrorMessage: l,
          ));
        },
        (r) {
          final index = copiedFunnels.indexWhere((funnel) => funnel.id == event.id);
          copiedFunnels[index] = copiedFunnels[index].copyWith(
            name: event.name,
            description: event.description,
            pageCount: event.pageCount,
          );
          emit(state.copyWith(
            updateStatus: SubmissionStatus.success,
            funnels: copiedFunnels,
          ));
        },
      );
    });

    on<DeleteFunnelEvent>((event, emit) async {
      emit(state.copyWith(deleteStatus: SubmissionStatus.loading));
      List<FunnelProjectsModel> copiedFunnels = [...state.funnels];
      final response = await _projectsRepository.deleteFunnel(id: event.id);
      response.fold(
        (l) {
          emit(state.copyWith(
            deleteStatus: SubmissionStatus.failure,
            deleteErrorMessage: l,
          ));
        },
        (r) {
          copiedFunnels.removeWhere((funnel) => funnel.id == event.id);
          emit(state.copyWith(
            deleteStatus: SubmissionStatus.success,
            funnels: copiedFunnels,
          ));
        },
      );
    });
  }
}

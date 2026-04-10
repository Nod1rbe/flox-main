import 'package:equatable/equatable.dart';
import 'package:flox/core/enums/submission_status.dart';
import 'package:flox/feature/builder/repositories/builder_repository.dart';
import 'package:flox/feature/builder/ui/model/page_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'builder_manager_state.dart';

@injectable
class BuilderManagerCubit extends Cubit<BuilderManagerState> {
  final BuilderRepository _builderRepository;

  BuilderManagerCubit(this._builderRepository) : super(BuilderManagerState());

  publishFunnel({required List<PageData> pages, required String funnelId, bool isLink = false}) async {
    if (isLink) {
      emit(state.copyWith(showLinksStatus: SubmissionStatus.loading, errorMessage: ''));
    } else {
      emit(state.copyWith(saveStatus: SubmissionStatus.loading, errorMessage: ''));
    }

    final response = await _builderRepository.uploadFunnel(pages: pages, funnelId: funnelId);

    response.fold(
      (l) {
        if (isLink) {
          emit(state.copyWith(showLinksStatus: SubmissionStatus.failure, errorMessage: l));
        } else {
          emit(state.copyWith(saveStatus: SubmissionStatus.failure, errorMessage: l));
        }
      },
      (r) {
        if (isLink) {
          emit(state.copyWith(showLinksStatus: SubmissionStatus.success, launcherLinks: r));
        } else {
          emit(state.copyWith(saveStatus: SubmissionStatus.success));
        }
      },
    );
  }

  autoSaveFunnel({required List<PageData> pages, required String funnelId}) async {
    await _builderRepository.uploadFunnel(pages: pages, funnelId: funnelId);
  }

  getFunnelProject({required String funnelId}) async {
    emit(state.copyWith(getProjectStatus: SubmissionStatus.loading, errorMessage: ''));
    final response = await _builderRepository.getFunnel(funnelId: funnelId);
    response.fold(
      (l) => emit(state.copyWith(getProjectStatus: SubmissionStatus.failure, errorMessage: l)),
      (r) => emit(state.copyWith(getProjectStatus: SubmissionStatus.success, pages: r)),
    );
  }
}

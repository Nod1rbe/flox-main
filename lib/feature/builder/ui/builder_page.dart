import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/core/di/injection.dart';
import 'package:flox/feature/builder/blocs/builder_bloc/builder_cubit.dart';
import 'package:flox/feature/builder/blocs/builder_manager_bloc/builder_manager_cubit.dart';
import 'package:flox/feature/builder/ui/layouts/configs_layout.dart';
import 'package:flox/feature/builder/ui/layouts/elements_layout.dart';
import 'package:flox/feature/builder/ui/layouts/header_layout.dart';
import 'package:flox/feature/builder/ui/layouts/pages_layout.dart';
import 'package:flox/feature/builder/ui/layouts/phone_layout.dart';
import 'package:flox/feature/builder/ui/model/page_data.dart';
import 'package:flox/templates/template1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class BuilderPage extends StatefulWidget {
  final String? funnelId;
  final bool? isEditing;
  final String? funnelName;

  const BuilderPage({
    super.key,
    @QueryParam('fid') required this.funnelId,
    @QueryParam('editing') required this.isEditing,
    @QueryParam('name') required this.funnelName,
  });

  @override
  State<BuilderPage> createState() => _BuilderPageState();
}

class _BuilderPageState extends State<BuilderPage> {
  late final BuilderManagerCubit _builderManagerCubit;
  late final BuilderCubit _builderCubit;
  Timer? _autoSaveTimer;

  @override
  void initState() {
    _builderManagerCubit = getIt<BuilderManagerCubit>();
    _builderCubit = BuilderCubit();
    _getInitialFunnel();
    _autoSaveTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _builderManagerCubit.autoSaveFunnel(pages: _builderCubit.state.pages, funnelId: widget.funnelId ?? '');
    });
    super.initState();
  }

  void _getInitialFunnel() async {
    if (widget.funnelId != null && widget.isEditing == true) {
      await _builderManagerCubit.getFunnelProject(funnelId: widget.funnelId!);
      _builderCubit.setInitialFunnel(pages: _builderManagerCubit.state.pages);
    } else if (widget.isEditing == false) {
      _builderCubit.setInitialFunnel(pages: template1, isEditing: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.funnelId == null || widget.isEditing == null || widget.funnelName == null) {
      return const Center(child: Text('Missing required parameters'));
    }
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _builderManagerCubit),
        BlocProvider.value(value: _builderCubit),
      ],
      child: Scaffold(
        backgroundColor: AppColors.pageBackground,
        body: Column(
          children: [
            HeaderLayout(funnelId: widget.funnelId ?? '', funnelName: widget.funnelName ?? ''),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<BuilderCubit, BuilderState>(
                    builder: (context, state) {
                      return PagesLayout(
                        selectedPage: state.selectedPage.pageOrder,
                        pageCount: state.pages.length,
                        onAddPage: () => context.read<BuilderCubit>().addPage(PageData.sample(state.pages.length)),
                        onSelectPage: context.read<BuilderCubit>().pageSelected,
                      );
                    },
                  ),
                  ElementsLayout(),
                  BlocBuilder<BuilderManagerCubit, BuilderManagerState>(builder: (context, state) {
                    return Expanded(child: PhoneScreenLayout(loading: state.getProjectStatus.isLoading));
                  }),
                  ConfigsLayout(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    template1.clear();
    template1.add(PageData.sample(0));
    _builderCubit.state.viewCubits?.forEach((cubit) => cubit.close());
    _builderCubit.close();
    _builderManagerCubit.close();
    _autoSaveTimer?.cancel();
    super.dispose();
  }
}

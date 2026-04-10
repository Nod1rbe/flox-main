import 'package:auto_route/auto_route.dart';
import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/core/di/injection.dart';
import 'package:flox/core/enums/ui_enums/flushbar_type.dart';
import 'package:flox/core/extensions/build_context_extensions.dart';
import 'package:flox/core/gen/assets.gen.dart';
import 'package:flox/core/routes/app_router.gr.dart';
import 'package:flox/feature/main_dashboard/my_funnels/bloc/funnel_projects_bloc.dart';
import 'package:flox/feature/main_dashboard/my_funnels/data/models/funnel_projects_model.dart';
import 'package:flox/feature/main_dashboard/my_funnels/ui/widgets/add_funnel_button.dart';
import 'package:flox/feature/main_dashboard/my_funnels/ui/widgets/my_funnel_item.dart';
import 'package:flox/ui_components/components/tappable_component.dart';
import 'package:flox/ui_components/elements/shimmer_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class MyFunnelsPage extends StatefulWidget {
  const MyFunnelsPage({super.key});

  @override
  State<MyFunnelsPage> createState() => _MyFunnelsPageState();
}

class _MyFunnelsPageState extends State<MyFunnelsPage> {
  late final FunnelProjectsBloc _funnelProjectsBloc;

  @override
  void initState() {
    _funnelProjectsBloc = getIt<FunnelProjectsBloc>()..add(GetFunnelsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _funnelProjectsBloc,
      child: Scaffold(
        backgroundColor: AppColors.pageBackground,
        body: Padding(
          padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => context.showFlushbar(
                      message: 'This message is being showed for testing purposes',
                      type: FlushbarType.success,
                    ),
                    child: Text(
                      'Funnels',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.white),
                    ),
                  ),
                  TappableComponent(
                    onTap: () => _funnelProjectsBloc.add(GetFunnelsEvent()),
                    borderRadius: 6,
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Assets.icons.refresh.svg(
                          colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 950, minWidth: 800),
                    child: BlocConsumer<FunnelProjectsBloc, FunnelProjectsState>(
                      listenWhen: (o, n) => o.getStatus != n.getStatus,
                      listener: (context, state) {
                        if (state.getStatus.isFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.getErrorMessage)),
                          );
                        }
                      },
                      builder: (context, state) {
                        return ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                          child: GridView.builder(
                            clipBehavior: Clip.none,
                            physics: const ClampingScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 24),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: _crossAxisCount,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              mainAxisExtent: 160,
                            ),
                            itemCount: state.getStatus.isLoading ? 4 : state.funnels.length + 1,
                            itemBuilder: (context, index) {
                              if (index == 0) return AddFunnelButton();

                              final isLoading = state.getStatus.isLoading;
                              final funnel = isLoading ? const FunnelProjectsModel() : state.funnels[index - 1];

                              return ShimmerElement(
                                isLoading: isLoading,
                                width: double.infinity,
                                height: 150,
                                radius: 10,
                                child: MyFunnelItem(
                                  funnel: funnel,
                                  onTap: () async {
                                    if (!isLoading && funnel.id != null && funnel.id!.isNotEmpty) {
                                      await context.router.push(
                                        BuilderRoute(
                                          funnelId: funnel.id ?? '',
                                          isEditing: funnel.pageIds.isNotEmpty,
                                          funnelName: funnel.name ?? '',
                                        ),
                                      );
                                      await Future.delayed(Duration(milliseconds: 280));
                                      _funnelProjectsBloc.add(GetFunnelsEvent());
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Invalid funnel ID')),
                                      );
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int get _crossAxisCount {
    if (context.width < 750) return 1;
    if (context.width < 1035) return 2;
    return 3;
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/core/di/injection.dart';
import 'package:flox/core/extensions/build_context_extensions.dart';
import 'package:flox/core/gen/assets.gen.dart';
import 'package:flox/core/routes/app_router.gr.dart';
import 'package:flox/feature/main_dashboard/my_funnels/bloc/funnel_projects_bloc.dart';
import 'package:flox/feature/main_dashboard/my_funnels/data/models/funnel_projects_model.dart';
import 'package:flox/feature/hackathon_ai/ui/hackathon_ai_chat_dialog.dart';
import 'package:flox/feature/main_dashboard/my_funnels/ui/widgets/add_funnel_button.dart';
import 'package:flox/feature/main_dashboard/my_funnels/ui/widgets/my_funnel_item.dart';
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
          padding: const EdgeInsets.fromLTRB(28, 18, 28, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Funnel\'lar',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tahrirlash, havolalar va chop etish',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: AppColors.subtitle,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: BorderSide(color: AppColors.primary.withValues(alpha: 0.55)),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => HackathonAiChatDialog.show(context),
                        icon: Icon(Icons.auto_awesome_rounded, size: 18, color: AppColors.primary),
                        label: Text(
                          'AI (local)',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Material(
                        color: AppColors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () => _funnelProjectsBloc.add(GetFunnelsEvent()),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Assets.icons.refresh.svg(
                              width: 20,
                              height: 20,
                              colorFilter: ColorFilter.mode(AppColors.white.withValues(alpha: 0.9), BlendMode.srcIn),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 26),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1040),
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
                            padding: const EdgeInsets.only(bottom: 28),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: _crossAxisCount,
                              mainAxisSpacing: 18,
                              crossAxisSpacing: 18,
                              mainAxisExtent: 168,
                            ),
                            itemCount: state.getStatus.isLoading ? 4 : state.funnels.length + 1,
                            itemBuilder: (context, index) {
                              if (index == 0) return AddFunnelButton();

                              final isLoading = state.getStatus.isLoading;
                              final funnel = isLoading ? const FunnelProjectsModel() : state.funnels[index - 1];

                              return ShimmerElement(
                                isLoading: isLoading,
                                width: double.infinity,
                                height: 156,
                                radius: 14,
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

import 'package:auto_route/auto_route.dart';
import 'package:flox/feature/builder/blocs/builder_bloc/builder_cubit.dart';
import 'package:flox/feature/builder/ui/builder_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ExperienceSPage extends StatefulWidget {
  const ExperienceSPage({super.key});

  @override
  State<ExperienceSPage> createState() => _ExperienceSPageState();
}

class _ExperienceSPageState extends State<ExperienceSPage> {
  late BuilderCubit builderCubit = context.read<BuilderCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BuilderCubit(),
      child: BuilderPage(
        funnelId: '',
        isEditing: false,
        funnelName: 'Funnel Name',
      ),
    );
  }
}

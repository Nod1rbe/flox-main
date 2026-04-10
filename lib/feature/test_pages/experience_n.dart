import 'package:auto_route/auto_route.dart';
import 'package:flox/feature/builder/blocs/builder_bloc/builder_cubit.dart';
import 'package:flox/feature/builder/ui/builder_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ExperienceNPage extends StatefulWidget {
  const ExperienceNPage({super.key});

  @override
  State<ExperienceNPage> createState() => _ExperienceNPageState();
}

class _ExperienceNPageState extends State<ExperienceNPage> {
  final List<String> items = ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5'];
  final String initialValue = 'Item 1';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BuilderCubit(),
      child: BuilderPage(
        funnelId: 'funnelId',
        isEditing: false,
        funnelName: 'Funnel Name',
      ),
    );
  }
}

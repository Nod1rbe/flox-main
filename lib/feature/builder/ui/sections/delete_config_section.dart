import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/feature/builder/blocs/builder_bloc/builder_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteConfigSection extends StatelessWidget {
  const DeleteConfigSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        context.read<BuilderCubit>().removeActiveConfig();
      },
      child: Container(
        margin: const EdgeInsets.all(24),
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: Text(
          'Delete Config',
          style: TextStyle(color: AppColors.softError, fontSize: 18, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

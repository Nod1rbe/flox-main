import 'package:auto_route/auto_route.dart';
import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/core/gen/assets.gen.dart';
import 'package:flox/core/utils/text_field_validators.dart';
import 'package:flox/feature/main_dashboard/my_funnels/bloc/funnel_projects_bloc.dart';
import 'package:flox/feature/main_dashboard/my_funnels/ui/widgets/delete_confirmation_dialog.dart';
import 'package:flox/ui_components/components/atoms/button_atom.dart';
import 'package:flox/ui_components/components/atoms/text_field_atom.dart';
import 'package:flox/ui_components/components/base_container_component.dart';
import 'package:flox/ui_components/components/tappable_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageFunnelDialog extends StatefulWidget {
  final String? name;
  final String? description;
  final String? id;

  const ManageFunnelDialog({
    super.key,
    this.name,
    this.description,
    this.id,
  });

  @override
  State<ManageFunnelDialog> createState() => _ManageFunnelDialogState();
}

class _ManageFunnelDialogState extends State<ManageFunnelDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    if (widget.name != null && widget.id != null) {
      _isEditing = true;
      _nameController.text = widget.name!;
      _descriptionController.text = widget.description ?? '';
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 430,
          maxHeight: 470,
        ),
        child: BaseContainerComponent(
          padding: EdgeInsets.zero,
          borderRadius: 16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 36),
                    Text(
                      _isEditing ? 'Edit Funnel' : 'Create New Funnel',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      width: 36,
                      height: 36,
                      child: _isEditing
                          ? TappableComponent(
                              onTap: () async {
                                await showDialog(
                                  context: context,
                                  useRootNavigator: true,
                                  builder: (_) {
                                    return BlocProvider.value(
                                      value: context.read<FunnelProjectsBloc>(),
                                      child: DeleteConfirmationDialog(
                                        funnelId: widget.id!,
                                      ),
                                    );
                                  },
                                ).then((value) {
                                  if (value is bool && value) {
                                    context.router.maybePop();
                                  }
                                });
                              },
                              borderRadius: 6,
                              hoverColor: AppColors.softError.withValues(alpha: 0.2),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Assets.icons.trash.svg(
                                  colorFilter: ColorFilter.mode(
                                    AppColors.softError,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            )
                          : null,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 8),
                        TextFieldAtom(
                          outerPadding: const EdgeInsets.symmetric(horizontal: 20),
                          controller: _nameController,
                          headerText: 'Funnel Name *',
                          hintText: 'Enter a name for your funnel',
                          validator: (value) {
                            return TextFieldValidators.funnelName(value);
                          },
                        ),
                        const SizedBox(height: 24),
                        TextFieldAtom(
                          outerPadding: const EdgeInsets.symmetric(horizontal: 20),
                          controller: _descriptionController,
                          headerText: 'Description (Optional)',
                          hintText: 'Briefly describe this funnel\'s purpose',
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          maxLines: 3,
                          maxLength: 100,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 32,
                      child: TappableComponent(
                        onTap: () => context.router.maybePop(),
                        hoverColor: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: 8,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    BlocConsumer<FunnelProjectsBloc, FunnelProjectsState>(
                      listenWhen: (previous, current) => _isEditing
                          ? previous.updateStatus != current.updateStatus
                          : previous.createStatus != current.createStatus,
                      buildWhen: (previous, current) => _isEditing
                          ? previous.updateStatus != current.updateStatus
                          : previous.createStatus != current.createStatus,
                      listener: (context, state) {
                        final status = _isEditing ? state.updateStatus : state.createStatus;
                        if (status.isSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(_isEditing ? 'Funnel updated' : 'Funnel created'),
                            ),
                          );
                          context.router.maybePop();
                        } else if (status.isFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(_isEditing ? 'Update failed' : 'Creation failed'),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        return ButtonAtom(
                          height: 32,
                          width: 130,
                          borderRadius: 8,
                          padding: EdgeInsets.zero,
                          color: AppColors.primary,
                          loading: _isEditing ? state.updateStatus.isLoading : state.createStatus.isLoading,
                          onTap: () {
                            if (!_formKey.currentState!.validate()) return;
                            final bloc = context.read<FunnelProjectsBloc>();
                            if (_isEditing) {
                              bloc.add(UpdateFunnelEvent(
                                name: _nameController.text.trim(),
                                description: _descriptionController.text.trim(),
                                id: widget.id!,
                              ));
                            } else {
                              bloc.add(CreateFunnelEvent(
                                name: _nameController.text.trim(),
                                description: _descriptionController.text.trim(),
                              ));
                            }
                          },
                          child: Center(
                            child: Text(
                              _isEditing ? 'Update Funnel' : 'Create Funnel',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.white),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

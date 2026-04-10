import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flox/core/extensions/logger.dart';
import 'package:flox/feature/builder/configs/base_config.dart';
import 'package:flox/feature/builder/configs/button_config/button_config.dart';
import 'package:flox/feature/builder/configs/button_config/cubit/button_view_cubit.dart';
import 'package:flox/feature/builder/configs/button_config/model/button_model.dart';
import 'package:flox/feature/builder/configs/image_config/cubit/image_view_cubit.dart';
import 'package:flox/feature/builder/configs/image_config/image_config.dart';
import 'package:flox/feature/builder/configs/image_config/model/image_model.dart';
import 'package:flox/feature/builder/configs/multiple_choice_config/cubit/multiple_choice_view_cubit.dart';
import 'package:flox/feature/builder/configs/multiple_choice_config/model/multiple_choice_model.dart';
import 'package:flox/feature/builder/configs/multiple_choice_config/multiple_choice_config.dart';
import 'package:flox/feature/builder/configs/page_settings_config/page_settings_config.dart';
import 'package:flox/feature/builder/configs/payment_config/cubit/payment_view_cubit.dart';
import 'package:flox/feature/builder/configs/payment_config/model/payment_model.dart';
import 'package:flox/feature/builder/configs/payment_config/payment_config.dart';
import 'package:flox/feature/builder/configs/progress_config/cubit/progress_view_cubit.dart';
import 'package:flox/feature/builder/configs/progress_config/model/progress_model.dart';
import 'package:flox/feature/builder/configs/progress_config/progress_config.dart';
import 'package:flox/feature/builder/configs/text_config/cubit/text_view_cubit.dart';
import 'package:flox/feature/builder/configs/text_config/model/text_model.dart';
import 'package:flox/feature/builder/configs/text_config/text_config.dart';
import 'package:flox/feature/builder/configs/text_field_config/cubit/text_field_view_cubit.dart';
import 'package:flox/feature/builder/configs/text_field_config/model/text_field_model.dart';
import 'package:flox/feature/builder/configs/text_field_config/text_field_config.dart';
import 'package:flox/feature/builder/ui/model/page_data.dart';
import 'package:flox/templates/template1.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'builder_state.dart';

class BuilderCubit extends Cubit<BuilderState> {
  BuilderCubit() : super(BuilderState.initial());

  void pageSelected(int order) {
    if (order >= state.pages.length || order < 0) return;
    var selectedPage = state.pages[order];
    List<Cubit> cubits = [];
    for (var i = 0; i < selectedPage.configs.length; i++) {
      cubits.add(getCubits(selectedPage.configs[i]));
    }
    emit(state.copyWith(
      selectedPage: selectedPage,
      viewCubits: cubits,
      navButtonCubit: ButtonViewCubit(selectedPage.navButton),
      selectedWidgetConfig: null,
      selectedWidgetConfigIndex: -1,
    ));
  }

  void addPage(PageData newPageData) {
    final updatedPages = List<PageData>.from(state.pages)..add(newPageData);

    List<Cubit> newPageCubits = [];
    for (var config in newPageData.configs) {
      newPageCubits.add(getCubits(config));
    }
    log(newPageData.toString());
    emit(state.copyWith(
      pages: updatedPages,
      selectedPage: newPageData,
      viewCubits: newPageCubits,
      navButtonCubit: ButtonViewCubit(newPageData.navButton),
      selectedWidgetConfigIndex: -1,
      didPagesChange: true,
    ));
  }

  void removePage(int pageIndex) {
    final pages = List<PageData>.from(state.pages)..removeAt(pageIndex);

    for (int i = 0; i < pages.length; i++) {
      pages[i] = pages[i].copyWith(pageOrder: i);
    }

    final isRemovedSelected = state.selectedPage.pageOrder == pageIndex;
    final selectedPage = isRemovedSelected ? (pages.isNotEmpty ? pages[0] : null) : state.selectedPage;
    final viewCubits = isRemovedSelected && selectedPage != null ? selectedPage.configs.map(getCubits).toList() : null;
    final navButtonCubit = isRemovedSelected && selectedPage != null ? ButtonViewCubit(selectedPage.navButton) : null;
    final selectedWidgetConfig = isRemovedSelected ? null : state.selectedWidgetConfig;
    final selectedWidgetConfigIndex = isRemovedSelected ? -1 : state.selectedWidgetConfigIndex;

    emit(state.copyWith(
      pages: pages,
      selectedPage: selectedPage,
      viewCubits: viewCubits,
      navButtonCubit: navButtonCubit,
      selectedWidgetConfig: selectedWidgetConfig,
      selectedWidgetConfigIndex: selectedWidgetConfigIndex,
      didPagesChange: true,
    ));
  }

  void removeActiveConfig() {
    var currentPage = state.selectedPage;
    if (state.selectedWidgetConfigIndex != null) {
      currentPage.configs.removeAt(state.selectedWidgetConfigIndex!);
      state.viewCubits?.removeAt(state.selectedWidgetConfigIndex!);
    }
    var pages = state.pages..removeAt(state.selectedPage.pageOrder);
    pages.insert(state.selectedPage.pageOrder, currentPage);
    emit(state.copyWith(
      pages: pages,
      selectedPage: pages[state.selectedPage.pageOrder],
      selectedWidgetConfigIndex: -1,
      viewCubits: state.viewCubits,
      didPagesChange: true,
    ));
  }

  void addComponent(ViewType componentType) {
    final selectedPage = state.selectedPage;

    switch (componentType) {
      case ViewType.text:
        selectedPage.configs.add(TextConfig.fromModel(TextModel.sample()));
        break;
      case ViewType.image:
        selectedPage.configs.add(ImageConfig.fromModel(ImageModel.sample()));
        break;
      case ViewType.button:
        selectedPage.configs.add(ButtonConfig.fromModel(ButtonModel.sample()));
        break;
      case ViewType.multipleChoice:
        selectedPage.configs.add(MultipleChoiceConfig.fromModel(MultipleChoiceModel.sample()));
        break;
      case ViewType.textField:
        selectedPage.configs.add(TextFieldConfig.fromModel(TextFieldModel.sample()));
        break;
      case ViewType.progress:
        selectedPage.configs.add(ProgressConfig.fromModel(ProgressModel.sample()));
        break;
      case ViewType.payment:
        selectedPage.configs.add(PaymentConfig.fromModel(PaymentModel.sample()));
        break;
    }
    appLog(componentType);
    Cubit viewCubit = getCubits(selectedPage.configs.last);
    List<Cubit> viewCubits = [...(state.viewCubits ?? []), viewCubit];
    emit(state.copyWith(selectedPage: selectedPage, viewCubits: viewCubits, didPagesChange: true));
  }

  void componentSelected({required BaseConfig config, required int index}) {
    emit(state.copyWith(selectedWidgetConfig: config, selectedWidgetConfigIndex: index));
  }

  Cubit getCubits(BaseConfig config) {
    switch (config.type) {
      case ViewType.text:
        return TextViewCubit(config as TextConfig);
      case ViewType.image:
        return ImageViewCubit(config as ImageConfig);
      case ViewType.button:
        return ButtonViewCubit(config as ButtonConfig);
      case ViewType.textField:
        return TextFieldViewCubit(config as TextFieldConfig);
      case ViewType.progress:
        return ProgressViewCubit(config as ProgressConfig);
      case ViewType.multipleChoice:
        return MultipleChoiceViewCubit(config as MultipleChoiceConfig);
      case ViewType.payment:
        return PaymentViewCubit(config as PaymentConfig);
    }
  }

  void updateSelectedConfig(BaseConfig config) {
    final pageIndex = state.selectedPage.pageOrder;

    if (state.selectedWidgetConfigIndex == -9) {
      final updatedPage = state.selectedPage.copyWith(navButton: config as ButtonConfig);
      final updatedPages = [...state.pages];
      updatedPages[state.selectedPage.pageOrder] = updatedPage;

      emit(state.copyWith(
        selectedPage: updatedPage,
        pages: updatedPages,
        navButtonCubit: ButtonViewCubit(config),
        didPagesChange: true,
      ));
      return;
    }

    var currentPage = state.pages[pageIndex];
    var newConfigs = List<BaseConfig>.from(currentPage.configs);
    var configIndex = state.selectedWidgetConfigIndex ?? 0;
    newConfigs[configIndex] = config;

    var newCubits = List<Cubit>.from(state.viewCubits ?? []);
    newCubits[configIndex] = getCubits(config);

    var newPage = currentPage.copyWith(configs: newConfigs);
    var newPages = List<PageData>.from(state.pages)..[pageIndex] = newPage;

    debugPrint("Updating config at index: $configIndex, page: $pageIndex");

    emit(state.copyWith(
      pages: newPages,
      selectedPage: newPage,
      viewCubits: newCubits,
      selectedWidgetConfig: config,
      selectedWidgetConfigIndex: configIndex,
      didPagesChange: true,
    ));
  }

  void reorderComponent({required int oldIndex, required int newIndex}) {
    if (oldIndex < newIndex) newIndex -= 1;

    final newConfigs = List<BaseConfig>.from(state.selectedPage.configs);
    final newCubits = List<Cubit>.from(state.viewCubits ?? []);

    final movedConfig = newConfigs.removeAt(oldIndex);
    final movedCubit = newCubits.removeAt(oldIndex);

    newConfigs.insert(newIndex, movedConfig);
    newCubits.insert(newIndex, movedCubit);

    final pageIndex = state.selectedPage.pageOrder;

    final newPage = state.selectedPage.copyWith(configs: newConfigs);
    final newPages = List<PageData>.from(state.pages)..[pageIndex] = newPage;

    emit(state.copyWith(
      selectedPage: newPage,
      pages: newPages,
      viewCubits: newCubits,
      selectedWidgetConfigIndex: -1,
      didPagesChange: true,
    ));
  }

  void updatePageSettings(PageSettingsConfig updatedSettings) {
    final pageIndex = state.selectedPage.pageOrder;
    final currentPage = state.pages[pageIndex];
    final newPage = currentPage.copyWith(pageSettingsConfig: updatedSettings);
    final newPages = List<PageData>.from(state.pages)..[pageIndex] = newPage;
    debugPrint("Updating page settings for page: $pageIndex");
    emit(state.copyWith(pages: newPages, selectedPage: newPage, didPagesChange: true));
  }

  setInitialFunnel({required List<PageData> pages, bool isEditing = true}) {
    if (pages.isEmpty) return;
    final PageData page = pages[0];
    if (isEditing) {
      List<Cubit> cubits = [];
      for (var i = 0; i < pages[0].configs.length; i++) {
        cubits.add(getCubits(pages[0].configs[i]));
      }
      emit(state.copyWith(
        pages: pages,
        selectedPage: page,
        viewCubits: cubits,
        navButtonCubit: ButtonViewCubit(page.navButton),
        selectedWidgetConfigIndex: -1,
        selectedWidgetConfig: null,
      ));
    } else {
      emit(BuilderState.initial());
    }
  }

  updateDidPagesChange(bool didPagesChange) => emit(state.copyWith(didPagesChange: didPagesChange));
}

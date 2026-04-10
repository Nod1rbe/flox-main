part of 'builder_cubit.dart';

class BuilderState extends Equatable {
  final List<PageData> pages;
  final PageData selectedPage;
  final BaseConfig? selectedWidgetConfig;
  final int? selectedWidgetConfigIndex;
  final List<Cubit>? viewCubits;
  final ButtonViewCubit? navButtonCubit;
  final bool didPagesChange;

  const BuilderState(
    this.pages,
    this.selectedPage,
    this.selectedWidgetConfig,
    this.selectedWidgetConfigIndex,
    this.viewCubits,
    this.navButtonCubit,
    this.didPagesChange,
  );

  factory BuilderState.initial() {
    return BuilderState(
      template1,
      template1[0],
      null,
      null,
      null,
      ButtonViewCubit(template1[0].navButton),
      false,
    );
  }

  BuilderState copyWith({
    List<PageData>? pages,
    PageData? selectedPage,
    BaseConfig? selectedWidgetConfig,
    List<Cubit>? viewCubits,
    int? selectedWidgetConfigIndex,
    ButtonViewCubit? navButtonCubit,
    bool? didPagesChange,
  }) {
    return BuilderState(
      pages ?? this.pages,
      selectedPage ?? this.selectedPage,
      selectedWidgetConfig ?? this.selectedWidgetConfig,
      selectedWidgetConfigIndex ?? this.selectedWidgetConfigIndex,
      viewCubits ?? this.viewCubits,
      navButtonCubit ?? this.navButtonCubit,
      didPagesChange ?? this.didPagesChange,
    );
  }

  Cubit? get currentCubit {
    final index = selectedWidgetConfigIndex;
    if (index == -9) return navButtonCubit;
    if (index == null || index < 0 || viewCubits == null || index >= viewCubits!.length) {
      return null;
    }
    return viewCubits![index];
  }

  Map<int, List<int>> get invalidAnalyticsFieldPositions {
    final Map<int, List<int>> result = {};

    for (int pageIndex = 0; pageIndex < pages.length; pageIndex++) {
      final page = pages[pageIndex];

      for (int configIndex = 0; configIndex < page.configs.length; configIndex++) {
        final config = page.configs[configIndex];

        final hasEmptyAnalyticsField = switch (config) {
          MultipleChoiceConfig(:final analyticsFieldName) ||
          TextFieldConfig(:final analyticsFieldName) =>
            analyticsFieldName.trim().isEmpty,
          _ => false,
        };

        if (hasEmptyAnalyticsField) {
          result.putIfAbsent(pageIndex, () => []).add(configIndex);
        }
      }
    }

    return result;
  }

  @override
  List<Object?> get props => [
        pages,
        selectedPage,
        selectedWidgetConfig,
        selectedWidgetConfigIndex,
        viewCubits,
        navButtonCubit,
        didPagesChange,
      ];
}

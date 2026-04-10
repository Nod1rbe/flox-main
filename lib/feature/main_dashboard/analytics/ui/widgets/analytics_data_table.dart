import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/core/extensions/alignment_extensions.dart';
import 'package:flox/feature/main_dashboard/analytics/cubit/analytics_cubit/analytics_cubit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnalyticsDataTable extends StatefulWidget {
  final List<AnalyticsLeadRow> rows;
  final VoidCallback? onExport;
  final bool showTopBorder;

  const AnalyticsDataTable({
    super.key,
    required this.rows,
    this.onExport,
    this.showTopBorder = false,
  });

  @override
  State<AnalyticsDataTable> createState() => _AnalyticsDataTableState();
}

class _AnalyticsDataTableState extends State<AnalyticsDataTable> {
  late List<double> _columnWidths;
  late List<String> _fieldNames;
  late int _rowCount;

  static const double _rowHeaderWidth = 45;
  static const double _cellHeight = 42;
  static const double _initialColumnWidth = 120;
  static const double _minColumnWidth = 100;
  static const double _maxColumnWidth = 400;
  static const double _resizeHandleWidth = 16;

  @override
  void initState() {
    super.initState();
    _rebuildColumns();
  }

  @override
  void didUpdateWidget(covariant AnalyticsDataTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rows != widget.rows) {
      _rebuildColumns();
    }
  }

  void _rebuildColumns() {
    final dynamicKeys = <String>{};
    for (final row in widget.rows) {
      dynamicKeys.addAll(row.fields.keys);
    }
    final dynamicList = dynamicKeys.toList()..sort();
    _fieldNames = ['Session', 'Reached Page', 'Source', 'Created At', ...dynamicList.map(_beautifyHeader)];
    _rowCount = widget.rows.length;
    _columnWidths = List.generate(_fieldNames.length, (_) => _initialColumnWidth);
    if (_fieldNames.isNotEmpty) {
      _columnWidths[0] = 160; // Session
      if (_fieldNames.length > 1) _columnWidths[1] = 110; // Reached Page
      if (_fieldNames.length > 2) _columnWidths[2] = 110; // Source
      if (_fieldNames.length > 3) _columnWidths[3] = 170; // Created At
    }
  }

  void _onResize(int colIndex, DragUpdateDetails details) {
    setState(() {
      final newWidth = _columnWidths[colIndex] + details.delta.dx;
      if (newWidth >= _minColumnWidth && newWidth <= _maxColumnWidth) {
        _columnWidths[colIndex] = newWidth;
      }
    });
  }

  Widget _buildRowHeaderColumn() {
    return Column(
      children: List.generate(_rowCount + 1, (rowIndex) {
        final isHeader = rowIndex == 0;
        return Container(
          height: _cellHeight,
          width: _rowHeaderWidth,
          decoration: BoxDecoration(
            color: isHeader ? AppColors.layoutBackground : AppColors.transparent,
            border: Border(
              right: BorderSide(color: Colors.grey.shade700),
              bottom: BorderSide(color: AppColors.disabledTextColor),
            ),
          ),
          child: Center(
            child: Text(
              isHeader ? '#' : '$rowIndex',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.white.withValues(alpha: 0.7),
              ),
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: widget.showTopBorder ? BorderSide(color: AppColors.disabledTextColor) : BorderSide.none,
          left: BorderSide(color: Colors.grey.shade700),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRowHeaderColumn(),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(_fieldNames.length, (colIndex) {
                  final field = _fieldNames[colIndex];

                  return Stack(
                    children: [
                      Container(
                        width: _columnWidths[colIndex],
                        child: Column(
                          children: List.generate(_rowCount + 1, (rowIndex) {
                            final isHeader = rowIndex == 0;
                            final text = isHeader
                                ? field
                                : _valueFor(field: field, rowIndex: rowIndex - 1);
                            return Container(
                              height: _cellHeight,
                              decoration: BoxDecoration(
                                color: isHeader
                                    ? AppColors.layoutBackground
                                    : (rowIndex.isEven
                                        ? AppColors.transparent
                                        : AppColors.defaultButtonBackground.withValues(alpha: 0.2)),
                                border: Border(
                                  right: BorderSide(color: Colors.grey.shade700),
                                  bottom: BorderSide(color: AppColors.disabledTextColor),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Tooltip(
                                  message: text,
                                  child: Text(
                                    text,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: isHeader ? FontWeight.w600 : FontWeight.w400,
                                      color: AppColors.white,
                                    ),
                                  ).centerLeft,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      Positioned.fill(
                        left: _columnWidths[colIndex] - (_resizeHandleWidth / 2),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.resizeLeftRight,
                          child: GestureDetector(
                            onHorizontalDragUpdate: (details) => _onResize(colIndex, details),
                            child: Container(
                              width: _resizeHandleWidth,
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _valueFor({required String field, required int rowIndex}) {
    if (rowIndex < 0 || rowIndex >= widget.rows.length) return '';
    final row = widget.rows[rowIndex];
    switch (field) {
      case 'Session':
        return _shortSession(row.sessionId);
      case 'Reached Page':
        return row.reachedPageId.toString();
      case 'Source':
        return row.source;
      case 'Created At':
        return DateFormat('dd MMM yyyy, HH:mm').format(row.createdAt.toLocal());
      default:
        return row.fields[_originalFieldName(field)]?.trim().isNotEmpty == true
            ? row.fields[_originalFieldName(field)]!
            : '—';
    }
  }

  String _shortSession(String sessionId) {
    if (sessionId.length <= 12) return sessionId;
    return '${sessionId.substring(0, 6)}...${sessionId.substring(sessionId.length - 4)}';
  }

  String _beautifyHeader(String raw) {
    final cleaned = raw.replaceAll('_', ' ').trim();
    if (cleaned.isEmpty) return raw;
    return cleaned
        .split(' ')
        .map((word) => word.isEmpty ? word : '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  String _originalFieldName(String header) {
    for (final row in widget.rows) {
      for (final key in row.fields.keys) {
        if (_beautifyHeader(key) == header) return key;
      }
    }
    return header;
  }
}

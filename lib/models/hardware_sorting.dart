import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pile_of_shame/extensions/string_extensions.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/hardware.dart';

part 'hardware_sorting.freezed.dart';
part 'hardware_sorting.g.dart';

abstract class HardwareSorter {
  const HardwareSorter();

  int compareGames(VideoGameHardware a, VideoGameHardware b, bool isAscending);
}

class HardwareSorterByName extends HardwareSorter {
  const HardwareSorterByName();

  @override
  int compareGames(VideoGameHardware a, VideoGameHardware b, bool isAscending) {
    final factor = isAscending ? 1 : -1;
    return a.name
            .prepareForCaseInsensitiveSearch()
            .compareTo(b.name.prepareForCaseInsensitiveSearch()) *
        factor;
  }
}

class HardwareSorterByPrice extends HardwareSorter {
  const HardwareSorterByPrice();

  @override
  int compareGames(VideoGameHardware a, VideoGameHardware b, bool isAscending) {
    final difference = a.price - b.price;
    if (difference.abs() < 0.01) {
      return const HardwareSorterByName().compareGames(a, b, isAscending);
    }
    final factor = isAscending ? 1 : -1;
    final result = a.price.compareTo(b.price) * factor;
    return result;
  }
}

class HardwareSorterByLastModified extends HardwareSorter {
  const HardwareSorterByLastModified();

  @override
  int compareGames(VideoGameHardware a, VideoGameHardware b, bool isAscending) {
    final factor = isAscending ? 1 : -1;
    final result = (a.lastModified.compareTo(b.lastModified)) * factor;
    if (result == 0) {
      return const HardwareSorterByName().compareGames(a, b, isAscending);
    }
    return result;
  }
}

class HardwareSorterByCreatedAt extends HardwareSorter {
  const HardwareSorterByCreatedAt();

  @override
  int compareGames(VideoGameHardware a, VideoGameHardware b, bool isAscending) {
    final factor = isAscending ? 1 : -1;
    final result = (a.createdAt.compareTo(b.createdAt)) * factor;
    if (result == 0) {
      return const HardwareSorterByName().compareGames(a, b, isAscending);
    }
    return result;
  }
}

class HardwareSorterByHasNotes extends HardwareSorter {
  const HardwareSorterByHasNotes();

  @override
  int compareGames(VideoGameHardware a, VideoGameHardware b, bool isAscending) {
    final factor = isAscending ? 1 : -1;
    final result = (((a.notes != null && a.notes!.isNotEmpty) ? 0 : 1) -
            ((b.notes != null && b.notes!.isNotEmpty) ? 0 : 1)) *
        factor;
    if (result == 0) {
      return const HardwareSorterByName().compareGames(a, b, isAscending);
    }
    return result;
  }
}

enum SortStrategyHardware {
  byName(sorter: HardwareSorterByName()),
  byPrice(sorter: HardwareSorterByPrice()),
  byLastModified(sorter: HardwareSorterByLastModified()),
  byCreatedAt(sorter: HardwareSorterByCreatedAt()),
  byHasNotes(sorter: HardwareSorterByHasNotes()),
  ;

  String toLocaleString(BuildContext context) {
    switch (this) {
      case SortStrategyHardware.byName:
        return AppLocalizations.of(context)!.byName;
      case SortStrategyHardware.byPrice:
        return AppLocalizations.of(context)!.byPrice;
      case SortStrategyHardware.byLastModified:
        return AppLocalizations.of(context)!.byLastModified;
      case SortStrategyHardware.byCreatedAt:
        return AppLocalizations.of(context)!.byCreatedAt;
      case SortStrategyHardware.byHasNotes:
        return AppLocalizations.of(context)!.byHasNotes;
    }
  }

  IconData toIcon() {
    switch (this) {
      case SortStrategyHardware.byName:
        return Icons.sort_by_alpha;
      case SortStrategyHardware.byPrice:
        return Icons.savings;
      case SortStrategyHardware.byLastModified:
      case SortStrategyHardware.byCreatedAt:
        return Icons.date_range;
      case SortStrategyHardware.byHasNotes:
        return Icons.note;
    }
  }

  final HardwareSorter sorter;

  const SortStrategyHardware({
    required this.sorter,
  });
}

@freezed
class HardwareSorting with _$HardwareSorting {
  const factory HardwareSorting({
    @Default(true) bool isAscending,
    @Default(SortStrategyHardware.byName) SortStrategyHardware sortStrategy,
  }) = _HardwareSorting;
  const HardwareSorting._();

  factory HardwareSorting.fromJson(Map<String, dynamic> json) =>
      _$HardwareSortingFromJson(json);
}

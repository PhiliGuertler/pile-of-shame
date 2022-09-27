const emptyFields = <String>[];

class IGDBFilters {
  final List<String> fields;
  final String? conditions;
  final String? search;
  final int? limit;

  IGDBFilters(
      {this.fields = emptyFields, this.conditions, this.search, this.limit});

  @override
  String toString() {
    final fieldsString = "fields ${fields.isEmpty ? "*" : fields.join(",")}";
    var searchString = "";
    if (search != null) {
      searchString = "search \"$search\"";
    }
    var conditionsString = "";
    if (conditions != null && conditions!.isNotEmpty) {
      conditionsString = "where $conditions";
    }
    var limitString = "";
    if (limit != null) {
      limitString = "limit $limit";
    }
    return "$fieldsString;${searchString.isNotEmpty ? "$searchString;" : ""}${conditionsString.isNotEmpty ? "$conditionsString;" : ""}${limitString.isNotEmpty ? "$limitString;" : ""}";
  }
}

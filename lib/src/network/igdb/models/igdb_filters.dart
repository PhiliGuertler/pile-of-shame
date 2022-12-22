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

class IGDBFilterUtils {
  // private constructor as this class is not meant to be instantiated
  IGDBFilterUtils._();

  static String _generateCondition(String field, String value, bool isExact) {
    if (isExact) {
      return "$field ~ \"$value\"";
    } else {
      return "$field ~ *\"$value\"*";
    }
  }

  static List<String> generateGameNameCondition(String name, bool isExact) {
    // generates name conditions where a colon is placed in between all words
    final nameTokens = name.split(RegExp(r'[\s:]+'));
    List<int> indexGeneration =
        List<int>.generate(nameTokens.length - 1, (i) => i);
    List<String> nameSearch = [];
    List<String> alternativeNameSearch = [];
    for (var index in indexGeneration) {
      String before = nameTokens.sublist(0, index + 1).join(" ");
      String after = nameTokens.sublist(index + 1).join(" ");
      String sum = "$before: $after";
      nameSearch.add(IGDBFilterUtils._generateCondition("name", sum, isExact));
      alternativeNameSearch.add(IGDBFilterUtils._generateCondition(
          "alternative_names.name", sum, isExact));
    }

    List<String> conditions = [];
    String regularNameCondition =
        IGDBFilterUtils._generateCondition("name", name, isExact);
    String alternativeNameCondition = IGDBFilterUtils._generateCondition(
        "alternative_names.name", name, isExact);

    conditions.add(regularNameCondition);
    conditions.addAll(nameSearch);
    conditions.add(alternativeNameCondition);
    conditions.addAll(alternativeNameSearch);

    return conditions;
  }
}

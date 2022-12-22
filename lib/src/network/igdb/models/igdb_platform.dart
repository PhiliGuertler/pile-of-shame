class IGDBPlatformFamily {
  final int id;
  final String name;
  final String slug;

  IGDBPlatformFamily(
      {required this.id, required this.name, required this.slug});

  IGDBPlatformFamily.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        slug = json["slug"];
}

class IGDBPlatform {
  final int id;
  final String? abbreviation;
  final String? alternativeName;
  final String? name;
  final int? platformFamilyId;
  final int? platformLogoId;
  final String? slug;

  IGDBPlatform({
    required this.id,
    this.abbreviation,
    this.alternativeName,
    this.name,
    this.platformFamilyId,
    this.platformLogoId,
    this.slug,
  });

  @override
  String toString() {
    return name ?? "Unbekannte Plattform";
  }

  IGDBPlatform.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        abbreviation = json["abbreviation"],
        alternativeName = json["alternative_name"],
        name = json["name"],
        platformFamilyId = json["platform_family"],
        platformLogoId = json["platform_logo"],
        slug = json["slug"];
}

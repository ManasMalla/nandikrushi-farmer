class NkUnit {
  final int id;
  final String title;
  final String unit;
  const NkUnit({
    required this.id,
    required this.title,
    required this.unit,
  });

  @override
  toString() {
    return "$title($unit)";
  }
}

class NkCategory {
  final int customerGroupId;
  final int categoryId;
  final String categoryName;
  final List<NkUnit> categoryUnits;
  final List<NkSubCategory> subCategories;

  const NkCategory({
    required this.customerGroupId,
    required this.categoryId,
    required this.categoryName,
    required this.categoryUnits,
    required this.subCategories,
  });

  @override
  toString() {
    return "Category: $categoryName (Id: $categoryId)\nUnits: [${categoryUnits.join(",")}]\nSubcategories: [${subCategories.join("\n")}]";
  }
}

class NkSubCategory {
  final int subcategoryId;
  final String subcategoryName;
  final List<NkUnit> subcategoryUnits;
  const NkSubCategory({
    required this.subcategoryId,
    required this.subcategoryName,
    required this.subcategoryUnits,
  });

  @override
  String toString() {
    return "Subcategory: $subcategoryName (Id: $subcategoryId), Units: [${subcategoryUnits.join(",")}]";
  }
}

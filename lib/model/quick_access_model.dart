class QuickAccessModel {
  final String image;
  final String title;
  final String? directory;

  QuickAccessModel({
    required this.image,
    required this.title,
    this.directory,
  });
}
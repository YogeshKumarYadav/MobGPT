class ImageModel {
  final String role;
  final String content;

  ImageModel({required this.role, required this.content});
  factory ImageModel.fromJson(Map<String, dynamic> json) =>
      ImageModel(
        role: json['chatIndex'],
        content: json['message']
      );
}

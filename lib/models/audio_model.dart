class AudioModel {
  final String role;
  final String content;

  AudioModel({required this.role, required this.content});
  factory AudioModel.fromJson(Map<String, dynamic> json) =>
      AudioModel(
        role: json['chatIndex'],
        content: json['message']
      );
}

class EditModel {
  final String role;
  final String input;
  final String instruction;

  EditModel(
      {required this.role, required this.input, required this.instruction});
  factory EditModel.fromJson(Map<String, dynamic> json) => EditModel(
      role: json['chatIndex'],
      input: json['message'],
      instruction: json['instruction']);
}

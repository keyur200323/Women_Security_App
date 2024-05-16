class UserModel {
  String? name;
  String? id;
  String? phone;
  String? childEmail;
  String? guardianEmail;
  String? type;
  UserModel({this.name,this.id,
    this.phone, this.childEmail, this.guardianEmail, this.type});

  Map<String, dynamic> toJson() => {
    'name': name,
    'id': id,
    'phone': phone,
    'child_email': childEmail,
    'parent_email': guardianEmail,
    'type':type
  };
}

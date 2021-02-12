class Employee {
  String id;
  String firstName;
  String email;
  String password;

  Employee({this.id, this.firstName,this.email,this.password});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: (json['id']) as String,
      firstName: json['first_name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }
}
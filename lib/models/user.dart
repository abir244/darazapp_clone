// lib/models/user.dart

class UserName {
  final String firstname;
  final String lastname;

  const UserName({required this.firstname, required this.lastname});

  factory UserName.fromJson(Map<String, dynamic> json) => UserName(
        firstname: json['firstname'] as String? ?? '',
        lastname: json['lastname'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'firstname': firstname,
        'lastname': lastname,
      };

  String get fullName => '$firstname $lastname';
}

class UserAddress {
  final String city;
  final String street;
  final String zipcode;

  const UserAddress({
    required this.city,
    required this.street,
    required this.zipcode,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) => UserAddress(
        city: json['city'] as String? ?? '',
        street: json['street'] as String? ?? '',
        zipcode: json['zipcode'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'city': city,
        'street': street,
        'zipcode': zipcode,
      };
}

class UserProfile {
  final int id;
  final String email;
  final String username;
  final String phone;
  final UserName name;
  final UserAddress address;

  const UserProfile({
    required this.id,
    required this.email,
    required this.username,
    required this.phone,
    required this.name,
    required this.address,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: json['id'] as int? ?? 0,
        email: json['email'] as String? ?? '',
        username: json['username'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        name: UserName.fromJson(json['name'] as Map<String, dynamic>? ?? {}),
        address: UserAddress.fromJson(
            json['address'] as Map<String, dynamic>? ?? {}),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'username': username,
        'phone': phone,
        'name': name.toJson(),
        'address': address.toJson(),
      };
}

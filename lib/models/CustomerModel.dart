class Customer {
  final String? id;
  final String? name;
  final String? surname;
  final String? tel;
  final String? email;
  final String? adresse;
  final String? city;
  final String? date;
  final String? update;
  final String? status;

  Customer({
      this.id,
      this.date,
      this.update,
      this.name,
      this.surname,
      this.tel,
      this.city,
      this.email,
      this.adresse,
      this.status});

  factory Customer.fromJson(Map<String, dynamic> i) {
    return Customer(
        id: i['id'],
        date: i['created_at'],
        update: i['updated_at'],
        name: i['customer_name'],
        surname: i['customer_surname'],
        tel: i['customer_tel'],
        email: i['customer_email'],
        adresse: i['customer_adresse'],
        city: i['customer_city'],
        status: i['customer_status']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'created_at': date,
        'updated_at': update,
        'customer_name': name,
        'customer_surname': surname,
        'customer_adresse': adresse,
        'customer_email': email,
        'customer_city': city,
        'customer_status': status,
        // 'customer_image':image,
        'customer_tel': tel,
      };
}

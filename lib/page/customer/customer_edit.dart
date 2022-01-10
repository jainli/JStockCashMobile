import 'package:flutter/material.dart';
import 'package:jstockcash/models/CustomerModel.dart';
import 'package:jstockcash/page/authentification/connection.dart';
import 'package:jstockcash/services/auth_service.dart';
import 'package:jstockcash/services/customer_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetalert/sweetalert.dart';

import '../forms/form.dart';
import 'customer_list.dart';

class CustomerEdit extends StatefulWidget {

  final Customer customer;

  const CustomerEdit({required this.customer});

  @override
  _CustomerEditState createState() => _CustomerEditState();
}

class _CustomerEditState extends State<CustomerEdit> {

  final formKey = GlobalKey<FormState>();

  CustomerService customerService = CustomerService();
  final AuthService authService = AuthService();


  // This is for text onChange
  TextEditingController customer_name = TextEditingController();
  TextEditingController customer_surname = TextEditingController();
  TextEditingController customer_tel = TextEditingController();
  TextEditingController customer_email = TextEditingController();
  TextEditingController customer_adresse = TextEditingController();
  TextEditingController customer_city = TextEditingController();
  TextEditingController customer_status = TextEditingController();

  @override
  void initState() {
    customer_name = TextEditingController(text: widget.customer.name);
    customer_surname = TextEditingController(text: widget.customer.surname);
    customer_tel = TextEditingController(text: widget.customer.tel);
    customer_email = TextEditingController(text: widget.customer.email);
    customer_adresse = TextEditingController(text: widget.customer.adresse);
    customer_city = TextEditingController(text: widget.customer.city);
    customer_status = TextEditingController(text: widget.customer.status);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit"),
        backgroundColor: Color(0xFF007AC3),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        padding: EdgeInsets.all(20),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: AppForm(
              formKey: formKey,
              customer_name: customer_name,
              customer_surname: customer_surname,
              customer_adresse: customer_adresse,
              customer_email: customer_email,
              customer_city: customer_city,
              customer_status: customer_status,
              customer_tel: customer_tel,
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: RaisedButton(
          child: Text('Modifier'),
          color: Colors.blue,
          textColor: Colors.white,
          onPressed: editCustomer
        ),
      ),
    );
  }

  Future editCustomer() async {

    if (formKey.currentState!.validate()) {

      SharedPreferences localStorage = await SharedPreferences.getInstance();

      var expires_in = localStorage.getString('expires_in');
      var res = await authService.autoLogout(DateTime.parse(expires_in!));

      if(res == true) {

        var phoneExists;
        var emailExists;

        if(int.parse(customer_tel.text) == int.parse(widget.customer.tel!)) {

          phoneExists = 0;

        } else {

          phoneExists = await customerService.phoneExists(int.parse(customer_tel.text));

        }

        if(customer_email.text == widget.customer.email) {

          emailExists = 0;

        } else {

          emailExists = await customerService.emailExists(customer_email.text);

        }

        if(phoneExists == 0 && emailExists == 0) {

          formKey.currentState!.save();

          customerService.updateCustomer(Customer(id: widget.customer.id, name: customer_name.text, surname: customer_surname.text, tel: customer_tel.text,
              email: customer_email.text, adresse: customer_adresse.text, city: customer_city.text, status: customer_status.text));

          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CustomerList())
          );

        } else {

          if(phoneExists == 1) {

            SweetAlert.show(
                context,
                title: "Error Error",
                subtitle: "Le numéro de téléphone existe déjà",
                style: SweetAlertStyle.error
            );

          }

          if(emailExists == 1) {

            SweetAlert.show(
                context,
                title: "Error Error",
                subtitle: "L'email existe déjà",
                style: SweetAlertStyle.error
            );

          }
        }

      } else {

        setState(() {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Login()
              )
          );
        });

      }
    }

  }
}

import 'package:flutter/material.dart';
import 'package:jstockcash/models/CustomerModel.dart';
import 'package:jstockcash/page/customer/customer_edit.dart';
import 'package:jstockcash/page/customer/customer_list.dart';
import 'package:jstockcash/services/customer_service.dart';


class CustomerView extends StatefulWidget {

  final Customer customer;

  CustomerView({required this.customer});

  @override
  _CustomerViewState createState() => _CustomerViewState();
}

class _CustomerViewState extends State<CustomerView> {

  CustomerService customerService = CustomerService();

  void deleteCustomer(context) async {

    await customerService.deleteCustomer(widget.customer.id!);

    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CustomerList())
    );

    /*http.post(
      Uri.parse("${Env.URL_PREFIX}/deletecustomerMob"),
      body: {
        'id': widget.customer.id.toString(),
      },
    );*/
    // Navigator.pop(context);

  }

  void confirmDelete(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Êtes-vous sûr de vouloir supprimer ce client ?'),
          actions: <Widget>[
            RaisedButton(
              child: Icon(Icons.cancel),
              color: Colors.red,
              textColor: Colors.white,
              onPressed: () => Navigator.of(context).pop(),
            ),
            RaisedButton(
              child: Icon(Icons.check_circle),
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () => deleteCustomer(context),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details du client'),
        backgroundColor: Color(0xFF007AC3),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => confirmDelete(context),
          ),
        ],
      ),
      body: Container(
          child: SingleChildScrollView(
              padding: EdgeInsets.all(35),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.all(5),

                        width: double.infinity,
                      ),
                    ),
                    const Image(
                      image: AssetImage("images/users.png"),
                      height: 200,
                    ),
                    Text(
                      "Name : ${widget.customer.name}",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Text(
                      "prenom : ${widget.customer.surname}",
                      style: TextStyle(fontSize: 20),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Text(
                      "telephone : ${widget.customer.tel}",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Text(
                      "Email : ${widget.customer.email}",
                      style: TextStyle(fontSize: 20),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Text(
                      "Adresse : ${widget.customer.adresse}",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Text(
                      "Ville : ${widget.customer.city}",
                      style: TextStyle(fontSize: 20),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Text(
                      "Enregistré le : ${widget.customer.date}",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Text(
                      "Dernièrer mise a jour  : ${widget.customer.update}",
                      style: TextStyle(fontSize: 15),
                    ),
                  ]
              )
          )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        backgroundColor: Colors.deepOrangeAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CustomerEdit(
                  customer: widget.customer,
                )),
          );
        },
      ),
    );
  }
}

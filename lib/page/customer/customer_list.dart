import 'dart:async';

import 'package:flutter/material.dart';

import 'package:jstockcash/models/CustomerModel.dart';
import 'package:jstockcash/page/authentification/connection.dart';
import 'package:jstockcash/page/customer/customer_create.dart';
import 'package:jstockcash/page/customer/customer_view.dart';
import 'package:jstockcash/page/widget/navigatorDrawer.dart';
import 'package:jstockcash/services/auth_service.dart';
import 'package:jstockcash/services/customer_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerList extends StatefulWidget {
  const CustomerList({Key? key}) : super(key: key);

  @override
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {


  Future<List<Customer>>? client;

  List<Customer> _customers = [];
  List<Customer> _foundCUstomers = [];

  final CustomerListKey = GlobalKey<_CustomerListState>();
  final CustomerService customerService = CustomerService();
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    loadList();

  }

  loadList() async {

    SharedPreferences localStorage = await SharedPreferences.getInstance();

    var expires_in = localStorage.getString('expires_in');
    var res = await authService.autoLogout(DateTime.parse(expires_in!));

    if(res == true) {

      setState(() {

        client = customerService.getCustomer();

        customerService.getCustomer().then((value) => {
          setState(() {
            _customers = value;
            _foundCUstomers = value;
          })
        });


      });

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

  void _runFilter(String enteredKeyword) {

    List<Customer> results = [];

    if(enteredKeyword.isEmpty) {

      results = _customers;

    } else {
      _customers.forEach((element) {

        if(element.name.toString().toLowerCase().contains(enteredKeyword.toLowerCase()) ||
            element.surname.toString().toLowerCase().contains(enteredKeyword.toLowerCase()) ||
            element.tel.toString().toLowerCase().contains(enteredKeyword.toLowerCase())) {

          results.add(element);

        }
      });
    }

    setState(() {
      _foundCUstomers = results;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: CustomerListKey,
      appBar: AppBar(
        title: Text("Liste Des Clients"),
        backgroundColor: Color(0xFF007AC3),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              TextField(
                onChanged: (value) => _runFilter(value),
                decoration: const InputDecoration(
                    labelText: 'Search...', //suffixIcon: Icon(Icons.search),
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25.0)))
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: _foundCUstomers.isNotEmpty
                    ? ListView.builder(
                    itemCount: _foundCUstomers.length,
                    itemBuilder: (context, index) => Card(
                      key: ValueKey(_foundCUstomers[index].id),
                      //color: Colors.amberAccent,
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        leading: Icon(Icons.person),
                        trailing: Text(_foundCUstomers[index].tel!, style: TextStyle(fontSize: 15),),
                        title: Text(
                          _foundCUstomers[index].name!,
                          style: TextStyle(fontSize: 20),
                        ),
                        subtitle: Text(_foundCUstomers[index].surname!, style: TextStyle(fontSize: 15),),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => CustomerView(customer: _foundCUstomers[index])));
                        },
                      ),
                    ))
                    : const SizedBox(
                    height: 30,
                    width: 30,
                    child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 3.5,
                        )
                    )
                ),
              )
              /*
              Expanded(
                child: FutureBuilder<List<Customer>>(
                  future: client,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    // By default, show a loading spinner.
                    if (!snapshot.hasData) return CircularProgressIndicator();
                    // Render student lists
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        var data = snapshot.data[index];
                        return Card(
                          child: ListTile(
                            leading: Icon(Icons.person),
                            trailing: Icon(Icons.view_list),
                            title: Text(
                              data.name,
                              style: TextStyle(fontSize: 20),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Detail(customer: data)),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              )

               */
            ]

        )
      ),
      drawer: Drawers(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepOrangeAccent,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return CustomerCreate();
          }));
        },
      ),
    );
  }
}

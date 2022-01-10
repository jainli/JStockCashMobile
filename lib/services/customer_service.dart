import 'dart:convert';
import 'dart:core';

import 'package:jstockcash/page/widget/api.dart';
import 'package:jstockcash/models/CustomerModel.dart';



class CustomerService {

  final callApi = CallApi();


  Future<List<Customer>> getCustomer() async {

    var response = await callApi.getData('customerMob');

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();

      List<Customer> client = items.map<Customer>((json) {
        return Customer.fromJson(json);
      }).toList();

      return client;
    } else {
      //return response.statusCode as Future<List<Customer>>;

      throw Exception('${ response.statusCode}');

      //return Future.error(response.statusCode);


    }
  }

  Future createCustomer(Customer customer) async {

    Map data = {
      'name': customer.name,
      'surname' :customer.surname,
      'tel' : customer.tel,
      'email' : customer.email,
      'adresse' : customer.adresse,
      'city' : customer.city,
      'status' : customer.status,
    };

    var response = await callApi.postData(data, 'customerMob');

    if(response.statusCode == 200) {

      return jsonDecode(response.body);

    } else {

      throw Exception('Failed to post a customer');

    }
  }

  Future phoneExists(int customerPhone) async {

    Map data = {
      'phone': customerPhone,
    };

    var response = await callApi.postData(data, 'phoneExistsCustomerMob');

    if(response.statusCode == 200) {

      return jsonDecode(response.body)['response'];

    } else {

      throw Exception('Failed to post a phone customer');

    }
  }

  Future emailExists(String customerEmail) async {

    Map data = {
      'email': customerEmail,
    };

    var response = await callApi.postData(data, 'emailExistsCustomerMob');

    if(response.statusCode == 200) {

      return jsonDecode(response.body)['response'];

    } else {

      throw Exception('Failed to post an email customer');

    }
  }

  Future updateCustomer(Customer customer) async {

    Map data = {
      'id': customer.id,
      'name': customer.name,
      'surname' :customer.surname,
      'tel' : customer.tel,
      'email' : customer.email,
      'adresse' : customer.adresse,
      'city' : customer.city,
      'status' : customer.status,
    };

    var response = await callApi.editData(data, 'updateCustomerMob');

    if(response.statusCode == 200) {

      return jsonDecode(response.body);

    } else {

      throw Exception('Failed to update a customer');

    }
  }

  Future deleteCustomer(int id) async {

    var response = await callApi.deleteData('deletecustomerMob/${id}');

    if(response.statusCode == 200) {

      return jsonDecode(response.body);

    } else {

      throw Exception('Failed to delete a customer');

    }

  }

}
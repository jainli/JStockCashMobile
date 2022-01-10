import 'package:flutter/material.dart';
import 'package:jstockcash/page/authentification/connection.dart';
import 'package:jstockcash/page/widget/navigatorDrawer.dart';
import 'package:jstockcash/services/auth_service.dart';
import 'dart:convert';
import 'package:jstockcash/services/product_service.dart';
import 'package:jstockcash/models/product.dart';
import 'package:jstockcash/page/article/product_view.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {

  final ProductService service = ProductService();

  //late Future<List<Product>> products;

  List<Product> _products = [];
  List<Product> _foundProducts = [];

  final productListKey = GlobalKey<_ProductListState>();
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

      service.getProducts().then((value) => {
        setState(() {
         _products = value;
         _foundProducts = value;
        })
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

    List<Product> results = [];

    if(enteredKeyword.isEmpty) {

      results = _products;

    } else {
      _products.forEach((element) {

        if(element.product_bar_code.toString().toLowerCase().contains(enteredKeyword.toLowerCase()) ||
            element.product_title.toString().toLowerCase().contains(enteredKeyword.toLowerCase()) ||
            element.mark.mark_title.toString().toLowerCase().contains(enteredKeyword.toLowerCase()) ||
            element.category.category_title.toString().toLowerCase().contains(enteredKeyword.toLowerCase())) {

          results.add(element);

        }
      });

    }

    setState(() {
      _foundProducts = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Key: productListKey,
      appBar: AppBar(
        title: Text("Liste des produits"),
        backgroundColor: Color(0xFF007AC3),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
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
                child: _foundProducts.isNotEmpty
                    ? ListView.builder(
                    itemCount: _foundProducts.length,
                    itemBuilder: (context, index) => Card(
                      key: ValueKey(_foundProducts[index].id),
                      //color: Colors.amberAccent,
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        leading: Icon(Icons.category_outlined),
                        trailing: Text(_foundProducts[index].product_bar_code, style: TextStyle(fontSize: 15),),
                        title: Text(
                          _foundProducts[index].product_title,
                          style: TextStyle(fontSize: 20),
                        ),
                        subtitle: Text(_foundProducts[index].product_selling_price.toString(), style: TextStyle(fontSize: 15),),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => ProductView(product: _foundProducts[index])));
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
          ],
        ),
      ),
        drawer: Drawers(),
      /*floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '');
        },
      )*/
    );

  }
}


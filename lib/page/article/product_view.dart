import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jstockcash/page/widget/environnement.dart';
import '../../models/product.dart';
import '../../page/widget/navigatorDrawer.dart';
import '../../services/product_service.dart';


class ProductView extends StatefulWidget {

  final Product product;

  ProductView({required this.product});

  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {

  final ProductService service = ProductService();

  final String _urlImage = Environnement.URL_PREFIX_IMAGE;

  bool _log = true;


  @override
  void initState() {
    super.initState();
    if(widget.product.product_image.toString() == null.toString()) {

      setState(() {

        _log = false;

      });

    }
  }

  /*
  void deleteProduct(context) async {
    service.deleteProduct(widget.product.id);
    Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic>route) => false);
  }
  */

  void confirmDelete(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Êtes-vous sûr de vouloir supprimer ce produit???'),
            actions: <Widget>[
              RaisedButton(
                  child: Icon(Icons.cancel),
                  color: Colors.red,
                  textColor: Colors.white,
                  onPressed: () => Navigator.of(context).pop(),
              ),
              /*
              RaisedButton(
                  child: Icon(Icons.check_circle),
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () => deleteProduct(context)
              )*/
            ],
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vue d'un produit"),
        backgroundColor: Color(0xFF007AC3),
        centerTitle: true,
        /*actions: <Widget>[
          IconButton(
              onPressed: () => confirmDelete(context),
              icon: Icon(Icons.delete)),
        ],*/
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(35),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _log
                  ? ClipOval(
                child: Image.network(
                  _urlImage+'/${widget.product.product_image}',
                  errorBuilder: (context, exception, stackTrack) => Icon(Icons.error,),
                  //loadingBuilder: (context, exception, stackTrack) => CircularProgressIndicator(strokeWidth: 3.5,),
                  height: 200,
                ),
              )
                  : const Image(
                image:   AssetImage("images/defautImage.png"),
                height: 200,
              ),
              /*const Image(
                image: AssetImage("images/defautImage.png"),
                height: 200,
              ),*/
              Padding(
                padding: EdgeInsets.all(20),
              ),
              SelectableText(
                "Titre : ${widget.product.product_title}",
                style: TextStyle(fontSize: 20,),
              ),
              Padding(
                padding: EdgeInsets.all(5),
              ),
              Text(
                "Prix de vente : ${widget.product.product_selling_price}",
                style: TextStyle(fontSize: 20),
              ),
              Padding(
                padding: EdgeInsets.all(5),
              ),
              SelectableText(
                "Code barre : ${widget.product.product_bar_code}",
                style: TextStyle(fontSize: 20),
              ),
              Padding(
                padding: EdgeInsets.all(5),
              ),
              Text(
                "Designation du produit : ${widget.product.product_designation}",
                style: TextStyle(fontSize: 20),
              ),
              Padding(
                padding: EdgeInsets.all(5),
              ),
              Text(
                "Unite du produit : ${widget.product.product_unit}",
                style: TextStyle(fontSize: 20),
              ),
              Padding(
                padding: EdgeInsets.all(5),
              ),
              Text(
                "Categorie du produit : ${widget.product.category.category_title}",
                style: TextStyle(fontSize: 20),
              ),
              Padding(
                padding: EdgeInsets.all(5),
              ),
              Text(
                "marque du produit : ${widget.product.mark.mark_title}",
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
        ),
      ),
      /*
      body: Container(
        alignment: Alignment.center,
        height: 270.0,
        padding: const EdgeInsets.all(35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(
              right: 5.0, left: 5.0, bottom: 15.0, top: 2.0
            )),
            Expanded(
              child: Text(
              "Titre: ${widget.product.product_title}",
              style: TextStyle(fontSize: 20,),
              ),
            ),
            Expanded(
                child: Text(
                  "Prix de vente : ${widget.product.product_selling_price}",
                  style: TextStyle(fontSize: 20),
                ),
            ),
            Expanded(
                child: Text(
                  "Code barre : ${widget.product.product_bar_code}",
                  style: TextStyle(fontSize: 20),
                ),
            ),
            Expanded(
                child: Text(
                  "Designation du produit : ${widget.product.product_designation}",
                  style: TextStyle(fontSize: 20),
                ),
            ),
            Expanded(
                child: Text(
                  "Unite du produit : ${widget.product.product_unit}",
                  style: TextStyle(fontSize: 20),
                ),
            ),
            Expanded(
                child: Text(
                  "Categorie du produit : ${widget.product.category.category_title}",
                  style: TextStyle(fontSize: 20),
                ),
            ),
            Expanded(
                child: Text(
                  "marque du produit : ${widget.product.mark.mark_title}",
                  style: TextStyle(fontSize: 20),
                )
            )
            /*Text(
              "Titre: ${widget.product.product_title}",
              style: TextStyle(fontSize: 20),
            ),
            Padding(padding: EdgeInsets.all(10)),
            Text(
              "Prix de vente : ${widget.product.product_selling_price}",
              style: TextStyle(fontSize: 20),
            ),
            Padding(padding: EdgeInsets.all(10)),
            Text(
              "Code barre : ${widget.product.product_bar_code}",
              style: TextStyle(fontSize: 20),
            ),
            Padding(padding: EdgeInsets.all(10)),
            Text(
              "Designation du produit : ${widget.product.product_designation}",
              style: TextStyle(fontSize: 20),
            ),
            Padding(padding: EdgeInsets.all(10)),
            Text(
              "Unite du produit : ${widget.product.product_unit}",
              style: TextStyle(fontSize: 20),
            ),
            Padding(padding: EdgeInsets.all(10)),
            Text(
              "Categorie du produit : ${widget.product.category.category_title}",
              style: TextStyle(fontSize: 20),
            ),
            Padding(padding: EdgeInsets.all(10)),
            Text(
              "marque du produit : ${widget.product.mark.mark_title}",
              style: TextStyle(fontSize: 20),
            )*/
          ],
        ),
      ),

       */
      /*
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.edit),
          onPressed: () => Navigator.of(context).pushNamed(''),
        )*/
    );
  }
}

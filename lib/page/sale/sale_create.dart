import 'dart:convert';

import '../../models/sale.dart';
import '../../page/authentification/connection.dart';
import '../../page/home/home.dart';
import '../../page/widget/navigatorDrawer.dart';
import '../../services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/product_service.dart';
import '../../services/product_damaged_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:editable/editable.dart';
import '../../services/customer_service.dart';
import '../../models/CustomerModel.dart';
import '../../services/sale_service.dart';
import '../../models/command_sale.dart';
import '../../services/command_sale_service.dart';
import '../../services/paiement_service.dart';
import '../../models/paiement.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';


class SaleCreate extends StatefulWidget {
  const SaleCreate({Key? key}) : super(key: key);

  @override
  _SaleCreateState createState() => _SaleCreateState();

}

class _SaleCreateState extends State<SaleCreate> {

  final ProductService productService = ProductService();
  final ProductDamagedService productDamagedService = ProductDamagedService();
  final CustomerService customerService = CustomerService();
  final SaleService saleService = SaleService();
  final CommandSaleService commandSaleService =  CommandSaleService();
  final PaiementService paiementService = PaiementService();
  final AuthService authService = AuthService();



  List<Customer> customers = [];
 // var customers = [];
  var _customerSelect;

  final _addFormKey = GlobalKey<FormState>();

  int _activeStepIndex = 0;

  TextEditingController sale_reductionController = TextEditingController();
  TextEditingController sale_augmentationController = TextEditingController();
  TextEditingController customer_idController = TextEditingController();
  TextEditingController site_idController  = TextEditingController();
  TextEditingController checkout_idController  = TextEditingController();
  TextEditingController barCodeControlller  = TextEditingController();
  TextEditingController actionQteController = TextEditingController();


  var items =  ['Apple','Banana','Grapes','Orange','watermelon','Pineapple'];


  TextEditingController especeAmountController = TextEditingController();
  TextEditingController amountReturnedController = TextEditingController();
  TextEditingController carteAmountController = TextEditingController();
  TextEditingController mobileAmountController = TextEditingController();


  List headers = [
  {"title":'Nom prduit', 'index': 1, 'key':'nom'},
  {"title":'Pu', 'index': 2, 'key':'pu'},
  {"title":'Qté', 'index': 3, 'key':'qte'},
  {"title":'Prix total', 'index': 4, 'key':'prixTotal'},
  ];

  List _rows = [];

  List _products = [];

  late double _totalAmount;
  late double _amountHasPaie;
  late double _amountPaie;
  late double _amountRest;

  var user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    user = {};

    shared().then((e) {

      setState(() {

        user = e;

        site_idController.text = e['site_name'];
        checkout_idController.text = e['checkout_number'];

      });

    });

    _totalAmount = 0;
    _amountHasPaie = 0;
    _amountPaie = 0;
    _amountRest = 0;

    _loadList();

  }

  Future shared() async {

    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final u = _prefs.getString("user");
    final userF = jsonDecode(u!) as Map;

    return userF;

  }

  Future _loadList() async{

    SharedPreferences localStorage = await SharedPreferences.getInstance();

    var expires_in = localStorage.getString('expires_in');
    var res = await authService.autoLogout(DateTime.parse(expires_in!));

    if(res == true) {

      Future<List<Customer>> futureCases = customerService.getCustomer();
      //final futureCases = customerService.getCustomer();
      futureCases.then((customersList) {
        setState(() {
          this.customers = customersList;
          _customerSelect = null;
          //_selectedValue = this.customers.first;
        });
      });
      return futureCases;

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


  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {

      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);

    } on PlatformException {

      barcodeScanRes = 'Failed to get platform version.';

    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() async {

      if( _isNumeric(barcodeScanRes)) {

        _operationsProduct(barcodeScanRes);

      } else {

        SweetAlert.show(
            context,
            title: "Error Error",
            subtitle: "Le code barre doit être constitué uniquement des chiffres",
            style: SweetAlertStyle.error
        );

      }


    });
  }

  Future<void> _operationsProduct(barcode) async {

    SharedPreferences localStorage = await SharedPreferences.getInstance();

    var expires_in = localStorage.getString('expires_in');
    var res = await authService.autoLogout(DateTime.parse(expires_in!));

    if(res == true) {

      if (barcode.length >= 12) {

        if (barcode.length == 12 || barcode.length == 13) {

          final product = await productService.fetchProductByBarCode(barcode);

          if (product == null) {

            Fluttertoast.showToast(
                msg: "Produit introuvable",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
            );

          } else {

            setState(() {
              _rows.add({
                "nom": product.product_title,
                "pu": product.product_selling_price.toString(),
                "qte": 1,
                "prixTotal": product.product_selling_price.toString(),
              });

              barCodeControlller.clear();

              _products.add({
                "id": product.id,
                "nom": product.product_title,
                "pu": product.product_selling_price.toString(),
                "qte": 1.toString(),
                "prixTotal": product.product_selling_price.toString(),
                "damaged": 0
              });

              _totalAmount = _totalAmount + product.product_selling_price;
              _amountHasPaie = _totalAmount;

              if (sale_reductionController.text.isNotEmpty) {
                var val = (_totalAmount *
                    double.parse(sale_reductionController.text)) / 100;
                _amountHasPaie = _totalAmount - val;
              }

              if (sale_augmentationController.text.isNotEmpty) {
                var val = (_totalAmount *
                    double.parse(sale_augmentationController.text)) / 100;
                _amountHasPaie = _totalAmount + val;
              }

              _amountRest = _amountHasPaie - _amountPaie;
            });
          }
        } else {

          final product_damaged = await productDamagedService
              .fetchProductDamagedAccordingBarCode(barcode);

          if (product_damaged == null) {

            Fluttertoast.showToast(
                msg: "Produit introuvable",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP_LEFT,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
            );

          } else {

            setState(() {
              _rows.add({
                "nom": product_damaged.product_damaged_title,
                "pu": product_damaged.product_damaged_selling_price.toString(),
                "qte": 1,
                "prixTotal": product_damaged.product_damaged_selling_price
                    .toString()
              });

              barCodeControlller.clear();

              _products.add({
                "id": product_damaged.id,
                "nom": product_damaged.product_damaged_title,
                "pu": product_damaged.product_damaged_selling_price.toString(),
                "qte": 1.toString(),
                "prixTotal": product_damaged.product_damaged_selling_price
                    .toString(),
                "damaged": 1
              });

              _totalAmount =
                  _totalAmount + product_damaged.product_damaged_selling_price;
              _amountHasPaie = _totalAmount;

              if (sale_reductionController.text.isNotEmpty) {
                var val = (_totalAmount *
                    double.parse(sale_reductionController.text)) / 100;
                _amountHasPaie = _totalAmount - val;
              }

              if (sale_augmentationController.text.isNotEmpty) {
                var val = (_totalAmount *
                    double.parse(sale_augmentationController.text)) / 100;
                _amountHasPaie = _totalAmount + val;
              }

              _amountRest = _amountHasPaie - _amountPaie;
            });
          }
        }
      }

      else {

        Fluttertoast.showToast(
            msg: "La taille du code barre est incorrecte",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );

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


  bool _isNumeric(String result) {
    if (result == null) {
      return false;
    }
    return double.tryParse(result) != null;
  }

  Future<void> _changeQte(value) async {

    if(value != "no edit") {

      final i = value['row'];

      if(value['qte'] != null && _isNumeric(value['qte'])) {

        final oldRow = _rows[i];

        final double res;

        res = double.parse(_rows[i]['pu']) * double.parse(value['qte']);

        setState(() {

          _rows[i]['nom'] = _products[i]['nom'];
          _rows[i]['qte'] = value['qte'];
          _rows[i]['prixTotal'] = res.toString();

          if(_totalAmount > 0) {

            _totalAmount = _totalAmount - double.parse(_products[i]['prixTotal']);

          }

          _totalAmount = _totalAmount + res;

          _amountHasPaie = _totalAmount;

          _products[i]['prixTotal'] = res.toString();
          _products[i]['qte'] = value['qte'];

          if(sale_reductionController.text.isNotEmpty) {

            var val = (_totalAmount * double.parse(sale_reductionController.text)) / 100;
            _amountHasPaie = _totalAmount - val;

          }

          if(sale_augmentationController.text.isNotEmpty) {

            var val = (_totalAmount * double.parse(sale_augmentationController.text)) / 100;
            _amountHasPaie = _totalAmount + val;

          }

          _amountRest = _amountHasPaie - _amountPaie;

         });

      } else {
        /*SweetAlert.show(context,
            title: "Just show a message",
            subtitle: "Sweet alert is pretty",
            style: SweetAlertStyle.success);*/
        print("Erreur");
      }

    } else {

      SweetAlert.show(context,
          title: "Error",
          subtitle: "Aucune donnée a modifié",
          style: SweetAlertStyle.error);

    }

  }

  Future<void> _operationAmount(amount, String objet) async {

    if(_isNumeric(amount)) {

      if(this._amountHasPaie == 0) {

        SweetAlert.show(
          context,
          title: "Impossible d'enregistrer le montant",
          subtitle: "Aucun produit n'a été enregistré",
          style: SweetAlertStyle.error
        );

        especeAmountController.clear();
        carteAmountController.clear();
        mobileAmountController.clear();

      } else {

        if(_amountPaie == 0) {

          if(_amountPaie < _amountHasPaie) {

            _amountPaie = 0;

            if (objet == "espece") {
              setState(() {
                if (sale_reductionController.text.isNotEmpty) {
                  var val = (_totalAmount *
                      double.parse(sale_reductionController.text)) / 100;
                  _amountHasPaie = _totalAmount - val;
                }

                if (sale_augmentationController.text.isNotEmpty) {
                  var val = (_totalAmount *
                      double.parse(sale_augmentationController.text)) / 100;
                  _amountHasPaie = _totalAmount + val;
                }

                _amountPaie = _amountPaie + double.parse(amount);
                _amountRest = _amountHasPaie - _amountPaie;

                var val;

                if (double.parse(especeAmountController.text) >
                    _amountHasPaie) {
                  val = double.parse(especeAmountController.text) -
                      _amountHasPaie;
                } else {
                  val = 0;
                }

                amountReturnedController.text = val.toString();
              });
            } else {
              setState(() {
                if (sale_reductionController.text.isNotEmpty) {
                  var val = (_totalAmount *
                      double.parse(sale_reductionController.text)) / 100;
                  _amountHasPaie = _totalAmount - val;
                }

                if (sale_augmentationController.text.isNotEmpty) {
                  var val = (_totalAmount *
                      double.parse(sale_augmentationController.text)) / 100;
                  _amountHasPaie = _totalAmount + val;
                }

                _amountPaie = _amountPaie + double.parse(amount);
                _amountRest = _amountHasPaie - _amountPaie;
              });
            }

          } else {

            switch(objet) {

              case 'espece':
                especeAmountController.clear();
                break;

              case 'carte':
                carteAmountController.clear();
                break;

              case 'mobile':
                mobileAmountController.clear();
                break;

              default:
                break;
            }
            print("Erreur");

          }

        } else {

          setState(() {

            if(_amountPaie < _amountHasPaie) {

              _amountPaie = 0;

              if (especeAmountController.text.isNotEmpty) {
                _amountPaie =
                    _amountPaie + double.parse(especeAmountController.text);

                if (sale_reductionController.text.isNotEmpty) {
                  var val = (_totalAmount *
                      double.parse(sale_reductionController.text)) / 100;
                  _amountHasPaie = _totalAmount - val;
                }

                if (sale_augmentationController.text.isNotEmpty) {
                  var val = (_totalAmount *
                      double.parse(sale_augmentationController.text)) / 100;
                  _amountHasPaie = _totalAmount + val;
                }

                _amountRest = _amountHasPaie - _amountPaie;

                var val;

                if (double.parse(especeAmountController.text) >
                    _amountHasPaie) {
                  val = double.parse(especeAmountController.text) -
                      _amountHasPaie;
                } else {
                  val = 0;
                }

                amountReturnedController.text = val.toString();
              }

              if (carteAmountController.text.isNotEmpty) {
                _amountPaie =
                    _amountPaie + double.parse(carteAmountController.text);

                if (sale_reductionController.text.isNotEmpty) {
                  var val = (_totalAmount *
                      double.parse(sale_reductionController.text)) / 100;
                  _amountHasPaie = _totalAmount - val;
                }

                if (sale_augmentationController.text.isNotEmpty) {
                  var val = (_totalAmount *
                      double.parse(sale_augmentationController.text)) / 100;
                  _amountHasPaie = _totalAmount + val;
                }

                _amountRest = _amountHasPaie - _amountPaie;
              }

              if (mobileAmountController.text.isNotEmpty) {
                _amountPaie =
                    _amountPaie + double.parse(mobileAmountController.text);

                if (sale_reductionController.text.isNotEmpty) {
                  var val = (_totalAmount *
                      double.parse(sale_reductionController.text)) / 100;
                  _amountHasPaie = _totalAmount - val;
                }

                if (sale_augmentationController.text.isNotEmpty) {
                  var val = (_totalAmount *
                      double.parse(sale_augmentationController.text)) / 100;
                  _amountHasPaie = _totalAmount + val;
                }

                _amountRest = _amountHasPaie - _amountPaie;
              }

            } else {

              switch(objet) {

                case 'espece':
                  especeAmountController.clear();
                  break;

                case 'carte':
                  carteAmountController.clear();
                  break;

                case 'mobile':
                  mobileAmountController.clear();
                  break;

                default:
                  break;
              }

              print("Erreur");

            }

          });

        }

      }

    } else {

      print("Erreur");

    }

    if(_amountPaie == 0) {

      _amountRest = _amountHasPaie;

    }

  }

  Future<void> _reductionAndAugmentation(value, String objet) async {

    if(_isNumeric(value)) {

      if (sale_reductionController.text.isNotEmpty &&
          sale_augmentationController.text.isNotEmpty) {
        SweetAlert.show(
            context,
            title: "Impossible d'effectuer cet action",
            subtitle: "Veuillez mettre à 0 la value de l'augmentation ou de la réduction",
            style: SweetAlertStyle.error
        );

        double som = 0;

        for (int i = 0; i < _products.length; i++) {
          som = som + double.parse(_products[i]["prixTotal"]);
        }

        setState(() {
          _totalAmount = som;
          _amountHasPaie = som;
          _amountRest = _amountHasPaie - _amountPaie;

          sale_augmentationController.clear();
          sale_reductionController.clear();
        });
      } else {
        if (objet == "red" && sale_reductionController.text.isNotEmpty) {
          setState(() {
            var val = (_totalAmount *
                double.parse(sale_reductionController.text)) / 100;
            _amountHasPaie = _totalAmount - val;
            _amountRest = _amountHasPaie - _amountPaie;
          });
        } else
        if (objet == "aug" && sale_augmentationController.text.isNotEmpty) {
          setState(() {
            var val = (_totalAmount *
                double.parse(sale_augmentationController.text)) / 100;
            _amountHasPaie = _totalAmount + val;
            _amountRest = _amountHasPaie - _amountPaie;
          });
        } else {
          late double som = 0;

          for (var i = 0; i < _products.length; i++) {
            som = som + double.parse(_products[i]['prixTotal']);
          }

          setState(() {
            _totalAmount = som;
            _amountHasPaie = som;
            _amountRest = _amountHasPaie - _amountPaie;

            sale_augmentationController.clear();
            sale_reductionController.clear();
          });
        }
      }

    } else {

      SweetAlert.show(
          context,
          title: "Erreur Erreur!!!",
          subtitle: "Veuillez saisir des valeurs numeriques",
          style: SweetAlertStyle.error

      );

      setState(() {

        late double som = 0;

        for (var i = 0; i < _products.length; i++) {
          som = som + double.parse(_products[i]['prixTotal']);
        }


        _totalAmount = som;
        _amountHasPaie = som;
        _amountRest = _amountHasPaie - _amountPaie;

        sale_augmentationController.clear();
        sale_reductionController.clear();

      });

    }

  }

  Editable buildEditable(colsData, rowsData) {
      return Editable(
        key: UniqueKey(),
        columns: colsData,
        rows: rowsData,
        showCreateButton: false,
        tdStyle: TextStyle(fontSize: 20),
        showSaveIcon: true,
        saveIconColor: Colors.red,
        saveIconSize: 20,
        borderColor: Colors.grey.shade300,
        onRowSaved: (value) {
          _changeQte(value);
        },
      );
  }

  Future _saveSale() async {

    // Save Sale

    var reduction;
    var augmentation;

    if(sale_reductionController.text.isEmpty) {

      reduction = double.parse(0.toString());

    } else {

      reduction = double.parse(sale_reductionController.text);

    }

    if(sale_augmentationController.text.isEmpty) {

      augmentation = double.parse(0.toString());

    } else {

      augmentation = double.parse(sale_augmentationController.text);

    }


    SharedPreferences localStorage = await SharedPreferences.getInstance();

    var expires_in = localStorage.getString('expires_in');
    var res = await authService.autoLogout(DateTime.parse(expires_in!));

    if(res == true) {

      var new_sale;

      Customer cust = Customer(id: _customerSelect);

      new_sale = saleService.createSale(
          Sale(sale_reduction: reduction,
              sale_augmentation: augmentation,
              sale_total_amount: _totalAmount,
              sale_amount_has_paid: _amountHasPaie,
              sale_amount_paid: _amountPaie,
              sale_amount_returned: double.parse(amountReturnedController.text),
              site_id: user['site_id'],
              checkout_id: user['checkout_id'],
              user_id: user['id'],
              customer: cust));

      new_sale.then((sale) {

        /*print(sale);
      print(sale['id']);
      print(_products);*/

        // Save Command Sale
        for (var i = 0; i < _products.length; i++) {
          var message;

          if (_products[i]['damaged'] == 0) {
            message = commandSaleService.createCommandSale(CommandSale(
              quantity_sold: int.parse(_products[i]['qte']),
              selling_price: double.parse(_products[i]['pu']),
              sale_id: sale['sale']['id'],
              product_id: _products[i]['id'],
            ));
          } else {
            message = commandSaleService.createCommandSale(CommandSale(
                quantity_sold: int.parse(_products[i]['qte']),
                selling_price: double.parse(_products[i]['pu']),
                sale_id: sale['sale']['id'],
                product_damaged_id: _products[i]['id']
            ));
          }

          /*message.then((mes) {
          print(mes);
        });*/

        }

        // Save paiements

        var messagePaiement;

        if (especeAmountController.text.isNotEmpty) {
          messagePaiement = paiementService.createPaiement(Paiement(
              means_payment: 'Espece',
              paiement_amount: double.parse(especeAmountController.text),
              sale_id: sale['sale']['id'],
              user_id: user['id']));

          /*messagePaiement.then((mes) {
          print(mes);
        });*/
        }

        if (carteAmountController.text.isNotEmpty) {
          messagePaiement = paiementService.createPaiement(Paiement(
              means_payment: 'Carte bancaire',
              paiement_amount: double.parse(carteAmountController.text),
              sale_id: sale['sale']['id'],
              user_id: user['id']));

          /*messagePaiement.then((mes) {
          print(mes);
        });*/
        }

        if (mobileAmountController.text.isNotEmpty) {
          messagePaiement = paiementService.createPaiement(Paiement(
              means_payment: 'Mobile money',
              paiement_amount: double.parse(mobileAmountController.text),
              sale_id: sale['sale']['id'],
              user_id: user['id']));

          /*messagePaiement.then((mes) {
          print(mes);
        });*/
        }

        setState(() {
          sale_reductionController.clear();
          sale_augmentationController.clear();
          customer_idController.clear();
          //site_idController.clear();
          //checkout_idController.clear();
          barCodeControlller.clear();
          actionQteController.clear();

          especeAmountController.clear();
          amountReturnedController.clear();
          carteAmountController.clear();
          mobileAmountController.clear();

          _totalAmount = 0;
          _amountHasPaie = 0;
          _amountPaie = 0;
          _amountRest = 0;

          _customerSelect = null;

          _rows = [];
          _products = [];

          SweetAlert.show(
              context,
              title: "Save successfull",
              subtitle: "Les informations de la vente ont été bien enregistré",
              style: SweetAlertStyle.success
          );
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


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Enregistrement d'une vente"),
        backgroundColor: Color(0xFF007AC3),
        centerTitle: true,
      ),
     body: Form(
       key: _addFormKey,
       child: Center(

       child: SingleChildScrollView(
         child: Container(
           padding: EdgeInsets.all(20.0),
           child: Column(
             children: <Widget>[
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: <Widget>[
                   Flexible(
                     child: TextFormField(
                       controller: site_idController,
                       enabled: false,
                       decoration: const InputDecoration(
                         border: OutlineInputBorder(),
                         labelText: 'Site',
                       ),
                       validator: (value) {
                         if(value?.isEmpty ?? true) {
                           return 'Please enter title';
                         }
                         return null;
                       },
                     ),
                   ),
                   SizedBox(width: 20.0,),
                   Flexible(
                     child: TextFormField(
                       controller: checkout_idController,
                       enabled: false,
                       decoration: const InputDecoration(
                           border: OutlineInputBorder(),
                           labelText: 'Caisse'
                       ),
                       validator: (value) {
                         if(value?.isEmpty ?? true) {
                           return 'Please enter title';
                         }
                         return null;
                       },
                     ),
                   ),

                 ],
               ),
               const SizedBox(
                 height: 20,
               ),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: <Widget>[
                   Flexible(
                     child: TextFormField(
                       controller: sale_reductionController,
                       decoration: const InputDecoration(
                           border: OutlineInputBorder(),
                           labelText: 'Réduction'
                       ),
                       onChanged: (value) {
                         _reductionAndAugmentation(value, "red");
                       },
                     ),
                   ),
                   SizedBox(width: 20.0,),
                   Flexible(
                     child: TextFormField(
                       controller: sale_augmentationController,
                       decoration: const InputDecoration(
                           border: OutlineInputBorder(),
                           labelText: 'Augmentation'
                       ),
                       onChanged: (value) {
                         _reductionAndAugmentation(value, "aug");
                       },
                     ),
                   ),

                 ],
               ),
               const SizedBox(
                 height: 30,
               ),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: <Widget>[
                   Flexible(
                     child: DropdownButton(
                       isExpanded: true,
                       value: _customerSelect,
                       hint: Text('Clients'),
                       isDense: true,
                       icon: Icon(Icons.keyboard_arrow_down),
                       items: customers.map<DropdownMenuItem>((map) {
                         return DropdownMenuItem(
                           value: map.id,
                           child: Text(map.name!+' '+map.surname!)
                         );
                       }).toList(),

                       onChanged: (value) {
                         setState(() {
                           _customerSelect = value!;
                         });
                         //print(_selectedValue,);
                       },
                     )
                   ),
                 ],
               ),
               const SizedBox(
                 height: 50,
               ),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: <Widget>[
                   Expanded(
                       child: SizedBox(
                         //width: 50,
                         child: TextField(
                           controller: barCodeControlller,
                           keyboardType: TextInputType.number,
                           inputFormatters: <TextInputFormatter>[
                             FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                           ],
                           decoration: const InputDecoration(
                             border: OutlineInputBorder(),
                             labelText: 'Code barre du produit',

                           ),
                           onChanged: (text) {
                             _operationsProduct(barCodeControlller.text);
                           },
                           style: const TextStyle(
                               fontSize: 25,
                               height: 1.5
                           ),
                         ),
                       )
                   ),
                   const SizedBox(width: 60),
                   Container(
                     alignment: Alignment.centerRight,
                     child: InkWell(
                       onTap: scanBarcodeNormal,
                       child: const Icon(
                         Icons.add_a_photo_outlined,
                         color: Colors.deepOrangeAccent,
                         size: 50,
                       ),
                     ),
                   ),

                 ],
               ),
               const SizedBox(
                 height: 30,
               ),
               Row(
                 children: <Widget>[
                   Expanded(
                       child: SizedBox(
                           child: (
                               Container(
                                   margin: const EdgeInsets.all(30.0),
                                   alignment: Alignment.center,
                                   child: Column(
                                     children: [
                                       IntrinsicHeight(
                                           child: buildEditable(headers, _rows)
                                       ),
                                     ],
                                   )
                               )
                           )
                       )
                   )
                 ],
               ),
               const SizedBox(
                 height: 50,
               ),
               Row(
                 children: <Widget>[
                   Expanded(child: SizedBox(
                     child: Card(
                         child: Padding(
                           padding: EdgeInsets.all(23.0),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: <Widget>[
                               Flexible(
                                   child: Column(children: [
                                     Text('Montant Total', style: TextStyle(fontSize: 20),),
                                     Text(_totalAmount.toString(), style: TextStyle(fontSize: 15),)
                                   ],)
                               ),
                               SizedBox(width: 20.0,),
                               Flexible(
                                   child: Column(children: [
                                     Text('Montant à payer', style: TextStyle(fontSize: 20),),
                                     Text(_amountHasPaie.toString(), style: TextStyle(fontSize: 15),)
                                   ],)
                               ),
                             ],
                           ),
                         )
                     ),
                   ))
                 ],
               ),
               const SizedBox(
                 height: 30,
               ),
               Row(
                 children: <Widget>[
                   Expanded(child: SizedBox(
                     child: Card(
                         child: Padding(
                           padding: EdgeInsets.all(20.0),
                           child: Column(
                             children: <Widget>[
                               Align(
                                 alignment: Alignment.centerLeft,
                                 child: Container(
                                   child: Text('Espèce', style: TextStyle(fontSize: 20),),
                                 ),
                               ),
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: <Widget>[
                                   Flexible(
                                     child: TextField(
                                       controller: especeAmountController,
                                       decoration: const InputDecoration(
                                           hintText: 'Montant Perçu',
                                           hintStyle: TextStyle(
                                               fontSize: 12
                                           )
                                       ),
                                       keyboardType: TextInputType.number,
                                       onSubmitted: (text) {
                                         _operationAmount(especeAmountController.text, "espece");
                                       },
                                     ),
                                   ),
                                   SizedBox(width: 20.0,),
                                   Flexible(
                                     child: TextField(
                                         controller: amountReturnedController,
                                         enabled: false,
                                         decoration: const InputDecoration(
                                             hintText: 'Montant Rendu',
                                             hintStyle: TextStyle(
                                                 fontSize: 12
                                             )
                                         )
                                     ),
                                   ),

                                 ],
                               ),
                               const SizedBox(
                                 height: 30,
                               ),
                               Align(
                                 alignment: Alignment.centerLeft,
                                 child: Container(
                                   child: Text('Carte Bancaire', style: TextStyle(fontSize: 20),),
                                 ),
                               ),
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: <Widget>[
                                   Flexible(
                                     child: TextField(
                                       controller: carteAmountController,
                                       decoration: const InputDecoration(
                                           hintText: 'Montant payé en FCFA',
                                           hintStyle: TextStyle(
                                               fontSize: 12
                                           )
                                       ),
                                       keyboardType: TextInputType.number,
                                       onSubmitted: (text) {
                                         _operationAmount(carteAmountController.text, "carte");
                                       },
                                     ),
                                   ),
                                 ],
                               ),
                               const SizedBox(
                                 height: 30,
                               ),
                               Align(
                                 alignment: Alignment.centerLeft,
                                 child: Container(
                                   child: Text('Mobile Money', style: TextStyle(fontSize: 20),),
                                 ),
                               ),
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: <Widget>[
                                   Flexible(
                                     child: TextField(
                                       controller: mobileAmountController,
                                       decoration: const InputDecoration(
                                           hintText: 'Montant payé en FCFA',
                                           hintStyle: TextStyle(
                                               fontSize: 12
                                           )
                                       ),
                                       keyboardType: TextInputType.number,
                                       onSubmitted: (text) {
                                         _operationAmount(mobileAmountController.text, "mobile");
                                       },
                                     ),
                                   ),
                                 ],
                               ),
                               const SizedBox(
                                 height: 50,
                               ),
                               const Divider(
                                   height: 18,
                                   color: Colors.black
                               ),
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: <Widget>[
                                   Flexible(
                                       child: Column(children: [
                                         Text('Montant à payer', style: TextStyle(fontSize: 20),),
                                         Text(_amountHasPaie.toString(), style: TextStyle(fontSize: 15),)
                                       ],)
                                   ),
                                   SizedBox(width: 20.0,),
                                   Flexible(
                                       child: Column(children: [
                                         Text('Montant payer', style: TextStyle(fontSize: 20),),
                                         Text(_amountPaie.toString(), style: TextStyle(fontSize: 15),)
                                       ],)
                                   ),
                                   SizedBox(width: 20.0,),
                                   Flexible(
                                       child: Column(children: [
                                         Text('Montant restant', style: TextStyle(fontSize: 20),),
                                         Text(_amountRest.toString(), style: TextStyle(fontSize: 15),)
                                       ],)
                                   ),
                                 ],
                               ),
                             ],
                           ),
                         )
                     ),
                   ))
                 ],
               ),
               const SizedBox(height: 15),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: <Widget>[
                   SizedBox(
                     height: 44,
                     child:  ElevatedButton(
                       onPressed: () {
                         if(_addFormKey.currentState!.validate()) {
                           _addFormKey.currentState!.save();
                           if(_amountPaie < _amountHasPaie || _amountPaie <= 0) {
                             SweetAlert.show(
                                 context,
                                 title: "Impossible d'enregistrer la vente",
                                 subtitle: "Veuillez payer la totalité du prix de la vente",
                                 style: SweetAlertStyle.error
                             );

                           } else {

                             _saveSale();

                           }
                         }
                       },
                       child: const Text("Enregistrer"),
                       style: ElevatedButton.styleFrom(
                           primary: Colors.blue
                       ),
                     ),
                   ),
                   SizedBox(
                     height: 44,
                     child: ElevatedButton(
                       onPressed: () {
                         Navigator.push(
                             context,
                             MaterialPageRoute(
                                 builder: (context) => Home(user: user)));
                       },
                       child: const Text("Annuler"),
                       style: ElevatedButton.styleFrom(
                           primary: Colors.red
                       ),
                     ),
                   )
                 ],
               ),
             ],
           ),
         ),
       ),
       )
     ),
      drawer: Drawers(),

    );

  }
}


/*
class SaleCreate extends StatefulWidget {
  const SaleCreate({Key? key}) : super(key: key);

  @override
  _SaleCreateState createState() => _SaleCreateState();
}

class _SaleCreateState extends State<SaleCreate> {
  String _scanBarcode = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
        '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) => print(barcode));
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: const Text('Barcode scan')),
            body: Builder(builder: (BuildContext context) {
              return Container(
                  alignment: Alignment.center,
                  child: Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                            onPressed: () => scanBarcodeNormal(),
                            child: Text('Start barcode scan')),
                        ElevatedButton(
                            onPressed: () => scanQR(),
                            child: Text('Start QR scan')),
                        ElevatedButton(
                            onPressed: () => startBarcodeScanStream(),
                            child: Text('Start barcode scan stream')),
                        Text('Scan result : $_scanBarcode\n',
                            style: TextStyle(fontSize: 20))
                      ]));
            })));
  }
}
*/
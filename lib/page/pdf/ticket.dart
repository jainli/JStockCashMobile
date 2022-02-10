import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import '../../page/pdf/mobile.dart'
    if (dart.library.html) '../../page/pdf/web.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class Ticket {
  late var productsSale;
  late Map entrepriseSale;
  late Map infoSale;
  late String numCheckout;

  Future<Uint8List> _readImageData(String name) async {
    final data = await rootBundle.load('images/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  Future<void> generateInvoice(
      products, Map entreprise, Map sale, String numCheck) async {
    this.productsSale = products;
    this.entrepriseSale = entreprise;
    this.infoSale = sale;
    this.numCheckout = numCheck;

    //Create a PDF document.
    final PdfDocument document = PdfDocument();
    document.pageSettings.size = const Size(80, 40);
//Set margin for all the pages
    document.pageSettings.margins.all = 1;
    //Add page to the PDF
    final PdfPage page = document.pages.add();
    // final pages = PdfPageSize.a8;
    //  document.pageSettings.size = pages;
    //Get page client size
    final Size pageSize = page.getClientSize();

//Change the page orientation to 90 degree
    // document.pageSettings.rotate = PdfPageRotateAngle.rotateAngle90;

    page.graphics.drawImage(PdfBitmap(await _readImageData('logo.png')),
        const Rect.fromLTWH(10, -1, 19, 8));

    //Generate PDF grid.
    final PdfGrid grid = getGrid();
    //Draw the header section by creating text element
    final PdfLayoutResult result = drawHeader(page, pageSize, grid);
    //Draw grid
    drawGrid(
      page,
      grid,
      result,
      pageSize,
    );
    //Add invoice footer
    drawFooter(page, pageSize, document); //Save the PDF document
    final List<int> bytes = document.save();
    //Dispose the document.
    document.dispose();

    //Save and launch the file.
    await saveAndLaunchFile(bytes, 'Ticket.pdf');
    // File('Output.pdf').writeAsBytes(document.save());
    // document.dispose();
  }

//   //Draws the invoice header
  PdfLayoutResult drawHeader(PdfPage page, Size pageSize, PdfGrid grid) {
    //Draw rec
    //Draw string
    page.graphics.drawString('${this.entrepriseSale['entreprise_name']}\n\n\r',
        PdfStandardFont(PdfFontFamily.helvetica, 4),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTRB(-60, 6, 100, 80),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
        ));
    page.graphics.drawString(
        "\n${this.entrepriseSale['entreprise_adresse']} \n ${this.entrepriseSale['entreprise_city']} ${this.entrepriseSale['entreprise_contry']}\n "
        "${this.entrepriseSale['entreprise_tel']} _ ${this.entrepriseSale['entreprise_tel1']} \n ${this.entrepriseSale['entreprise_email']}\n "
        " BP :  ${this.entrepriseSale['entreprise_Bp']}   ${this.entrepriseSale['entreprise_city']}\n *****************************  ",
        PdfStandardFont(PdfFontFamily.helvetica, 2),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTRB(-60, 8, 100, 80),
        format: PdfStringFormat(alignment: PdfTextAlignment.center));

    // page.graphics.drawString(
    //     "Bienvenue chez ${this.entrepriseSale['entreprise_name']}",
    //     PdfStandardFont(PdfFontFamily.helvetica, 4),
    //     brush: PdfBrushes.black,
    //     bounds: Rect.fromLTRB(-20, 18, 100, 80),
    //     format: PdfStringFormat(
    //       alignment: PdfTextAlignment.center,
    //     ));

    final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 4);

    final String invoiceNumber = '';
    final Size contentSize = contentFont.measureString(invoiceNumber);
    // ignore: leading_newlines_in_multiline_strings
    const String address = '';

    return PdfTextElement(text: address, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(30, 100,
            pageSize.width - (contentSize.width + 30), pageSize.height - 20))!;
  }

  //Draws the grid
  void drawGrid(PdfPage page, PdfGrid grid, PdfLayoutResult result, pageSize) {
    Rect? totalPriceCellBounds;
    Rect? quantityCellBounds;
    //Invoke the beginCellLayout event.
    grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
      final PdfGrid grid = sender as PdfGrid;

      if (args.cellIndex == grid.columns.count - 1) {
        totalPriceCellBounds = args.bounds;
      } else if (args.cellIndex == grid.columns.count - 2) {
        quantityCellBounds = args.bounds;
      }
    };
    //Draw the PDF grid and get the result.
    final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 4);
    ;

    result = grid.draw(page: page, bounds: Rect.fromLTWH(0, 26, 0, 110))!;

    //Draw grand total.
    page.graphics.drawString('   Montant Total : ',
        PdfStandardFont(PdfFontFamily.courier, 2, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(22, result.bounds.bottom + 1, 0, 20),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.right,
        ));

    page.graphics.drawString(' ${this.infoSale['sale_amount_has_paid']}\n\r',
        PdfStandardFont(PdfFontFamily.helvetica, 2, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(36, result.bounds.bottom + 1, 0, 20),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.right,
        ));
    page.graphics.drawString('   Montant A Payer :',
        PdfStandardFont(PdfFontFamily.courier, 2, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(22, result.bounds.bottom + 3, 0, 20),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.right,
        ));
    page.graphics.drawString(
        ' ${this.infoSale['sale_amount_has_paid'].toString()}\n\r',
        PdfStandardFont(PdfFontFamily.helvetica, 2, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(36, result.bounds.bottom + 3, 0, 20),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.right,
        ));
    page.graphics.drawString('   Montant Payer :',
        PdfStandardFont(PdfFontFamily.courier, 2, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(22, result.bounds.bottom + 5, 0, 20),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.right,
        ));
    page.graphics.drawString(
        ' ${this.infoSale['sale_amount_paid'].toString()}\n\n',
        PdfStandardFont(PdfFontFamily.helvetica, 2, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(36, result.bounds.bottom + 5, 0, 20),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.right,
        ));
    page.graphics.drawString('   Montant Rendu :',
        PdfStandardFont(PdfFontFamily.courier, 2, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(22, result.bounds.bottom + 7, 0, 20),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.right,
        ));
    page.graphics.drawString(
        ' ${this.infoSale['sale_amount_returned'].toString()}\n\n\r',
        PdfStandardFont(PdfFontFamily.helvetica, 2, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(36, result.bounds.bottom + 7, 0, 20),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.right,
        ));

    page.graphics.drawString(
        '## Au Plaisir De Vous Revoir! ## \n Merci Pour Votre Visite',
        PdfStandardFont(PdfFontFamily.courier, 2, style: PdfFontStyle.italic),
        bounds: Rect.fromLTWH(18, result.bounds.bottom + 12, 0, 20),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
        ));
    DateTime dateTime = DateTime.now();
    String TheDate = DateFormat('dd-MM-yyyy  hh:mm:ss').format(dateTime);
    final String NumVente = '${this.infoSale['sale_number']}';
    final String NumCaisse = '${this.numCheckout}';

    final Size contentSize = contentFont.measureString(TheDate);

    page.graphics.drawString(
        NumVente, PdfStandardFont(PdfFontFamily.helvetica, 2),
        format: PdfStringFormat(alignment: PdfTextAlignment.left),
        bounds: Rect.fromLTWH(30, result.bounds.bottom + 17,
            pageSize.width - (contentSize.width + 150), 10));
    page.graphics.drawString(
        NumCaisse, PdfStandardFont(PdfFontFamily.helvetica, 2),
        format: PdfStringFormat(alignment: PdfTextAlignment.left),
        bounds: Rect.fromLTWH(2, result.bounds.bottom + 17,
            pageSize.width - (contentSize.width + 150), 0));
    page.graphics.drawString(
        TheDate, PdfStandardFont(PdfFontFamily.helvetica, 2),
        format: PdfStringFormat(alignment: PdfTextAlignment.left),
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 17,
            pageSize.width - (contentSize.width + 150), 0));
/*
    page.graphics.drawString('******** Nous vous remercions de votre visite *******\n\n',
        PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(160, result.bounds.bottom + 110, 0, 20));
    page.graphics.drawString('A bientôt ',
        PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(250, result.bounds.bottom + 140, 0, 20));*/
    //  page.graphics.drawString(bar,
    // PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
    // bounds: Rect.fromLTWH(160, 350, 0, 20)
  }

  //Draw the invoice footer data.
  void drawFooter(PdfPage page, Size pageSize, document) {
    //Create the footer with specific bounds
    PdfPageTemplateElement footer =
        PdfPageTemplateElement(Rect.fromLTRB(-20, 20, 0, 15));

    //Create the page number field
    PdfPageNumberField pageNumber = PdfPageNumberField(
        font: PdfStandardFont(PdfFontFamily.courier, 3),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)));

    //Sets the number style for page number
    pageNumber.numberStyle = PdfNumberStyle.upperRoman;

    //Create the page count field
    PdfPageCountField count = PdfPageCountField(
        font: PdfStandardFont(PdfFontFamily.courier, 3),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)));

    //set the number style for page count
    count.numberStyle = PdfNumberStyle.upperRoman;

    //Create the date and time field
    PdfDateTimeField dateTimeField = PdfDateTimeField(
        font: PdfStandardFont(PdfFontFamily.timesRoman, 4),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)));

    //Sets the date and time
    dateTimeField.date = DateTime(2020, 2, 10, 13, 13, 13, 13, 13);

    //Sets the date and time format
    dateTimeField.dateFormatString = 'hh\':\'mm\':\'ss';
    PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 3);
    //Create the composite field with page number page count
    PdfCompositeField compositeField = PdfCompositeField(
        font: PdfStandardFont(PdfFontFamily.timesRoman, 10),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        text:
            '${this.entrepriseSale['entreprise_name']} \nVous remercie de votre visite.',
        fields: <PdfAutomaticField>[
          PdfPageNumberField(font: font, brush: PdfBrushes.black),
          PdfPageCountField(font: font, brush: PdfBrushes.black)
        ]);
    compositeField.bounds = footer.bounds;

//Add the composite field in footer
    compositeField.draw(footer.graphics,
        Offset(290, 50 - PdfStandardFont(PdfFontFamily.timesRoman, 6).height));

//Add the footer at the bottom of the document
    document.template.bottom = footer;
  }

  //Create PDF grid and return
  PdfGrid getGrid() {
    //Create a PDF grid
    final PdfGrid grid = PdfGrid();
    //Secify the columns count to the grid.
    grid.columns.add(count: 4);
    //Create the header row of the grid.
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    //Set style

    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor.empty);
    headerRow.style.textBrush = PdfBrushes.black;
    headerRow.style.font = PdfStandardFont(PdfFontFamily.timesRoman, 1);

    //headerRow.cells[0].value = '#';
    headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[1].stringFormat.alignment = PdfTextAlignment.left;
    headerRow.cells[2].stringFormat.alignment = PdfTextAlignment.left;
    headerRow.cells[3].stringFormat.alignment = PdfTextAlignment.left;
    headerRow.cells[1].style.font =
        PdfStandardFont(PdfFontFamily.timesRoman, 1);
    headerRow.cells[0].value = 'Titre';
    headerRow.cells[1].value = 'Prix';
    headerRow.cells[2].value = 'Qté';
    headerRow.cells[3].value = 'Total';
    headerRow.height = 4;

    //Add rows
    for (var i = 0; i < this.productsSale.length; i++) {
      addProducts(
          this.productsSale[i]['nom'],
          double.parse(this.productsSale[i]['pu']),
          int.parse(this.productsSale[i]['qte']),
          double.parse(this.productsSale[i]['prixTotal']),
          grid);
    }

    //Apply the table built-in style

    PdfGridBuiltInStyleSettings();

    grid.applyBuiltInStyle(
      PdfGridBuiltInStyle.listTable1LightAccent3,
    );
    //Set gird columns width
    grid.columns[0].width = 17;

    grid.columns[0].format = PdfStringFormat(
      alignment: PdfTextAlignment.left,
    );
    grid.columns[1].format = PdfStringFormat(alignment: PdfTextAlignment.left);
    grid.columns[2].format =
        PdfStringFormat(alignment: PdfTextAlignment.center);
    grid.columns[3].format = PdfStringFormat(alignment: PdfTextAlignment.left);
    grid.columns[1].width = 8;
    grid.columns[2].width = 3;
    grid.columns[3].width = 7;
    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.height = 3;
      headerRow.cells[i].style = PdfGridCellStyle(
        // backgroundBrush: PdfBrushes.lightYellow,
        cellPadding: PdfPaddings(left: 0, right: 0, top: 0, bottom: 0),
        font: PdfStandardFont(PdfFontFamily.helvetica, 2),
        // borders: PdfBorders(  PdfPen left:0,top: 0, bottom: 0,right: 0 );

        // textBrush: PdfBrushes.white,
        // textPen: PdfPens.orange,
      );

      // headerRow.cells[4].style = PdfGridCellStyle(
      //   // backgroundBrush: PdfBrushes.lightYellow,
      //   cellPadding: PdfPaddings(left: 0, right: 2, top: 0, bottom: 0),
      //   font: PdfStandardFont(PdfFontFamily.helvetica, 2),
      // );
    }
    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        if (j == 0) {
          cell.stringFormat.alignment = PdfTextAlignment.center;
          row.height = 3;
        }
        cell.style = PdfGridCellStyle(
          // backgroundBrush: PdfBrushes.lightYellow,
          cellPadding: PdfPaddings(left: 0, right: 0, top: 0, bottom: 0),
          font: PdfStandardFont(PdfFontFamily.timesRoman, 2),
          // textBrush: PdfBrushes.white,
          // textPen: PdfPens.orange,
        );
        PdfPaddings(bottom: 0, left: 0, right: 0, top: 0);
      }
    }
    ;
    return grid;
  }

  //Create and row for the grid.
  void addProducts(String productName, double price, int quantity, double total,
      PdfGrid grid) {
    final PdfGridRow row = grid.rows.add();

    row.cells[0].value = productName;
    row.cells[1].value = price.toString();
    row.cells[2].value = quantity.toString();
    row.cells[3].value = total.toString();
  }
}

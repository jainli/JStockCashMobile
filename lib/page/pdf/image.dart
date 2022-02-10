import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';


Future<String> image(String image) async {

  String imagepath = " /images/logo_noir.jpg";
  File imagefile = File(imagepath); //convert Path to File
  Uint8List imagebytes = await imagefile.readAsBytes(); //convert to bytes
  String base64string = base64.encode(imagebytes);
print(base64string);
  return base64string.toString();

}
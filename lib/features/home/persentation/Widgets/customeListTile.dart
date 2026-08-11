import 'package:flutter/material.dart';

class CustomeListTile extends StatelessWidget {
   CustomeListTile({super.key,this.ingreName,this.NoPieces});
  String? ingreName,NoPieces;
  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text("$ingreName",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
      trailing: Text("$NoPieces pcs",style: TextStyle(fontSize: 18),),
    );
  }
}

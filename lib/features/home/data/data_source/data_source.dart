import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../persentation/Cubits/DetailsCubit/DetailsCubit.dart';

abstract class BaseDataSource{
   getData();
   getdatawithid(context);
}
class DataSource extends BaseDataSource{
  List<QueryDocumentSnapshot> data=[];
  @override
  getData() async {

    // data.clear();
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Recipes")
          .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      data.addAll(querySnapshot.docs);
    } catch (e) {
      print("Error fetching data: $e");
      return [];
    }
    return data;
  }

  //with id
  @override
  List<QueryDocumentSnapshot> datawithref=[];
  getdatawithid(context)async {
    QuerySnapshot querySnapshot=await FirebaseFirestore.instance.collection("Recipes").where("typeofmeal",isEqualTo:
    BlocProvider.of<DetailsCubit>(context).reff).get();
    datawithref.addAll(querySnapshot.docs);
    print(datawithref);
    return datawithref;
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../persentation/Cubits/DetailsCubit/DetailsCubit.dart';

abstract class BaseDataSource{
   getdata();
   getdatawithid(context);
}
class DataSource extends BaseDataSource{
  List<QueryDocumentSnapshot> data=[];
  @override
   getdata()async {
    QuerySnapshot querySnapshot =await FirebaseFirestore.instance.collection("Recipes").get();
    data.addAll(querySnapshot.docs);
    print(data);
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
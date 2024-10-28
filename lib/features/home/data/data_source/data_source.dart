import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseDataSource{
   getdata();
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
}
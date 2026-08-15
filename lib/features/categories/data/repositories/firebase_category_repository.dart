// /// [ICategoryRepository] backed by the `categories` Firestore collection.
// class FirebaseCategoryRepository implements ICategoryRepository {
//   FirebaseCategoryRepository({FirebaseFirestore? firestore})
//     : _firestore = firestore ?? FirebaseFirestore.instance;

//   final FirebaseFirestore _firestore;

//   @override
//   Future<List<CategoryModel>> getCategories() async {
//     final snapshot = await _firestore
//         .collection('categories')
//         .orderBy('order')
//         .get();

//     return snapshot.docs
//         .map((doc) => CategoryModel.fromJson({...doc.data(), 'id': doc.id}))
//         .toList();
//   }
// }

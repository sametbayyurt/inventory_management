import 'package:inventory_management/data/entity/categories.dart';
import 'package:inventory_management/data/entity/products.dart';
import 'package:inventory_management/sqlite/database_helper.dart';

class InventoryDaoRepository {

  Future<void> save(String name, int stock, int category_id) async {
    var db = await DatabaseHelper.databaseAccess();
    var newProduct = Map<String, dynamic>();
    newProduct["name"] = name;
    newProduct["stock"] = stock;
    newProduct["category_id"] = category_id;
    await db.insert("products", newProduct);
  }

  Future<List<Categories>> loadCategories() async {
    var db = await DatabaseHelper.databaseAccess();
    List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM categories");

    return List.generate(maps.length, (i) {
      var row = maps[i];
      return Categories(id: row["id"], name: row["name"]);
    });
  }

  Future<List<Products>> loadProducts() async {
    var db = await DatabaseHelper.databaseAccess();

    List<Map<String, dynamic>> maps = await db.rawQuery("""
        SELECT 
          products.id,
          products.name,
          products.stock,
          products.category_id,
          categories.name AS category_name
          FROM products
          JOIN categories
          ON products.category_id = categories.id
        """);

    return List.generate(maps.length, (i) {
      var row = maps[i];
      return Products(
        id: row["id"],
        name: row["name"],
        stock: row["stock"],
        categoryId: row["category_id"],
        categoryName: row["category_name"],
      );
    });
  }

  Future<List<Products>> search(String searchResult) async {
    var db = await DatabaseHelper.databaseAccess();

    List<Map<String, dynamic>> maps = await db.rawQuery("""
        SELECT 
            p.id,
            p.name,
            p.stock,
            p.category_id,
            c.name AS category_name
            FROM products p
            JOIN categories c
            ON p.category_id = c.id
            WHERE p.name LIKE '%$searchResult%'
        """);

    return List.generate(maps.length, (i) {
      var row = maps[i];
      return Products(
        id: row["id"],
        name: row["name"],
        stock: row["stock"],
        categoryId: row["category_id"],   // ✅
        categoryName: row["category_name"],
      );
    });
  }

  Future<void> delete(int id) async{
    var db = await DatabaseHelper.databaseAccess();
    await db.delete("products", where: "id = ?",whereArgs: [id]);
  }

  Future<void> update(int id, String name, int stock, int categoryId) async{
    var db = await DatabaseHelper.databaseAccess();
    var updatedProduct = Map<String,dynamic>();
    updatedProduct["name"] = name;
    updatedProduct["stock"] = stock;
    updatedProduct["category_id"] = categoryId;
    await db.update("products", updatedProduct, where: "id = ?",whereArgs: [id]);
  }

  Future<Products> getProductById(int id) async {
    var db = await DatabaseHelper.databaseAccess();

    List<Map<String, dynamic>> maps = await db.rawQuery("""
    SELECT 
      products.id,
      products.name,
      products.stock,
      products.category_id,
      categories.name AS category_name
    FROM products
    JOIN categories
      ON products.category_id = categories.id
    WHERE products.id = ?
  """, [id]);

    if (maps.isNotEmpty) {
      var row = maps.first;
      return Products(
        id: row["id"],
        name: row["name"],
        stock: row["stock"],
        categoryId: row["category_id"],
        categoryName: row["category_name"],
      );
    } else {
      throw Exception("Ürün bulunamadı");
    }
  }

}

import 'dart:convert';

List<Product> productFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  Product({
    this.id,
    this.name,
    this.image,
    this.brand,
    this.package,
    this.price,
    this.rating,
    this.qty,
    this.date,
  });

  int id;
  String name;
  String image;
  String brand;
  String package;
  int price;
  int qty;
  double rating;
  String date;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    name: json["name"],
    image: json["image_url"],
    brand: json["brand_name"],
    package: json["package_name"],
    price: json["price"],
    qty: json["qty"],
    date: json["date"],
    rating: json["rating"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image_url": image,
    "brand_name": brand,
    "package_name": package,
    "price": price,
    "rating": rating,
    "qty": qty,
    "date": date,
  };
}

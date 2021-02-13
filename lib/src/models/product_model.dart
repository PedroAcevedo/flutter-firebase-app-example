import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
    Product({
        this.id,
        this.title = '',
        this.value = 0.0,
        this.available = true,
        this.url,
    });

    String id; 
    String title;
    double value;
    bool available;
    String url;

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        id          : json["id"],
        title       : json["title"],
        value       : json["value"],
        available   : json["available"],
        url         : json["url"],
    );

    Map<String, dynamic> toJson() => {
        "title"       : title,
        "value"       : value,
        "available"   : available,
        "url"         : url,
    };
}
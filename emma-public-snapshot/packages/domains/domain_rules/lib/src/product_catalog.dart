enum ProductCatalogStatus { simulationOnly, gateRequired }

class ProductCatalogProduct {
  const ProductCatalogProduct({
    required this.id,
    required this.label,
    required this.status,
    required this.gateNote,
  });

  final String id;
  final String label;
  final ProductCatalogStatus status;
  final String gateNote;
}

abstract interface class ProductCatalogPort {
  Future<List<ProductCatalogProduct>> listProducts();
}

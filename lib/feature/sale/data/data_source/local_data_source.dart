abstract class SalesHistoryLocalDataSource {
  Future<List<Map<String, dynamic>>> getSales();

  Future<List<Map<String, dynamic>>> searchSales(String keyword);

  Future<List<Map<String, dynamic>>> getSaleItems(int saleId);
  Future<void> reopenOrder(int saleId);

  Future<void> deleteSale(int saleId);
}
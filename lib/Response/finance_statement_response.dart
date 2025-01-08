

class FinanceStatementResponse {
  FinanceStatementResponse({
    this.statementData,
});
  FinanceStatementResponse.fromJson(Map<String, dynamic> json){
    statementData = json['data'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['data'] ?? {})]
        : List<Map<String, dynamic>>.from(json['data'] ?? []);
  }
  List<Map<String, dynamic>>? statementData;
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/exchange_rate_model.dart';
import '../../core/constants/api_constants.dart';
import '../../core/errors/exceptions.dart';

/// Interface pour la source de données distante
abstract class CurrencyRemoteDataSource {
  Future<ExchangeRateModel> getExchangeRates(String baseCurrency);
}

/// Implémentation de la source de données distante
class CurrencyRemoteDataSourceImpl implements CurrencyRemoteDataSource {
  final http.Client client;

  CurrencyRemoteDataSourceImpl({required this.client});

  @override
  Future<ExchangeRateModel> getExchangeRates(String baseCurrency) async {
    final url = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.latestEndpoint}/$baseCurrency',
    );

    try {
      final response = await client.get(url).timeout(ApiConstants.timeout);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return ExchangeRateModel.fromJson(json);
      } else {
        throw ServerException(
          'Erreur ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } on http.ClientException catch (e) {
      throw NetworkException('Erreur réseau: ${e.message}');
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Erreur lors de la récupération des taux: $e');
    }
  }
}
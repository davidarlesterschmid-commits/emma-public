import 'package:dio/dio.dart';
import 'package:domain_employer_mobility/domain_employer_mobility.dart';

/// Remote side of the benefit repository.
abstract interface class BenefitRemoteDataSource {
  Future<List<Benefit>> getBenefits();
}

class BenefitRemoteDataSourceImpl implements BenefitRemoteDataSource {
  BenefitRemoteDataSourceImpl(this._dio);

  // ignore: unused_field
  final Dio _dio;

  @override
  Future<List<Benefit>> getBenefits() async {
    // TODO(emma-employer): replace with Partnerhub catalogue endpoint.
    await Future<void>.delayed(const Duration(seconds: 1));
    return [
      Benefit(
        id: '1',
        name: 'nextbike MonatTicket',
        description: 'Unbegrenztes Bikesharing in Leipzig',
        partnerName: 'nextbike',
        isInBudget: true,
        deepLink: 'https://nextbike.de/app',
        voucherCode: null,
        logoUrl: null,
      ),
      Benefit(
        id: '2',
        name: 'teilAuto Monatspaket',
        description: 'Car-Sharing für Geschäftsfahrten',
        partnerName: 'teilAuto',
        isInBudget: true,
        voucherCode: 'EMMA2024',
        deepLink: null,
        logoUrl: null,
      ),
      Benefit(
        id: '3',
        name: 'DB Bahncard 25',
        description: 'Rabatt auf Bahnfahrten',
        partnerName: 'Deutsche Bahn',
        isInBudget: false,
        deepLink: 'https://www.bahn.de',
        voucherCode: null,
        logoUrl: null,
      ),
    ];
  }
}

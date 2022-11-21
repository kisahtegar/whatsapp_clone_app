import 'package:whatsapp_clone_app/data/data_sources/local_data_sources/local_data_source.dart';
import 'package:whatsapp_clone_app/domain/entities/contact_entity.dart';
import 'package:whatsapp_clone_app/domain/repositories/get_device_number_repository.dart';

class GetDeviceNumberRepositoryImpl extends GetDeviceNumberRepository {
  final LocalDataSource localDataSource;

  GetDeviceNumberRepositoryImpl({required this.localDataSource});

  @override
  Future<List<ContactEntity>> getDeviceNumbers() =>
      localDataSource.getDeviceNumbers();
}

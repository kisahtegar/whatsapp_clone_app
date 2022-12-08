import 'package:contacts_service/contacts_service.dart';

import '../../../domain/entities/contact_entity.dart';

abstract class LocalDataSource {
  Future<List<ContactEntity>> getDeviceNumbers();
}

class LocalDataSourceImpl extends LocalDataSource {
  @override
  Future<List<ContactEntity>> getDeviceNumbers() async {
    List<ContactEntity> contacts = [];
    final getContactsData = await ContactsService.getContacts();

    for (var myContact in getContactsData) {
      myContact.phones?.forEach((phoneData) {
        contacts.add(ContactEntity(
          phoneNumber: phoneData.value,
          label: myContact.displayName,
        ));
      });
    }
    return contacts;
  }
}

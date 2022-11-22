import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_clone_app/domain/entities/user_entity.dart';
import 'package:whatsapp_clone_app/presentation/bloc/get_device_number/get_device_number_cubit.dart';
import 'package:whatsapp_clone_app/presentation/bloc/user/user_cubit.dart';
import 'package:whatsapp_clone_app/presentation/pages/sub_pages/single_communication_page.dart';
import 'package:whatsapp_clone_app/presentation/widgets/theme/style.dart';

import '../../../domain/entities/contact_entity.dart';

class SelectContactPage extends StatefulWidget {
  final UserEntity userInfo;

  const SelectContactPage({super.key, required this.userInfo});

  @override
  State<SelectContactPage> createState() => _SelectContactPageState();
}

class _SelectContactPageState extends State<SelectContactPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<GetDeviceNumberCubit>(context).getDeviceNumbers();
    _requestContactPermission();
  }

  Future<void> _requestContactPermission() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      print("Permission is granted");
    } else if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
      if (await Permission.contacts.request().isGranted) {
        // Either the permission was already granted before or the user just granted it.
        print("Permission was granted");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetDeviceNumberCubit, GetDeviceNumberState>(
      builder: (context, getDeviceNumberState) {
        if (getDeviceNumberState is GetDeviceNumberLoaded) {
          return BlocBuilder<UserCubit, UserState>(
            builder: (context, userState) {
              if (userState is UserLoaded) {
                final List<ContactEntity> contacts = [];
                final dbUsers = userState.users
                    .where((user) => user.uid != widget.userInfo.uid)
                    .toList();

                getDeviceNumberState.contacts.forEach((deviceUserNumber) {
                  dbUsers.forEach((dbUser) {
                    if (dbUser.phoneNumber ==
                        deviceUserNumber.phoneNumber!.replaceAll('', '')) {
                      contacts.add(ContactEntity(
                        label: dbUser.name,
                        phoneNumber: dbUser.phoneNumber,
                        uid: dbUser.uid,
                        status: dbUser.status,
                      ));
                    }
                  });
                });

                // NOTE: When UserLoaded return to this page
                return Scaffold(
                  appBar: AppBar(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Select Contact"),
                        Text(
                          "${contacts.length} contacts",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    actions: const [
                      Icon(Icons.search),
                      Icon(Icons.more_vert),
                    ],
                  ),
                  body: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: Column(
                      children: [
                        _newGroupButtonWidget(),
                        const SizedBox(height: 10),
                        _newContactButtonWidget(),
                        const SizedBox(height: 10),
                        _listContact(contacts),
                      ],
                    ),
                  ),
                );
              }
              // NOTE: UserLoading/Failure
              debugPrint("UserLoading/Failure");
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            },
          );
        }
        // NOTE: GetDeviceNumberLoading/Failure
        debugPrint("GetDeviceNumberLoading/Failure");
        return Container();
      },
    );
  }

  Widget _newGroupButtonWidget() {
    return Container(
      child: Row(
        children: [
          Container(
            height: 45,
            width: 45,
            decoration: const BoxDecoration(
              color: greenColor,
              borderRadius: BorderRadius.all(Radius.circular(40)),
            ),
            child: const Icon(
              Icons.people,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 15),
          const Text(
            "New Group",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _newContactButtonWidget() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 45,
                width: 45,
                decoration: const BoxDecoration(
                    color: greenColor,
                    borderRadius: BorderRadius.all(Radius.circular(40))),
                child: const Icon(
                  Icons.person_add,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              const Text(
                "New contact",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Icon(
            Icons.qr_code,
            color: greenColor,
          )
        ],
      ),
    );
  }

  Widget _listContact(List<ContactEntity> contacts) {
    return Expanded(
      child: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              BlocProvider.of<UserCubit>(context).createChatChannel(
                uid: widget.userInfo.uid!,
                otherUid: contacts[index].uid!,
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SingleCommunicationPage(
                    recipientName: contacts[index].label!,
                    recipientUID: contacts[index].uid!,
                    recipientPhoneNumber: contacts[index].phoneNumber!,
                    senderPhoneNumber: widget.userInfo.phoneNumber!,
                    senderName: widget.userInfo.name!,
                    senderUID: widget.userInfo.uid!,
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 55,
                        width: 55,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        child: Image.asset('assets/profile_default.png'),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${contacts[index].label}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              "Hey there! I am Using WhatsApp Clone.",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_clone_app/presentation/bloc/auth/auth_cubit.dart';
import 'package:whatsapp_clone_app/presentation/bloc/phone_auth/phone_auth_cubit.dart';
import 'package:whatsapp_clone_app/presentation/pages/phone_verification_page.dart';
import 'package:whatsapp_clone_app/presentation/pages/set_initial_profile_page.dart';
import 'package:whatsapp_clone_app/presentation/screens/home_screen.dart';
import 'package:whatsapp_clone_app/presentation/widgets/theme/style.dart';

import '../../data/models/user_model.dart';
import '../bloc/user/user_cubit.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  static Country _selectedFilteredDialogCountry =
      CountryPickerUtils.getCountryByPhoneCode("62");
  String _countryCode = _selectedFilteredDialogCountry.phoneCode;
  String _phoneNumber = "";

  TextEditingController _phoneAuthController = TextEditingController();

  @override
  void dispose() {
    _phoneAuthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("RegistrationScreen: Building!");
    return Scaffold(
      body: BlocConsumer<PhoneAuthCubit, PhoneAuthState>(
        listener: (context, phoneAuthstate) {
          if (phoneAuthstate is PhoneAuthSuccess) {
            BlocProvider.of<AuthCubit>(context).loggedIn();
          }
          if (phoneAuthstate is PhoneAuthFailure) {
            toast("Something wrong");
          }
        },
        builder: (context, phoneAuthState) {
          if (phoneAuthState is PhoneAuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (phoneAuthState is PhoneAuthSmsCodeReceived) {
            return PhoneVerificationPage(phoneNumber: _phoneNumber);
          }
          if (phoneAuthState is PhoneAuthProfileInfo) {
            return SetInitialProfilePage(phoneNumber: _phoneNumber);
          }
          if (phoneAuthState is PhoneAuthSuccess) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                if (authState is Authenticated) {
                  return BlocBuilder<UserCubit, UserState>(
                    builder: (context, userState) {
                      if (userState is UserLoaded) {
                        final currentUserInfo = userState.users.firstWhere(
                          (user) => user.uid == authState.uid,
                          orElse: () => const UserModel(),
                        );
                        return HomeScreen(userInfo: currentUserInfo);
                      }
                      debugPrint("RegistrationScreen: UserLoading/Failure");
                      return Container();
                    },
                  );
                }
                debugPrint("RegistrationScreen: UnAuthenticated");
                return Container();
              },
            );
          }
          debugPrint("RegistrationScreen: PhoneAuthLoading/Failure");
          return _bodyWidget(context);
        },
      ),
    );
  }

  Container _bodyWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        children: <Widget>[
          // NOTE: Top Text and Description
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const <Widget>[
              Text(""),
              Text(
                "Verify your phone number",
                style: TextStyle(
                  fontSize: 18,
                  color: greenColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(Icons.more_vert)
            ],
          ),
          const SizedBox(height: 30),
          const Text(
            "WhatsApp Clone will send and SMS message (carrier charges may apply) to verify your phone number. Enter your country code and phone number:",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 30),

          // NOTE: ListTile for List country
          ListTile(
            onTap: _openFilteredCountryPickerDialog,
            title: _buildDialogItem(_selectedFilteredDialogCountry),
          ),

          // NOTE: Phone Number Input
          Row(
            children: <Widget>[
              // Phone Code
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1.50,
                      color: greenColor,
                    ),
                  ),
                ),
                width: 80,
                height: 42,
                alignment: Alignment.center,
                child: Text(_selectedFilteredDialogCountry.phoneCode),
              ),
              const SizedBox(width: 8.0),
              // Input phone number
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    controller: _phoneAuthController,
                    decoration: const InputDecoration(hintText: "Phone Number"),
                  ),
                ),
              ),
            ],
          ),

          // NOTE: Next Button
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: MaterialButton(
                color: greenColor,
                onPressed: _submitVerifyPhoneNumber,
                child: const Text(
                  "Next",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _openFilteredCountryPickerDialog() {
    showDialog(
      context: context,
      builder: (_) => Theme(
        data: Theme.of(context).copyWith(primaryColor: primaryColor),
        child: CountryPickerDialog(
          titlePadding: const EdgeInsets.all(8.0),
          searchCursorColor: Colors.black,
          isSearchable: true,
          title: const Text("Select your phone code"),
          searchInputDecoration: const InputDecoration(
            hintText: "Search",
          ),
          itemBuilder: _buildDialogItem,
          onValuePicked: (Country country) {
            setState(() {
              _selectedFilteredDialogCountry = country;
              _countryCode = country.phoneCode;
            });
          },
        ),
      ),
    );
  }

  Widget _buildDialogItem(Country country) {
    return Container(
      height: 40,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: greenColor, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          const SizedBox(
            height: 8.0,
          ),
          Text(" +${country.phoneCode}   "),
          const SizedBox(
            height: 8.0,
          ),
          Text(country.name),
          const Spacer(),
          const Icon(Icons.arrow_drop_down)
        ],
      ),
    );
  }

  void _submitVerifyPhoneNumber() {
    if (_phoneAuthController.text.isNotEmpty) {
      _phoneNumber = "+$_countryCode${_phoneAuthController.text}";
      BlocProvider.of<PhoneAuthCubit>(context).submitVerifyPhoneNumber(
        phoneNumber: _phoneNumber,
      );
    }
  }
}

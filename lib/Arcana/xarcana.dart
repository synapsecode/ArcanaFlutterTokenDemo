import 'dart:async';
import 'package:arcana_auth_flutter/arcana_sdk.dart' as ac;
import 'package:flutter/material.dart';

import 'arcana_credential.dart';

class XArcana {
  //Instance Variables
  final arcana = ac.AuthProvider(
    clientId: "xar_test_e506e3cab55e498e7cb881d936aeb53c8c3ebc00",
  );

  String arcanaAccountAddress = '';
  ArcanaEthereumCredentials? arcanaETHCredentials;

  //Static Variables
  static const String appID = 'com.ratofy.ratofy';
  static XArcana instance = XArcana();

  Future<void> loginToArcana(BuildContext context) async {
    //Initiating Arcana
    arcana.init(context: context);
    //Sign In to Arcana first
    await arcana.loginWithSocial("google");
    arcanaAccountAddress = await arcana.getAccount();
    arcanaETHCredentials = ArcanaEthereumCredentials(
      auth: arcana,
      account: arcanaAccountAddress,
    );
  }

  logout() async {
    arcana.logout();
  }

  void showArcanaWallet() {
    arcana.showWallet();
  }
}

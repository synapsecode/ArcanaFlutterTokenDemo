import 'package:arcanamint/Arcana/xarcana.dart';
import 'package:arcanamint/NFT/nftcontroller.dart';
import 'package:flutter/material.dart';

import 'Arcana/arcana_mint.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Regular Mint'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Text('ArcanaAddress: ${XArcana.instance.arcanaAccountAddress}'),
            ElevatedButton(
              child: Text('Login 2 Arcana'),
              onPressed: () async {
                await XArcana.instance.loginToArcana(context);
                setState(() {});
              },
            ),
            ElevatedButton(
              child: Text('Show Arcana Wallet'),
              onPressed: () async {
                XArcana.instance.showArcanaWallet();
                setState(() {});
              },
            ),
            ElevatedButton(
              child: Text('Mint using Web3Dart and NFT Contract'),
              onPressed: () async {
                if (XArcana.instance.arcana.isLoggedIn() == false) return;
                await NftController().createToken(context, '', '', '', 0);
              },
            ),
            ElevatedButton(
              child: Text('Mint using Arcana Request'),
              onPressed: () async {
                if (XArcana.instance.arcana.isLoggedIn() == false) return;
                await ArcanaMinter().createTokenUsingArcana();
              },
            )
          ],
        ),
      ),
    );
  }
}

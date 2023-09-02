import 'dart:async';
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:arcanamint/Arcana/xarcana.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

import '../Arcana/arcana_credential.dart';
import '../logging.dart';
import 'NFT.g.dart';

class NftController {
  static NftController? _instance;
  factory NftController() => _instance ??= NftController._();

  late http.Client httpClient;
  late Web3Client ethClient;

  //---FOR PROD---//
  // var apiUrl = "https://polygon-mainnet.g.alchemy.com/v2/iAfmPploCy3DaPRzVz0EtpoWPFGctNI_";
  // var nftContractAddress = EthereumAddress.fromHex("0x63c05a2A000f99BC3d021723AB06eA423FFF9323");
  // var nftMarketplaceContractAddress = EthereumAddress.fromHex("0x5C86F9a387987F0d5871849E0435C85982E0CADA");
  //--END--//

  //--FOR DEV--//
  var apiUrl =
      "https://rpc-mumbai.maticvigil.com/v1/55a87ebf030da27ae3365afef8cf3927a371eb3c";
  var nftContractAddress =
      EthereumAddress.fromHex("0x9fBa5F3bAcD95d284aFe545B38bE7a7b132B005b");
  var nftMarketplaceContractAddress =
      EthereumAddress.fromHex("0x5Fae44F1D90d03C9bfDEa012f961f9bbA57f21A9");
  //--END--//

  NftController._() {
    init();
  }

  Future<bool> createToken(
    BuildContext context,
    String name,
    String desc,
    String url,
    int price,
  ) async {
    try {
      print('CreateToken Called');
      Web3Client client = Web3Client(apiUrl, httpClient);
      final ethCred = await getEthCred(context);
      print('ETH_CRED_RECEIVED');
      NFT nft = NFT(address: nftContractAddress, client: client);
      String r = "";
      print('Using Address => ${XArcana.instance.arcanaAccountAddress}');
      // openSignerApp();
      const data =
          'https://s3.amazonaws.com/images.seroundtable.com/google-images-test-1554379850.jpg';
      try {
        r = await nft.createToken(
          data,
          credentials: ethCred,
          transaction: Transaction(
            from:
                EthereumAddress.fromHex(XArcana.instance.arcanaAccountAddress),
          ),
        );
        print('NFT_TOKEN_CREATED');
      } catch (e) {
        Logging().log.e(e);
        print('ERRRRRORRRR => $e');
        return false;
      }

      debugPrint(r);

      int? tokenId;
      Completer c = Completer();
      Timer.periodic(const Duration(milliseconds: 500), (timer) async {
        var reciept = await client.getTransactionReceipt(r);
        debugPrint((reciept != null).toString());
        if (reciept != null && reciept.status != null && reciept.status!) {
          timer.cancel();
          var hexTokenId = reciept.logs[0].topics?[3];
          if (hexTokenId != null) {
            tokenId = hexToDartInt(hexTokenId);
            debugPrint(tokenId.toString());
          }
          if (!c.isCompleted) {
            c.complete();
          }
        }
      });
      await c.future;
      client.dispose();
      if (tokenId == null) {
        return false;
      } else {
        print('PUTTING FOR SALE!!!!!');
        // await putForSale(tokenId!, price);
      }
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  void init() async {
    httpClient = http.Client();
    ethClient = Web3Client(apiUrl, httpClient);
  }

  void dispose() {
    _instance?.dispose();
  }

  Future<ArcanaEthereumCredentials> getEthCred(BuildContext context) async {
    final ethCred = XArcana.instance.arcanaETHCredentials;
    if (ethCred == null) {
      //Retrying with LOGIN
      await XArcana.instance.loginToArcana(context);
      return XArcana.instance.arcanaETHCredentials!; //TODO: handle errors here
    }
    return ethCred;
  }
}

import 'package:arcanamint/Arcana/xarcana.dart';
import 'package:arcanamint/logging.dart';

class ArcanaMinter {
  createTokenUsingArcana() async {
    // await addETHChain();
    // print('ETHCHAINADDED');
    // await switchChain();
    // print('ETHCHAINSWITCHED');
    await watchAsset();
  }

  watchAsset() async {
    final arcana = XArcana.instance.arcana;
    try {
      final x = await arcana.request(method: "wallet_watchAsset", params: {
        "type": "ERC20",
        "options": {
          "address": "0x9fBa5F3bAcD95d284aFe545B38bE7a7b132B005b",
          "symbol": "TEST1",
          "decimals": 18,
          "image":
              "https://s3.amazonaws.com/images.seroundtable.com/google-images-test-1554379850.jpg"
        }
      });
      print("RECEIVED ===> $x");
    } catch (e) {
      print(e);
      Logging().log.e(e);
    }
  }

  addETHChain() async {
    final arcana = XArcana.instance.arcana;
    await arcana.request(method: "wallet_addEthereumChain", params: [
      {
        "blockExplorerUrls": ["https://polygonscan.com/"],
        "iconUrls": [],
        "rpcUrls": ["https://polygon-rpc.com/"],
        "chainId": "0x89",
        "chainName": "Polygon Mainnet",
        "nativeCurrency": {"name": "MATIC", "symbol": "MATIC", "decimals": 18}
      }
    ]);
  }

  switchChain() async {
    final arcana = XArcana.instance.arcana;
    await arcana.request(method: "wallet_switchEthereumChain", params: [
      {"chainId": "0x89"}
    ]);
  }
}

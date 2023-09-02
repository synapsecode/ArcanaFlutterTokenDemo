import 'dart:async';
import 'dart:typed_data';
import 'package:arcana_auth_flutter/arcana_sdk.dart';
import 'package:convert/convert.dart';
import 'package:web3dart/src/crypto/secp256k1.dart';
import 'package:web3dart/web3dart.dart';

class ArcanaEthereumCredentials extends CustomTransactionSender {
  ArcanaEthereumCredentials({required this.auth, required this.account});

  final AuthProvider auth;
  final String account;

  @override
  Future<EthereumAddress> extractAddress() {
    return getEthAdd();
  }

  Future<EthereumAddress> getEthAdd() async {
    return EthereumAddress.fromHex(account);
  }

  @override
  Future<String> sendTransaction(Transaction transaction) async {
    final hash = await auth.sendTransaction(params: {
      "to": transaction.to?.hex,
      "value": transaction.value?.getInWei,
      "data": transaction.data,
      "gas": transaction.maxGas,
      "gasPrice": transaction.gasPrice?.getInWei,
      "nonce": transaction.nonce,
    });
    return hash;
  }

  @override
  Future<MsgSignature> signToSignature(Uint8List payload,
      {int? chainId, bool isEIP1559 = false}) async {
    String message = '0x${hex.encode(payload)}';
    String hash = '';

    try {
      String value = await auth.request(
        method: 'personal_sign',
        params: [message, account],
      );

      hash = value;
      ByteData byteData = ByteData.view(
          Uint8List.fromList(hex.decode(hash.substring(2))).buffer);
      BigInt value1 = BigInt.from(byteData.getInt64(0));
      BigInt value2 = BigInt.from(byteData.getInt64(8));
      int value3 = byteData.getInt32(16);
      MsgSignature msgSignature = MsgSignature(value1, value2, value3);
      return msgSignature;
    } catch (err) {
      return MsgSignature(BigInt.from(0), BigInt.from(0), 0);
    }
  }

  Future<MsgSignature> getMS() async {
    return MsgSignature(BigInt.from(0), BigInt.from(0), 0);
  }

  @override
  EthereumAddress get address => EthereumAddress.fromHex(account);

  @override
  MsgSignature signToEcSignature(
    Uint8List payload, {
    int? chainId,
    bool isEIP1559 = false,
  }) {
    return MsgSignature(BigInt.from(0), BigInt.from(0), 0);
  }
}

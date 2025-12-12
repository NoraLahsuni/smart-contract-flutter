import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

class ContractLinking extends ChangeNotifier {
  // Variables de configuration
  final String _rpcUrl = "http://127.0.0.1:7545";
  final String _privateKey = "0x94537466a57823a23b0de00aca9c159ac427b3da4a5f31243aafeb3d6239af29";

  // Variables déclarées
  late Web3Client _client;
  bool isLoading = true;
  late String _abiCode;
  late EthereumAddress _contractAddress;
  late Credentials _credentials;
  late DeployedContract _contract;
  late ContractFunction _yourName;
  late ContractFunction _setName;
  String deployedName = ""; // CHANGÉ: Initialisé à vide

  // Constructeur
  ContractLinking() {
    initialSetup();
  }

  // Initialisation
  Future<void> initialSetup() async {
    try {
      print("🚀 Initialisation de la connexion...");
      _client = Web3Client(_rpcUrl, Client());
      
      await getAbi();
      await getCredentials();
      await getDeployedContract();
      
      print("✅ Initialisation terminée");
    } catch (e) {
      print("❌ Erreur d'initialisation: $e");
      deployedName = "Erreur";
      isLoading = false;
      notifyListeners();
    }
  }

  // Récupérer l'ABI du contrat
  Future<void> getAbi() async {
    try {
      print("📄 Chargement de l'ABI...");
      String abiStringFile = await rootBundle.loadString("src/artifacts/HelloWorld.json");
      var jsonAbi = jsonDecode(abiStringFile);
      _abiCode = jsonEncode(jsonAbi["abi"]);
      
      // Récupération de l'adresse du contrat déployé
      _contractAddress = EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
      
      print("📍 Contrat trouvé à l'adresse: ${_contractAddress.hex}");
    } catch (e) {
      print("❌ Erreur lecture ABI: $e");
      throw Exception("Impossible de charger l'ABI du contrat");
    }
  }

  // Obtenir les credentials
  Future<void> getCredentials() async {
    try {
      print("🔑 Obtention des credentials...");
      
      // Nettoyer la clé privée
      String cleanPrivateKey = _privateKey.trim();
      if (cleanPrivateKey.startsWith('0x')) {
        cleanPrivateKey = cleanPrivateKey.substring(2);
      }
      
      print("🔐 Clé utilisée (début): ${cleanPrivateKey.substring(0, 10)}...");
      
      _credentials = EthPrivateKey.fromHex(cleanPrivateKey);
      final address = await _credentials.extractAddress();
      print("👤 Compte connecté: ${address.hex}");
      
      // Vérifier le solde
      final balance = await _client.getBalance(address);
      print("💰 Solde: ${balance.getValueInUnit(EtherUnit.ether)} ETH");
      
    } catch (e) {
      print("❌ Erreur credentials: $e");
      throw Exception("Clé privée invalide");
    }
  }

  // Obtenir le contrat déployé
  Future<void> getDeployedContract() async {
    try {
      print("📦 Chargement du contrat...");
      
      _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "HelloWorld"),
        _contractAddress
      );
      
      _yourName = _contract.function("yourName");
      _setName = _contract.function("setName");
      
      await getName();
    } catch (e) {
      print("❌ Erreur contrat: $e");
      throw Exception("Impossible de charger le contrat");
    }
  }

  // Obtenir le nom actuel
  Future<void> getName() async {
    try {
      print("📖 Lecture du nom...");
      
      var currentName = await _client.call(
        contract: _contract,
        function: _yourName,
        params: []
      );
      
      deployedName = currentName[0].toString();
      isLoading = false;
      notifyListeners();
      
      print("✅ Nom récupéré: '$deployedName'");
    } catch (e) {
      print("❌ Erreur lecture nom: $e");
      deployedName = "Erreur";
      isLoading = false;
      notifyListeners();
    }
  }

  // Définir un nouveau nom - CORRIGÉ
  Future<void> setName(String nameToSet) async {
    try {
      if (nameToSet.isEmpty) {
        throw Exception("Le nom ne peut pas être vide");
      }
      
      print("✏️ Tentative changement vers: '$nameToSet'");
      isLoading = true;
      notifyListeners();
      
      // Obtenir l'adresse du compte
      final address = await _credentials.extractAddress();
      print("📤 Envoi depuis: ${address.hex}");
      
      // Envoyer la transaction avec chainId pour Ganache
      await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
          contract: _contract,
          function: _setName,
          parameters: [nameToSet],
          from: address,
          maxGas: 100000,
        ),
        chainId: 1337, // IMPORTANT: Ajouté pour Ganache
      );
      
      print("✅ Transaction envoyée");
      
      // Attendre la confirmation
      await Future.delayed(Duration(seconds: 3));
      
      // Récupérer le nouveau nom
      await getName();
      
      print("🎉 Nom changé avec succès");
      
    } catch (e) {
      print("❌ ERREUR set name: $e");
      print("🔍 Type: ${e.runtimeType}");
      
      isLoading = false;
      notifyListeners();
      
      // Messages d'erreur plus clairs
      if (e.toString().contains("Invalid signature") || e.toString().contains("-32700")) {
        throw Exception("ERREUR: Clé privée invalide ou signature incorrecte");
      } else if (e.toString().contains("insufficient funds")) {
        throw Exception("ERREUR: Solde insuffisant");
      } else {
        throw Exception("Échec: $e");
      }
    }
  }
  
  // AJOUTER CETTE MÉTHODE POUR LE BOUTON ACTUALISER
  Future<void> refresh() async {
    try {
      print("🔄 Actualisation...");
      isLoading = true;
      notifyListeners();
      
      await getName();
      
      print("✅ Actualisation terminée");
    } catch (e) {
      print("❌ Erreur actualisation: $e");
      deployedName = "Erreur";
      isLoading = false;
      notifyListeners();
    }
  }
}
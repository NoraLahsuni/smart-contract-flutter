import 'package:flutter/material.dart';
import 'contract_linking.dart';
import 'package:provider/provider.dart';

class HelloUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtenir l'objet ContractLinking
    var contractLink = Provider.of<ContractLinking>(context);
    
    TextEditingController yourNameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hello World DApp",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.blueAccent),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Color(0xFF0A0A0A),
            ],
          ),
        ),
        child: Center(
          child: contractLink.isLoading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.blueAccent,
                      strokeWidth: 3,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Connexion à la blockchain...",
                      style: TextStyle(
                        color: Colors.blueGrey[300],
                        fontSize: 16,
                      ),
                    ),
                  ],
                )
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Hello ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 52,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 10,
                                  color: Colors.blueAccent.withOpacity(0.3),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            contractLink.deployedName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 52,
                              color: Colors.blueAccent,
                              shadows: [
                                Shadow(
                                  blurRadius: 15,
                                  color: Colors.blueAccent.withOpacity(0.5),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.blueAccent),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueAccent.withOpacity(0.1),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Adresse du contrat:",
                              style: TextStyle(
                                color: Colors.blueGrey[300],
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "0x8aAE...C1a1",
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 12,
                                fontFamily: 'Monospace',
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                      TextFormField(
                        controller: yourNameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white, width: 2),
                          ),
                          labelText: "Your Name",
                          labelStyle: TextStyle(color: Colors.blueGrey[300]),
                          hintText: "What is your name?",
                          hintStyle: TextStyle(color: Colors.blueGrey[500]),
                          prefixIcon: Icon(
                            Icons.drive_file_rename_outline,
                            color: Colors.blueAccent,
                          ),
                          filled: true,
                          fillColor: Color(0xFF1A1A1A),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          child: Text(
                            'Set Name',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                          shadowColor: Colors.blueAccent.withOpacity(0.5),
                        ),
                        onPressed: () {
                          if (yourNameController.text.isNotEmpty) {
                            contractLink.setName(yourNameController.text);
                            yourNameController.clear();
                            
                            // Afficher un message de confirmation
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Transaction envoyée à la blockchain...",
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Veuillez entrer un nom",
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: const Color.fromARGB(255, 54, 82, 244),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          child: Text(
                            'Actualiser',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: BorderSide(color: Colors.blueAccent, width: 1),
                        ),
                        onPressed: () {
                          contractLink.getName();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Actualisation en cours...",
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 40),
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.blueGrey),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.lock, color: Colors.blueAccent, size: 16),
                            SizedBox(width: 8),
                            Text(
                              "Blockchain Secure",
                              style: TextStyle(
                                color: Colors.blueGrey[300],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
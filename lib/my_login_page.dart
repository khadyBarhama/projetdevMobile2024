import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  var cacherMotDePasse = true;
  final _formKey = GlobalKey<FormState>();
  final motDePasseFieldController = TextEditingController();
  final confirmMotDePasseFieldController = TextEditingController();
  final emailFieldController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e) {
      print("Erreur d'initialisation Firebase : $e");
      Fluttertoast.showToast(
        msg: "Erreur d'initialisation Firebase",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
        msg: "Il y a des erreurs, merci de les corriger",
        backgroundColor: Colors.red,
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailFieldController.text.trim(),
        password: motDePasseFieldController.text.trim(),
      );

      Fluttertoast.showToast(
        msg: "Création du compte réussie 🎉",
        backgroundColor: Colors.green,
      );
    } on FirebaseAuthException catch (e) {
      String message = "Erreur inconnue";
      if (e.code == 'email-already-in-use') {
        message = "L'email est déjà utilisé.";
      } else if (e.code == 'weak-password') {
        message = "Mot de passe trop faible.";
      } else if (e.code == 'invalid-email') {
        message = "Email invalide.";
      }
      Fluttertoast.showToast(
        msg: message,
        backgroundColor: Colors.red,
      );
    } catch (e) {
      print("Erreur: $e");
      Fluttertoast.showToast(
        msg: "Erreur lors de la création du compte",
        backgroundColor: Colors.red,
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.person_add_alt_rounded,
                size: 100, color: Colors.blue),
            const Text("S'enregistrer",
                textAlign: TextAlign.center, style: TextStyle(fontSize: 30)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: emailFieldController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                  hintText: "Entrez votre Email",
                  labelText: "Email",
                ),
                validator: (value) => value!.isEmpty
                    ? "Merci de fournir une adresse Email"
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: motDePasseFieldController,
                obscureText: cacherMotDePasse,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: "Entrez votre mot de passe",
                  labelText: "Mot de passe",
                  suffixIcon: IconButton(
                    onPressed: () =>
                        setState(() => cacherMotDePasse = !cacherMotDePasse),
                    icon: Icon(
                      cacherMotDePasse
                          ? Icons.visibility_off_outlined
                          : Icons.visibility,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty)
                    return "Le mot de passe ne peut être vide";
                  if (value.length < 6)
                    return "Le mot de passe doit contenir au moins 6 caractères";
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: confirmMotDePasseFieldController,
                obscureText: cacherMotDePasse,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: "Confirmez votre mot de passe",
                  labelText: "Confirmation mot de passe",
                  suffixIcon: IconButton(
                    onPressed: () =>
                        setState(() => cacherMotDePasse = !cacherMotDePasse),
                    icon: Icon(
                      cacherMotDePasse
                          ? Icons.visibility_off_outlined
                          : Icons.visibility,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value != motDePasseFieldController.text) {
                    return "Les mots de passe ne correspondent pas";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ElevatedButton(
                onPressed: isLoading ? null : _registerUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  elevation: 5,
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("S'enregistrer"),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/*import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  var cacherMotDePasse = true;
  final _formKey = GlobalKey<FormState>();
  var motDePasseFieldController = TextEditingController();
  var confirmMotDePasseFieldController = TextEditingController();
  var emailFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey, // la cle globale du formulaire
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.person_add_alt_rounded,
              size: 100,
              color: Colors.blue,
            ),
            const Text(
              "S'enregistrer",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: emailFieldController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                  hintText: "Entrez votre Email",
                  labelText: "Email",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Merci de fournir une adresse Email";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: motDePasseFieldController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Attention le mot de passe ne peut etre vide";
                  }

                  if (motDePasseFieldController.text !=
                      confirmMotDePasseFieldController.text) {
                    return "Attention le mot de passe est différent de la confirmation";
                  }
                  return null;
                },
                obscureText: cacherMotDePasse,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Entrez votre mot de passe",
                  labelText: "Mot de passe",
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        cacherMotDePasse = !cacherMotDePasse;
                      });

                      print("Cacher Mot de passe $cacherMotDePasse");
                    },
                    icon: cacherMotDePasse
                        ? Icon(Icons.visibility_off_outlined)
                        : Icon(Icons.visibility),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: confirmMotDePasseFieldController,
                validator: (value) {
                  if (motDePasseFieldController.text !=
                      confirmMotDePasseFieldController.text) {
                    return "Attention le mot de passe est différent de la confirmation";
                  }
                  return null;
                },
                obscureText: cacherMotDePasse,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Confirmez votre mot de passe",
                  labelText: "Confirmation mot de passe",
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        cacherMotDePasse = !cacherMotDePasse;
                      });
                    },
                    icon: cacherMotDePasse
                        ? Icon(Icons.visibility_off_outlined)
                        : Icon(Icons.visibility),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      final UserCredential usercred = await FirebaseAuth
                          .instance
                          .createUserWithEmailAndPassword(
                        email: emailFieldController.text,
                        password: motDePasseFieldController.text,
                      );

                      print(
                          "Hello the ${emailFieldController.text}  : ${motDePasseFieldController.text}");
                      Fluttertoast.showToast(
                          msg: "Creation du compte avec succès",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } catch (e) {
                      print(e);
                      Fluttertoast.showToast(
                          msg: "Erreur de creation du compte ${e.toString()}",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  } else {
                    Fluttertoast.showToast(
                        msg: "Il y a des erreurs, merci de les corriger",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                },
                child: Text("S'enregistrer"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    elevation: 5),
              ),
            )
          ],
        ),
      ),
    );
  }
}*/

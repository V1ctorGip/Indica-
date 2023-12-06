import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:indikai/models/filme.dart';

class TelaEditarFilme extends StatefulWidget {
  const TelaEditarFilme({Key? key}) : super(key: key);

  @override
  State<TelaEditarFilme> createState() => _TelaEditarFilme();
}

class _TelaEditarFilme extends State<TelaEditarFilme> {
  late Filme _filme;
  late DocumentReference _filmeRef;
  final _user = FirebaseAuth.instance.currentUser as User;

  final _formKey = GlobalKey<FormState>();

  Widget _buildForm(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              style: TextStyle(color: Colors.white),
              initialValue: _filme.nome,
              decoration: const InputDecoration(
                labelText: 'Nome',
                labelStyle: TextStyle(color: Colors.white54),
                helperText: 'Informe o nome do filme',
                helperStyle: TextStyle(color: Colors.lightBlue),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Informe o nome do Filme';
                }
                return null;
              },
              onSaved: (value) {
                _filme.nome = value!;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              style: TextStyle(color: Colors.white),
              initialValue: _filme.categoria,
              decoration: const InputDecoration(
                labelText: 'Categoria',
                labelStyle: TextStyle(color: Colors.white54),
                helperText: 'Informe a categoria',
                helperStyle: TextStyle(color: Colors.lightBlue),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty &&
                    !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                  return 'Informe uma categoria válida';
                }
                return null;
              },
              onSaved: (value) {
                _filme.categoria = value!;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              style: TextStyle(color: Colors.white),
              initialValue: _filme.anoLancamento,
              decoration: const InputDecoration(
                labelText: 'Ano de lançamento',
                labelStyle: TextStyle(color: Colors.white54),
                helperText: 'Informe o ano de lançamento',
                helperStyle: TextStyle(color: Colors.lightBlue),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r'19[00-99]|20[00-99]').hasMatch(value)) {
                  return 'Informe um ano válido';
                }
                return null;
              },
              onSaved: (value) {
                _filme.anoLancamento = value!;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              style: TextStyle(color: Colors.white),
              initialValue: _filme.score,
              decoration: const InputDecoration(
                labelText: 'Nota',
                labelStyle: TextStyle(color: Colors.white54),
                helperText: 'Informe a nota do filme',
                helperStyle: TextStyle(color: Colors.lightBlue),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r'^[0-9]?$|^10$').hasMatch(value)) {
                  return 'Informe uma indicação válida: 0 até 10';
                }
                return null;
              },
              onSaved: (value) {
                _filme.score = value!;
              },
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ));
  }

  void _showDialogErrors() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Informações do filme'),
            content: const Text(
                'Há erros nos campos. Corrija-os e tente novamente.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Fechar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    _filme = ModalRoute.of(context)!.settings.arguments as Filme;

    _filmeRef = FirebaseFirestore.instance
        .doc('usuarios/${_user.uid}/filmes/${_filme.id}');

    return Scaffold(
      appBar: AppBar(
        title: Text('Editaí',
            style: GoogleFonts.rubikWetPaint(
                textStyle: const TextStyle(fontSize: 36.0))),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                child: const Text('Atualize os dados do filme',
                    style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(
                height: 10,
              ),
              _buildForm(context)
            ],
          )),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.check),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              await _filmeRef.update(_filme.toDocument());
              if (!mounted) return;
              Navigator.of(context).pushNamed("/homepage");
            } else {
              _showDialogErrors();
            }
          }),
    );
  }
}

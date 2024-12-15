import 'package:flutter/material.dart';
import 'package:contactos/services/firebase_service.dart';
import 'contact_form_page.dart';
import '../models/contact_model.dart';

class ContactListPage extends StatefulWidget {
  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  final FirebaseService _firebaseService = FirebaseService();
  late Future<List<Contact>> _contactList;

  @override
  void initState() {
    super.initState();
    _contactList = _firebaseService.getContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agenda de Contactos'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactFormPage()),
              );
            },
          )
        ],
      ),
      body: FutureBuilder<List<Contact>>(
        future: _contactList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No contacts found.'));
          }

          var contacts = snapshot.data!;

          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              var contact = contacts[index];
              return ListTile(
                title: Text(contact.name),
                subtitle: Text(contact.phone),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await _firebaseService.deleteContact(contact.key!);
                    setState(() {
                      _contactList = _firebaseService.getContacts();
                    });
                  },
                ),
                onTap: () {
                  // Aquí podrías agregar un botón de editar si lo deseas
                },
              );
            },
          );
        },
      ),
    );
  }
}

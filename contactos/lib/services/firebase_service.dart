import 'package:firebase_database/firebase_database.dart';
import '../models/contact_model.dart';

class FirebaseService {
  final DatabaseReference _contactsRef =
      FirebaseDatabase.instance.ref().child('contacts');

  // Método para agregar un contacto
  Future<void> addContact(Contact contact) async {
    await _contactsRef.push().set(contact.toMap());
  }

  // Método para obtener todos los contactos
  Future<List<Contact>> getContacts() async {
    DataSnapshot snapshot = await _contactsRef.get();
    List<Contact> contacts = [];
    if (snapshot.exists) {
      var data = snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        contacts.add(Contact.fromMap(value, key));
      });
    }
    return contacts;
  }

  // Método para actualizar un contacto
  Future<void> updateContact(Contact contact) async {
    await _contactsRef.child(contact.key!).update(contact.toMap());
  }

  // Método para eliminar un contacto
  Future<void> deleteContact(String key) async {
    await _contactsRef.child(key).remove();
  }
}

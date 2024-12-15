import 'package:flutter/material.dart';
import 'package:contactos/services/firebase_service.dart';
import '../models/contact_model.dart';

class ContactFormPage extends StatefulWidget {
  final Contact? contact; // Permite pasar un contacto si es para editar.

  ContactFormPage({this.contact});

  @override
  _ContactFormPageState createState() => _ContactFormPageState();
}

class _ContactFormPageState extends State<ContactFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      _nameController.text = widget.contact!.name;
      _phoneController.text = widget.contact!.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact == null ? 'Nuevo Contacto' : 'Editar Contacto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Teléfono'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un teléfono';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    var contact = Contact(
                      name: _nameController.text,
                      phone: _phoneController.text,
                    );
                    if (widget.contact == null) {
                      // Si es un contacto nuevo
                      await _firebaseService.addContact(contact);
                    } else {
                      // Si es un contacto existente (editar)
                      contact.key = widget.contact!.key;
                      await _firebaseService.updateContact(contact);
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(widget.contact == null ? 'Agregar' : 'Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

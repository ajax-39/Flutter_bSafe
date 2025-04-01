import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';
import 'package:safe/components/custom_button.dart';
import 'package:safe/widgets/contacts/firebase.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  //* Add contact
  uploadContact() {
    //! Input
    final nameController = TextEditingController();
    final numberController = TextEditingController();
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 1000,
          child: ListView(
            shrinkWrap: true,
            children: [
              const Text('Fill Details'),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Enter Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: numberController,
                decoration: const InputDecoration(
                  hintText: 'Enter Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: "Add Contact",
                onPressed: () async {
                  String id = randomAlphaNumeric(9);
                  Map<String, dynamic> details = {
                    "id": id,
                    "Name": nameController.text,
                    "Number": numberController.text,
                  };

                  await FirebaseMethods().addContact(details, id).then((value) {
                    Fluttertoast.showToast(msg: "Contact Added");
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  //* Read Data
  Stream? contactsStream;

  getAllList() async {
    contactsStream = await FirebaseMethods().getContactList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getAllList();
  }

  //* Store data locally
  List<Map<String, dynamic>> phoneBook = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trusted Contacts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              uploadContact();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Contacts',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: contactsStream,
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (ctx, index) {
                      DocumentSnapshot ds = snapshot.data.docs[index];

                      Map<String, dynamic> temp = {
                        "Name": ds['Name'],
                        "Number": ds["Number"],
                      };
                      phoneBook.add(temp);

                      return Dismissible(
                        key: Key(ds.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20.0),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (direction) async {
                          await FirebaseMethods().deleteContact(ds.id);
                          Fluttertoast.showToast(msg: "Contact Deleted");
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Text(
                                ds['Name'][0],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            title: Text(
                              ds['Name'],
                              style: const TextStyle(fontSize: 20),
                            ),
                            subtitle: Text(
                              ds['Number'],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

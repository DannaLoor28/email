import 'package:flutter/material.dart';
import '../model/backend.dart';
import '../model/email.dart';
import '../widgets/email_widget.dart'; 
import 'detail_screen.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<Email> emails = [];

  @override
  void initState() {
    super.initState();
    loadEmails();
  }

  Future<void> loadEmails() async {
    emails = await Backend().getEmails();
    setState(() {});
  }

  void markAsRead(int id) {
    Backend().markEmailAsRead(id);
    setState(() {
      emails.firstWhere((email) => email.id == id).read = true;
    });
  }

  void deleteEmail(int id) {
    Backend().deleteEmail(id);
    setState(() {
      emails.removeWhere((email) => email.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Correos',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: emails.isEmpty
          ? Center(
              child: Text(
                "No hay correos.",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            )
          : ListView.builder(
              itemCount: emails.length,
              padding: EdgeInsets.all(10),
              itemBuilder: (context, index) {
                final email = emails[index];
                return Dismissible(
                  key: Key(email.id.toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => deleteEmail(email.id),
                  background: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerRight,
                    color: Colors.red,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: GestureDetector(
                    onLongPress: () => markAsRead(email.id),
                    onTap: () {
                      setState(() {
                        email.read = true;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(email: email),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        EmailWidget(email: email), 
                        Divider(
                          thickness: 1.5,
                          color: Colors.grey,
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

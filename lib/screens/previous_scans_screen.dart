import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Scan {
  String imageUrl;
  String timestamp;
  String caption;
  String id;

  Scan(
    this.imageUrl,
    this.timestamp,
    this.caption,
    this.id,
  );
}

class PreviousScans extends StatefulWidget {
  @override
  _PreviousScansState createState() => _PreviousScansState();
}

class _PreviousScansState extends State<PreviousScans> {
  TextEditingController _searchQuery = TextEditingController();
  List<Scan> _list = [];
  bool _isSearching;

  _PreviousScansState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _isSearching = false;
        });
      } else {
        setState(() {
          _list.clear();
          _isSearching = true;
          scans.map((e) {
            if (e.id.startsWith(_searchQuery.text)) {
              _list.add(e);
            }
          }).toList();
        });
      }
    });
  }

  List<Scan> scans = [];

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    populateScans();
    _isSearching = false;
  }

  void populateScans() {
    FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach(
        (element) {
          scans.add(Scan(
            element['imageUrl'],
            element['timestamp'],
            element['caption'],
            element['id'],
          ));
        },
      );
      scans.sort((a, b) =>
          DateTime.parse(a.timestamp).compareTo(DateTime.parse(b.timestamp)));
    }).then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          TextField(
            controller: _searchQuery,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'[0-9]'),
              ),
            ],
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              isDense: true,
              hintText: 'Search by ID',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0),
              ),
            ),
          ),
          SizedBox(height: 10),
          _loading
              ? CircularProgressIndicator()
              : scans.length == 0
                  ? Text('No scans found')
                  : SingleChildScrollView(
                      child: _isSearching
                          ? Column(
                              children: [
                                for (int index = _list.length - 1;
                                    index >= 0;
                                    index--)
                                  ScanCard(scan: _list[index]),
                              ],
                            )
                          : Column(
                              children: [
                                for (int index = scans.length - 1;
                                    index >= 0;
                                    index--)
                                  ScanCard(scan: scans[index]),
                              ],
                            ),
                    ),
        ],
      ),
    );
  }
}

class ScanCard extends StatelessWidget {
  const ScanCard({
    Key key,
    @required this.scan,
  }) : super(key: key);

  final Scan scan;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.white),
              ),
              clipBehavior: Clip.hardEdge,
              color: Colors.transparent,
              child: Ink.image(
                image: NetworkImage(scan.imageUrl),
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return SimpleDialog(
                          children: [
                            Image.network(
                              scan.imageUrl,
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            // Container(
            //   height: 100,
            //   width: 100,
            //   decoration: BoxDecoration(
            //     border: Border.all(color: Colors.white),
            //     borderRadius: BorderRadius.circular(10),
            //     image: DecorationImage(
            //       image: NetworkImage(
            //           scans[index].imageUrl),
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontFamily: 'Raleway'),
                    children: [
                      TextSpan(
                        text: 'ID: ',
                        style: TextStyle(
                          fontFamily: 'Raleway-Bold',
                        ),
                      ),
                      TextSpan(text: scan.id),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontFamily: 'Raleway'),
                    children: [
                      TextSpan(
                        text: 'Date: ',
                        style: TextStyle(
                          fontFamily: 'Raleway-Bold',
                        ),
                      ),
                      TextSpan(
                        text: DateFormat("MMMM dd, yyyy").format(
                          DateTime.parse(scan.timestamp),
                        ),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontFamily: 'Raleway'),
                    children: [
                      TextSpan(
                        text: 'Time: ',
                        style: TextStyle(
                          fontFamily: 'Raleway-Bold',
                        ),
                      ),
                      TextSpan(
                        text: DateFormat("HH:mm").format(
                          DateTime.parse(
                            scan.timestamp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 240,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(fontFamily: 'Raleway'),
                      children: [
                        TextSpan(
                          text: 'Caption: ',
                          style: TextStyle(
                            fontFamily: 'Raleway-Bold',
                          ),
                        ),
                        TextSpan(
                          text: scan.caption,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

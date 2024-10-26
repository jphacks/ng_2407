import 'package:eki_kuguru/models/register_station_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'displayMap.dart';
import 'generateWidget.dart';
import 'header.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final dbService = DatabaseService();
  await dbService.batchddVoteNumToFacilities();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: "test"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // firebase test code
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();
  // messages stream
  Stream<QuerySnapshot>? _messagesStream;
  int _counter = 0;

  // testコレクションにmessageとtimestampを追加
  void _addMessage() {
    if (_messageController.text.isNotEmpty) {
      _firestore.collection('test').add({
        'message': _messageController.text,
        'timestamp': Timestamp.now(),
      });
      _messageController.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize messages stream
    _messagesStream = _firestore
        .collection('test')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      appBar: Header(state: 0),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messagesStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final data = snapshot.requireData;

                return ListView.builder(
                  itemCount: data.docs.length,
                  itemBuilder: (context, index) {
                    final doc = data.docs[index];
                    final message = doc['message'];
                    final timestamp = (doc['timestamp'] as Timestamp).toDate();
                    return ListTile(
                      title: Text(message),
                      subtitle: Text(timestamp.toString()),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Enter a message',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _addMessage,
                ),
              ],
            ),
          ),
          const Divider(),
          // Counter UI
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text('You have pushed the button this many times:'),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                FloatingActionButton(
                  onPressed: _incrementCounter,
                  tooltip: 'Increment',
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

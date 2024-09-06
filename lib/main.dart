import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter Animations Demo",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AnimatedListScreen(),
    );
  }
}

class AnimatedListScreen extends StatefulWidget {
  const AnimatedListScreen({super.key});

  @override
  State<AnimatedListScreen> createState() => _AnimatedListScreenState();
}

class _AnimatedListScreenState extends State<AnimatedListScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<String> _items = ['Item 1', 'Item 2', 'Item 3'];
  int counter = 4;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(width * 0.06),
        ),
        elevation: height * 0.013,
        toolbarHeight: height * 0.1,
        shadowColor: Colors.black,
        backgroundColor: Colors.black87,
        title: Center(
          child: Text(
            "Animated List",
            style: TextStyle(
                color: Colors.white,
                fontSize: width * 0.085,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
                width * 0.1, height * 0.015, width * 0.1, height * 0.015),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildAddButton(width),
                _buildRemoveButton(width),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(height * 0.005),
            child: Divider(
              endIndent: width * 0.1,
              indent: width * 0.1,
              color: Colors.black87,
            ),
          ),
          Center(
            child: Text(
              "Available Items:",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: width * 0.06),
            ),
          ),
          Expanded(
            child: _items.isEmpty
                ? Padding(
                    padding: EdgeInsets.only(top: height * 0.2),
                    child: Text(
                      "No Item is Available!",
                      style: TextStyle(
                        fontSize: width * 0.05,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.only(
                      top: height * 0.01,
                      left: width * 0.015,
                      right: width * 0.015,
                    ),
                    child: AnimatedList(
                      key: _listKey,
                      controller: _scrollController,
                      initialItemCount: _items.length,
                      itemBuilder: (context, index, animation) {
                        return _buildAnimatedItems(
                            _items[index], animation, width);
                      },
                    ),
                  ),
          ),
          Padding(
            padding: EdgeInsets.all(height * 0.012),
            child: _buildNextScreenButton(context, width),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedItems(
      String item, Animation<double> animation, double width) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: animation.drive(
          Tween<Offset>(
            begin: const Offset(1, 0),
            end: const Offset(0, 0),
          ),
        ),
        child: InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(width * 0.04),
                  ),
                ),
                backgroundColor: Colors.black87,
                content: Text(
                  "Selected: $item",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                width * 0.02, width * 0.01, width * 0.02, 0),
            child: Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.black87,
                  width: width * 0.01,
                ),
                borderRadius: BorderRadius.circular(width * 0.1),
              ),
              elevation: 5,
              color: Colors.black54,
              child: Padding(
                padding: EdgeInsets.all(width * 0.015),
                child: ListTile(
                  title: Text(
                    item,
                    style:
                        TextStyle(fontSize: width * 0.05, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton(double width) {
    return Card(
      color: Colors.black87,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(width * 0.1),
      ),
      child: ElevatedButton(
        onPressed: () {
          _addItem();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
          foregroundColor: Colors.black,
          shape: const CircleBorder(),
          minimumSize: Size(width * 0.19, width * 0.19),
          textStyle:
              TextStyle(fontSize: width * 0.05, fontWeight: FontWeight.bold),
        ),
        child: Icon(
          Icons.add,
          size: width * 0.1,
        ),
      ),
    );
  }

  Widget _buildRemoveButton(double width) {
    return Card(
      color: Colors.black87,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(width * 0.1),
      ),
      child: ElevatedButton(
        onPressed: () {
          if (_items.isNotEmpty) {
            _removeItem();
          }
        },
        onLongPress: () {
          Future.delayed(const Duration(seconds: 2), () {
            if (_items.isNotEmpty) {
              _removeAllItems(width);
            }
          });
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            foregroundColor: Colors.black,
            shape: const CircleBorder(),
            minimumSize: Size(width * 0.019, width * 0.19),
            textStyle:
                TextStyle(fontSize: width * 0.05, fontWeight: FontWeight.bold)),
        child: Icon(
          Icons.delete,
          size: width * 0.1,
        ),
      ),
    );
  }

  Widget _buildNextScreenButton(BuildContext context, double width) {
    return Card(
      color: Colors.black87,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(width * 0.05),
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const SecondScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                var begin = const Offset(1.0, 0.0);
                var end = Offset.zero;
                var curve = Curves.ease;

                var tween = Tween(begin: begin, end: end).chain(
                  CurveTween(curve: curve),
                );
                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
          foregroundColor: Colors.black,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Next Screen",
              style: TextStyle(fontSize: width * 0.04),
            ),
            SizedBox(
              width: width * 0.01,
            ),
            Icon(
              Icons.arrow_forward_rounded,
              size: width * 0.06,
            ),
          ],
        ),
      ),
    );
  }

  void _addItem() {
    final newIndex = _items.length;
    if (_listKey.currentState != null) {
      _items.add('Item $counter');
      _listKey.currentState!.insertItem(newIndex);
      counter++;

      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      });
    } else {
      // Handle the case where _listKey.currentState is null
      print('Error: _listKey.currentState is null');
    }
  }

  void _removeItem() {
    final removedIndex = _items.length - 1;
    var removedItem = _items.removeAt(removedIndex);
    _listKey.currentState!.removeItem(
      removedIndex,
      (context, animation) => _buildAnimatedItems(
          removedItem, animation, MediaQuery.of(context).size.width),
    );
    counter--;
  }

  void _removeAllItems(double width) {
    for (int i = _items.length - 1; i >= 0; i--) {
      var removedItems = _items.removeAt(i);
      _listKey.currentState!.removeItem(
        i,
        (context, animation) =>
            _buildAnimatedItems(removedItems, animation, width),
      );
    }
    counter = 1;
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white, size: width * 0.075),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(width * 0.06),
        ),
        elevation: 10,
        shadowColor: Colors.black,
        backgroundColor: Colors.black87,
        toolbarHeight: height * 0.1,
        title: Padding(
          padding: EdgeInsets.only(right: width * 0.1),
          child: Center(
            child: Text(
              "Second Screen",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: width * 0.085,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: Center(
        child: Hero(
            tag: 'hero-tag',
            child: Material(
              color: Colors.transparent,
              child: Text(
                "Welcome to the Second Screen!",
                style: TextStyle(
                    fontSize: width * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            )),
      ),
    );
  }
}

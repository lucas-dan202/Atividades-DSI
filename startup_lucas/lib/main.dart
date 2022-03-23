import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerador lucas_startup', // Título antigo: 'Startup Name Generator'
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      home: const RandomWords(),
    );
  }
}


class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold (                     
      appBar: AppBar(
        title: const Text('Gerador de Nomes Aleatórios'), // Título antigo: 'Startup Name Generator'
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
            tooltip: 'Sugestões Salvas', // Título antigo: 'Saved Suggestions'
          ),
        ],
      ),
      body: _buildSuggestions(),
    );                             
  }
  
  void _pushSaved() {
    Navigator.of(context).push(
      
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map(
            (pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
                  context: context,
                  tiles: tiles,
                ).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Sugestões Salvas'), // Título antigo: 'Saved Suggestions'
            ),
            body: ListView(children: divided),
          );
        },
      ), 
    );
  }  

  
  
  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return Dismissible(
      child: ListTile(
        title: Text(
          pair.asPascalCase,
          style: _biggerFont,
        ),
        trailing: Icon(    
          alreadySaved ? Icons.check_box : Icons.check_box,
          color: alreadySaved ? Colors.blue : null,
          semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
        ),
        onTap: () {
          setState(() {
            if (alreadySaved) {
              _saved.remove(pair);
            }  else { 
              _saved.add(pair); 
            } 
          });
        },
      ),
      key: ValueKey(pair.asPascalCase),  
      background: Container(
        color: Colors.green.withOpacity(0.8),
        child: Icon(Icons.check_circle, color: Colors.white,),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
      ),
      secondaryBackground: Container(
        color: Colors.red.withOpacity(0.8),
        child: Icon(Icons.cancel, color: Colors.white,),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
      ),           
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
    
      padding: const EdgeInsets.all(16),
      
      itemBuilder: (context, i) {
        
        if (i.isOdd) {
          return const Divider();
        }

        
        final index = i ~/ 2;
        
        if (index >= _suggestions.length) {
          
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      },
    );
    
  
}
}
class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);
  
  @override
  _RandomWordsState createState() => _RandomWordsState();
}
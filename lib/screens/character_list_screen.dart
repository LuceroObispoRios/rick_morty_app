import 'package:flutter/material.dart';
import 'package:rick_morty_app/models/character.dart';
import 'package:rick_morty_app/services/character_service.dart';

class CharacterListScreen extends StatelessWidget {
  const CharacterListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Rick & Morty"),
      ),
      body: const CharacterList(),
    );
  }
}

class CharacterList extends StatefulWidget {
  const CharacterList({super.key});

  @override
  State<CharacterList> createState() => _CharacterListState();
}

class _CharacterListState extends State<CharacterList> {
  final List<Character> _characters = [];
  int _currentPage = 1;
  bool _isLoading = false;
  final CharacterService _characterService = CharacterService();

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    final newCharacters = await _characterService.getAll(page: _currentPage);

    setState(() {
      _characters.addAll(newCharacters);
      _isLoading = false;
    });
  }

  void _loadMoreData() {
    setState(() {
      _currentPage++;
    });
    _fetchData();
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            itemCount: _characters.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
            ),
            itemBuilder: (context, index) =>
                CharacterItem(character: _characters[index]),
          ),
        ),
        _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ElevatedButton(
                onPressed: _loadMoreData,
                child: const Text('Load More'),
              ),
      ],
    );
  }
}

class CharacterItem extends StatelessWidget {
  final Character character;
  const CharacterItem({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Expanded(
            child: Image.network(
              character.image,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),
          Text(character.name),
          Text(character.species),
        ],
      ),
    );
  }
}


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:search_github_bloc/details/DetailsWidget.dart';
import 'package:search_github_bloc/models/SearchItem.dart';
import 'package:search_github_bloc/models/SearchResult.dart';

import 'blocks/SearchBloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SearchBloc _searchBloc;

  // initState eh chamado apenas uma vez quando o componente eh carregado.
  @override
  void initState() {
    _searchBloc = new SearchBloc();
    super.initState();
  }

  // dispose eh chamado quando o componente eh morto.
  @override
  void dispose() {
    super.dispose();
    _searchBloc
        ?.dispose(); // operador ? faz um teste, se _searchBloc existir, ele executa o .dispose();
  }

  Widget _textField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: _searchBloc.searchEvent.add,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Digite o nome do repositório",
            labelText: "Pesquisa"),
      ),
    );
  }

  Widget _items(SearchItem item) {
    print("teste");

    return ListTile(
      leading: Hero(
        tag: item.url,
        child: CircleAvatar(
          backgroundImage: NetworkImage(item?.avatarUrl ??
              "https://d2v9y0dukr6mq2.cloudfront.net/video/thumbnail/VCHXZQKsxil3lhgr4/animation-loading-circle-icon-on-white-background-with-alpha-channel-4k-video_sjujffkcde_thumbnail-full01.png"),
        ),
      ),
      title: Text(item?.fullName ?? "title"),
      subtitle: Text(item?.url ?? "url"),
      onTap: () => Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => DetailsWidget(
                    item: item,
                  ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Github Search"),
      ),
      body: ListView(
        children: <Widget>[
          _textField(),
          StreamBuilder<SearchResult>(
              stream: _searchBloc.apiResultFlux,
              builder:
                  (BuildContext context, AsyncSnapshot<SearchResult> snapshot) {

                // Validacao: SE existir dados em snapshot (snapshot.hasData): monta o ListView
                // SE NAO: monta o CircularProgressIndicator.
                return snapshot.hasData
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: snapshot.data.items.length,
                        itemBuilder: (BuildContext context, int index) {
                          SearchItem item = snapshot.data.items[index];
                          return _items(item);
                        },
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      );
              }),
        ],
      ),
    );
  }
}

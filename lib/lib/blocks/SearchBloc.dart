import 'package:search_github_bloc/models/SearchResult.dart';
//import 'package:search_github_bloc/services/data/GithubService.dart';
import '../services/data/GithubService.dart';
import 'package:rxdart/rxdart.dart';


class SearchBloc {

  GithubService _service = new GithubService();

  final _searchController = new BehaviorSubject<String>();

  // Cria o metodo de get searchFlux: que vai pegar do _searchController.stream
  Stream<String> get searchFlux => _searchController.stream;

  // Cria o metodo get para adicionar eventos ao fluxo:
  Sink<String> get searchEvent => _searchController.sink;

  Stream<SearchResult> apiResultFlux;

  SearchBloc() {
    apiResultFlux = searchFlux
      .distinct() // Distingue a string recebida para nao passar duplicadas
      .where((valor) => valor.length > 2) // Filtra para passar somente strings com mais de 2 caracteres
      .debounceTime(Duration(milliseconds: 500)) // debounce aguarda um tempo (500ms) sem que nenhum evento seja mandado, se houver algum novo evento adicionado entre os 500ms, o debounce sera reiniciado.
      .asyncMap(_service.search) // Após passar pelos filtros, o asyncMap executa o search do _service para buscar os dados na api.
      .switchMap((valor) => Stream.value(valor)); // Converte o valor em um fluxo observable e retorna somente o valor mais atual pesquisado na api.
  }

  // Libera os recursos do bloc fechando o fluxo _searchController.
  void dispose() {
    _searchController.close();
  }
}
import 'package:flutter/material.dart';
import 'package:github_search/empty_result_widget.dart';
import 'package:github_search/github_api.dart';
import 'package:github_search/search_bloc.dart';
import 'package:github_search/search_error_widget.dart';
import 'package:github_search/search_intro_widget.dart';
import 'package:github_search/search_loading_widget.dart';
import 'package:github_search/search_result_widget.dart';
import 'package:github_search/search_state.dart';

// The View in a Stream-based architecture takes two arguments: The State Stream
// and the onTextChanged callback. In our case, the onTextChanged callback will
// emit the latest String to a Stream<String> whenever it is called.
//
// The State will use the Stream<String> to send new search requests to the
// GithubApi.
class SearchScreen extends StatefulWidget {
  final GithubApi api;

  SearchScreen({Key key, GithubApi api})
      : this.api = api ?? GithubApi(),
        super(key: key);

  @override
  SearchScreenState createState() {
    return new SearchScreenState();
  }
}

class SearchScreenState extends State<SearchScreen> {
  SearchBloc bloc;

  @override
  void initState() {
    super.initState();

    bloc = new SearchBloc(widget.api);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<SearchState>(
      stream: bloc.state,
      initialData: new SearchNoTerm(),
      builder: (BuildContext context, AsyncSnapshot<SearchState> snapshot) {
        final state = snapshot.data;

        return new Scaffold(
          body: new Stack(
            children: <Widget>[
              new Flex(direction: Axis.vertical, children: <Widget>[
                new Container(
                  padding: new EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 4.0),
                  child: new TextField(
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search Github...',
                    ),
                    style: new TextStyle(
                      fontSize: 36.0,
                      fontFamily: "Hind",
                      decoration: TextDecoration.none,
                    ),
                    onChanged: bloc.onTextChanged.add,
                  ),
                ),
                new Expanded(
                  child: new Stack(
                    children: <Widget>[
                      // Fade in an intro screen if no term has been entered
                      new SearchIntro(visible: state is SearchNoTerm),

                      // Fade in an Empty Result screen if the search contained
                      // no items
                      new EmptyWidget(visible: state is SearchEmpty),

                      // Fade in a loading screen when results are being fetched
                      // from Github
                      new LoadingWidget(visible: state is SearchLoading),

                      // Fade in an error if something went wrong when fetching
                      // the results
                      new SearchErrorWidget(visible: state is SearchError),

                      // Fade in the Result if available
                      new SearchResultWidget(
                        items:
                            state is SearchPopulated ? state.result.items : [],
                      ),
                    ],
                  ),
                )
              ])
            ],
          ),
        );
      },
    );
  }
}

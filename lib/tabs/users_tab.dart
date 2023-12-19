import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:shopkeeper/blocs/user_bloc.dart';
import 'package:shopkeeper/tiles/user_tile.dart';

class UsersTab extends StatelessWidget {
  const UsersTab({super.key});

  @override
  Widget build(BuildContext context) {
    //final userBloc = BlocProvider.getBloc<UserBloc>();
    final userBloc = UserBloc();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: TextField(
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
                hintText: 'Pesquisar',
                hintStyle: TextStyle(color: Colors.white),
                icon: Icon(Icons.search),
                border: InputBorder.none),
            // controller: textFieldController,
            onChanged: userBloc.onChangedSearch,
          ),
        ),
        StreamBuilder<List>(
          stream: userBloc.outUsers,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),
                ),
              );
            } else if (snapshot.data!.length == 0) {
              return const Center(child: Text('Nenhum usuário encontrado'));
            } else {
              return Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        return UserTile(snapshot.data?[index]);
                      },
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                      itemCount: snapshot.data!.length)
                  // itemCount: 5),
                  );
            }
          },
        )
      ],
    );
  }
}

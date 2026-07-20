:- module(bomb, [
    place_player_bomb/5,
    tick_bomb/4
]).

:- use_module('../map/map_manager.pl').

/*
  Gerenciamento das bombas.
*/

place_player_bomb(_, Map, ExistingBomb, Map, ExistingBomb) :-
    nonvar(ExistingBomb),
    ExistingBomb = bomb(_, _),
    !.

place_player_bomb(
    Pos,
    Map,
    none,
    Map,
    bomb(Pos, 3)
).

tick_bomb(Map, none, Map, none).

tick_bomb(
    Map,
    bomb(Pos, Timer),
    Map,
    bomb(Pos, NewTimer)
) :-
    Timer > 1,
    NewTimer is Timer - 1.

tick_bomb(
    Map,
    bomb(_, 1),
    Map,
    none
).
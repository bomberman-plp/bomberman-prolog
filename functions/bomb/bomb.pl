:- module(bomb, [
    place_player_bomb/5,
    tick_bomb/5
]).

:- use_module('../map/map_manager.pl').
:- use_module('../map/map_collision.pl').

place_player_bomb(_, Map, ExistingBomb, Map, ExistingBomb) :-
    nonvar(ExistingBomb),
    ExistingBomb = bomb(_, _),
    !.

place_player_bomb(Pos, Map, none, Map, bomb(Pos, 3)).

tick_bomb(Map, none, _, Map, none).

tick_bomb(Map, bomb(Pos, Timer), _, Map, bomb(Pos, NewTimer)) :-
    Timer > 1,
    NewTimer is Timer - 1.

tick_bomb(Map, bomb(Pos, 1), PlayerPos, NewMap, Status) :-
    explode(Pos, PlayerPos, Map, NewMap, Status).

explode(Pos, PlayerPos, Map, NewMap, Status) :-
    blast_tiles(Pos, Map, Tiles),
    destroy_tiles(Tiles, Map, DestroyedMap),
    (   member(PlayerPos, Tiles)
    ->  set_tile(PlayerPos, empty, DestroyedMap, NewMap),
        Status = exploding(Tiles, game_over)
    ;   NewMap = DestroyedMap,
        Status = exploding(Tiles, none)
    ).

blast_tiles((X, Y), Map, Tiles) :-
    blast_dir((X, Y), 1, 0, Map, 2, Right),
    blast_dir((X, Y), -1, 0, Map, 2, Left),
    blast_dir((X, Y), 0, 1, Map, 2, Down),
    blast_dir((X, Y), 0, -1, Map, 2, Up),
    append([Right, Left, Down, Up], AllDir),
    Tiles = [(X, Y) | AllDir].

blast_dir(_, _, _, _, 0, []) :- !.

blast_dir((X, Y), Dx, Dy, Map, Depth, Tiles) :-
    Tx is X + Dx,
    Ty is Y + Dy,
    (   is_indestructible((Tx, Ty), Map)
    ->  Tiles = []
    ;   NextDepth is Depth - 1,
        Tiles = [(Tx, Ty) | Rest],
        (   is_destructible((Tx, Ty), Map)
        ->  Rest = []
        ;   blast_dir((Tx, Ty), Dx, Dy, Map, NextDepth, Rest)
        )
    ).

destroy_tiles([], Map, Map).
destroy_tiles([(X, Y)|Tiles], Map, NewMap) :-
    (   is_destructible((X, Y), Map)
    ->  set_tile((X, Y), empty, Map, TempMap)
    ;   TempMap = Map
    ),
    destroy_tiles(Tiles, TempMap, NewMap).
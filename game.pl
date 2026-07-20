:- module(game, [
    run_game/3
]).

/*
  Loop principal do jogo.
*/

:- use_module('./functions/draw/draw.pl').
:- use_module('./functions/move/move.pl').
:- use_module('./functions/bomb/bomb.pl').

run_game(GameMap, PlayerPos, BombState) :-

    write('BombState = '),
    write(BombState),
    nl,

    draw_map(GameMap, BombState),

    write('Use W/A/S/D para mover | B para bomba | Q para sair: '),
    get_single_char(Code),
    char_code(Key, Code),

    (
        Key == 'q'
    ->
        nl,
        write('Jogo encerrado!'),
        nl

    ;   Key == 'b'
    ->
        place_player_bomb(
            PlayerPos,
            GameMap,
            BombState,
            NextMap,
            NextBombState
        ),

        run_game(
            NextMap,
            PlayerPos,
            NextBombState
        )

    ;
        move(
            Key,
            PlayerPos,
            GameMap,
            TempMap-TempPos
        ),

        tick_bomb(
            TempMap,
            BombState,
            NextMap,
            NextBombState
        ),

        run_game(
            NextMap,
            TempPos,
            NextBombState
        )
    ).
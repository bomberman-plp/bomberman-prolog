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
    draw_map(GameMap, PlayerPos, BombState),

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
            TempPos,
            NextMap,
            NextBombState
        ),

        (
            NextBombState = exploding(_, _, FinalStatus)
        ->
            draw_map(NextMap, TempPos, NextBombState),
            sleep(0.5),
            (
                FinalStatus = game_over
            ->
                draw_map(NextMap, TempPos, none),
                write('Game Over!'),
                nl
            ;
                run_game(NextMap, TempPos, FinalStatus)
            )
        ;   NextBombState = game_over
        ->
            draw_map(NextMap, TempPos, none),
            write('Game Over!'),
            nl
        ;
            run_game(NextMap, TempPos, NextBombState)
        )
    ).
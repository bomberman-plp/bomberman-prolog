:- module(game, [
    run_game/2
]).

/*
  Loop principal do jogo.
*/

:- use_module('./functions/draw/draw.pl').
:- use_module('./functions/move/move.pl').

run_game(GameMap, PlayerPos) :-
    % 1. Desenha o mapa
    draw_map(GameMap),
    % 2. Lê entrada do teclado
    write('Use W/A/S/D para mover | Q para sair: '),
    get_single_char(Code),
    char_code(Key, Code),
    
    % 3. Trata encerramento ou atualiza e repete
    (   Key == 'q'
    ->  nl, write('Jogo encerrado!'), nl
    ;   move(Key, PlayerPos, GameMap, NextMap-NextPos),
        run_game(NextMap, NextPos)
    ).
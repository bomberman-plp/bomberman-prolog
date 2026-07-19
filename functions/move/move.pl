:- module(move, [
    move/4
]).

/*
  Módulo responsável por calcular a próxima posição e validar colisão:
  - Se for Chão Vazio (empty): Atualiza no mapa.
  - Se for Parede/Madeira/Indestrutível: Ignora e mantém na mesma posição.
*/

:- use_module('../map/map_manager.pl').
:- use_module('../map/map_collision.pl').

% Mapeamento Tecla -> (DeltaX, DeltaY)
key_direction('w',  0, -1). % Cima
key_direction('s',  0,  1). % Baixo
key_direction('a', -1,  0). % Esquerda
key_direction('d',  1,  0). % Direita

% 1. Tenta mover e valida colisão
move(Key, (PX, PY), OldMap, NewMap-NewPos) :-
    key_direction(Key, DX, DY),
    NextX is PX + DX,
    NextY is PY + DY,
    TargetCoord = (NextX, NextY),
    
    % Checa se a posição de destino é chão vazio (usando map_collision.pl)
    is_empty(TargetCoord, OldMap),
    !, % Se for vazio, efetua o movimento
    NewPos = TargetCoord,
    set_tile((PX, PY), empty, OldMap, TempMap),
    set_tile(NewPos, player, TempMap, NewMap).

% 2. Se a posição for Parede, Madeira ou tecla inválida: recusa o movimento
move(_, PlayerPos, CurrentMap, CurrentMap-PlayerPos).
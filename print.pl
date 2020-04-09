printNewLine() :-
    write('\n').

printSpace(0) :- !.

printSpace(Count) :-
    ansi_format([], ' ', []),
    NewCount is Count -1,
    printSpace(NewCount).

printEmptyTile(0) :- !.
printEmptyTile(Count) :-
    ansi_format([], '◻', []),
    NewCount is Count -1,
    printEmptyTile(NewCount).

printTileN(_,0) :- !.

printTileN(Color,Count) :-
    printTile(Color),
    NewCount is Count - 1,
    printTileN(Color,NewCount).

colorByIndex(0,azul).
colorByIndex(1,rojo).
colorByIndex(2,amarillo).
colorByIndex(3,negro).
colorByIndex(4,blanco).

printTile(azul) :- ansi_format([bold,fg(blue)], '◼', []).
printTile(amarillo) :- ansi_format([bold,fg(yellow)], '◼', []).
printTile(rojo) :- ansi_format([bold,fg(red)], '◼', []).
printTile(negro) :- ansi_format([bold,fg(black)], '◼', []).
printTile(blanco) :- ansi_format([bold,fg(white)], '◼', []).

printEmptyTileColor(azul) :- ansi_format([bold,fg(blue)], '◻', []).
printEmptyTileColor(amarillo) :- ansi_format([bold,fg(yellow)], '◻', []).
printEmptyTileColor(rojo) :- ansi_format([bold,fg(red)], '◻', []).
printEmptyTileColor(negro) :- ansi_format([bold,fg(black)], '◻', []).
printEmptyTileColor(blanco) :- ansi_format([bold,fg(white)], '◻', []).

printFactory([]) :- !.
printFactory([[_,0]|R]) :- 
    printFactory(R), 
    !.
printFactory([[Color,Count]|R]) :-
    printTile(Color),
    NewCount is Count - 1,
    printFactory([[Color,NewCount]|R]).
    
printFactories([],_,_) :- !.

printFactories([F|FR],Index,Mask) :-
    length(FR,L),
    N is 9 - L,
    ansi_format([], 'Factory ~w:', [N]),
    member(Index,Mask),
    printFactory(F),
    NewIndex is Index + 1,
    printNewLine(),
    printFactories(FR, NewIndex, Mask),
    !.

printFactories([_|FR],Index,Mask) :-
    NewIndex is Index + 1,
    printNewLine(),
    printFactories(FR, NewIndex, Mask),
    !.

printFactories(Factories,Mask) :-
    printFactories(Factories, 0, Mask).


printPatternLine(Row,[Color,Count]) :-
    Spaces is 5 - Row - 1,
    printSpace(Spaces),
    printEmptyTile(Count),
    NewCount is Row + 1 - Count,
    printTileN(Color,NewCount).

printWallTile(Row,Index,0) :-
    ColorIndex is (Index - Row) mod 5,
    colorByIndex(ColorIndex,Color),
    printEmptyTileColor(Color).

printWallTile(Row,Index,1) :-
    ColorIndex is (Index - Row) mod 5,
    colorByIndex(ColorIndex,Color),
    printTile(Color).

printPatternLinesAndWall(5,_,_) :- !.

printPatternLinesAndWall(Row,[PL|PLR],[A0,A1,A2,A3,A4|R]) :-
    printPatternLine(Row,PL),
    printSpace(2),
    printWallTile(Row,0,A0),
    printWallTile(Row,1,A1),
    printWallTile(Row,2,A2),
    printWallTile(Row,3,A3),
    printWallTile(Row,4,A4),
    printNewLine(),
    NewRow is Row + 1,
    printPatternLinesAndWall(NewRow,PLR,R),
    !.

printFloor([]) :- !.

printFloor([[false,_]|R]) :-
    ansi_format([bold], '◻', []),
    printFloor(R),
    !.

printFloor([[Color,_]|R]) :-
    printTile(Color),
    printFloor(R).

printBoard(Wall,PatternLines, Floor) :-
    printPatternLinesAndWall(0,PatternLines,Wall),
    printFloor(Floor).

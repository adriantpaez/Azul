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
colorByIndex(1,amarillo).
colorByIndex(2,rojo).
colorByIndex(3,negro).
colorByIndex(4,blanco).
colorByIndex(5,initial).

printTile(azul) :- ansi_format([bold,fg(blue)], '◼', []).
printTile(amarillo) :- ansi_format([bold,fg(yellow)], '◼', []).
printTile(rojo) :- ansi_format([bold,fg(red)], '◼', []).
printTile(negro) :- ansi_format([bold,fg(black)], '◼', []).
printTile(blanco) :- ansi_format([bold,fg(white)], '◼', []).
printTile(initial) :- ansi_format([bold,fg(green)], '⬢', []).

printEmptyTileColor(azul) :- ansi_format([bold,fg(blue)], '◻', []).
printEmptyTileColor(amarillo) :- ansi_format([bold,fg(yellow)], '◻', []).
printEmptyTileColor(rojo) :- ansi_format([bold,fg(red)], '◻', []).
printEmptyTileColor(negro) :- ansi_format([bold,fg(black)], '◻', []).
printEmptyTileColor(blanco) :- ansi_format([bold,fg(white)], '◻', []).

printColorVector([]) :- !.
printColorVector([[_,0]|R]) :- 
    printColorVector(R), 
    !.
printColorVector([[Color,Count]|R]) :-
    printTile(Color),
    NewCount is Count - 1,
    printColorVector([[Color,NewCount]|R]).
    
printFactories([],_,_) :- !.

printFactories([F|FR],Index,Mask) :-
    length(FR,L),
    N is 9 - L,
    ansi_format([], 'F ~w:', [N]),
    member(Index,Mask),
    printColorVector(F),
    NewIndex is Index + 1,
    printSpace(3),
    printFactories(FR, NewIndex, Mask),
    !.

printFactories([_|FR],Index,Mask) :-
    NewIndex is Index + 1,
    printEmptyTile(4),
    printSpace(3),
    printFactories(FR, NewIndex, Mask),
    !.

printFactories(Factories,Mask) :-
    printFactories(Factories, 0, Mask),
    printNewLine().


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

printPlayerId(Id) :-
    ansi_format([], 'Player: ~w\n', [Id]).

printplayerResult([Id, W, PL, FL, Points], Factories, FactoryMask):-
    printPlayerId(Id),
    printFactories(Factories, FactoryMask),
    printBoard(W, PL, FL),
    write("Points: "),
    write(Points),
    printNewLine(),
    printNewLine().


printBag([CV,_]):-
    write("Bag: "),
    printColorVector(CV),
    printNewLine().

printCover(Cover) :-
    write("Cover: "),
    printColorVector(Cover),
    printNewLine().

printTable(Table) :-
    write("Table: "),
    printColorVector(Table),
    printNewLine().

printInitial(true) :-
    printTile(initial),
    printNewLine().

printInitial(false).

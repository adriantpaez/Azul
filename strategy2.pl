:- ["utils.pl"].
:- ["blue.pl"].

options([], [], _):-!.

options([F|Factories], FO, Mask):-
    length([F|Factories], L),
    Index is 9-L, 
    member(Index, Mask),
    getOptions(F,Index,O),
    options(Factories, Options, Mask),
    concatLists(O, Options, FO),
    !.

options([_|Factories], FO, Mask):-
    options(Factories, FO, Mask).

getOptions([], _, []):-!.

getOptions([[_, 0]|Factory], Index, Rest):-
    getOptions(Factory, Index, Rest),
    !.

getOptions([ColorTuple|Factory],Index, [[Index, ColorTuple]|Rest]):-
    getOptions(Factory, Index,Rest),
    !.

allOptions(Factories, Table, Options, Mask):-
    options(Factories, FO, Mask),
    getOptions(Table, 9, TO),
    concatLists(FO, TO, Options).

takeBest([_, PointsA], [ChoiceB, PointsB], [ChoiceB, PointsB]) :-
    PointsA < PointsB,
    !.

takeBest([_, _, _, PointsA],[FIB, CTB, PLB, PointsB],[FIB, CTB, PLB, PointsB] ):-
    PointsA<PointsB,
    !.

takeBest(A, _, A):-!.

% bestChoicePoints(Choice, PatternLines, Wall, CurrentResult, BestResult)
% Devuelve en BestResult la mejor fila del PatternLines para poner Choice.
% Donde Result es [BestChoice, Points] y BestChoice es un indice de PatternLines
% y Points los puntos que genera.

bestChoicePoints(_, _, 5, _, CurrentResult, CurrentResult):-!.

bestChoicePoints([Color, Count], PatternLines, Index, Wall, [BestChoiceCurrent, PointsCurrent], BestFinal) :-
    Index<5,
    possibleToPushColorPL(PatternLines, [Color, _], Index, Wall),
    !,
    floorVector(Floor),
    coverEmpty(Cover),
    pushColorPL(PatternLines, [Color, Count], Index, Floor, FloorResult, Cover, CoverResult, PatternLinesResult),
    fromPLToWall(PatternLinesResult, _, Wall, _, CoverResult, _, FloorResult, 0, Points),
    takeBest([BestChoiceCurrent, PointsCurrent], [Index, Points], NewBestCurrent),
    NewIndex is Index + 1,
    bestChoicePoints([Color, Count], PatternLines, NewIndex, Wall, NewBestCurrent, BestFinal),
    !.


bestChoicePoints(Choice, PatternLines, Index, Wall, CurrentResult, BestResult) :-
    Index<5,
    NewIndex is Index + 1,
    bestChoicePoints(Choice, PatternLines, NewIndex, Wall, CurrentResult, BestResult),
    !.

bestChoicePoints(Choice, PatternLines, Wall, Result) :-
    bestChoicePoints(Choice, PatternLines, 0, Wall, [-1, -100], Result).

bestTake(Factories, Table, PatternLines, Wall, Best, Mask):-
    allOptions(Factories, Table, Options, Mask), 
    bestTake_aux(Options, Factories, PatternLines, Wall, [-1, [[], -1], -1, -100], Best).

bestTake_aux([], _,_,_, CurrentBest, CurrentBest).

bestTake_aux([[_, [Color,Count]]|Options], Factories, PatternLines, Wall, CurrentBest, Best):-
    bestChoicePoints([Color, Count], PatternLines, Wall, [-1, -100]),
    bestTake_aux(Options, Factories, PatternLines, Wall, CurrentBest, Best).

bestTake_aux([[FI, [Color,Count]]|Options], Factories, PatternLines, Wall, CurrentBest, Best):-
    bestChoicePoints([Color, Count], PatternLines, Wall, PLChoice),
    append([FI, [Color,Count]], PLChoice, NewChoice),
    takeBest(CurrentBest,NewChoice, NewBest),
    bestTake_aux(Options, Factories, PatternLines, Wall, NewBest, Best).


strategy(PL, W, Factories, Table, Table, Cover, Cover, Floor, Floor, PL, Mask, Mask, false):-
    bestTake(Factories, Table, PL, W, [-1, [[], -1], -1, -100], Mask).

strategy(PL, W, Factories, Table, TableR, Cover, CoverR, Floor, FloorR, PLR, Mask, MaskR, Initial):-
    bestTake(Factories, Table, PL, W, [FI, [Color, Count], PLI, _], Mask),
    continueStrategy(Factories, FI, Color, Count,Table, TableR, PL, PLI, W, PLR, Floor, FloorR, Cover, CoverR, Mask, MaskR, Initial).

continueStrategy(Factories, FI, Color,Count, Table, TableR, PL, PLI, W, PLR, Floor, FloorR, Cover, CoverR, Mask, MaskR, false):-
    FI < 9,
    getByIndex(Factories, FI, SF),
    !,
    factoryGetColor(SF, Color, Table, TableR),
    possibleToPushColorPL(PL, [Color, Count], PLI, W),
    pushColorPL(PL, [Color, Count], PLI, Floor, FloorR, Cover, CoverR, PLR),
    removeValue(Mask, FI, MaskR).


continueStrategy(_, _, Color, Count, Table, TableR, PL, PLI, W, PLR, Floor, FloorR, Cover, CoverR, Mask, Mask, true):-
    tablePopColor(Table, Color, TableR, _),
    possibleToPushColorPL(PL, [Color, Count], PLI, W),
    pushColorPL(PL, [Color, Count], PLI, Floor, FloorR, Cover, CoverR, PLR).




    

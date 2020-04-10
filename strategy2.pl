:- ["blue.pl"].

takeBest([_, PointsA], [ChoiceB, PointsB], [ChoiceB, PointsB]) :-
    PointsA < PointsB.

takeBest([ChoiceA, PointsA], _, [ChoiceA, PointsA]).

% bestChoicePoints(Choice, PatternLines, Wall, CurrentResult, BestResult)
% Devuelve en BestResult la mejor fila del PatternLines para poner Choice.
% Donde Result es [BestChoice, Points] y BestChoice es un indice de PatternLines
% y Points los puntos que genera.

bestChoicePoints(_, _, 5, _, CurrentResult, CurrentResult).

bestChoicePoints([Color, Count], PatternLines, Index, Wall, [BestChoiceCurrent, PointsCurrent], BestFinal) :-
    possibleToPushColorPL(PatternLines, [Color, _], Index, Wall),
    !,
    floorVector(Floor),
    coverEmpty(Cover),
    pushColorPL(PatternLines, [Color, Count], Index, Floor, FloorResult, Cover, CoverResult, PatternLinesResult),
    fromPLToWall(PatternLinesResult, _, Wall, _, CoverResult, _, _, 0, Points),
    floorPoint(FloorResult, FloorPoints),
    NewPoints is Points + FloorPoints,
    takeBest([BestChoiceCurrent, PointsCurrent], [Index, NewPoints], NewBestCurrent),
    NewIndex is Index + 1,
    bestChoicePoints([Color, Count], PatternLines, NewIndex, Wall, NewBestCurrent, BestFinal).


bestChoicePoints(Choice, PatternLines, Index, Wall, CurrentResult, BestResult) :-
    NewIndex is Index + 1,
    bestChoicePoints(Choice, PatternLines, NewIndex, Wall, CurrentResult, BestResult),
    !.

bestChoicePoints(Choice, PatternLines, Wall, Result) :-
    bestChoicePoints(Choice, PatternLines, 0, Wall, [-1, -100], Result).
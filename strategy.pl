:- ["blue.pl"].

%=========
% RANDOM
%=========


selectRandomFactory(F, SF, Mask, MaskR):-
    length(Mask, L),
    random(0, L, IT),
    getByIndex(Mask, IT, I),
    getByIndex(F, I, SF),
    removeValue(Mask, I, MaskR).

selectRandomColor(SF, [ColorR, CountR]):-
    maskColorFactory(SF, Mask),
    length(Mask, L),
    random(0, L, IT),
    getByIndex(Mask, IT, I),
    getByIndex(SF, I, [ColorR, CountR]).

maskColorFactory(F, M):-
    maskColorFactory(F, 0, M).

maskColorFactory([], _,[]):-!.

maskColorFactory([[_, 0]|F], Index, M):-
    NewIndex is Index+1,
    maskColorFactory(F, NewIndex, M),
    !.

maskColorFactory([_|F],Index, [Index|M]):-
    NewIndex is Index+1,
    maskColorFactory(F, NewIndex, M).

    
selectRandomFactoryOrTable(Result):-
    random(0, 1.0, R),
    X is 9/10,
    probs(R, X, Result).

selectRandom(Factories, Table, TableR, [ColorR, CountR], Mask, MaskR):-
    selectRandomFactoryOrTable(1),
    selectRandomFactory(Factories, SF,Mask, MaskR),
    selectRandomColor(SF, [ColorR, CountR]),
    factoryGetColor(SF, ColorR, Table, TableR),
    !.

selectRandom(_, Table, TableR, [ColorR, CountR], Mask, Mask):-
    selectRandomColor(Table, [ColorR, CountR]),
    tablePopColor(Table, ColorR,TableR, _).
    

selectFirstFreePL(PL,[Color, Count], 5, _, F, FR, _, _, PL):-
    pushFloor(F, [Color, Count], FR),
    !.


selectFirstFreePL(PL,[Color, Count], Index, Wall, F, FR, C, CR, PLR):-
    possibleToPushColorPL(PL, [Color, Count], Index, Wall),
    pushColorPL(PL, [Color, Count], Index, F, FR, C, CR, PLR),
    !.

selectFirstFreePL(PL,[Color, Count], Index, Wall, F, FR, C, CR, PLR):-
    NewIndex is Index+1,
    selectFirstFreePL(PL, [Color, Count], NewIndex, Wall, F, FR, C, CR, PLR).


randomStrategy(PL, W, Factories, Table, TableR, Cover, CoverR, Floor, FloorR, PLR, Mask, MaskR):-
    selectRandom(Factories, Table, TableR, [ColorR, CountR], Mask, MaskR),
    selectFirstFreePL(PL, [ColorR, CountR], 0,W, Floor,FloorR, Cover, CoverR, PLR).

calculateMaskFactories([], _, []):-!.

calculateMaskFactories([F|Rest], Index, FM):-
    bagRecalculateMask([F,_], [F, []]),
    NewIndex is Index+1,
    calculateMaskFactories(Rest, NewIndex, FM),
    !.

calculateMaskFactories([_|Rest], Index, [NewIndex|FM]):-
    NewIndex is Index+1,
    calculateMaskFactories(Rest, NewIndex,FM).

calculateMaskFactories(Factories, Mask) :-
    calculateMaskFactories(Factories, 0, Mask).


:- ["blue.pl"].

%=========
% RANDOM
%=========

selectRandomFactory(F, SF):-
    random(0, 9, I),
    getByIndex(F, I, SF).

selectRandomColor(SF, [ColorR, CountR]):-
    length(SF, L),
    random(0,L, I),
    getByIndex(SF, I, [ColorR, CountR]).
    
selectRandomFactoryOrTable(Result):-
    random(0, 1.0, R),
    X is 9/10,
    probs(R, X, Result).

selectRandom(Factories, Table, TableR, [ColorR, CountR]):-
    selectRandomFactoryOrTable(1),
    selectRandomFactory(Factories, SF),
    selectRandomColor(SF, [ColorR, CountR]),
    factoryGetColor(SF, ColorR, Table, TableR),
    !.

selectRandom(_, Table, TableR, [ColorR, CountR]):-
    selectRandomColor(Table, [ColorR, CountR]),
    tablePopColor(Table, ColorR,TableR, _).
    


    




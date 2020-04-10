:-["utils.pl"].

options([], []):-!.

options([F|Factories], FO):-
    length([F|Factories], L),
    Index is 9-L, 
    getOptions(F,Index,O),
    options(Factories, Options),
    concatLists(O, Options, FO).

getOptions([[_, 0]|Factory], Index, Rest):-
    getOptions(Factory, Index, Rest).

getOptions([ColorTuple|Factory],Index, [[Index, ColorTuple]|Rest]):-
    getOptions(Factory, Index,Rest).

allOptions(Factories, Table, Options):-
    options(Factories, FO),
    getOptions(Table, 9, TO),
    concatLists(FO, TO, Options).

    
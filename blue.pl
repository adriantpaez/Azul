
:- ["utils.pl"].

% ==========
% COLORTUPLE
% ==========

%  colorTuple(Color,Count,CT)
% Inicializa un ColorTuple en CT con Color y Count
% 
colorTuple(Color,Count,[Color,Count]).

% insertTile(ColorTuple,Count,ColorTupleResult)
% Incrementa el contador de ColorTuple en Count
insertTile([Color,ColorCount], Count, [Color,CountResult]) :- 
    CountResult is ColorCount + Count.

% ===========
% COLORVECTOR
% ===========

% colorVector(CV)
% Inicializa un ColorVector en CV
% 
colorVector([[azul,0],[amarillo,0],[rojo,0],[negro,0],[blanco,0]]).


% pushNColorVector(ColorVector,Color,N,ColorVectorResult)
% Aumenta en N la cantidad de Color en ColorVector, dando como resultado ColorVectorResult
% 
pushNColorVector([[Color,Count]|ColorVector],Color,N,[[Color,NewCount]|ColorVector]) :- 
    NewCount is Count + N, !.

pushNColorVector([[OtherColor,Count]|ColorVector],Color,N,[[OtherColor,Count]|ColorVectorResult]) :- 
    pushNColorVector(ColorVector,Color,N,ColorVectorResult).

% =====
% FLOOR
% =====

floorVector([[false,-1], [false,-1], [false,-2], [false,-2], [false,-2], [false,-3], [false,-3]]).

% floorPoint(FloorVector,Points).
% Calcular los puntos negativos del piso
% 
floorPoint([],0) :- !.

floorPoint([[false,_]|R],Points) :-
    floorPoint(R,Points), !.

floorPoint([[true,Value]|R],Points) :-
    floorPoint(R,RPoints),
    Points is RPoints + Value.

% ====
% WALL
% ====

% rowPoints(W,I,TL,P)
% Devuelve en P los puntos que se ganan en fila por jugar en la posición I de W con TL como tope de izquierdo de la fila
rowPoints(W,I,TL,P) :- 
    TR is TL+4, 
    countCountinous(W,I,-1,TL,PL), 
    countCountinous(W,I,1,TR,PR), 
    P is PL + PR - 1.

% columnPoints(W,I,TU,P)
% Devuelve en P los puntos que se ganan en columna por jugar en la posición I de W con TU como tope superior de la columna
columnPoints(W,I,TU,P) :-  
    TD is TU+20, 
    countCountinous(W,I,-5,TU,PU), 
    countCountinous(W,I,5,TD,PD), 
    P is PU + PD - 1.

% wallPoints(W,I,P)
% Deveuelve en P los puntos por jugar en la posición I de W
wallPoints(W,I,0) :-
    getByIndex(W,I,0), !.

wallPoints(W,I,P) :-
    TL is (I/5) * 5, 
    rowPoints(W,I,TL,PR), 
    TU is I mod 5, 
    columnPoints(W,I,TU,PC), 
    P is PR + PC.


% ===
% BAG
% ===


% initializebag(B)
% Genera la bolsa inicial del juego con las 100 fichas, 20 de cada una
initializebag([[BlueTuple,YellowTuple,RedTuple,BlackTuple, WhiteTuple],[0,1,2,3,4]]) :-
    colorTuple(azul,20,BlueTuple),
    colorTuple(amarillo,20,YellowTuple),
    colorTuple(rojo,20,RedTuple),
    colorTuple(negro,20,BlackTuple),
    colorTuple(blanco,20,WhiteTuple).


takeOneBag([BagVector,Mask],Index,[BagVectorResult,MaskResult],ColorResult) :-
    getByIndex(BagVector,Index,ColorTuple),
    insertTile(ColorTuple,-1,[ColorResult,0]),
    pushNColorVector(BagVector,ColorResult,-1,BagVectorResult),
    removeValue(Mask,Index,MaskResult), !.

takeOneBag([BagVector,Mask],Index,[BagVectorResult,Mask],ColorResult) :-
    getByIndex(BagVector,Index,ColorTuple),
    insertTile(ColorTuple,-1,[ColorResult,_]),
    pushNColorVector(BagVector,ColorResult,-1,BagVectorResult).

                                                                            

takeNBag([BagVector,[]], _, Factory,Factory ,[BagVector,[]]) :- !.

takeNBag([BagVector,Mask], 0, Factory,Factory ,[BagVector,Mask]) :- !.

takeNBag([BagVector,Mask], Count, Factory,FactoryResult ,[BagVectorResult,MaskResult]) :-
    length(Mask,R),
    random(0,R,I),
    getByIndex(Mask,I,J),
    takeOneBag([BagVector,Mask],J,[BagVectorTemp,MaskTemp],Color),
    pushNColorVector(Factory,Color,1,FactoryTemp),
    NewCount is Count - 1,
    takeNBag([BagVectorTemp,MaskTemp],NewCount,FactoryTemp,FactoryResult,[BagVectorResult,MaskResult]).

% =======
% FACTORY
% =======

factoryEmpty([[azul,0],[amarillo,0],[rojo,0],[negro,0],[blanco,0]]).

% factories(FC,B,FL,BR)
% FL es el resultado de generar FC factorias, tomando de la bolsa B y dando BR como la bolsa resultante
makeNFactories(0,Bag,[],Bag) :- !.
makeNFactories(N,Bag,[FactoryResult|RFactoryList],BagResult) :-
    factoryEmpty(Factory),
    takeNBag(Bag,4,Factory,FactoryResult,RBagResult),
    NewN is N - 1,
    makeNFactories(NewN,RBagResult,RFactoryList,BagResult).


getIndex(azul,0).
getIndex(amarillo,1).
getIndex(rojo,2).
getIndex(negro,3).
getIndex(blanco,4).

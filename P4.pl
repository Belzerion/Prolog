:- use_module(library(clpfd)).
:- use_module(library(lists)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* Vertical EndgameTest
  J : joueur
  G : Grille de jeu
*/
concat(L1,[],L1).
concat(L1,[X|L2],[X|L3]):- concat(L1,L2,L3).
verticalEndGame(L,S):- concat(_,S,L).
verticalEndGame([_|L],S):- concat(_,S,L).
verticalEndGame([L|_],X):- verticalEndGame(L, [X,X,X,X]).
verticalEndGame([_|G],J):- verticalEndGame(G,J).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* Horizontal End Game Test
  J : Joueur
  G : Grille de
*/
horizontalEndGame(G,J):- transpose(G,T), verticalEndGame(T,J).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* Diagonal End Game Test
  J : Joueur
  G : Grille de jeu
*/
diag3([L|Q],J,I,N):- LI is I+1, nth0(LI,L,J), N is 1.
diag2([L|Q],J,I,N):- LI is I+1, nth0(LI,L,J), diag3(Q,J,LI,R), N is R+1.
diag1([L|Q],J,I,N):- LI is I+1, nth0(LI,L,J), diag2(Q,J,LI,R), N is R+1.
diagonalEndGame([L|Q],J,N):- nth0(I,L,J), diag1(Q,J,I,R), N is R+1.
diagonalEndGame(L,J):- diagonalEndGame(L,J,N), N == 4.
diagonalEndGame([_|G],J):- diagonalEndGame(G,J,N), N == 4.
diagonalEndGame([_|G],J):- diagonalEndGame(G,J).

diag3Bis([L|Q],J,I,N):- LI is I-1, nth0(LI,L,J), N is 1.
diag2Bis([L|Q],J,I,N):- LI is I-1, nth0(LI,L,J), diag3Bis(Q,J,LI,R), N is R+1.
diag1Bis([L|Q],J,I,N):- LI is I-1, nth0(LI,L,J), diag2Bis(Q,J,LI,R), N is R+1.
diagonalEndGameBis([L|Q],J,N):- nth0(I,L,J), diag1Bis(Q,J,I,R), N is R+1.
diagonalEndGameBis(L,J):- diagonalEndGameBis(L,J,N), N == 4.
diagonalEndGameBis([_|G],J):- diagonalEndGameBis(G,J,N), N == 4.
diagonalEndGameBis([_|G],J):- diagonalEndGameBis(G,J).

/* Test à lancer pour le test de fin diagonale*/
diagonalEnd(G,J):- diagonalEndGame(G,J); diagonalEndGameBis(G,J).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* Test si la grille est pleine
  G : Grille de jeu
*/
fullGrid([]).
fullGrid([T|Q]):- length(T,6), fullGrid(Q).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* Jouer un Coup */
inserto(_,[],[],_).
inserto(E,[_|Xs],[E|Ys],1) :- inserto(E,Xs,Ys,0),!.
inserto(E,[X|Xs],[X|Ys],N) :- N1 #= N-1,  % N<=length(List)
                              inserto(E,Xs,Ys,N1).

maJGrille(G,I,L3):- IB is I+1, inserto(L3,G,GBIS,IB), write(GBIS).

jouerCoupValide([L|_],I,X,N,L3):- N == I, append(L,[X],L3).
jouerCoupValide([L|Q],I,X,N,L3):- R is N+1, jouerCoupValide(Q,I,X,R,L3).
jouerCoupValide(G,I,X):- N is 0, jouerCoupValide(G,I,X,N,L3), maJGrille(G,I,L3).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

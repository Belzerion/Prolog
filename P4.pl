:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- use_module(library(random)).


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
  G : Grille de jeu
*/
hor1([L|Q],J,I,N):- nth0(I,L,J), N is 1.
hor1([L|Q],J,I,N):- nth0(I,L,J), hor1(Q,J,I,R), N is R+1.
horizontalEndGame([L|Q],J,N):- nth0(I,L,J), hor1(Q,J,I,R), N is R+1.
horizontalEndGame(L,J):- horizontalEndGame(L,J,N), N == 4.
horizontalEndGame([_|G],J):- horizontalEndGame(G,J).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* Diagonal End Game Test
  J : Joueur
  G : Grille de jeu
*/
diag1([L|Q],J,I,N):- LI is I+1, nth0(LI,L,J), N is 1.
diag1([L|Q],J,I,N):- LI is I+1, nth0(LI,L,J), diag1(Q,J,LI,R), N is R+1.
diagonalEndGame([L|Q],J,N):- nth0(I,L,J), diag1(Q,J,I,R), N is R+1.
diagonalEndGame(L,J):- diagonalEndGame(L,J,N), N == 4.
diagonalEndGame([_|G],J):- diagonalEndGame(G,J).

diag1Bis([L|Q],J,I,N):- LI is I-1, nth0(LI,L,J), N is 1.
diag1Bis([L|Q],J,I,N):- LI is I-1, nth0(LI,L,J), diag1Bis(Q,J,LI,R), N is R+1.
diagonalEndGameBis([L|Q],J,N):- nth0(I,L,J), diag1Bis(Q,J,I,R), N is R+1.
diagonalEndGameBis(L,J):- diagonalEndGameBis(L,J,N), N == 4.
diagonalEndGameBis([_|G],J):- diagonalEndGameBis(G,J).

/* Test à lancer pour le test de fin diagonale*/
diagonalEnd(G,J):- diagonalEndGame(G,J); diagonalEndGameBis(G,J).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* Teste si la grille est pleine
  T : tête de la grille de jeu
  Q : queue de la grille de jeu
*/
fullGrid([]).
fullGrid([T|Q]):- length(T,6), fullGrid(Q).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* Test pour la fin de jeu
  G : Grille de jeu
  J : joueur
*/
endGame(G,J):- diagonalEnd(G,J); horizontalEndGame(G,J); verticalEndGame(G,J).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* Jouer un Coup
  référence du inserto : https://stackoverflow.com/questions/35069340/insert-element-into-a-2d-list-in-prolog
*/
inserto(_,[],[],_).
inserto(E,[_|Xs],[E|Ys],1) :- inserto(E,Xs,Ys,0),!.
inserto(E,[X|Xs],[X|Ys],N) :- N1 #= N-1,  % N<=length(List)
                              inserto(E,Xs,Ys,N1).

maJGrille(G,I,L3,NEWG):- length(L3,T), T > 6, write("Coup invalide"); IB is I+1, inserto(L3,G,NEWG,IB).

jouerCoupValide([L|_],I,X,N,L3):- N == I, append(L,[X],L3).
jouerCoupValide([L|Q],I,X,N,L3):- R is N+1, jouerCoupValide(Q,I,X,R,L3).
jouerCoupValide(G,I,X,NEWG):- N is 0, jouerCoupValide(G,I,X,N,L3), maJGrille(G,I,L3,NEWG).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* humain vs humain */
jouerCoupX(G, COL):- jouerCoupValide(G,COL,x,NEWG), write(NEWG), (endGame(NEWG,x), write("\nX gagne"); fullGrid(NEWG), write("\nla grille est pleine")).

jouerCoupO(G, COL):- jouerCoupValide(G,COL,o,NEWG), write(NEWG), (endGame(NEWG,o), write("\nO gagne"); fullGrid(NEWG), write("\nla grille est pleine")).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* IA Min max  */

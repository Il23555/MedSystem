
pow(_,0,1).
pow(B,E,R) :- E > 0,!, E1 is E -1, pow(B,E1,R1), R is B * R1.

/* Функции принадлежности */
pressure(X, 'нормальное', 0):- X=<90.
pressure(X, 'нормальное', R):- X>90,X<100, X1 is ((X-90)/20), pow(X1, 2, X2), R is 2*X2.
pressure(X, 'нормальное', R):- X>=100, X<110, X1 is ((110-X)/20), pow(X1, 2, X2), R is 1-2*X2.
pressure(X, 'нормальное', 1):- X>=110.

pressure(X, 'пониженное', 0):- X>=110.
pressure(X, 'пониженное', R):- X>=100, X<110, X1 is ((110-X)/20), pow(X1, 2, X2), R is 2*X2.
pressure(X, 'пониженное', R):- X>90, X<100, X1 is ((X-90)/20), pow(X1, 2, X2), R is 1-2*X2.
pressure(X, 'пониженное', 1):- X=<90.

conscience(X, 'отсутствует', 0):- X>3.
conscience(X, 'отсутствует', R):- X>1, X=<3, X1 is ((3-X)/3), pow(X1, 2, X2), R is 2*X2.
conscience(X, 'отсутствует', R):- X>0, X=<1, X1 is (X/3), pow(X1, 2, X2), R is 1-2*X2.
conscience(0, 'отсутствует', 1).

conscience(X, 'прослеживается', 0):- X<1.
conscience(X, 'прослеживается', R):- X>=1,X<2, X1 is ((X-1)/3), pow(X1, 2, X2), R is 2*X2.
conscience(X, 'прослеживается', R):- X>=2, X<4, X1 is ((4-X)/3), pow(X1, 2, X2), R is 1-2*X2.
conscience(X, 'прослеживается', 1):- X>=4.

nitrogen(X, 'нормальный', 0):- X>7.
nitrogen(X, 'нормальный', R):- X>6.6, X=<7, X1 is ((7-X)/0.8), pow(X1, 2, X2), R is 2*X2.
nitrogen(X, 'нормальный', R):- X>6.2, X=<6.6, X1 is ((X-6.2)/0.8), pow(X1, 2, X2), R is 1-2*X2.
nitrogen(X, 'нормальный', 1):- X=<6.2.

nitrogen(X, 'повышенный', 0):- X=<6.4.
nitrogen(X, 'повышенный', R):- X>6.4,X<6.8, X1 is ((X-6.4)/0.8), pow(X1, 2, X2), R is 2*X2.
nitrogen(X, 'повышенный', R):- X>=6.8, X<7.2, X1 is ((7.2-X)/0.8), pow(X1, 2, X2), R is 1-2*X2.
nitrogen(X, 'повышенный', 1):- X>=7.2.

breath(X, 'не часто', 0):- X>26.
breath(X, 'не часто', R):- X>22, X=<26, X1 is ((26-X)/8), pow(X1, 2, X2), R is 2*X2.
breath(X, 'не часто', R):- X>18, X=<22, X1 is ((X-18)/8), pow(X1, 2, X2), R is 1-2*X2.
breath(X, 'не часто', 1):- X=<18.

breath(X, 'часто', 0):- X=<18.
breath(X, 'часто', R):- X>18,X<23, X1 is ((X-18)/10), pow(X1, 2, X2), R is 2*X2.
breath(X, 'часто', R):- X>=23, X<28, X1 is ((28-X)/10), pow(X1, 2, X2), R is 1-2*X2.
breath(X, 'часто', 1):- X>=28.

age(X, 'взрослый', 0):- X>60.
age(X, 'взрослый', R):- X>56, X=<60, X1 is ((60-X)/8), pow(X1, 2, X2), R is 2*X2.
age(X, 'взрослый', R):- X>52, X=<56, X1 is ((X-52)/8), pow(X1, 2, X2), R is 1-2*X2.
age(X, 'взрослый', 1):- X=<52.

age(X, 'пожилой', 0):- X=<50.
age(X, 'пожилой', R):- X>50,X<57, X1 is ((X-50)/14), pow(X1, 2, X2), R is 2*X2.
age(X, 'пожилой', R):- X>=57, X<64, X1 is ((64-X)/14), pow(X1, 2, X2), R is 1-2*X2.
age(X, 'пожилой', 1):- X>=64.

/* Расчет минимума в списке */
car([H|_],H).
cdr([_|B],B).
min(X,Y,X):-Y>X.
min(X,Y,Y):-X>=Y.
min_list([X],X).
min_list(S, X):-car(S,Y1),cdr(S,Y3),min_list(Y3,Y2),min(Y1,Y2,X).

/* Фазификация и агрегирование степеней истинности предпосылок */
truthfulness(X1, X2, X3, X4, X5,
                              F_А1, F_A2, F_A3, F_A4, F_A5, Y):-
    pressure(X1, F_А1, A1),
    conscience(X2, F_A2, A2),
    nitrogen(X3, F_A3, A3),
    breath(X4, F_A4, A4),
    age(X5, F_A5, A5),
    min_list([A1, A2, A3, A4, A5], Y).


/* Использование базы правил -> (фазификация & агрегирование) & активизация */
rule1(X1, X2, X3, X4, X5, Y, B):- truthfulness(X1, X2, X3, X4, X5,
                                                                   'нормальное', 'прослеживается', 'нормальный','не часто', 'взрослый', Y),
                                                B is 1.
rule2(X1, X2, X3, X4, X5, Y, B):- truthfulness(X1, X2, X3, X4, X5,
                                                                   'нормальное', 'отсутствует', 'нормальный', 'не часто', 'взрослый', Y),
                                                B is 0.
rule3(X1, X2, X3, X4, X5, Y, B):- truthfulness(X1, X2, X3, X4, X5,
                                                                   'нормальное', 'прослеживается', 'повышенный', 'не часто', 'взрослый', Y),
                                                B is 2.
rule4(X1, X2, X3, X4, X5, Y, B):- truthfulness(X1, X2, X3, X4, X5,
                                                                   'нормальное', 'отсутствует', 'повышенный', 'не часто', 'взрослый', Y),
                                                B is 1.
rule5(X1, X2, X3, X4, X5, Y, B):- truthfulness(X1, X2, X3, X4, X5,
                                                                   'нормальное', 'прослеживается', 'нормальный', 'часто', 'взрослый', Y),
                                                B is 2.
rule6(X1, X2, X3, X4, X5, Y, B):- truthfulness(X1, X2, X3, X4, X5,
                                                                   'нормальное', 'отсутствует', 'нормальный', 'часто', 'взрослый', Y),
                                                B is 1.
rule7(X1, X2, X3, X4, X5, Y, B):- truthfulness(X1, X2, X3, X4, X5,
                                                                   'нормальное', 'прослеживается', 'повышенный', 'часто', 'взрослый', Y),
                                                B is 3.
rule8(X1, X2, X3, X4, X5, Y, B):- truthfulness(X1, X2, X3, X4, X5,
                                                                   'нормальное', 'отсутствует', 'повышенный', 'часто', 'взрослый', Y),
                                                B is 2.
rule9(X1, X2, X3, X4, X5, Y, B):- truthfulness(X1, X2, X3, X4, X5,
                                                                   'пониженное', 'прослеживается', 'нормальный', 'не часто', 'взрослый', Y),
                                                B is 2.
rule10(X1, X2, X3, X4, X5, Y, B):- truthfulness(X1, X2, X3, X4, X5,
                                                                   'пониженное', 'отсутствует', 'нормальный', 'не часто', 'взрослый', Y),
                                                B is 1.
rule11(X1, X2, X3, X4, X5, Y, B):- truthfulness(X1, X2, X3, X4, X5,
                                                                   'пониженное', 'прослеживается', 'повышенный', 'не часто', 'взрослый', Y),
                                                B is 3.
rule12(X1, X2, X3, X4, X5, Y, B):- truthfulness(X1, X2, X3, X4, X5,
                                                                   'пониженное', 'отсутствует', 'повышенный', 'не часто', 'взрослый', Y),
                                                B is 2.
rule13(X1, X2, X3, X4, X5, Y, B):- truthfulness(X1, X2, X3, X4, X5,
                                                                   'пониженное', 'прослеживается', 'нормальный', 'часто', 'взрослый', Y),
                                                B is 3.
rule14(X1, X2, X3, X4, X5, Y, B):- truthfulness(X1, X2, X3, X4, X5,
                                                                   'пониженное', 'отсутствует', 'нормальный', 'часто', 'взрослый', Y),
                                                B is 2.
rule15(X1, X2, X3, X4, X5, Y, B):- truthfulness(X1, X2, X3, X4, X5,
                                                                   'пониженное', 'прослеживается', 'повышенный', 'часто', 'взрослый', Y),
                                                B is 4.
rule16(X1, X2, X3, X4, X5, Y, B):- truthfulness(X1, X2, X3, X4, X5,
                                                                   'пониженное', 'отсутствует', 'повышенный', 'часто', 'пожилой', Y),
                                                B is 3.
rule17(X1, X2, X3, X4, X5, Y, B):- truthfulness(X1, X2, X3, X4, X5,
                                                                   'нормальное', 'прослеживается', 'нормальный', 'не часто', 'пожилой', Y),
                                                B is 2.
rule18(X1, X2, X3, X4, X5, Y, B):- truthfulness(X1, X2, X3, X4, X5,
                                                                   'нормальное', 'отсутствует', 'нормальный', 'не часто', 'пожилой', Y),
                                                B is 1.
rule19(X1, X2, X3, X4, X5, Y, B):- truthfulness(X1, X2, X3, X4, X5,
                                                                   'нормальное', 'прослеживается', 'повышенный', 'не часто', 'пожилой', Y),
                                                B is 3.
rule20(X1, X2, X3, X4, X5, Y, B):- truthfulness(X1, X2, X3, X4, X5,
                                                                   'нормальное', 'отсутствует', 'повышенный', 'не часто', 'пожилой', Y),
                                                B is 2.
rule21(X1, X2, X3, X4, X5, Y, B):- truthfulness(X1, X2, X3, X4, X5,
                                                                   'нормальное', 'прослеживается', 'нормальный', 'часто', 'пожилой', Y),
                                                B is 3.
rule22(X1, X2, X3, X4, X5, Y, B):- truthfulness(X1, X2, X3, X4, X5,
                                                                   'нормальное', 'отсутствует', 'нормальный', 'часто', 'пожилой', Y),
                                                B is 2.
rule23(X1, X2, X3, X4, X5, Y, B):- truthfulness(X1, X2, X3, X4, X5,
                                                                   'нормальное', 'прослеживается', 'повышенный', 'часто', 'пожилой', Y),
                                                B is 4.
rule24(X1, X2, X3, X4, X5, Y, B):- truthfulness(X1, X2, X3, X4, X5,
                                                                   'нормальное', 'отсутствует', 'повышенный', 'часто', 'пожилой', Y),
                                                B is 3.
rule25(X1, X2, X3, X4, X5, Y, B):- truthfulness(X1, X2, X3, X4, X5,
                                                                   'пониженное', 'прослеживается', 'нормальный', 'не часто', 'пожилой', Y),
                                                B is 3.
rule26(X1, X2, X3, X4, X5, Y, B):- truthfulness(X1, X2, X3, X4, X5,
                                                                   'пониженное', 'отсутствует', 'нормальный', 'не часто', 'пожилой', Y),
                                                B is 2.
rule27(X1, X2, X3, X4, X5, Y, B):- truthfulness(X1, X2, X3, X4, X5,
                                                                   'пониженное', 'прослеживается', 'повышенный', 'не часто', 'пожилой', Y),
                                                B is 4.
rule28(X1, X2, X3, X4, X5, Y, B):- truthfulness(X1, X2, X3, X4, X5,
                                                                   'пониженное', 'отсутствует', 'повышенный', 'не часто', 'пожилой', Y),
                                                B is 3.
rule29(X1, X2, X3, X4, X5, Y, B):- truthfulness(X1, X2, X3, X4, X5,
                                                                   'пониженное', 'прослеживается', 'нормальный', 'часто', 'пожилой', Y),
                                                B is 4.
rule30(X1, X2, X3, X4, X5, Y, B):- truthfulness(X1, X2, X3, X4, X5,
                                                                   'пониженное', 'отсутствует', 'нормальный', 'часто', 'пожилой', Y),
                                                B is 3.
rule31(X1, X2, X3, X4, X5, Y, B):- truthfulness(X1, X2, X3, X4, X5,
                                                                   'пониженное', 'прослеживается', 'повышенный', 'часто', 'пожилой', Y),
                                                B is 5.
rule32(X1, X2, X3, X4, X5, Y, B):- truthfulness(X1, X2, X3, X4, X5,
                                                                   'пониженное', 'отсутствует', 'повышенный', 'часто', 'пожилой', Y),
                                                B is 4.
/* Деффазификация без предварительного аккумулирования активизированных заключений отдельных правил,
 *  используется разновидность метода центра тяжести для одноточечных множеств */
fuzzy_logic(X1, X2, X3, X4, X5, Y):-
    rule1(X1, X2, X3, X4, X5, Y1, B1),
    rule2(X1, X2, X3, X4, X5, Y2, B2),
    rule3(X1, X2, X3, X4, X5, Y3, B3),
    rule4(X1, X2, X3, X4, X5, Y4, B4),
    rule5(X1, X2, X3, X4, X5, Y5, B5),
    rule6(X1, X2, X3, X4, X5, Y6, B6),
    rule7(X1, X2, X3, X4, X5, Y7, B7),
    rule8(X1, X2, X3, X4, X5, Y8, B8),
    rule9(X1, X2, X3, X4, X5, Y9, B9),
    rule10(X1, X2, X3, X4, X5, Y10, B10),
    rule11(X1, X2, X3, X4, X5, Y11, B11),
    rule12(X1, X2, X3, X4, X5, Y12, B12),
    rule13(X1, X2, X3, X4, X5, Y13, B13),
    rule14(X1, X2, X3, X4, X5, Y14, B14),
    rule15(X1, X2, X3, X4, X5, Y15, B15),
    rule16(X1, X2, X3, X4, X5, Y16, B16),
    rule17(X1, X2, X3, X4, X5, Y17, B17),
    rule18(X1, X2, X3, X4, X5, Y18, B18),
    rule19(X1, X2, X3, X4, X5, Y19, B19),
    rule20(X1, X2, X3, X4, X5, Y20, B20),
    rule21(X1, X2, X3, X4, X5, Y21, B21),
    rule22(X1, X2, X3, X4, X5, Y22, B22),
    rule23(X1, X2, X3, X4, X5, Y23, B23),
    rule24(X1, X2, X3, X4, X5, Y24, B24),
    rule25(X1, X2, X3, X4, X5, Y25, B25),
    rule26(X1, X2, X3, X4, X5, Y26, B26),
    rule27(X1, X2, X3, X4, X5, Y27, B27),
    rule28(X1, X2, X3, X4, X5, Y28, B28),
    rule29(X1, X2, X3, X4, X5, Y29, B29),
    rule30(X1, X2, X3, X4, X5, Y30, B30),
    rule31(X1, X2, X3, X4, X5, Y31, B31),
    rule32(X1, X2, X3, X4, X5, Y32, B32),
    Y is (Y1*B1 + Y2*B2 + Y3*B3+Y4*B4+
         Y5*B5 + Y6*B6 + Y7*B7 + Y8*B8+
         Y9*B9 + Y10*B10 + Y11*B11 + Y12*B12+
         Y13*B13 + Y14*B14 + Y15*B15 + Y16*B16 +
         Y17*B17 + Y18*B18 + Y19*B19 + Y20*B20+
         Y21*B21 + Y22*B22 + Y23*B23+Y24*B24+
         Y25*B25 + Y26*B26 + Y27*B27 + Y28*B28+
         Y29*B29 + Y30*B30 + Y31*B31 + Y32*B32)/(Y1 + Y2 + Y3+ Y4 +
                                                Y5 + Y6+Y7 + Y8+
                                                Y9+Y10+Y11+Y12+
                                                Y13+Y14 + Y15 + Y16+
                                                Y17 +Y18+Y19+Y20+
                                                 Y21 +Y22 +Y23+Y24 +
                                                Y25 + Y26+Y27 +Y28+
                                                Y29+Y30+Y31+Y32).


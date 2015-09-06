MYDIR =: getpath_j_  '\/' rplc~ > (4!:4<'thisfile'){(4!:3)  thisfile=:'' NB. boilerplate to set the working directory
require MYDIR , 'bn.ijs'

assign_z_ =: 4 : '(x) =: y'

cocurrent 'bnctx'
sum2 =: 3 : 0 NB. slow and mem hog demo
acc =. newM {: y
toX__acc (}: y)  ( [: add__acc newM@[) reduce acc
)

sum =: 3 : 0 
acc =. newM {: y
toX__acc (}: y)  4 : 'y[ BNfree a [ BNadd I__y;I__y;a =. newI x' reduce acc
)
sum3 =: 3 : 0 
acc =. newM {: y
toX__acc (}: y)  addX__acc@[ reduce acc
)
sum4 =: 3 : 0
acc =. newM {. y
toX__acc addW__acc"0 }.y
)
sum2 =: 3 : 0
acc =. newM {: y
toX__acc (}: y)  4 : 'y[ BNadd_word I__y; x' reduce acc
)
MRabin =: 4 : 0 NB. millerrabin text.  x is random witnesses < y
e =. <. @ -:^:(0=2&|)^:a: y-1
for_a. x  do. if. (+./c=y-1) +: 1={:c=. a y&|@^"0 e do. 0 return. end. end.
 1
)
MRabinBN=: 4 : 0 NB. millerrabin text.  x is random witnesses < y
Y =. newM y
NB.y1 =. dupM Y
NB. BNsub_word I__y1;1
NB. yl =. ,y1d =. dupM y1
NB. NB.e =. <. @ -:^:(0=2&|)^:a: y-1
E =. newM e =. <. @ -:^:(0=2&|)^:a: y-1
NB.while.0 = BNis_odd I__i [i=.{: yl do.  yl =. yl , 'BNdiv_word I;2' inl dup__i end.
NB.'toX a:' inl yl
for_a. 'I' inl newM x  do. 
   BNmod_exp"1   EEi ;"0 1 a ;"1  EEi;"0 1 I__Y ; (CTX)[EEi =. 'I' inl EE =. dupM E 
'toX a:' inl EE
if. (+./ (y-1) = 'toX a:' inl EE) +: 1= BNget_word {: EEi do. out=.0 return. end. 

end. pD 1

label_cleanup.
)

cocurrent 'ctx'

NB.sum =:  3 : '( [: toX_ctx_ (][ [: BNadd_ctx_ ] ; ;)/)a =. newM y'
sum =:   (][ [: BNadd_ctx_ ] ; ;)/@:newM
sum2 =: 3 : 0 NB. test avoids appending long pointer to xints 
acc =. newM {: y
(}: y) 4 : 'y[ BNfree a [ BNadd y;y;a =. newI x' reduce acc   
)
ProductW =: 3 : 0
acc =. newM {: y
(}: y) 4 : 'y[ BNfree a [ BNmul_word y;a =. newI x' reduce acc   
)
product =: (][ [: BNmul_ctx_ ] ;wCTX ;)/@:newM

MRabinBN=: 4 : 0 NB. millerrabin text.  x is random witnesses < y
Y =. newM y
E =. newM e =. <. @ -:^:(0=2&|)^:a: y-1
for_a. newM x  do. 
  BNmod_exp"1   EEi ;"0 1 a ;"1  EEi;"0 1 Y ; (CTX)[EEi  =. dupM E 
  
   if. (+./ (y-1) = toX  EEi) +: 1= BNget_word {: EEi do. out=.0 return. end. 

end.  1
)

NB. seed modified on each call.
NB. creates an object with roll function that takes word to reduce to.
lCG =: 3 : 0 NB. returns lcg object class.  y:  modPrimeX addX  SeedX
(coself a:) new_lcg_ pD new y
)
BBS =: 3 : '(coself a:) new_blum_ pD new y'
NB. j implementation is same speed at 400bit modulus. 4x slower at 800bit modulus
lcgj =: 3 : 0
'p a s' =. y
seed =: s
roll =: (] | 'seed' ([ assign  a + ]) (p|~seed) (p|*) 3 : 'seed')"0
1
)
bbsj =: 3 : 0  NB. 60x slower than BBS (BN implementation)
'p s' =. y
seedb =: s  
rollb =: (] | 'seedb' assign  [: p&|@(*:) 3 : 'seedb')"0
1
)


cocurrent 'lcg'  NB. uses context. meant for secure_ctx_ feature in openssl 1.03
create =: 3 : 0
x =. 0 {:: y
coinsert C =: '' conew x
'P A S ' =: getfrom__C("0) 1{:: y
M =: getE__C a:
BNmod__C  M;P;S;CTX__C
roll =: ([: BNmod_word__C S;] [[: BNmod_add__C S;S;A;P;CTX__C [[:BNmod_mul__C S;S;M;P;CTX__C"_)"0
1
)
new =: 4 : ' (x,&< y) conew coself a:'  NB. x is locale to inherit from
rollE =: 3 : 0"0
BNmod_mul__C S;S;M;P;CTX__C
BNmod_add__C S;S;A;P;CTX__C
BNmod_word__C S;y
)
destroy =: 3 : 'codestroy__C [BNclear_free P;M;S;A'

NB. more secure and 33% faster than BN lcg at 800 bits due to fewer calls.
cocurrent 'blum' NB. blum blum shub rng

create =: 3 : 0
x =. 0 {:: y
coinsert C =: '' conew x
'P S ' =: getfrom__C("0) 1{:: y
roll =: ([: BNmod_word__C S;][ [:BNmod_sqr__C S;S;P;CTX__C"_)"0
1
)
new =: 4 : ' (x,&< y) conew coself a:'  NB. x is locale to inherit from
rollE =: 3 : 0"0
BNmod_sqr__C S;S;P;CTX__C
BNmod_word__C S;y
)

destroy =: 3 : 'codestroy__C [BNclear_free P;S'

coclass 'base'
NB. (][BNadd__C)^:1000 I__a;I__a;I__a
NB. FIBONACI full cycle
fibtest =: 3 : 0
'fibCtx' coassign  '' conew 'bnctx'
(codestroy__fibCtx@:(''"_) ] ,.@('toX a:'&inl)) MANAGED__fibCtx[(1 2 0{][BNadd__fibCtx)^:y  '<I'inl newM__fibCtx 1 1 1
)

sum =: 3 : 0
'sumCtx' coassign  '' conew 'bnctx'
incontext__sumCtx
)
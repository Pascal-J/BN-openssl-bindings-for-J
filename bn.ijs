require 'dll'
cocurrent 'ssl'
sslp =: IFWIN pick '';'D:\OpenSSL-Win64\bin\' NB. OVERWRITTEN NEXT LINE
sslp =: IFWIN pick ''; '/',~ jpath '~bin'  NB. with J802.  cut this line if you wish to point to downloaded folder
NB. OPENSSL =: jpath '~system/ssleay32.dll '
NB.OPENSSL =: sslp , '\ssleay32.dll '
OPENSSL =: sslp , (IFIOS + (;: 'Win Linux Android Darwin') i. <UNAME_z_) pick 'libeay32.dll '; ('libssl.so';'/system/lib/libssl.so'),  (2 $ <'/usr/lib/libssl.dylib ')
NB.OPENSSL =: sslp , (IFIOS + (;: 'Win Linux Android Darwin') i. <UNAME_z_) pick 'libeay32.dll '; (2 $ <'libssl.so ');  (2 $ <'libssl.0.9.8.dylib ')

SSLE =: sslp , '\openssl'
ssl =: 1 : '(OPENSSL , m)&cd'

NB. =========================================================
NB. DOCS: https://www.openssl.org/docs/manmaster/crypto/bn.html
NB. =========================================================

BNctxnew =: ' BN_CTX_new > x' ssl
BNCTX_securenew =: ' BN_CTX_secure_new  >  x' ssl
BNnew =: ' BN_new >  x' ssl  NB. probably don't use... unamanaged memory version.
NB. BIGNUM *BN_bin2bn(const unsigned char *s,int len,BIGNUM *ret)
bin2BN =: ' BN_bin2bn > x *c l x' ssl
NB. int	BN_bn2bin(const BIGNUM *a, unsigned char *to)
BN2bin =: ' BN_bn2bin  i x *c' ssl
BN2mpi =: ' BN_bn2bin  i x *c' ssl	NB.int BN_bn2mpi(const BIGNUM *a, unsigned char *to);
BN_bn2hex=: ' BN_bn2hex  c x ' ssl NB.char * BN_bn2hex(const BIGNUM *a);
BN_hex2bn =:  ' BN_hex2bn  i *x *c' ssl  NB.(BIGNUM **a, const char *str);
BNnum_bytes=: ' BN_num_bytes  i *i' ssl  NB. doest work as its macro?
NB. int BN_num_bits(const BIGNUM *a)
BNnum_bits=: ' BN_num_bits >  i x' ssl
num_bytes =: 0.125 >.@* BNnum_bits
BN2dec=: ' BN_bn2dec >   x x' ssl NB. char *BN_bn2dec(const BIGNUM *num)
dec2BN=: ' BN_dec2bn   i *x *c' ssl NB. int BN_dec2bn(BIGNUM **num, const char *str)
NB.BNbn2mpi=: ' BN_bn2mpi >+  x x' ssl  int BN_bn2mpi(const BIGNUM *a, unsigned char *to);
NB. BN_print(BIO *fp, const BIGNUM *a);
BNfree =:  ' BN_free >  n x' ssl"0 NB.BN_free(bn: pBIGNUM); cdecl
BNclear_free=:  ' BN_clear_free >  n x' ssl"0 NB.BN_free(bn: pBIGNUM); cdecl
BNclear =:  ' BN_clear > n x' ssl"0 NB.BN_free(bn: pBIGNUM); cdecl
BNCTX_free=: 'BN_CTX_free n x' ssl  NB. void BN_CTX_free(BN_CTX *c);
BNCTX_start =: 'BN_CTX_start n x' ssl	NB.void BN_CTX_start(BN_CTX *ctx);
BNCTX_end =: 'BN_CTX_end  n x' ssl
BNdup =:  ' BN_dup >  x x' ssl"1 NB.BIGNUM *BN_dup(const BIGNUM *from);
BNCTX_get =:  ' BN_CTX_get >  x x' ssl	NB. BIGNUM *BN_CTX_get(BN_CTX *ctx);
BNcopy =:  ' BN_copy >  x x x' ssl"1 NB.BIGNUM *BN_copy(BIGNUM *to, const BIGNUM *from);
BNswap =:  ' BN_swap >  x x x' ssl"1
BNadd =:  ' BN_add >  i x x x' ssl"1   NB.int BN_add(BIGNUM *r, const BIGNUM *a, const BIGNUM *b)
BNadd_word =: ' BN_add_word > i x i' ssl"1 NB. int BN_add_word(BIGNUM *a, BN_ULONG w)
BNmod_sqr =: ' BN_mod_sqr > i x x x x' ssl"1 NB.BN_mod_sqr(BIGNUM *r, BIGNUM *a, const BIGNUM *m, BN_CTX *ctx);
BNmod_exp =: ' BN_mod_exp > i x x x x x' ssl"1 NB.int BN_mod_exp(BIGNUM *r, BIGNUM *a, const BIGNUM *p,const BIGNUM *m, BN_CTX *ctx);
BNmod_mul =: ' BN_mod_mul > i x x x x x' ssl"1
BNmod_add =: ' BN_mod_add > i x x x x x' ssl"1
BNmod_sub =: ' BN_mod_sub > i x x x x x' ssl"1
BNmod_inv=: ' BN_mod_inverse > x x x x x' ssl"1  NB.BIGNUM *BN_mod_inverse(BIGNUM *r, BIGNUM *a, const BIGNUM *n, BN_CTX *ctx);
BNmod_word =: ' BN_mod_word > i x i' ssl"1 NB.BN_ULONG BN_mod_word(const BIGNUM *a, BN_ULONG w);
BNdiv_word =: ' BN_div_word > i x i' ssl"1 NB.BN_ULONG BN_div_word(BIGNUM *a, BN_ULONG w);
BNmul_word=: ' BN_mul_word > i x i' ssl"1 NB.int BN_mul_word(BIGNUM *a, BN_ULONG w);
BNsub_word=: ' BN_sub_word > i x i' ssl"1 NB.int BN_sub_word(BIGNUM *a, BN_ULONG w);
BNset_word=: ' BN_set_word > i x i' ssl"1 NB.int BN_set_word(BIGNUM *a, unsigned long w); unsigned long BN_get_word(BIGNUM *a);
BNget_word=: ' BN_get_word > l x' ssl"0
BNis_word=: ' BN_is_word > i x x' ssl
NB. BNis_odd=: ' BN_is_odd > + i x ' ssl
BNcmp=: ' BN_cmp > i x x' ssl"1
BNmul =:  ' BN_mul > i x x x x' ssl"1  
BNexp =:  ' BN_exp > i x x x x' ssl"1 
BNsub =:  ' BN_sub > i x x x' ssl"1 
BNdiv =:  ' BN_div > i x x x x x' ssl"1 
NB. BNmod =:  ' BN_mod > + i x x x x' ssl  NB. this is innaccessible macro. use div with 2nd param null.
BNmod =:  ' BN_nnmod > i x x x x' ssl"1 
BNlshift =:  ' BN_lshift > i x x i' ssl"1  NB.int BN_lshift(BIGNUM *r, const BIGNUM *a, int n);
BNrshift =:  ' BN_rshift > i x x i' ssl"1 
BNmask_bits =:  ' BN_mask_bits > i x i' ssl"1    

BNfdec =: ([: (1 {.@{:: dec2BN)"1  (,0) ; ":)"0  NB. monad  
BNfstr =: ([: (1 {.@{:: dec2BN)"1  (,0) ; ])every  NB. string of decimal representation.        
NB. coclass 'OOP'
NB. OOP_z_ =: <'OOP'
NB. Cbase =: <'base'
NB. coclass_z_ =: 18!:4@boxxopen@:[ ((('_OOP_' ,~ 'C' ,  ]) assign boxopen)^:(0 = L.))
NB. coclass =: 18!:4@boxxopen@:[ ((('_OOP_' ,~  'C' ,  ]) assign (][ coerase)@:boxopen)^:(0 = L.))
cocurrent 'z'
pD_z_ =: 1!:2&2
cders_z_ =: cder ; cderx
coself_z_ =: coname@(''"_)
codestroy =: (coerase@coname@(''"_) ] destroy :: ])"0
coinsert=: 3 : 0  NB. change to allow insert of an object rather than class.  boxopen instead of <
 n=. ;: :: ] y
 p=. ; (, 18!:2) @ boxopen each n
 p=. ~. ( 18!:2 coname''), p
 (p /: p = <,'z') 18!:2 coname''
)

inl_z_ =: (cocurrent@] ".@] [)"1 0
inlC_z_ =: 2 : 0 
 (([: <^:(0=L.) v"_) inl~ m , ' ', lr@:]) :  (([: <^:(0=L.) v"_) inl~ (lr@:[), ' ' ,m , ' ', lr@:] )
)
inlA_z_ =: 1 : 'u inlC  (18!:5 '''')'
coassign_z_ =: 4 : 0 NB.y is object or list of objects. x is string name.  Destroys previous value prior to assign.
 try. (coerase  ] 'destroy a:'&inl :: ]) x~ catch. end.
 (x) =: y
)
lr_z_ =: 3 : '5!:5 < ''y'''
lrA_z_ =: 1 : '5!:5 < ''u'''
loc =: (,&'_'@[ ,&'_'@, ":@>@])"1 0
locs =: 1 : 'm loc 18!:5 '''''
eval_z_ =: 1 : ' a: 1 :  m'
reduce =: 1 : '<"_1@[ ([: u &.>/(>@:) ,) <@:]'

coclass 'bnctx'
MANAGED =: i. 0 
NULLC =: 0{a.
coinsert 'ssl'
create =: 3 : 0
CTX =: BNctxnew 0{.a.
)
withtemp =: 1 : 0  NB.creates new ctx that will execute u  then destroy itself u incontext withtemp
'tmpCtx' coassign a: conew 'bnctx'
 NB.('[: (] [', ' destroy' locs__tmpCtx , ') ' , u lrA inlA__tmpCtx lrA )eval 
('[: (] [', ' destroy' locs__tmpCtx , ') ' , m inlA__tmpCtx lrA)eval 
)
NB. FUNCTIONS ON BNs
new =: 3 : 'a [ (''coinsert '', lr coself a:) inl a=.''bn'' conew"0 1~ y'
newI =: 3 : 'create_bn_ y'  NB. need to manually release, but no object at all.
newM =: 3 : 'a [ (''coinsert '', lr coself a:) inl appendmanaged  a=.''bn'' conew"0 1~ y'  NB. appends BN in public list. autodestroyed on destroy this. 

dup =: 3 : 'a [ coinsert__a coself a: [  a =. dup__y a:'"0  NB. just 1 BN. not list.
dupM =: 3 : 'appendmanaged a [ coinsert__a coself a: [  a =. dup__y a:'"0
kill=: 3 : 'codestroy__y a:' NB. just 1 BN.
NB. incontext =: 1 : 0  NB. u is dyad, has access to faster autoreleased gets instead of new.
NB. ('BNCTX_end_ssl_@(CTX"_) ] [(' , m , ' :: ((cders ; 13!:11 ; 13!:12 )@:(''''"_))) ][ BNCTX_start_ssl_@(CTX"_)') eval
NB. )
NB. get =: 3 : 'BNCTX_get CTX'  NB. not object and not managed.
NB. getM =: 3 : 'appendmanaged a=. new_bnget_"_ 0 y' NB. requires an incontext adverb surrounding call.
get =: 3 : 'a [ coinsert__a coself a: [  a =.(CTX;y) conew ''bnget'' '"0
getfrom=: 3 : 'a [ coinsert__a coself a: [  a =.  CTX newCopy y' NB. y is another BN. will be erased.
getE =: 3 : 'a [ coinsert__a coself a: [  a =.  CTX newEmpty y'
getM =: appendmanaged@get
getEM =:appendmanaged@getE
mod_sqr =: 4 : 0
a =. newI x
b =. newI y
BNmod_sqr b;b;a;CTX
)

NB. displays "results (all passed BN)" then clears mem.  Seg faults if y is not a BN (or fails if BN not in managed list) 
NB. 3 : ' MANAGED   (''segfault saved: args should be BN'' ;])`(XCns@])@.(+/@(e.~)) y'
XC =: XCns =: clearmanaged bind (i.0) ] 'toX' inlA ]
appendmanaged =: 3 : 'y[ MANAGED =: MANAGED ~.@, , y' NB. SAFER, but doesn't matter.  Better to manually ~. if dupes possible and matter.
appendmanaged =: 3 : 'y[ MANAGED =: MANAGED , , y'
clearmanaged =: 'MANAGED'&coassign
killmanaged =: clearmanaged @: ((i.0)"_)
destroy =: 3 :  'clearmanaged i.0  [ BNCTX_free :: ] CTX '  NB. CTX_free may not exist

NB. =========================================================
NB. top class only.  Manages raw BNs
NB. ---------------------------------------------------------
cocurrent 'ctx'
NB. =========================================================
coinsert 'bnctx'

new =: newI =: BNfdec 

NB. 3 : 0"0
NB.  I =.  BNnew 0{.a.
NB.  initlen =. dec2BN (,I);(": y)
NB.  I
NB. )
NB. 
newM =: (][appendmanaged)@:(new"0)
toS =: 3 : 0"0
 o =. BN2dec  y
 memr o,0 _1 2
)
toS =: ([: memr 0 _1 2 ,~ BN2dec)"0
dup =: BNdup"0
dupM =: appendmanaged@:dup
shift =:   [: : (] [ ]`(BNlshift@(];;~))`(BNrshift@(];];-@[))@.(*@[))"0   NB. dyad x is int > 0 lshift, < 0 rshift.  y is BN.
NB. makes new temp BN, and returns xint of div/mult
shiftN =: [: : ([ ((0{::]) XF@[ dup@:]`(BNlshift@((,<)~))`(BNrshift@(](,<)-@[))@.(*@[))  getE@];])"0
mask =: (][([ <. BNnum_bits@]) BNmask_bits@:(;~)  ])"0 NB. dyad x is int # of bits.  Overwrites
get =: 3 :  0
I =. BNCTX_get CTX
Ii =.  BNnew 0{.a.
initlen =. dec2BN (,Ii);(": y)
BNcopy  I;Ii
BNclear_free Ii
I
)
getfrom=: 3 : 0  NB. use only for 1. not list. y is BN
I =. BNCTX_get CTX
BNcopy  I;y
BNclear_free y
I
)
getE =: 3 : 'BNCTX_get CTX'
set =: ( dec2BN)@:(,@[ ; ":@])"0 0 NB. dyad. x is BN pointer, y  NB.3 : 'I =: BNfdec y'
setbin =: ([: bin2BN ];#@];[)"0 1  NB. dyad BN v bytestr
newB =: (,0)&setbin f.
newBM =: appendmanaged@:newB f.
toB =: ([: (2 {::BN2bin) ];' '#~ num_bytes)"0
tobin =: 3 : 0
i =. num_bytes I
s =. i# ' '
NB.so =. 15!:6 <'s'
pD o =. BN2bin  (I);s
NB.memr so,0 i 2
s
)
toX =: (0 ". 'x' ,~ toS)"0 f.
toW =: BNget_word"0
XF =: BNfree ] toX NB.toX and free one BN
NB. displays "results (all passed BN)" then clears mem.  Seg faults if y is not a BN (or fails if BN not in managed list) 
XC =: 3 : ' MANAGED   (0 assert~ ''segfault saved: args should be BN- '', lr@])`(XCns@])@.(+/@(e.~)) y'
XCns =: clearmanaged bind (i.0) ] toX 
clearmanaged =: 3 : 'MANAGED =: y [ BNfree@boxopen"0 MANAGED'
wCTX =: 1 : '(''CTX"_'' inlA (,<)("1)~ ])@:u'
Align =: (,./)&(boxopen"_1)
insert =: 1 : '(BNfree"_1 ][: toX  u/)@:new'
withtemp =: 1 : 0  NB.creates new ctx that will execute u  then destroy itself u incontext withtemp
'tmpCtx' coassign a: conew 'ctx'
 NB.('[: (] [', ' destroy' locs__tmpCtx , ') ' , u lrA inlA__tmpCtx lrA )eval 
('[: (] [', ' destroy' locs__tmpCtx , ') ' , m inlA__tmpCtx lrA)eval 
)

NB. =========================================================
NB. ---------------------------------------------------------
cocurrent 'bn'
NB. =========================================================
coinsert 'ssl'
create =: 3 : 0
NB.I =:  BNnew 0{.a.
I =: 0
pD initlen =. dec2BN (,I);(": y)
assert. (0 {:: initlen) > 0
I =: 1 {.@{:: initlen
)

NB.create =: 3 : 'I =: BNfdec y'  NB.quicker but assumes called right


todec =: 3 : 0
o =. BN2dec  I
memr o,0 _1 2
)
toX =: 0 ". 'x' ,~ todec
Dbn_z_ =: 3 : 'todec__y a:'
Xbn_z_ =: 3 : 'toX__y a:'

dup =: 3 : 0
b =. conew 'bn'
I__b =: BNdup I
b
)

tobin =: 3 : 0
i =. num_bytes I
s =. i# ' '
NB.so =. 15!:6 <'s'
pD o =. BN2bin  (I);s
NB.memr so,0 i 2
s
)
set =: 3 : 'I =: BNfdec y'
setbin =: 3 : 0
i =. # y
I =: bin2BN y;i;I
)
add =: 3 : 0 NB. adds self to y (bn object)
i =.BNadd I;I;I__y
coself a:
)
addX =: 3 : 0
a =. newI y
i =.BNadd I;I;a
BNfree a
coself a:
)
addW =: 3 : 0
i =.BNadd_word I;y
coself a:
)

mod_sqr =: 3 : 0 NB. monad reduces this(stores) by n.  dyad 
i =.BNmod_sqr I;I;I__y;CTX
coself a:
)
mod_sqrX =: 3 : 0 NB. BN&| int.  will return remainder.  temp BN destroyed.
a =. newI y
i =.BNmod_sqr a;a;I;CTX
i =. BN2dec a
(BNfree a) 
b =. 0 ". 'x' ,~  memr 0 _1 2,~ i
)
destroy =: 3 : 0
BNfree I
)

NB. =========================================================
Note 'Secure ctx'
all of the same methods as ctx.  Uses ssl's crypto_malloc_ to make external threads accessing data segfault.
May not be part of J's default linked openssl library.  Needs 1.03 or higher (I think).
Not tested.
)
NB. =========================================================
cocurrent 'ctxS'
coinsert 'ctx'
NB. uncomment when version 1.03
NB.create =: 3 : 'CTX =: BNCTX_securenew 0{.a.'
clearmanaged =: 3 : 'MANAGED =: y [ BNclear_free"0 MANAGED'

NB. =========================================================
NB.  USEFUL only with secure ctx
NB. =========================================================
cocurrent 'bnget' NB. all from bn, with create override only
coinsert 'bn'
create =: 3 : 0  NB. use only for 1. not list.
I =: BNCTX_get 0{:: y
Ii =.  BNnew 0{.a.
NB.pD Ia =:  15!:6 <'I'
initlen =. dec2BN (,Ii);(": 1 {:: y)
BNcopy  I;Ii
BNclear_free Ii
I
)

newCopy =: 4 : 0  NB. use only for 1. not list. y is BN
a =. conew coself ''
I__a =: BNCTX_get x
BNcopy  I__a;y
BNclear_free y
a
)
newEmpty =: 3 : 0
a =. conew coself ''
I__a =: BNCTX_get x
a
)

cocurrent 'getrawBN'
coinsert 'ssl'
new =: 4 : 0
I =. BNCTX_get x
Ii =.  BNnew 0{.a.
initlen =. dec2BN (,Ii);(": y)
BNcopy  I;Ii
BNclear_free Ii
I
)
newCopy =: 4 : 0  NB. use only for 1. not list. y is BN
I =. BNCTX_get x
BNcopy  I;y
BNclear_free y
I
)
newEmpty =: BNCTX_get 


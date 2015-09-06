# BN-openssl-bindings-for-J
bindings and memory management interfaces for big number functions.  speed boost 

for function documentation:  
https://www.openssl.org/docs/manmaster/crypto/bn.html

The library works with pointers to big numbers.  Several interfaces are provided to manage memory and pointer safety regarding allocation:

bnctx locale:  
Place an object (class bn) wrapper around each BN (pointer) as so prevent seg faults from mistakenly not using a pointer when a pointer is needed.  A ruby like interface to BNs is possible, but not being actively developed.  The bnctx object provides a CTX pointer to any functions that need one.  Can destroy managed BN objects at any time, and auto destroys on codestroy of the bnctx object.

ctx locale:  
also provides memory management functions, but manages raw pointers.  The interfaces are somewhat compatible in that the same naming conventions are used.  There is less memory and overhead operations and so a minor speed boost, and easier code writing.

ctxS locale:  
inherits from ctx, and designed to use the secure_ctx_ memory system from openssl's current master branch.  This promises to allow secure memory storage.  Untested so far though.  It also uses clear on free mode when releasing from memory.

bnsample.ijs:  

sum - shows various coding styles to achieve a sum.  And a platform to benchmark timing differences.  Raw J code tends to be faster until numbers get huge.  

product - implemented only for raw ctx.  J has a relatively faster native multiplication than addition.

millerrabin prime test - in several coding styles.  shows off BNs very fast op-mod routines.  Over 100 times faster in BN than in J at modest integer sizes.

lcg and bbs RNG - coded to use J's flexible inheritance modes.  BN's strenghts are in larger numbers.  Its weaknesses in call overhead.  bbs is much slower than lcg in J, but a bit faster in BN due to fewer calls being made.  BN is faster at modest integer sizes.

BN function conventions:

results are first parameter.  Can overwrite any of the other parameters to save function calls.  
If a CTX is needed it is the last parameter.  
If a modulo is performed, it is the last parameter before CTX.  
Other parameters are roughly in "C math" order.  a ^ p, a / d...  
the div function creates 2 results:  remainder and <.@%~ as first 2 parameters.

Memory management and utlities:

withtemp - adverb that creates a context runs code (m as ". string but with x and y lr appended in expected places) then destroys context freeing managed BNs.
clearmanaged - kills managed BNs with option to replace them with new list.  
killmanaged - kills managed.  
XC - toX and clear - returns the extended integer contents of a list of BNs and then clears all managed BNs.

The noun MANAGED in any of the context locales holds the pointers or objects.  running toX on them will provide their numeric value.  They are in order of managed creation, and a convenient interface to inspect while creating a function. 

BN creators with a M suffix offer memory managed counterparts compared to ones that require manual freeing.

Testing on other platforms:  
This was written on windows 64 bit J8.02 or higher.  If it doesn't work on your platform, it can probably be fixed in the line near the top of bn.ijs.  That line does work for mac systems I've tried in the past.
OPENSSL =: ...

I'd appreciate any corrections to that line needed for your platform.

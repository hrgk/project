local ZZAlgorithm = import(".ZZAlgorithm")

assert(ZZAlgorithm.canZiMoHu({16,16,16,14,14,14,13,13,13,12,12,12,29,29}))

-- 七对
assert(ZZAlgorithm.canZiMoHu({31,31,11,11,11,11,12,12,12,12,13,13,13,13}, true))

assert(ZZAlgorithm.canZiMoHu({21,21,21,22,23,24,25,26,27,28,29,29,29,29}))

assert(ZZAlgorithm.canZiMoHu({21,21,21,22,23,24,25,26,27,28,29,29,29,28}))

assert(ZZAlgorithm.canZiMoHu({21,21,21,22,23,24,25,26,27,28,29,29,29,27}))
assert(ZZAlgorithm.canZiMoHu({21,21,21,22,23,24,25,26,27,28,29,29,29,26}))
assert(ZZAlgorithm.canZiMoHu({21,21,21,22,23,24,25,26,27,28,29,29,29,25}))
assert(ZZAlgorithm.canZiMoHu({21,21,21,22,23,24,25,26,27,28,29,29,29,24}))
assert(ZZAlgorithm.canZiMoHu({21,21,21,22,23,24,25,26,27,28,29,29,29,23}))
assert(ZZAlgorithm.canZiMoHu({21,21,21,22,23,24,25,26,27,28,29,29,29,22}))
assert(ZZAlgorithm.canZiMoHu({21,21,21,22,23,24,25,26,27,28,29,29,29,21}))
assert(ZZAlgorithm.canZiMoHu({21,22,22,22,22,23,11,12,13,11,13,12,39,39}))
assert(ZZAlgorithm.canZiMoHu({21,22,22,22,23,11,12,12,13,13,14,39,39,22}))
assert(ZZAlgorithm.canZiMoHu({22,22,22,22,23,31,32,33,34,35,36,39,39,21}))
assert(ZZAlgorithm.canZiMoHu({31,32,33,33,33,34,35,36,37,38,38,38,35,33}))

assert(ZZAlgorithm.canZiMoHu({31,32,33,33,33,34,35,36,37,38,38,38,35,34}))
assert(ZZAlgorithm.canZiMoHu({31,31,31,32,32,32,32,33,33,33,33,34,39,39}))
assert(ZZAlgorithm.canZiMoHu({31,31,31,32,32,33,33,34,34,35,35,35,39,39}))

assert(ZZAlgorithm.canZiMoHu({31,32,33,33,33,34,35,36,37,38,38,38,35,36}))
assert(ZZAlgorithm.canZiMoHu({11,11,11,12,12,12,33,34,35,38,38,38,33,33}))
assert(ZZAlgorithm.canZiMoHu({11,11,11,12,12,12,33,34,35,38,38,38,33,36}))

assert(ZZAlgorithm.canZiMoHu({21,22,23,24,25,26,27,28,29,51,51,51,51,37}, true, true))
assert(ZZAlgorithm.canZiMoHu({21,22,23,24,25,26,27,28,29,51,51,51,51,37}))
assert(ZZAlgorithm.canZiMoHu({21,21,21,22,23,24,25,26,27,28,29,29,29,51}))

assert(ZZAlgorithm.canZiMoHu({51,51,51,51,11,12,33,34,25,26,21,22,29,29}))

assert(ZZAlgorithm.canZiMoHu({51,21}))
assert(ZZAlgorithm.canZiMoHu({51,15}))
assert(ZZAlgorithm.canZiMoHu({51,35}))
assert(ZZAlgorithm.canZiMoHu({35,51}))
assert(ZZAlgorithm.canZiMoHu({25,51}))
assert(ZZAlgorithm.canZiMoHu({15,51}))
assert(ZZAlgorithm.canZiMoHu({51,11,12,19,51}))
assert(ZZAlgorithm.canZiMoHu({51,11,12,19,13}))
assert(ZZAlgorithm.canZiMoHu({51,11,12,19,19}))
assert(ZZAlgorithm.canZiMoHu({21,22,23,24,25,26,27,28,29,51,51,51,51,21}))
assert(ZZAlgorithm.canZiMoHu({21,22,23,24,25,26,27,28,29,51,51,51,51,22}))
assert(ZZAlgorithm.canZiMoHu({21,22,23,24,25,26,27,28,29,51,51,51,51,34}))
assert(ZZAlgorithm.canZiMoHu({21,22,23,24,25,26,27,28,29,51,51,51,51,26}))
assert(ZZAlgorithm.canZiMoHu({21,22,23,24,25,26,27,28,29,51,51,51,51,27}))
assert(ZZAlgorithm.canZiMoHu({21,22,23,24,25,26,27,28,29,51,51,51,51,11}))
assert(ZZAlgorithm.canZiMoHu({21,22,23,24,25,26,27,28,29,51,51,51,51,33}))
assert(ZZAlgorithm.canZiMoHu({21,22,23,24,25,26,27,28,29,51,37}))
assert(ZZAlgorithm.canZiMoHu({21,22,23,24,25,26,27,28,29,51,51}))
assert(ZZAlgorithm.canZiMoHu({21,22,23,24,25,26,27,28,29,51,22}))
assert(ZZAlgorithm.canZiMoHu({21,22,23,24,25,26,27,28,29,51,33}))
assert(ZZAlgorithm.canZiMoHu({21,22,23,24,25,26,27,28,29,51,11}))
assert(ZZAlgorithm.canZiMoHu({21,22,23,24,25,26,27,28,29,51,16}))
assert(ZZAlgorithm.canZiMoHu({21,22,23,24,25,26,27,28,29,51,18}))
assert(ZZAlgorithm.canZiMoHu({21,22,23,24,25,26,27,28,29,51,27}))
assert(ZZAlgorithm.canZiMoHu({51,51,51,51,11,12,33,34,25,26,21,22,29,13}))
assert(ZZAlgorithm.canZiMoHu({51,51,51,51,11,12,33,34,25,26,21,22,29,32}))
assert(ZZAlgorithm.canZiMoHu({51,51,51,51,11,12,33,34,25,26,21,22,29,35}))
assert(ZZAlgorithm.canZiMoHu({51,51,51,51,11}))
assert(ZZAlgorithm.canZiMoHu({51,51,51,51,13}))
assert(ZZAlgorithm.canZiMoHu({51,51,51,51,15}))
assert(ZZAlgorithm.canZiMoHu({51,51,51,51,14}))
assert(ZZAlgorithm.canZiMoHu({51,51,51,51,16}))
assert(ZZAlgorithm.canZiMoHu({51,51,51,51,18}))
assert(ZZAlgorithm.canZiMoHu({51,51,51,51,19}))
assert(ZZAlgorithm.canZiMoHu({51,51,51,51,21}))
assert(ZZAlgorithm.canZiMoHu({51,51,51,51,23}))
assert(ZZAlgorithm.canZiMoHu({51,51,51,51,26}))
assert(ZZAlgorithm.canZiMoHu({51,51,51,51,29}))
assert(ZZAlgorithm.canZiMoHu({51,51,51,51,31}))
assert(ZZAlgorithm.canZiMoHu({51,51,51,51,33}))
assert(ZZAlgorithm.canZiMoHu({51,51,51,51,38}))
assert(ZZAlgorithm.canZiMoHu({21,21,12,12,13,13,14,14,15,15,16,16,37,37}, true))
assert(ZZAlgorithm.canZiMoHu({11,11,11,11,13,13,14,14,15,15,16,16,17,17}, true))

assert(ZZAlgorithm.isSevenPairs_({21,21,12,12,13,13,14,14,15,15,16,16,37,51}, 51))
assert(ZZAlgorithm.canZiMoHu({21,21,12,12,13,13,14,14,15,15,36,37,51,51}, true))
assert(ZZAlgorithm.canZiMoHu({21,21,12,12,13,13,14,14,31,35,36,51,51,51}, true))
assert(ZZAlgorithm.canZiMoHu({21,21,12,12,13,13,38,34,31,35,51,51,51,51}, true))
assert(ZZAlgorithm.canZiMoHu({21,21,12,12,13,13,35,34,31,35,51,51,51,51}, true))

assert(ZZAlgorithm.canZiMoHu({11,12,13,14,15,16,17,18,19,21,22,23,24,24}, true))

assert(not ZZAlgorithm.canChiHu({14,14,31,31,31,37,37}, 31, true))
-- local ret, path = ZZAlgorithm.canChiHu({14,14,23,23}, 14, true)
assert(ZZAlgorithm.canChiHu({14,14,23,23}, 14, true))

assert(ZZAlgorithm.canChiHu({32,33,34,34,34,35,35,35,36,36,36,39,39}, 31, true))
assert(ZZAlgorithm.canChiHu({17,17,17,18,18,18,19,19,19,28,28,32,33}, 31, true))

assert(ZZAlgorithm.canChiHu({17,17,17,18,18,18,28,28,32,33}, 31, true))

assert(ZZAlgorithm.isTingPai({17,17,17,18,18,18,28,28,32,33}, true))

local ret = ZZAlgorithm.getTingPai(nil, {51,17,17, 28, 28, 39, 39}, true)
assert(ret[17] ~= nil)
assert(ret[28] ~= nil)
assert(ret[39] ~= nil)
-- assert(false)

-- dump(ZZAlgorithm.getTingOperate({17,17,17,18,18,18,19,28,28,32,33}, true))
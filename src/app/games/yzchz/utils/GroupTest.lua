local BaseAlgorithm = import(".BaseAlgorithm")
local PaperCardGroup = import(".PaperCardGroup")

assert(PaperCardGroup.searchYouHuXiShunByCard(102, {}) == nil)
local __tt = {109, 110, 203, 203, 205, 208, 208, 209, 103, 102, 101, 104, 103, 102, 210, 207, 202, 207, 206, 205}
local __tc = BaseAlgorithm.statCards(__tt)
assert(unpack(PaperCardGroup.searchYouHuXiShunByCard(207, __tc)) == unpack({202, 207, 210}))


local __tt = {{}, {}, {}, {}, {}, {}}
PaperCardGroup.removeEmptyItem(__tt)
assert(#__tt == 0)


--  拆牌方法搜索测试
local __tt = {210,210,210,106,106,106,201,202,203,108,108,104,104,204,204,103,103,101,107,109,110}
--  {210,210,210},{106,106,106},{201,202,203},{108,108},{104,104,204,204},{103,103},{101,107,109,110}
local __ret = PaperCardGroup.chaiPai(__tt)
assert(#__ret == 7)

local __tt = {207,207,207,102,102,102,201,202,203,110,110,109,109,105,205,205,104,204,201,208}
--  {207,207,207},{102,102,102},{201,202,203},{110,110,109,109},{105,205,205},{104,204},{201,208}
local __ret = PaperCardGroup.chaiPai(__tt)
assert(#__ret == 7)

local __tt = {102,101,103,209,209,208,208,108,206,106,205,205,204,104,202,202,110,207,203,101}
--  {102,101,103},{209,209},{208,208,108},{206,106},{205,205},{204,104},{202,202},{110,207,203,101}
local __ret = PaperCardGroup.chaiPai(__tt)
assert(#__ret == 7)

local __tt = {107,107,107,206,206,206,105,105,105,101,102,103,209,209,109,208,108,201,203,210}
--  {107,107,107},{206,206,206},{105,105,105},{101,102,103},{209,209,109},{208,108},{201,203,210}
local __ret = PaperCardGroup.chaiPai(__tt)
assert(#__ret == 7)

local __tt = {208,208,208,105,105,105,107,102,110,210,210,109,109,108,108,202,202,101,201,205,106}
--  {208,208,208},{105,105,105},{107,102,110},{210,210},{109,109,108,108},{202,202,101,201},{205,106}
local __ret = PaperCardGroup.chaiPai(__tt)
assert(#__ret == 7)

local __tt = {204,204,204,204,106,106,106,101,102,103,105,205,205,104,104,202,202,210,201,101}
--  {204,204,204,204},{106,106,106},{101,102,103},{105,205,205},{104,104},{202,202},{210,201,101}
local __ret = PaperCardGroup.chaiPai(__tt)
assert(#__ret == 7)

local __tt = {102,103,104,105,106,107,108,109,210,210,210,210,209,209,209,209,202,202,202,202}
local __ret = PaperCardGroup.chaiPai(__tt)
assert(#__ret == 6)

local __tt = {101,106,103,104,105,210,210,209,209,110,110,108,108,107,207,107,207,210,202,202}
local __ret = PaperCardGroup.chaiPai(__tt)
assert(#__ret == 7)
assert(#__ret[#__ret] == 3)

local __tt = {205,205,205,206,206,206,210,110,110,208,208,108,106,105,202,102,102,201,101,204,109}
local __ret = PaperCardGroup.chaiPai(__tt)
assert(#__ret == 7)

local __tt = {104,104,104,202,207,210,209,209,109,108,207,206,106,205,105,105,201,201,101,202}
local __ret = PaperCardGroup.chaiPai(__tt)
assert(#__ret == 7)

local __tt = {104,105,102,105,108,106,204,101,109,209,206,103,210,103,208,209,207,202,102,203}
local __ret = PaperCardGroup.chaiPai(__tt)
assert(#__ret == 7)

local __tt = {106,106,106,102,102,102,110,110,209,209,109,208,208,108,207,207,107,206,105,203,201}
local __ret = PaperCardGroup.chaiPai(__tt)
assert(#__ret == 7)

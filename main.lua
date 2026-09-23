Decksmith = {}
Decksmith.start_args = {}
Decksmith.mod = SMODS.current_mod

if not love.filesystem.getInfo('Decksmith_decks') then love.filesystem.createDirectory('Decksmith_decks') end

assert(SMODS.load_file('src/file_io.lua'))()
assert(SMODS.load_file('src/cfg.lua'))()
assert(SMODS.load_file('src/deck.lua'))()
assert(SMODS.load_file('src/funcs.lua'))()
assert(SMODS.load_file('src/overrides.lua'))()
assert(SMODS.load_file('src/menus.lua'))()
assert(SMODS.load_file('src/calculate.lua'))()

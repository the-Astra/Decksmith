Decksmith.mod.calculate = function(self, context)
    local ret = {}

    if context.final_scoring_step then
        if Decksmith.start_args.ds_modifier_plasma then
            table.insert(ret, {balance = true})
        end
    end

    if context.round_eval then
        if G.GAME.last_blind and G.GAME.last_blind.boss then
            if G.GAME.ds_modifier_anaglyph ~= '' then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        add_tag({ key = Decksmith.start_args.ds_modifier_anaglyph })
                        play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                        play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                        return true
                    end
                }))
            end

            if G.GAME.ds_modifier_joker_every_ante then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SMODS.add_card { key = G.GAME.ds_modifier_joker_every_ante, edition = G.GAME.ds_modifier_ante_joker_edition }
                        return true
                    end
                }))
            end
        end
    end

    if next(ret) ~= nil then
        return SMODS.merge_effects(ret)
    end
end

local create_card_ref = create_card
function create_card(...)
    local card = create_card_ref(...)
    if G.GAME.ds_modifier_all_cards_edition then
        card:set_edition(G.GAME.ds_modifier_all_cards_edition)
    end
    return card
end



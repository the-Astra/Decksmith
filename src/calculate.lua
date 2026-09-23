Decksmith.mod.calculate = function(self, context)
    local ret = {}

    if context.final_scoring_step then
        if Decksmith.start_args.ds_modifier_plasma then
            table.insert(ret, {balance = true})
        end
    end

    if context.round_eval then
        if G.GAME.last_blind and G.GAME.last_blind.boss then
            if Decksmith.start_args.ds_modifier_anaglyph then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        add_tag({ key = 'tag_double' })
                        play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                        play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                        return true
                    end
                }))
            end
        end
    end

    return SMODS.merge_effects(ret)
end
Decksmith.customize_menu = SMODS.RunSelectPage:extend {
    automatic_preview = false,
    optional = function() return SMODS.RunSelect.Setup.choices.deck_choice == 'b_ds_custom' end,
    set_default = function(self, choice)
        if self.ds_args then
            for _, v in pairs(self.ds_args) do
                Decksmith.start_args[v] = Decksmith.start_args[v] or ''
            end
        end
        return nil
    end
}

Decksmith.customize_menu {
    key = 'import',
    optional = function() return SMODS.RunSelect.Setup.choices.deck_choice == 'b_ds_custom' and next(Decksmith.get_valid_deck_names()) ~= nil end,
    definition = function(self)
        local state = Decksmith.import_state
        if state.rebuilding then
            state.rebuilding = nil
        else
            Decksmith.reset_import_selection()
        end
        return Decksmith.create_import_page()
    end,
}

Decksmith.customize_menu {
    key = 'general',
    ds_args = {
        'ds_joker_slots',
        'ds_consumable_slots',
        'ds_shop_slots',
        'ds_winning_ante',
        'ds_ante_scaling',
    },
    definition = function(self)
        return Decksmith.create_menu_page({
            key = 'k_ds_general',
            -- no_reset = true, -- EXAMPLE
            options = {
                {'ds_joker_slots'},
                {'ds_consumable_slots'},
                {'ds_shop_slots'},
                {'spacer'},
                {'ds_winning_ante'},
                {'ds_ante_scaling'}
            }
        })
    end,
    start_run = function(self, choice)
        -- Ante stuff
        G.GAME.starting_params.ante_scaling = tonumber(Decksmith.start_args.ds_ante_scaling) or G.GAME.starting_params.ante_scaling
        G.GAME.win_ante = tonumber(Decksmith.start_args.ds_winning_ante) and to_big(tonumber(Decksmith.start_args.ds_winning_ante)) or G.GAME.win_ante

        local joker_slots = tonumber(Decksmith.start_args.ds_joker_slots)
        if joker_slots and G.jokers then
            G.jokers.config.card_limits.base = joker_slots
            G.jokers.config.card_limits.mod = 0
            G.jokers:handle_card_limit()
            G.GAME.starting_params.joker_slots = joker_slots
        end

        local consumable_slots = tonumber(Decksmith.start_args.ds_consumable_slots)
        if consumable_slots and G.consumeables then
            G.consumeables.config.card_limits.base = consumable_slots
            G.consumeables.config.card_limits.mod = 0
            G.consumeables:handle_card_limit()
            G.GAME.starting_params.consumable_slots = consumable_slots
        end

        G.E_MANAGER:add_event(Event({
            func = function()
                if tonumber(Decksmith.start_args.ds_shop_slots) then
                    change_shop_size(Decksmith.start_args.ds_shop_slots - 2)
                end
                return true;
            end
        }))

        -- Do this here since this is the first page
        if Decksmith.start_args.banned_keys and next(Decksmith.start_args.banned_keys) then
            for k, _ in pairs(Decksmith.start_args.banned_keys) do
                G.GAME.banned_keys[k] = true
            end
        end
    end,
}

Decksmith.customize_menu {
    key = 'money',
    ds_args = {
        'ds_starting_dollars',
        'ds_interest_amount',
        'ds_interest_cap',
        'ds_dollars_per_hand',
        'ds_dollars_per_discard',
        'ds_discard_cost',
        'ds_reroll_cost',
        'ds_discount_percentage',
    },
    definition = function(self)
        return Decksmith.create_menu_page({
            key = 'k_ds_money',
            options = {
                {'ds_starting_dollars', --[[ {no_random = true} ]]}, -- EXAMPLE
                {'ds_interest_amount', --[[ {no_reset = true} ]]}, -- EXAMPLE
                {'ds_interest_cap'},
                {'spacer'},
                {'ds_dollars_per_hand'},
                {'ds_dollars_per_discard'},
                {'ds_discard_cost'},
                {'spacer'},
                {'ds_reroll_cost'},
                {'ds_discount_percentage'}
            }
        })
        
    end,
    start_run = function(self, choice)
        G.GAME.dollars = tonumber(Decksmith.start_args.ds_starting_dollars) or G.GAME.dollars

        -- Why are there three values for this?
        G.GAME.base_reroll_cost = tonumber(Decksmith.start_args.ds_reroll_cost) or G.GAME.base_reroll_cost
        G.GAME.round_resets.base_reroll_cost = tonumber(Decksmith.start_args.ds_reroll_cost) or G.GAME.round_resets.base_reroll_cost
        G.GAME.current_round.base_reroll_cost = tonumber(Decksmith.start_args.ds_reroll_cost) or G.GAME.current_round.base_reroll_cost

        G.GAME.modifiers.money_per_hand = tonumber(Decksmith.start_args.ds_dollars_per_hand) or G.GAME.modifiers.money_per_hand
        G.GAME.modifiers.money_per_discard = tonumber(Decksmith.start_args.ds_dollars_per_discard) or G.GAME.modifiers.money_per_discard

        G.GAME.interest_amount = tonumber(Decksmith.start_args.ds_interest_amount) or G.GAME.interest_amount
        G.GAME.interest_cap = tonumber(Decksmith.start_args.ds_interest_cap) or G.GAME.interest_cap

        G.GAME.discount_percent = tonumber(Decksmith.start_args.ds_discount_percentage) or G.GAME.discount_percent
        G.GAME.modifiers.discard_cost = tonumber(Decksmith.start_args.ds_discard_cost) or G.GAME.modifiers.discard_cost
    end,
}

Decksmith.customize_menu {
    key = 'rates',
    ds_args = {
        'ds_joker_rate',
        'ds_tarot_rate',
        'ds_planet_rate',
        'ds_spectral_rate',
        'ds_pcard_rate',
    },
    definition = function(self)
        return Decksmith.create_menu_page({
            key = 'k_ds_rates',
            -- no_random = true, -- EXAMPLE
            options = {
                {'ds_joker_rate'},
                {'ds_tarot_rate'},
                {'ds_planet_rate'},
                {'ds_spectral_rate'},
                {'ds_pcard_rate'}
            }
        })
    end,
    start_run = function(self, choice)
        G.GAME.joker_rate = tonumber(Decksmith.start_args.ds_joker_rate) or G.GAME.joker_rate

        G.GAME.tarot_rate = tonumber(Decksmith.start_args.ds_tarot_rate) or G.GAME.tarot_rate

        G.GAME.planet_rate = tonumber(Decksmith.start_args.ds_planet_rate) or G.GAME.planet_rate

        G.GAME.spectral_rate = tonumber(Decksmith.start_args.ds_spectral_rate)or G.GAME.spectral_rate

        G.GAME.playing_card_rate = tonumber(Decksmith.start_args.ds_pcard_rate) or G.GAME.playing_card_rate
    end,
}

Decksmith.customize_menu({
    key = 'starting_jokers',
    automatic_preview = true,
    random_select = true,
    double_click_advance = false,
    optional = function() return SMODS.RunSelect.Setup.choices.deck_choice == 'b_ds_custom' and tonumber(Decksmith.start_args.ds_joker_slots) ~= 0 end,
    selection_limit = function() return tonumber(Decksmith.start_args.ds_joker_slots) or Decksmith.defaults.ds_joker_slots.reset end,
    generate_pool = function(self) return G.P_CENTER_POOLS.Joker end,
    selected_text = function(self, selection)
        if not selection then selection = {} end
        return localize{type = 'variable', key = 'a_ds_jokers_remaining', vars = {self:selection_limit() - #selection}}
    end,
    start_run = function(self, choice)
        for _, v in pairs(choice) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.7,
                func = function()
                    local c = SMODS.add_card({key = v.key, skip_materialize = true, edition = v.edition, no_edition = not v.edition})
                    c:start_materialize()
                    return true
                end
            }))
        end
    end,
    create_selection_card = function(self, card_key, card_number, area)
        local card = Card(area.T.x, area.T.y, G.CARD_W, G.CARD_H, nil, G.P_CENTERS[card_key] or G.P_CENTERS.j_joker)
        card.ds_preview_card = self.key
        card.index = #area.cards + 1
        if Decksmith.start_args.banned_keys and Decksmith.start_args.banned_keys[card_key] then
            card.debuff = true
        end
        return card
    end,
    handle_choice = function(self, choice, remove)
        Decksmith.handle_duplicate_choices(self, choice, remove, 'ds_starting_jokers')
    end,
    choose_random = function(self)
        local choices = SMODS.RunSelect.Setup.choices[self.key] or {}
        if self.selection_limit() > SMODS.table_size(choices) then
            local options = {}
            for i=1, #self.pool do
                if self.pool[i].unlocked then
                    options[#options + 1] = self.pool[i].key
                end
            end

            local selected = pseudorandom_element(options, pseudoseed(os.time()))
            play_sound('whoosh1', math.random()*0.2 + 0.99, 0.35)
            self:handle_choice({config = {center = {key = selected}}})
        end
    end,
    set_default = function(self, choice)
        Decksmith.start_args.ds_starting_jokers = Decksmith.start_args.ds_starting_jokers or {}
        return Decksmith.start_args.ds_starting_jokers
    end,
})

Decksmith.customize_menu({
    key = 'starting_consumables',
    automatic_preview = true,
    random_select = true,
    double_click_advance = false,
    optional = function() return SMODS.RunSelect.Setup.choices.deck_choice == 'b_ds_custom' and tonumber(Decksmith.start_args.ds_consumable_slots) ~= 0 end,
    selection_limit = function() return tonumber(Decksmith.start_args.ds_consumable_slots) or Decksmith.defaults.ds_consumable_slots.reset end,
    generate_pool = function(self) return SMODS.merge_lists(Decksmith.get_consumable_pools()) end,
    selected_text = function(self, selection)
        if not selection then selection = {} end
        return localize{type = 'variable', key = 'a_ds_consumables_remaining', vars = {self:selection_limit() - #selection}}
    end,
    start_run = function(self, choice)
        for _, v in pairs(choice) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.7,
                func = function()
                    local c = SMODS.add_card({key = v.key, skip_materialize = true, edition = v.edition})
                    c:start_materialize()
                    return true
                end
            }))
        end
    end,
    create_selection_card = function(self, card_key, card_number, area)
        local card = Card(area.T.x, area.T.y, G.CARD_W, G.CARD_H, nil, G.P_CENTERS[card_key] or G.P_CENTERS.c_strength)
        card.ds_preview_card = self.key
        card.index = #area.cards + 1
        if Decksmith.start_args.banned_keys and Decksmith.start_args.banned_keys[card_key] then
            card.debuff = true
        end
        return card
    end,
    handle_choice = function(self, choice, remove)
        Decksmith.handle_duplicate_choices(self, choice, remove, 'ds_starting_consumables')
    end,
    choose_random = function(self)
        local choices = SMODS.RunSelect.Setup.choices[self.key] or {}
        if self.selection_limit() > SMODS.table_size(choices) then
            local options = {}
            for i=1, #self.pool do
                if self.pool[i].unlocked then
                    options[#options + 1] = self.pool[i].key
                end
            end

            local selected = pseudorandom_element(options, pseudoseed(os.time()))
            play_sound('whoosh1', math.random()*0.2 + 0.99, 0.35)
            self:handle_choice({config = {center = {key = selected}}})
        end
    end,
    set_default = function(self, choice)
        Decksmith.start_args.ds_starting_consumables = Decksmith.start_args.ds_starting_consumables or {}
        return Decksmith.start_args.ds_starting_consumables
    end,
})

Decksmith.customize_menu({
    key = 'starting_vouchers',
    grid_size = {2, 2},
    automatic_preview = true,
    random_select = true,
    selection_limit = #G.P_CENTER_POOLS.Voucher,
    include_deck_preview = true,
    double_click_advance = false,
    generate_pool = function(self) return G.P_CENTER_POOLS.Voucher end,
    selected_text = function(self, selection)
        return localize('run_select_ds_starting_vouchers') -- tried to make this dynamic but gave up lol
    end,
    start_run = function(self, choice)
        for _, area in ipairs(G.I.CARDAREA or {}) do
            if SMODS.should_handle_limit(area) then area:handle_card_limit() end
        end
        G.TAROT_INTERRUPT = G.STATE
        for k, _ in pairs(choice) do
            G.GAME.used_vouchers[k] = true
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.5,
                func = function()

                    local voucher_card = SMODS.create_card({area = G.play, key = k})
                    voucher_card:add_to_deck()
                    voucher_card:start_materialize()
                    voucher_card.cost = 0
                    G.play:emplace(voucher_card)

                    voucher_card:redeem()
                    
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            voucher_card:start_dissolve()
                            return true
                        end
                    }))

                    delay(1)
                    
                    return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            blocking = false,
            func = function()
            if #G.play.cards ~= 0 then return end
                G.STATE = G.TAROT_INTERRUPT
                G.TAROT_INTERRUPT = nil
                return true
                end
        }))
    end,
    create_selection_card = function(self, card_key, card_number, area)
        local card = Card(area.T.x, area.T.y, G.CARD_W, G.CARD_H, nil, G.P_CENTERS[card_key] or G.P_CENTERS.v_blank)
        card.ds_preview_card = self.key
        if Decksmith.start_args.banned_keys and Decksmith.start_args.banned_keys[card_key] then
            card.debuff = true
        end
        return card
    end,
    handle_choice = function(self, choice, remove)
        if not Decksmith.start_args.banned_keys or not Decksmith.start_args.banned_keys[choice.config.center.key] then
            SMODS.RunSelectPage.handle_choice(self, choice, remove)
            if remove then
                Decksmith.start_args.ds_starting_vouchers[choice.config.center.key] = nil
            else
                Decksmith.start_args.ds_starting_vouchers[choice.config.center.key] = true
            end
        end
    end,
    choose_random = function(self)
        local choices = SMODS.RunSelect.Setup.choices[self.key] or {}
        if self.selection_limit > SMODS.table_size(choices) then
            local options = {}
            for i=1, #self.pool do
                if self.pool[i].unlocked then
                    options[#options + 1] = self.pool[i].key
                end
            end

            local selected = false
            while not selected do
                selected = pseudorandom_element(options, pseudoseed(os.time()))
                if (selected == choices or choices[selected]) and #options > 1 then selected = false end
            end
            play_sound('whoosh1', math.random()*0.2 + 0.99, 0.35)
            self:handle_choice({config = {center = {key = selected}}})
        end
    end,
    set_default = function(self, choice)
        Decksmith.start_args.ds_starting_vouchers = Decksmith.start_args.ds_starting_vouchers or {}
        return Decksmith.start_args.ds_starting_vouchers
    end,
})

--[[ Decksmith.customize_menu {
    key = 'modifiers',
    definition = function(self)
        return Decksmith.create_menu_page({
            key = 'k_ds_modifiers',
            no_reset = true,
            no_random = true,
            options = {
                
            }
        })
    end,
} ]]

Decksmith.customize_menu {
    key = 'export',
    ds_args = {
        'ds_name',
        'ds_author'
    },
    definition = function(self)
        SMODS.RunSelect.Functions.build_preview_areas('deck_choice')
        local deck_preview = SMODS.RunSelect.Functions.build_preview_ui('deck_choice', true)
        deck_preview.nodes[1].config.minh = Decksmith.page_height
        deck_preview.nodes[1].config.align = 'cm'
        SMODS.RunSelect.Functions.populate_preview_ui('deck_choice', SMODS.RunSelect.Setup.choices.deck_choice, true)

        return
            {n = G.UIT.R, config = {align = 'cm'}, nodes = {
                deck_preview,
                {n=G.UIT.C, config={minh = Decksmith.page_height, padding = 0.1}, nodes = {
                    {n=G.UIT.R, config = {colour = G.C.BLACK, r = true, align = 'cl', padding = 0.1, emboss = 0.05}, nodes = {
                        {n=G.UIT.C, config = {align = 'cm', minw = 1}, nodes = {
                            {n=G.UIT.R, config={minh=Decksmith.page_height-0.2, align='cm'}, nodes={
                                -- TODO: should probably be dynatext incase of localization changes or longer text
                                {n=G.UIT.T, config = {text = localize('k_ds_export'), scale = 0.8, colour = G.C.L_BLACK, vert = true}}
                            }},
                        }},
                        {n=G.UIT.C, config = {minh = 4, minw = 0.04, colour = G.C.L_BLACK}}, -- line
                        {n=G.UIT.C, config = {align = 'cm', padding = 0.05}, nodes = {
                            {n=G.UIT.R, config = { align = 'cm', padding = 0.15}, nodes = { -- Deck Name Input Node
                                {n=G.UIT.R, config = {align = 'cm', padding = 0.05, minw = 3.8}, nodes = {
                                    {n=G.UIT.T, config = {text = localize('k_ds_name_deck'), scale = 0.53, colour = G.C.WHITE}}
                                }},
                                {n=G.UIT.R, config = { align = 'cm', padding = 0.1}, nodes = {
                                    {n=G.UIT.C, config = {align = 'cm'}, nodes = {
                                        create_text_input {
                                            id = 'ds_name_input',
                                            prompt_text = Decksmith.defaults['ds_name'].reset,
                                            w = 2.5,
                                            h = 1,
                                            all_caps = false,
                                            max_length = 60,
                                            ref_table = Decksmith.start_args,
                                            ref_value = 'ds_name',
                                            extended_corpus = true
                                        }
                                    }},
                                    {n=G.UIT.C, config = {align='cm'}, nodes = {
                                        {n=G.UIT.C, config={minw = 0.2}},
                                        Decksmith.create_value_button('reset', Decksmith.button_size, 'ds_name'),
                                    }}
                                }},
                            }},
                            {n=G.UIT.R, config = { align = 'cm', padding = 0.15}, nodes = { -- Author Input Node
                                {n=G.UIT.R, config = {align = 'cm', padding = 0.05, minw = 3.8}, nodes = {
                                    {n=G.UIT.T, config = {text = localize('k_ds_sign_deck'), scale = 0.53, colour = G.C.WHITE}}
                                }},
                                {n=G.UIT.R, config = { align = 'cm', padding = 0.1}, nodes = {
                                    {n=G.UIT.C, config = {align = 'cm'}, nodes = {
                                        create_text_input {
                                            id = 'ds_author_input',
                                            prompt_text = Decksmith.defaults['ds_author'].reset,
                                            w = 2,
                                            h = 1,
                                            all_caps = false,
                                            max_length = 20,
                                            ref_table = Decksmith.start_args,
                                            ref_value = 'ds_author',
                                            extended_corpus = true
                                        }
                                    }},
                                    {n=G.UIT.C, config = {align='cm'}, nodes = {
                                        {n=G.UIT.C, config={minw = 0.2}},
                                        Decksmith.create_value_button('reset', Decksmith.button_size, 'ds_author'),
                                    }}
                                }},
                            }},
                            { n = G.UIT.R, config = { align = "cm", minw = 2.5, padding = 0.1 }, nodes = { -- Save Deck Button
                                { n = G.UIT.R, config = {  id = "ds_save_deck",align = "cm", padding = 0.3, no_fill = true, r = 0.1, hover = true, colour = G.C.GREEN, button = "ds_init_save_process", shadow = true, focus_args = { nav = "wide", button = "b" } }, nodes = {
                                    { n = G.UIT.T, config = { text = localize("k_ds_save_deck"), scale = 0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
                                } },
                            } },
                            { n = G.UIT.R, config = { align = "cm", minw = 2.5, padding = 0.1 }, nodes = { --Open Decks Folder Button
                                { n = G.UIT.R, config = { id = "ds_open_folder", align = "cm", padding = 0.3, no_fill = true, r = 0.1, hover = true, colour = G.C.ORANGE, button = "ds_open_decks_folder", shadow = true, focus_args = { nav = "wide", button = "b" } }, nodes = {
                                    { n = G.UIT.T, config = { text = localize("k_ds_open_folder"), scale = 0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
                                } },
                            } },
                        }}
                    }}
                }},
            }}
    end,
}

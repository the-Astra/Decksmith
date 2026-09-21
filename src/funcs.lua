to_big = to_big or function(x) return x end

function Decksmith.text_input_element(value, args)
    args = args or {}
    args.colour = args.colour or G.C.BLUE
    local label = args.label or G.localization.misc.dictionary['k_'..value] or value
    label = type(label) == 'string' and {label} or label

    local label_nodes = {}

    for _, v in pairs(label) do
        table.insert(label_nodes, {n=G.UIT.R, config = {align = 'cm'}, nodes = {{n=G.UIT.T, config = {text = v, scale = args.label_size or 0.37, colour = args.label_colour or G.C.WHITE}}}})
    end

    local t = {
        n=G.UIT.R, config = { align = 'cr', padding = 0.1}, nodes = {
            {n=G.UIT.C, config = {align = 'cl', padding = 0.1, minw = 3.8}, nodes = label_nodes},
            {n=G.UIT.C, config = {align = 'cm'}, nodes = {
                create_text_input {
                    id = value .. '_input',
                    prompt_text = Decksmith.defaults[value].reset .. '',
                    w = args.w or 1.5,
                    h = args.h or 0.5,
                    all_caps = args.all_caps or false,
                    ref_table = args.ref_table or Decksmith.start_args,
                    ref_value = value,
                    colour = args.colour,
                    hooked_colour = args.hooked_colour or args.colour and darken(args.colour, 0.3),
                    extended_corpus = true
                }
            }},
            {n=G.UIT.C, config = {align='cm'}, nodes = {
                {n=G.UIT.C, config={minw = 0.2}},
                Decksmith.create_value_button(not args.no_random and 'random', Decksmith.button_size/1.5, value),
                {n=G.UIT.C, config={minw = 0.1}},
                Decksmith.create_value_button(not args.no_reset and 'reset', Decksmith.button_size/1.5, value),
            }}
        }
    }

    if not args.no_random then table.insert(Decksmith.this_page_random_options, value) end
    if not args.no_reset then table.insert(Decksmith.this_page_reset_options, value) end

    return t
end

function Decksmith.toggle_element(value, args)
    args = args or {}
    args.colour = args.colour or G.C.BLUE
    local label = args.label or G.localization.misc.dictionary['k_'..value] or value
    label = type(label) == 'string' and {label} or label

    local label_nodes = {}

    for _, v in pairs(label) do
        table.insert(label_nodes, {n=G.UIT.R, config = {align = 'cm'}, nodes = {{n=G.UIT.T, config = {text = v, scale = args.label_size or 0.37, colour = args.label_colour or G.C.WHITE}}}})
    end

    local t = {
        n=G.UIT.R, config = { align = 'cr', padding = 0.1}, nodes = {
            {n=G.UIT.C, config = {align = 'cl', padding = 0.1, minw = 3.8}, nodes = label_nodes},
            {n=G.UIT.C, config = {align = 'cm'}, nodes = {
                create_toggle {
                    col = true,
                    id = value .. '_input',
                    label = '',
                    scale = args.scale or 1,
                    w = args.w or 1.5,
                    h = args.h or 0.5,
                    ref_table = args.ref_table or Decksmith.start_args,
                    ref_value = value,
                    colour = args.colour,
                    shadow = true,
                }
            }},
            {n=G.UIT.C, config = {align='cm'}, nodes = {
                {n=G.UIT.C, config={minw = 0.2}},
                Decksmith.create_value_button(not args.no_random and 'random', Decksmith.button_size/1.5, value),
                {n=G.UIT.C, config={minw = 0.1}},
                Decksmith.create_value_button(not args.no_reset and 'reset', Decksmith.button_size/1.5, value),
            }}
        }
    }

    if not args.no_random then table.insert(Decksmith.this_page_random_options, value) end
    if not args.no_reset then table.insert(Decksmith.this_page_reset_options, value) end

    return t
end

function Decksmith.create_menu_page(args)
    SMODS.RunSelect.Functions.build_preview_areas('deck_choice')
    local deck_preview = SMODS.RunSelect.Functions.build_preview_ui('deck_choice', true)
    deck_preview.nodes[1].config.minh = Decksmith.page_height
    deck_preview.nodes[1].config.align = 'cm'
    SMODS.RunSelect.Functions.populate_preview_ui('deck_choice', SMODS.RunSelect.Setup.choices.deck_choice, true)

    local options = {n=G.UIT.C, config = {align = 'cl'}, nodes = {}}
    Decksmith.this_page_random_options = {}
    Decksmith.this_page_reset_options = {}
    
    for _, option in ipairs(args.options) do
        -- print(option)
        if option[2] and option[2].type then
            if option[2].type == 'text_input' then
                options.nodes[#options.nodes + 1] = Decksmith.text_input_element(option[1], option[2])
            elseif option[2].type == 'toggle' then
                options.nodes[#options.nodes + 1] = Decksmith.toggle_element(option[1], option[2])
            elseif option[2].type == 'button' then
                options.nodes[#options.nodes + 1] = Decksmith.button_element(option[1], option[2])
            end
        else
            options.nodes[#options.nodes + 1] = option[1] == 'spacer' and {n=G.UIT.R, config = {minh = 0.02, colour = G.C.L_BLACK}} or Decksmith.text_input_element(option[1], option[2])
        end
    end                        

    return 
        {n = G.UIT.R, config = {align = 'cm'}, nodes = {
            deck_preview, -- can be moved to the right if preferred, I think it looks good on the left and helps make it clear that you are customising this deck in particular
            {n=G.UIT.C, config={minh = Decksmith.page_height, padding = 0.1}, nodes = {
                {n=G.UIT.R, config = {colour = G.C.BLACK, r = true, align = 'cl', padding = 0.1, emboss = 0.05}, nodes = {
                    {n=G.UIT.C, config = {align = 'cm', minw = 1}, nodes = {
                        {n=G.UIT.R, config={minh=2*Decksmith.button_size + 0.1}}, -- random reset buttons spacer
                        {n=G.UIT.R, config={minh=Decksmith.page_height-0.4-(4*Decksmith.button_size), align='cm'}, nodes={
                            -- TODO: should probably be dynatext incase of localization changes or longer text
                            {n=G.UIT.T, config = {text = localize(args.key), scale = 0.8, colour = G.C.L_BLACK, vert = true}}
                        }},
                        {n=G.UIT.R, config={minh=1, align='cm'}, nodes={ -- whole page random/reset buttons
                            {n=G.UIT.R, nodes = {Decksmith.create_value_button(not args.no_random and 'random_all', Decksmith.button_size, args.key)}},
                            {n=G.UIT.R, config={minh = 0.1}}, -- spacer
                            {n=G.UIT.R, nodes = {Decksmith.create_value_button(not args.no_reset and 'reset_all', Decksmith.button_size, args.key)}},
                        }}
                    }},
                    {n=G.UIT.C, config = {minh = 4, minw = 0.04, colour = G.C.L_BLACK}}, -- line
                    {n=G.UIT.C, config = {align = 'cm', padding = 0.05}, nodes = {
                        options
                    }}
                }}
            }},
        }}
end

function Decksmith.create_value_button(type, size, key)
    local args = Decksmith.buttons[type] or {}

    if args.atlas then
        local sprite = SMODS.create_sprite(0, 0, size, size, args.atlas, args.pos)
        sprite.states.hover.can = false
        sprite.states.click.can = false
        sprite.states.drag.can = false
        return {n=G.UIT.C, config = {
            minw = size,
            minh = size,
            colour = G.C.CLEAR,
            tooltip = args.tooltip and {text = {localize(args.tooltip)}},
            button = args.on_click,
            hover = args.hover,
            shadow = args.shadow,
            ref_value = key,
            align = 'cm',
            r = true
        }, nodes = {
            {n=G.UIT.O, config = {align = 'cm', object = sprite}}
        }}
    end

    return {n=G.UIT.C, config = {
        minw = size,
        minh = size,
        colour = args.colour,
        tooltip = args.tooltip and {text = {localize(args.tooltip)}},
        button = args.on_click,
        hover = args.hover,
        shadow = args.shadow,
        r=true,
        ref_value = key
    }}
end

G.FUNCS.ds_reset = function(e)
    --  print('[NYI] Reset',e.config.ref_value)
    Decksmith.start_args[e.config.ref_value] = ''
    Decksmith.reset_page()
end

G.FUNCS.ds_reset_all = function(e)
    --  print('[NYI] Reset',e.config.ref_value)
    for _, v in pairs(Decksmith.this_page_reset_options) do
        Decksmith.start_args[v] = ''
    end
    Decksmith.reset_page()
end

G.FUNCS.ds_random = function(e)
    -- print('[NYI] Random',e.config.ref_value)
    Decksmith.start_args[e.config.ref_value] = math.random(Decksmith.defaults[e.config.ref_value].min, Decksmith.defaults[e.config.ref_value].max)
    Decksmith.reset_page()
end

G.FUNCS.ds_random_all = function(e)
    -- print('[NYI] Random',e.config.ref_value)
    for _, v in pairs(Decksmith.this_page_random_options) do
        Decksmith.start_args[v] = math.random(Decksmith.defaults[v].min, Decksmith.defaults[v].max)
    end
    Decksmith.reset_page()
end

G.FUNCS.ds_refresh = function(e)
    Decksmith.reset_page()
end

function Decksmith.reset_page()
    local b = G.OVERLAY_MENU:get_UIE_by_ID("previous_selection")
    local o = b.config.ref_value
    b.config.ref_value = 0
    SMODS.RunSelect.Functions.change_page(b)
    b.config.ref_value = o
end

function Decksmith.get_consumable_pools()
    return {G.P_CENTER_POOLS.Tarot, G.P_CENTER_POOLS.Planet, G.P_CENTER_POOLS.Spectral}
end

Decksmith.import_state = Decksmith.import_state or {files = {}, selected = nil, preview = nil, rows = {}, file_info = {}, error = nil}
local import_content_width = 6.25
local import_card_area_width = 5.85
local import_list_width = 3.7

function Decksmith.reset_import_selection()
    local state = Decksmith.import_state
    Decksmith.import_card_areas = nil
    state.selected = nil
    state.preview = nil
    state.rows = {}
    state.error = nil
    state.selected_button = nil
end

local function ds_import_display_key(key)
    local localized = G.localization and G.localization.misc and G.localization.misc.dictionary and G.localization.misc.dictionary['k_' .. tostring(key)]
    if type(localized) == 'string' then return localized end
    local center = G.P_CENTERS and G.P_CENTERS[key]
    if center and center.name then return center.name end
    return tostring(key):gsub('^ds_', ''):gsub('_', ' '):gsub('(%a)([%w]*)', function(a, b)
        return string.upper(a) .. b
    end)
end

local function ds_import_display_value(value)
    if type(value) == 'boolean' then return localize(value and 'k_ds_yes' or 'k_ds_no') end
    if value == nil then return localize('k_ds_none') end
    local key = tostring(value)
    local center = G.P_CENTERS and G.P_CENTERS[key]
    return center and center.name or key
end

local function ds_import_flatten(value, path, rows)
    rows = rows or {}
    path = path or ''
    if type(value) ~= 'table' then
        rows[#rows + 1] = {label = path ~= '' and path or localize('k_ds_value'), value = ds_import_display_value(value)}
        return rows
    end

    local keys = {}
    for key in pairs(value) do keys[#keys + 1] = key end
    table.sort(keys, function(a, b) return tostring(a) < tostring(b) end)
    if #keys == 0 then
        rows[#rows + 1] = {label = path ~= '' and path or localize('k_ds_data'), value = localize('k_ds_empty')}
    end
    for _, key in ipairs(keys) do
        local next_path = path == '' and ds_import_display_key(key) or (path .. ' / ' .. ds_import_display_key(key))
        ds_import_flatten(value[key], next_path, rows)
    end
    return rows
end

local preview_categories = {
    general = {title = 'k_ds_run_rules', colour = G.C.BLUE, order = 1},
    money = {title = 'k_ds_economy', colour = G.C.GOLD, order = 2},
    rates = {title = 'k_ds_shop_rates', colour = G.C.PURPLE, order = 3},
    jokers = {title = 'k_ds_starting_jokers_title', colour = G.C.RED, order = 4},
    consumables = {title = 'k_ds_starting_consumables_title', colour = G.C.PURPLE, order = 5},
    vouchers = {title = 'k_ds_starting_vouchers_title', colour = G.C.ORANGE, order = 6},
    modifiers = {title = 'k_ds_bans_modifiers', colour = G.C.FILTER, order = 7},
    other = {title = 'k_ds_deck_info', colour = G.C.GREY, order = 8},
}

local general_keys = {
    ds_joker_slots = true, ds_consumable_slots = true, ds_shop_slots = true,
    ds_winning_ante = true, ds_ante_scaling = true
}
local money_keys = {
    ds_starting_dollars = true, ds_interest_amount = true, ds_interest_cap = true,
    ds_dollars_per_hand = true, ds_dollars_per_discard = true, ds_discard_cost = true,
    ds_reroll_cost = true, ds_discount_percentage = true
}
local rate_keys = {
    ds_joker_rate = true, ds_tarot_rate = true, ds_planet_rate = true,
    ds_spectral_rate = true, ds_pcard_rate = true
}

local function ds_import_category(key)
    if general_keys[key] then return 'general' end
    if money_keys[key] then return 'money' end
    if rate_keys[key] then return 'rates' end
    if key == 'ds_starting_jokers' then return 'jokers' end
    if key == 'ds_starting_consumables' then return 'consumables' end
    if key == 'ds_starting_vouchers' then return 'vouchers' end
    if key == 'banned_keys' or key == 'modifiers' then return 'modifiers' end
    return 'other'
end

local function ds_import_build_rows(settings)
    local row_blacklist = {
        ds_name = true
    }
    local grouped, rows = {}, {}
    for key, value in pairs(settings) do
        if not row_blacklist[key] then
            local category = ds_import_category(key)
            grouped[category] = grouped[category] or {}
            if type(value) == 'table' then
                for _, row in ipairs(ds_import_flatten(value, '', {})) do
                    grouped[category][#grouped[category] + 1] = row
                end
            else
                grouped[category][#grouped[category] + 1] = {label = ds_import_display_key(key), value = ds_import_display_value(value)}
            end
        end
    end
    local category_keys = {}
    for key in pairs(grouped) do category_keys[#category_keys + 1] = key end
    table.sort(category_keys, function(a, b) return preview_categories[a].order < preview_categories[b].order end)
    for _, key in ipairs(category_keys) do
        local category = preview_categories[key]
        if key ~= 'jokers' and key ~= 'consumables' and key ~= 'vouchers' then
            table.sort(grouped[key], function(a, b) return a.label < b.label end)
            rows[#rows + 1] = {section = true, label = localize(category.title), colour = category.colour}
            for _, row in ipairs(grouped[key]) do rows[#rows + 1] = row end
        end
    end
    return rows
end

function Decksmith.refresh_import_files()
    local state = Decksmith.import_state
    state.files = {}
    state.file_info = {}
    for _, deck in pairs(Decksmith.retrieve_valid_decks()) do
        state.files[#state.files + 1] = deck.name
        state.file_info[deck.name] = deck
    end
    table.sort(state.files, function(a, b) return a:lower() < b:lower() end)
end

function Decksmith.read_import_file(filename)
    local ok, decoded = pcall(Decksmith.get_deck_data, filename)
    if not ok or type(decoded) ~= 'table' then return nil, localize('k_ds_invalid_deck') end
    return decoded
end

function Decksmith.select_import_file(filename)
    local state = Decksmith.import_state
    local decoded, err = Decksmith.read_import_file(filename)
    state.selected, state.preview, state.error = filename, decoded, err
    state.rows = decoded and ds_import_build_rows(decoded) or {}
end

function Decksmith.import_settings(data)
    if type(data) ~= 'table' then return false end
    Decksmith.start_args = copy_table(data)

    local pages = {'ds_starting_jokers', 'ds_starting_consumables', 'ds_starting_vouchers'}
    local profile = G.PROFILES[G.SETTINGS.profile]
    profile.last_choices = profile.last_choices or {}
    for _, page in ipairs(pages) do
        local imported = copy_table(Decksmith.start_args[page] or {})
        SMODS.RunSelect.Setup.choices[page] = imported
        profile.last_choices[page] = copy_table(imported)
    end
    return true
end

local function ds_import_text(text, scale, colour)
    return {n = G.UIT.T, config = {text = tostring(text), scale = scale or 0.32, colour = colour or G.C.UI.TEXT_LIGHT}}
end

local function ds_import_scrollbox(nodes, width, height)
    local scroll_box = SMODS.UIScrollBox({
        content = {
            definition = {n = G.UIT.ROOT, config = {colour = G.C.CLEAR}, nodes = {
                {n = G.UIT.C, config = {align = 'cm', minw = width, padding = 0.025}, nodes = nodes}
            }},
            config = {align = 'cm'}
        },
        overflow = {node_config = {colour = G.C.CLEAR, no_overflow = 'v', maxh = height}},
        sync_mode = 'offset'
    })
    local panel_nodes = {{n = G.UIT.O, config = {object = scroll_box}}}
    local content_height = scroll_box.content and scroll_box.content.UIRoot and scroll_box.content.UIRoot.T and scroll_box.content.UIRoot.T.h or 0
    if content_height > height then
        panel_nodes[#panel_nodes + 1] = {n = G.UIT.C, config = {minw = 0.08}}
        panel_nodes[#panel_nodes + 1] = SMODS.GUI.scrollbar({
            scroll_collision_obj = scroll_box, h = height, w = 0.18, knob_h = math.min(0.7, height * 0.2),
            knob_colour = G.C.GOLD, bg_colour = {0.08, 0.08, 0.08, 0.65}
        })
    else
        scroll_box.scroll_args.overflow.node_config.maxh = nil
    end
    return {n = G.UIT.R, config = {align = 'cm'}, nodes = panel_nodes}
end

function Decksmith.remove_import_card_areas()
    if Decksmith.import_card_areas then
        for _, area in pairs(Decksmith.import_card_areas) do
            if area.cards then
                remove_all(area.cards)
                area.cards = {}
            end
        end
    end
    for i = #G.I.CARD, 1, -1 do
        if G.I.CARD[i].decksmith_import_preview then G.I.CARD[i]:remove() end
    end
    Decksmith.import_card_areas = nil
end

local card_area_draw = CardArea.draw
local function ds_import_draw_card_area(self)
    local dragged = G.CONTROLLER and G.CONTROLLER.dragging.target
    if not dragged or dragged.area ~= self then return card_area_draw(self) end
    G.CONTROLLER.dragging.target = nil
    card_area_draw(self)
    G.CONTROLLER.dragging.target = dragged
end

local function ds_import_card_area(title, values, colour)
    if type(values) ~= 'table' or not next(values) then return nil end
    local count = 0
    for _, amount in pairs(values) do count = count + (type(amount) == 'number' and amount or 1) end
    local area = CardArea(G.ROOM.T.w, G.ROOM.T.h, import_card_area_width, G.CARD_H * 0.56, {card_limit = math.max(1, count), type = 'title_2', highlight_limit = 0, deck_height = 0.55, thin_draw = 1})
    area.draw = ds_import_draw_card_area
    Decksmith.import_card_areas = Decksmith.import_card_areas or {}
    Decksmith.import_card_areas[#Decksmith.import_card_areas + 1] = area

    local prototypes = {}
    for _, v in pairs(values) do prototypes[#prototypes + 1] = v end
    local missing = 0
    for _, v in ipairs(prototypes) do
        local amount = type(values[v.key]) == 'number' and values[v.key] or 1
        local center = G.P_CENTERS[v.key]
        if center then
            for _ = 1, amount do
                local card = Card(area.T.x, area.T.y, G.CARD_W * 0.48, G.CARD_H * 0.48, nil, center)
                card.decksmith_import_preview = true
                area:emplace(card)
                card.states.click.can = false
                card.states.drag.can = true
                card.states.hover.can = true
                if v.edition then
                    card:set_edition(v.edition, true, true)
                end
            end
        else
            missing = missing + amount
        end
    end

    local heading = localize{
        type = 'variable',
        key = missing > 0 and 'a_ds_preview_count_missing' or 'a_ds_preview_count',
        vars = missing > 0 and {title, count, missing} or {title, count}
    }
    return {n = G.UIT.R, config = {align = 'cm', colour = G.C.L_BLACK, r = 0.07, minw = import_content_width, padding = 0.035}, nodes = {
        {n = G.UIT.C, config = {align = 'cl', minw = 1.35}, nodes = {
            {n = G.UIT.R, config = {align = 'cm', colour = colour, r = 0.06, minw = 1.25, minh = 0.56}, nodes = {
                ds_import_text(heading, 0.2, G.C.WHITE)
            }}
        }},
        {n = G.UIT.C, config = {align = 'cm', minw = 4.75}, nodes = {
            {n = G.UIT.O, config = {object = area}}
        }}
    }}
end

local function ds_import_build_card_nodes(settings)
    Decksmith.remove_import_card_areas()
    settings = settings or {}
    local nodes = {}
    local specs = {
        {localize('k_ds_jokers'), settings.ds_starting_jokers, G.C.RED}, {localize('k_ds_consumables'), settings.ds_starting_consumables, G.C.PURPLE},
        {localize('k_ds_vouchers'), settings.ds_starting_vouchers, G.C.ORANGE}
    }
    for _, spec in ipairs(specs) do
        local node = ds_import_card_area(spec[1], spec[2], spec[3])
        if node then
            nodes[#nodes + 1] = node
            nodes[#nodes + 1] = {n = G.UIT.R, config = {minh = 0.06}}
        end
    end
    return nodes
end

local function ds_import_file_button(filename, selected, file_info)
    local modified = file_info and file_info.modtime
    local date_text = type(modified) == 'number' and os.date('%Y-%m-%d', modified) or localize('k_ds_saved_deck_preset')
    local filedata = Decksmith.get_deck_data(filename)
    local deck_name = filedata.ds_name or filename:gsub('%.jkr$', '')
    if string.len(deck_name) > 20 then
        deck_name = string.sub(deck_name, 1, 17) .. '...'
    end
    return {n = G.UIT.R, config = {
        align = 'cm', button = 'ds_import_select', ref_value = filename,
        hover = true, shadow = true, colour = selected and G.C.GREEN or G.C.BLUE,
        r = 0.1, minw = 3.35, minh = 0.72, padding = 0.06
    }, nodes = {
        {n = G.UIT.C, config = {align = 'cl', minw = 2.55}, nodes = {
            {n = G.UIT.R, config = {align = 'cl'}, nodes = {ds_import_text(deck_name, 0.31)}},
            {n = G.UIT.R, config = {align = 'cl'}, nodes = {ds_import_text(date_text, 0.18, G.C.WHITE)}}
        }},
        {n = G.UIT.C, config = {align = 'cm', colour = selected and G.C.DARK_EDITION or G.C.BLACK,
            r = 0.08, minw = 0.58, minh = 0.38}, nodes = {ds_import_text('JKR', 0.19, G.C.GOLD)
        }}
    }}
end

local function ds_import_build_file_nodes(state)
    local nodes = {}
    for _, filename in ipairs(state.files) do
        nodes[#nodes + 1] = ds_import_file_button(filename, filename == state.selected, state.file_info[filename])
        nodes[#nodes + 1] = {n = G.UIT.R, config = {minh = 0.08}}
    end
    if #nodes == 0 then
        nodes[1] = {n = G.UIT.R, config = {align = 'cm', minh = 1}, nodes = {
            ds_import_text(localize('k_ds_no_decks'), 0.36)
        }}
    end
    return nodes
end

local function ds_import_build_setting_nodes(rows)
    local nodes = {}
    for i, row in ipairs(rows) do
        if row.section then
            nodes[#nodes + 1] = {n = G.UIT.R, config = {align = 'cl', colour = row.colour, r = 0.06, minw = import_content_width, minh = 0.34, padding = 0.025}, nodes = {
                {n = G.UIT.C, config = {minw = 0.12}},
                ds_import_text(row.label, 0.23, G.C.WHITE)
            }}
        else
            nodes[#nodes + 1] = {n = G.UIT.R, config = {align = 'cl', colour = i % 2 == 0 and G.C.L_BLACK or G.C.BLACK, r = 0.04, minw = import_content_width, minh = 0.33, padding = 0.025}, nodes = {
                {n = G.UIT.C, config = {align = 'cl', minw = 4.65}, nodes = {
                    {n = G.UIT.C, config = {minw = 0.12}},
                    ds_import_text(row.label, 0.265)
                }},
                {n = G.UIT.C, config = {align = 'cr', minw = 1.35}, nodes = {
                    {n = G.UIT.C, config = {align = 'cm', colour = {0.78, 0.82, 0.86, 1}, r = 0.06, minw = 0.75, minh = 0.27, emboss = 0.04}, nodes = {
                        ds_import_text(row.value, 0.25, G.C.BLACK)
                    }}
                }}
            }}
        end
    end
    return nodes
end

local function ds_import_build_preview_nodes(state)
    if state.error then
        Decksmith.remove_import_card_areas()
        return {{n = G.UIT.R, config = {align = 'cm', padding = 0.1}, nodes = {
            ds_import_text(state.error, 0.34, G.C.RED)
        }}}
    end
    if not state.preview then
        Decksmith.remove_import_card_areas()
        return {{n = G.UIT.R, config = {align = 'cm', minh = 2}, nodes = {
            ds_import_text(localize('k_ds_select_preview'), 0.38)
        }}}
    end
    local deck_name = state.preview.ds_name or state.selected:gsub('%.jkr$', '')
    if string.len(deck_name) > 45 then
        deck_name = string.sub(deck_name, 1, 42) .. '...'
    end
    local nodes = {{n = G.UIT.R, config = {align = 'cm', colour = G.C.BLUE, r = 0.1, minw = import_content_width, minh = 0.72, padding = 0.06}, nodes = {
        {n = G.UIT.C, config = {align = 'cl', minw = 4.7}, nodes = {
            {n = G.UIT.R, config = {align = 'cl'}, nodes = {
                {n = G.UIT.C, config = {minw = 0.12}},
                ds_import_text(deck_name, 0.42, G.C.GOLD)
            }},
            {n = G.UIT.R, config = {align = 'cl'}, nodes = {
                {n = G.UIT.C, config = {minw = 0.12}},
                ds_import_text(localize('k_ds_full_deck_preview'), 0.18, G.C.WHITE)
            }}
        }},
        {n = G.UIT.C, config = {align = 'cm', colour = G.C.GREEN, r = 0.08, minw = 1.65, minh = 0.46, button = 'ds_import_load', hover = true, shadow = true}, nodes = {
            ds_import_text(localize('k_ds_load_deck'), 0.23)
        }}
    }}}
    for _, node in ipairs(ds_import_build_card_nodes(state.preview)) do nodes[#nodes + 1] = node end
    nodes[#nodes + 1] = ds_import_scrollbox(ds_import_build_setting_nodes(state.rows), 6.05, 1.45)
    return nodes
end

local function ds_import_preview_content(state)
    return {n = G.UIT.C, config = {align = 'tm', minw = import_content_width}, nodes = ds_import_build_preview_nodes(state)}
end

function Decksmith.create_import_page()
    Decksmith.refresh_import_files()
    local state = Decksmith.import_state
    local file_nodes = ds_import_build_file_nodes(state)
    return {n = G.UIT.R, config = {align = 'cm', padding = 0.08}, nodes = {
        {n = G.UIT.C, config = {align = 'tm', colour = G.C.BLACK, r = 0.1, padding = 0.12, minw = import_list_width, minh = Decksmith.page_height}, nodes = {
            {n = G.UIT.R, config = {align = 'cl', minw = 3.35, minh = 0.62, padding = 0.04}, nodes = {
                {n=G.UIT.C, config = {align='cl', colour = G.C.ORANGE, r = 0.08, minw = 3.35 - Decksmith.button_size - 0.04, padding = 0.04, hover = true, button = 'ds_open_decks_folder'}, nodes = {
                    ds_import_text(localize('k_ds_saved_decks'), 0.38, G.C.WHITE),
                }},
                Decksmith.create_value_button('refresh', Decksmith.button_size)
            }},
            {n = G.UIT.R, config = {align = 'cl', minw = 3.3, minh = 0.38, padding = 0.04}, nodes = {
                ds_import_text(#state.files == 1 and localize('k_ds_one_deck') or localize{type = 'variable', key = 'a_ds_deck_count', vars = {#state.files}}, 0.21)
            }},
            {n = G.UIT.R, config = {align = 'tl', minh = 4.55}, nodes = {
                ds_import_scrollbox(file_nodes, 3, 4.45)
            }}
        }},
        {n = G.UIT.C, config = {align = 'ct', colour = G.C.BLACK, r = 0.1, padding = 0.12, minw = 6.8, minh = Decksmith.page_height}, nodes = {
            {n = G.UIT.R, config = {align = 'ct', minh = 5.72}, nodes = {
                {n = G.UIT.C, config = {id = 'ds_import_preview', align = 'tm', minw = import_content_width, minh = 5.72}, nodes = {ds_import_preview_content(state)}}
            }}
        }}
    }}
end

G.FUNCS.ds_import_select = function(e)
    local state = Decksmith.import_state
    if state.selected == e.config.ref_value then return end
    if state.selected_button then state.selected_button.config.colour = G.C.BLUE end
    state.selected_button = e
    e.config.colour = G.C.GREEN
    Decksmith.select_import_file(e.config.ref_value)
    local preview = G.OVERLAY_MENU:get_UIE_by_ID('ds_import_preview')
    if not preview then return end
    remove_all(preview.children)
    preview.children = {}
    Decksmith.remove_import_card_areas()
    preview.UIBox:add_child(ds_import_preview_content(state), preview)
end

G.FUNCS.ds_import_load = function()
    local preview = Decksmith.import_state.preview
    if preview and Decksmith.import_settings(preview) then play_sound('button', 1, 0.5) end
end

function Decksmith.handle_duplicate_choices(page_def, choice, remove, start_table)
    if not Decksmith.start_args.banned_keys or not Decksmith.start_args.banned_keys[choice.config.center.key] then
        SMODS.RunSelect.Setup.choices[page_def.key] = SMODS.RunSelect.Setup.choices[page_def.key] or {}

        local selection_limit
        if type(page_def.selection_limit) == 'function' then
            selection_limit = page_def:selection_limit() or 1
        else
            selection_limit = page_def.selection_limit
        end

        if not remove then
            if selection_limit > 1 then

                local already_selected = #SMODS.RunSelect.Setup.choices[page_def.key]

                if already_selected < selection_limit then
                    table.insert(SMODS.RunSelect.Setup.choices[page_def.key], { key = choice.config.center.key, edition = choice.edition and choice.edition.key or nil })
                    Decksmith.start_args[start_table] = SMODS.RunSelect.Setup.choices[page_def.key]
                else
                    if choice.juice_up then choice:juice_up() end
                    return
                end
            else
                SMODS.RunSelect.Setup.choices[page_def.key] = {{ key = choice.config.center.key, edition = choice.edition and choice.edition.key or nil }}
            end
            if SMODS.RunSelect.Internals.preview_area then Decksmith.handle_verbose_choices_preview(page_def.key, choice.config.center.key, page_def.silent) end
        else
            table.remove(SMODS.RunSelect.Setup.choices[page_def.key], choice.index)
            Decksmith.start_args[start_table] = SMODS.RunSelect.Setup.choices[page_def.key]

            if SMODS.RunSelect.Internals.preview_area then
                for _, v in pairs(SMODS.RunSelect.Internals.preview_area.cards) do
                    if v.index > choice.index then
                        v.index = v.index - 1
                    end
                end
                Decksmith.handle_verbose_choices_preview(page_def.key, choice, page_def.silent, true)
            end
        end
    end
end

function Decksmith.handle_verbose_choices_preview(key, to_add, silent, _remove)
    if SMODS.config.run_select_performance then silent = true end
    local page_def = SMODS.RunSelect.Pages[key]

    local selection_limit = SMODS.RunSelect.Functions.get_selection_limit(page_def)

    if selection_limit == 1 and not _remove then
        if G.E_MANAGER.queues.run_select then G.E_MANAGER:clear_queue('run_select') end
        remove_all(SMODS.RunSelect.Internals.preview_area.cards)
        SMODS.RunSelect.Internals.preview_area.cards = {}
        remove_all(SMODS.RunSelect.Internals.preview_area_holding.cards)
        SMODS.RunSelect.Internals.preview_area_holding.cards = {}
    end

    if _remove then
        to_add:remove()
        SMODS.RunSelect.Functions.update_preview_texts(page_def)
        return
    end

    if not SMODS.RunSelect.Setup.choices[page_def.key] or (type(SMODS.RunSelect.Setup.choices[page_def.key]) == 'table' and not next(SMODS.RunSelect.Setup.choices[page_def.key])) then
        return
    end

    local preview_area = SMODS.RunSelect.Internals.preview_area
    local holding_area = SMODS.RunSelect.Internals.preview_area_holding
    
    SMODS.RunSelect.Internals.stack_size = SMODS.config.run_select_performance and math.min(5, page_def.preview_size or page_def.stack_size) or page_def.preview_size or page_def.stack_size
    local card_size = page_def.sprite_size or {w = G.CARD_W, h = G.CARD_H}
    if type(to_add) == 'table' then
        local temp = {}
        for k, v in pairs(to_add) do
            table.insert(temp, v)
        end
        to_add = temp
        SMODS.RunSelect.Internals.stack_size = #to_add
    end
    for j=1, SMODS.RunSelect.Internals.stack_size do
        local card = page_def.create_selection_card and page_def:create_selection_card(type(to_add) == 'table' and to_add[j].key or to_add, j, preview_area) 
        or Card(preview_area.T.x, preview_area.T.y, card_size.w, card_size.h, nil, G.P_CENTERS[type(to_add) == 'table' and to_add[j].key or to_add])
        card.params.run_select_preview_card = page_def.key
        if SMODS.RunSelect.Setup.choices[page_def.key][card.index] and SMODS.RunSelect.Setup.choices[page_def.key][card.index].edition then
            card:set_edition(SMODS.RunSelect.Setup.choices[page_def.key][card.index].edition, true, true)
        end
        if silent then
            preview_area:emplace(card)
        else
            holding_area:emplace(card)
            G.E_MANAGER:add_event(Event({
                func = (function()
                    play_sound('card1', math.random()*0.2 + 0.99, 0.35)
                    if holding_area.cards and preview_area.cards then preview_area:draw_card_from(holding_area) end
                    return true
                end)
            }), 'run_select')
        end
    end
    SMODS.RunSelect.Functions.update_preview_texts(page_def)
end

function Decksmith.populate_defaults(page_def, start_table_ref)
    SMODS.RunSelect.Setup.choices[page_def.key] = SMODS.RunSelect.Setup.choices[page_def.key] or {}
    for k, v in pairs(start_table_ref) do
        SMODS.RunSelect.Setup.choices[page_def.key][k] = v
    end
end

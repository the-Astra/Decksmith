-- Retrieves all deck files that may be valid
function Decksmith.retrieve_valid_decks()
    local filedata = SMODS.NFS.getDirectoryItemsInfo('Decksmith_decks')
    local valid_decks = {}
    for _, v in pairs(filedata) do
        if v.type == 'file' and v.name and string.sub(v.name, -4, -1) == '.jkr' then
            table.insert(valid_decks, v)
        end
    end
    return valid_decks
end

-- Returns a key/value table where the key is the filename and the value is the plaintext name
function Decksmith.get_valid_deck_names()
    local valid_decks = Decksmith.retrieve_valid_decks()
    local names = {}
    for _, v in pairs(valid_decks) do
        local data = assert(loadstring(SMODS.NFS.read('Decksmith_decks/' .. v.name)))()
        -- if data.name then
            names[v.name] = data.name or v.name -- TODO: Change when proper save naming is implemented
        -- end
    end
    return names
end

-- Retrieves data from a specified deck
function Decksmith.get_deck_data(path)
    return assert(setfenv(loadstring(SMODS.NFS.read('Decksmith_decks/' .. path)), {}))()
end

-- Hook this to add pages that need to be reset on deck import
function Decksmith.pages_to_reset_defaults()
    return {
        ['ds_starting_jokers'] = true,
        ['ds_starting_consumables'] = true,
        ['ds_starting_vouchers'] = true,
    }
end

-- Uses deck data to set deck preset
function Decksmith.set_deck_preset(path)
    local deck_data = Decksmith.get_deck_data(path)
    for k, v in pairs(deck_data) do
        if v ~= '' then
            Decksmith.start_args[k] = v
        end
    end
    local reset_pages = Decksmith.pages_to_reset_defaults()
    for key, page in pairs(SMODS.RunSelect.Pages) do
        if reset_pages[key] then
            SMODS.RunSelect.Setup.choices[key] = page:set_default(G.PROFILES[G.SETTINGS.profile].last_choices[key])
        end
    end
end

-- Check if a deck with name already exists. Create popup if it does, immediately save if not
function Decksmith.check_save_deck(new_path)
    local existing_names = Decksmith.get_valid_deck_names()
    local already_exists = false
    for k, _ in pairs(existing_names) do
        if k == new_path then
            Decksmith.overwrite_popup = UIBox({
                definition = G.UIDEF.ds_conflict_popup(new_path),
                config = {
                    align = 'cm',
                    major = G.ROOM_ATTACH,
                    offset = {x=0,y=10},
                    bond = 'Weak',
                    no_esc = true,
                    instance_type = 'POPUP'
                }
            })

            Decksmith.overwrite_popup.alignment.offset.y = 0
            G.ROOM.jiggle = G.ROOM.jiggle + 1
            Decksmith.overwrite_popup:align_to_major()

            already_exists = true
            break
        end
    end
    if not already_exists then
        Decksmith.write_deck(new_path)
    end
end

-- Creates or overwrites deck save under specified name
function Decksmith.write_deck(path)
    local file = SMODS.NFS.newFile('Decksmith_decks/' .. path)
    file:open('w')
    file:write('return {\r\n')
    for k, v in pairs(Decksmith.start_args) do
        if type(v) ~= 'table' and v ~= '' or type(v) == 'table' and next(v) ~= nil then
            file:write('    ' .. tostring(k) .. ' = ')
            local value = Decksmith.serialize_entry(v)
            file:write(tostring(value) .. ',\r\n')
        end
    end 
    file:write('}')
    file:close()
    G.FUNCS.ds_open_decks_folder()
end

function Decksmith.serialize_entry(value)
    local built_string
    if type(value) == 'table' then
        built_string = '{ '
        for k, v in pairs(value) do
            if type(k) ~= "number" then
                built_string = built_string .. tostring(k) .. ' = '
            end
            built_string = built_string .. tostring(Decksmith.serialize_entry(v)) .. ', '
        end
        built_string = built_string .. '}'
    elseif type(value) == "string" and not tonumber(value) then
        built_string = "'" .. value .. "'"
    else
        built_string = value
    end
    return built_string
end

function G.FUNCS.ds_open_decks_folder()
    love.system.openURL(love.filesystem.getSaveDirectory() .. '/Decksmith_decks/')
end

function G.FUNCS.ds_overwrite(e)
    local path = e.config.ref_value
    Decksmith.overwrite_popup:remove()
    Decksmith.overwrite_popup = nil
    Decksmith.write_deck(path)
end

function G.FUNCS.ds_cancel_write()
    Decksmith.overwrite_popup:remove()
    Decksmith.overwrite_popup = nil
end

function G.FUNCS.ds_init_save_process()
    local deck_name = Decksmith.start_args.ds_name or Decksmith.defaults.ds_name.reset
    local new_path = string.gsub(deck_name, " ", "_") .. '.jkr'
    Decksmith.check_save_deck(new_path)
end

function G.UIDEF.ds_conflict_popup(path)

    local warning_nodes = {}
    warning_nodes[#warning_nodes+1] = {}

    local loc_vars = {
        background_colour = G.C.CLEAR,
        text_colour = G.C.UI.TEXT_LIGHT,
        scale = 2.0,
        vars = {
            path,
            elements = {
                SMODS.create_sprite(0, 0, 1, 1, 'mod_tags', { x = 0, y = 0}),
                SMODS.create_sprite(0, 0, 1, 1, 'mod_tags', { x = 0, y = 0})
            }
        }
    }

    localize {
        type = 'descriptions',
        key = 'ds_warning_text',
        set = 'Other',
        vars = loc_vars.vars,
        text_colour = loc_vars.text_colour,
        shadow = loc_vars.shadow,
        nodes = warning_nodes[#warning_nodes],
    }
    warning_nodes[#warning_nodes] = desc_from_rows(warning_nodes[#warning_nodes])
    warning_nodes[#warning_nodes].config.colour = loc_vars.background_colour or warning_nodes[#warning_nodes].config.colour

    return {
        n = G.UIT.ROOT, config = { align = "cm", minw = G.ROOM.T.w * 5, minh = G.ROOM.T.h * 5, padding = 0.1, r = 0.1, colour = { G.C.GREY[1], G.C.GREY[2], G.C.GREY[3], 0.7 } }, nodes = {
        { n = G.UIT.R, config = { r = 0.1, colour = G.C.JOKER_GREY, padding = 0.05, align = "cm" }, nodes = {
            { n = G.UIT.C, config = { colour = G.C.L_BLACK, r = 0.1, padding = 0.2, align = "cm" }, nodes = {
                { n = G.UIT.R, config = { align = "cm", padding = 0.1 }, nodes = warning_nodes },
                { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                    { n = G.UIT.C, config = { padding = 0.3 }, nodes = {
                        { n = G.UIT.R, config = { id = "ds_continue_write", align = "cm", minw = 2.5, padding = 0.1, r = 0.1, hover = true, colour = G.C.GREEN, button = "ds_overwrite", shadow = true, focus_args = { nav = "wide", button = "b" }, ref_value = path }, nodes = {
                            { n = G.UIT.R, config = { align = "cm", padding = 0, no_fill = true }, nodes = {
                                { n = G.UIT.T, config = { text = localize("k_ds_continue"), scale = 0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
                            } },
                        } },
                    }},
                    { n = G.UIT.C, config = { padding = 0.3 }, nodes = {
                        { n = G.UIT.R, config = { id = "ds_cancel_write", align = "cm", minw = 2.5, padding = 0.1, r = 0.1, hover = true, colour = G.C.RED, button = "ds_cancel_write", shadow = true, focus_args = { nav = "wide", button = "b" } }, nodes = {
                            { n = G.UIT.R, config = { align = "cm", padding = 0, no_fill = true }, nodes = {
                                { n = G.UIT.T, config = { text = localize("k_ds_cancel"), scale = 0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
                            } },
                        } },
                    }},
                } },
            } },
        } },
    } }
end
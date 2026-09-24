-- Ban items on right click
local controller_queue_R_cursor_press_ref = Controller.queue_R_cursor_press
function Controller:queue_R_cursor_press(x, y)
    controller_queue_R_cursor_press_ref(self, x, y)
    local press_node = self.hovering.target or self.focused.target
    if press_node and press_node:is(Card) and press_node.ds_preview_card and press_node.area ~= SMODS.RunSelect.Internals.preview_area then
        play_sound('button', 1, 0.3)
        press_node:juice_up()
        Decksmith.start_args.banned_keys = Decksmith.start_args.banned_keys or {}
        if not Decksmith.start_args.banned_keys[press_node.config.center.key] then
            Decksmith.start_args.banned_keys[press_node.config.center.key] = true
            if SMODS.RunSelect.Setup.choices[press_node.ds_preview_card] then
                SMODS.RunSelect.Setup.choices[press_node.ds_preview_card][press_node.config.center.key] = nil
                for _, v in ipairs(SMODS.RunSelect.Internals.preview_area.cards) do
                    if v.config.center.key == press_node.config.center.key then
                        G.E_MANAGER:add_event(Event({
                            trigger = 'immediate',
                            delay = 0,
                            func = function()
                                v:remove()
                                return true;
                            end
                        }))
                    end
                end
                SMODS.RunSelect.Functions.update_preview_texts(SMODS.RunSelect.Pages[press_node.ds_preview_card])
            end
            press_node.debuff = true
        else
            Decksmith.start_args.banned_keys[press_node.config.center.key] = nil
            press_node.debuff = nil
        end
    end
end

local toggle_dropdown_ref = G.FUNCS.toggle_dropdown_menu
function G.FUNCS.toggle_dropdown_menu(e)
    toggle_dropdown_ref(e)
    local opened_drop = e.config.id
    if e.config.dropdown_obj and Decksmith.this_page_dropdowns and Decksmith.this_page_dropdowns[opened_drop] and not Decksmith.closing_other_drops then
        Decksmith.closing_other_drops = true
        for k, _ in pairs(Decksmith.this_page_dropdowns) do
            if k ~= opened_drop then
                local this_drop = G.OVERLAY_MENU:get_UIE_by_ID(k)
                if this_drop and this_drop.config.dropdown_obj then
                    G.FUNCS.toggle_dropdown_menu(this_drop)
                end
            end
        end
        Decksmith.closing_other_drops = nil
    end
end

local populate_preview_ref = SMODS.RunSelect.Functions.populate_preview_ui
function SMODS.RunSelect.Functions.populate_preview_ui(key, to_add, silent, _remove)
    if type(to_add) == 'table' and type(to_add[1]) == "table" then
        Decksmith.handle_verbose_choices_preview(key, to_add, silent, _remove)
    else
        populate_preview_ref(key, to_add, silent, _remove)
    end
end

local get_starting_params_ref = get_starting_params
function get_starting_params()
    return Decksmith.modifer_starting_params(get_starting_params_ref())
end

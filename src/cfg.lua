Decksmith.button_size = 0.7
Decksmith.page_height = 6.8

Decksmith.buttons = {
    reset = {
        hover = true,
        shadow = true,
        atlas = 'tags',
        pos = { x = 2, y = 3 },
        on_click = 'ds_reset',
        tooltip = 'k_ds_reset'
    },
    reset_all = {
        hover = true,
        shadow = true,
        atlas = 'tags',
        pos = { x = 2, y = 3 },
        on_click = 'ds_reset_all',
        tooltip = 'k_ds_reset_all'
    },
    random = {
        hover = true,
        shadow = true,
        atlas = 'tags',
        pos = { x = 5, y = 3 },
        on_click = 'ds_random',
        tooltip = 'k_ds_randomize'
    },
    random_all = {
        hover = true,
        shadow = true,
        atlas = 'tags',
        pos = { x = 5, y = 3 },
        on_click = 'ds_random_all',
        tooltip = 'k_ds_randomize_all'
    },
    refresh = {
        hover = true,
        shadow = true,
        atlas = 'tags',
        pos = { x = 0, y = 2 },
        on_click = 'ds_refresh',
        tooltip = 'k_ds_refresh'
    },
}

Decksmith.defaults = {
    -- General
    ds_joker_slots = {reset = 5, min = 1, max = 25},
    ds_consumable_slots = {reset = 2, min = 1, max = 25},
    ds_shop_slots = {reset = 2, min = 1, max = 25},
    ds_winning_ante = {reset = 8, min = 1, max = 38},
    ds_ante_scaling = {reset = 1, min = 1, max = 15},

    -- Money
    ds_starting_dollars = {reset = 4, min = 0, max = 150},
    ds_interest_amount = {reset = 1, min = 0, max = 15},
    ds_interest_cap = {reset = 5, min = 0, max = 25},
    ds_dollars_per_hand = {reset = 1, min = 0, max = 10},
    ds_dollars_per_discard = {reset = 0, min = 0, max = 10},
    ds_discard_cost = {reset = 0, min = 0, max = 10},
    ds_reroll_cost = {reset = 5, min = 0, max = 20},
    ds_discount_percentage = {reset = 0, min = 0, max = 100},

    -- Rates
    ds_joker_rate = {reset = 20, min = 0, max = 50},
    ds_tarot_rate = {reset = 4, min = 0, max = 50},
    ds_planet_rate = {reset = 4, min = 0, max = 50},
    ds_spectral_rate = {reset = 0, min = 0, max = 50},
    ds_pcard_rate = {reset = 0, min = 0, max = 50},

    -- Name
    ds_name = {reset = "My New Deck"},
    ds_author = {reset = "Unknown Author"},
}

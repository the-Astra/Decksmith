return {
    descriptions = {
        Back = {
            b_ds_custom = {
                name = 'Custom Deck',
                text = {
                    'Build your',
                    'own deck!'
                }
            }
        },
        Other = {
            ds_warning_text = {
                text = {
                    "{element:1} {s:2.0,C:warning_text}WARNING!!{} {element:2}",
                    " ",
                    "{s:1.6}A deck saved under the file name",
                    "{C:attention,s:1.8}'#1#'{}",
                    "{s:1.6}already exists.",
                    " ",
                    "{s:1.6}Would you like to overwrite this deck?"
                }
            }
        }
    },
    misc = {
        dictionary = {
            -- Labels
            k_ds_joker_slots = 'Joker Slots',
            k_ds_consumable_slots = 'Consumable Slots',
            k_ds_shop_slots = 'Shop Slots',
            k_ds_ante_scaling = 'Ante Scaling',
            k_ds_winning_ante = 'Winning Ante',

            k_ds_starting_dollars = 'Starting Dollars',
            k_ds_reroll_cost = 'Reroll Cost',
            k_ds_dollars_per_hand = 'Dollars per Hand',
            k_ds_dollars_per_discard = 'Dollars per Discard',
            k_ds_interest_amount = 'Interest Amount',
            k_ds_interest_cap = 'Interest Cap',
            k_ds_discount_percentage = 'Discount Percentage',
            k_ds_discard_cost = 'Discard Cost',

            k_ds_joker_rate = 'Joker Rate',
            k_ds_tarot_rate = 'Tarot Rate',
            k_ds_planet_rate = 'Planet Rate',
            k_ds_spectral_rate = 'Spectral Rate',
            k_ds_pcard_rate = 'Playing Card Rate',

            k_ds_name_deck = 'Name Your Deck',
            k_ds_sign_deck = 'Sign Your Deck',

            -- Title labels
            k_ds_import = 'IMPORT DECK',
            k_ds_general = 'GENERAL',
            k_ds_money = 'MONEY',
            k_ds_rates = 'RATES',
            k_ds_MODIFIERS = 'MODIFIERS',
            k_ds_export = 'EXPORT DECK',
            k_ds_saved_decks = 'SAVED DECKS',
            k_ds_no_decks = 'No .jkr decks found',
            k_ds_select_preview = 'Select a deck to preview all saved data',
            k_ds_load_deck = 'Load Deck',
            k_ds_full_deck_preview = 'FULL DECK PREVIEW',
            k_ds_saved_deck_preset = 'SAVED DECK PRESET',
            k_ds_invalid_deck = 'Invalid or unsupported .jkr file',
            k_ds_one_deck = '1 DECK',
            k_ds_yes = 'Yes',
            k_ds_no = 'No',
            k_ds_none = 'None',
            k_ds_value = 'Value',
            k_ds_data = 'Data',
            k_ds_empty = '(empty)',
            k_ds_run_rules = 'RUN RULES',
            k_ds_economy = 'ECONOMY',
            k_ds_shop_rates = 'SHOP RATES',
            k_ds_starting_jokers_title = 'STARTING JOKERS',
            k_ds_starting_consumables_title = 'STARTING CONSUMABLES',
            k_ds_starting_vouchers_title = 'STARTING VOUCHERS',
            k_ds_bans_modifiers = 'BANS & MODIFIERS',
            k_ds_deck_info = 'DECK INFO',
            k_ds_jokers = 'JOKERS',
            k_ds_consumables = 'CONSUMABLES',
            k_ds_vouchers = 'VOUCHERS',

            -- Run Select
            run_select_ds_import = 'Import',
            run_select_ds_general = 'General',
            run_select_ds_money = 'Money',
            run_select_ds_rates = 'Rates',
            run_select_ds_starting_jokers = 'Jokers',
            run_select_ds_starting_consumables = 'Consumables',
            run_select_ds_starting_vouchers = 'Vouchers',
            run_select_ds_modifiers = 'Modifiers',
            run_select_ds_export = 'Export',

            -- Run Select Random
            run_select_ds_starting_jokers_random = 'Random Joker',
            run_select_ds_starting_consumables_random = 'Random Card',
            run_select_ds_starting_vouchers_random = 'Random Voucher',

            -- Tooltips
            k_ds_reset = 'Reset Value',
            k_ds_reset_all = 'Reset All Values',
            k_ds_randomize = 'Randomize Value',
            k_ds_randomize_all = 'Randomize All Values',
            k_ds_refresh = 'Refresh Page',

            -- Buttons
            k_ds_continue = 'Continue',
            k_ds_cancel = 'Cancel',
            k_ds_open_folder = 'Open Decks Folder',
            k_ds_save_deck = 'Save Deck'
        },
        v_dictionary = {
            a_ds_jokers_remaining = '#1# Joker(s) remaining',
            a_ds_consumables_remaining = '#1# Consumable(s) remaining',
            a_ds_deck_count = '#1# DECKS',
            a_ds_preview_count = '#1#  #2#',
            a_ds_preview_count_missing = '#1#  #2# (#3# MISSING)',
            a_ds_created_by = 'Created by: #1#'
        }
    }
}

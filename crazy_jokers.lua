SMODS.Atlas{
	key = 'crazy_jokers_atlas',
	path = 'Jokers.png',
	px = 73, 
	py = 97,
	atlas_table = 'ASSET_ATLAS'
}

--Talking Joker
SMODS.Joker{
	key = 'talking_joker',
	atlas = 'crazy_jokers_atlas',
	pos = {x = 0, y = 0},
	rarity = 1,
	cost = 6,
	blueprint_compat = true,
	perishable_compat = false,
	config = {
		extra = {
			Xmult = 1,
			Xmult_gain = 0.25
		}
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.Xmult_gain,
				card.ability.extra.Xmult
			}
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main and (card.ability.extra.Xmult > 1) then
			return {
				Xmult_mod = card.ability.extra.Xmult,
				message = 'X' .. card.ability.extra.Xmult,
				colour = G.C.MULT
			}
		end
		if context.buying_card and (context.cardarea == G.jokers) and (context.card.config.center.rarity == 1) and not context.blueprint and not (context.card == card) then
			card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain
			return {
                message = localize('k_upgrade_ex'),
				colour = G.C.MULT
            }
		end
	end
}



--Arizona Ranger
SMODS.Joker{
	key = 'arizona_ranger',
	atlas = 'crazy_jokers_atlas',
	pos = {x = 1, y = 0},
	rarity = 2,
	cost = 7,
	blueprint_compat = true,
	perishable_compat = false,
	config = {
		extra = {
			mult = 10,
			mult_gain = 5,
			dollars = 3,
			poker_hand = 'High Card',
			repetitions = 1,
			suit = 'Hearts'
		}
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.mult,
				card.ability.extra.mult_gain,
				card.ability.extra.dollars,
				localize(card.ability.extra.poker_hand, 'poker_hands'),
				card.ability.extra.repetitions,
				localize(card.ability.extra.suit, 'suits_singular')
			}
		}
	end,
	calculate = function(self, card, context)
		if context.destroying_card and not context.blueprint then
			if context.destroying_card:is_suit(card.ability.extra.suit) then
				return { 
					dollars = card.ability.extra.dollars,
					remove = true
				}
			end
		end
		if context.before and context.main_eval and next(context.poker_hands[card.ability.extra.poker_hand]) then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
			return {
				message = localize('k_upgrade_ex'),
				colour = G.C.MULT
			}
        end
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            local _poker_hands = {}
            for k, v in pairs(G.GAME.hands) do
                if v.visible and k ~= card.ability.extra.poker_hand then
                    _poker_hands[#_poker_hands + 1] = k
                end
            end
            card.ability.extra.poker_hand = pseudorandom_element(_poker_hands, pseudoseed('vremade_to_do'))
            return {
                message = localize('k_reset')
            }
        end
		if context.after and context.cardarea == G.play and not context.blueprint then
			for i = 1, #context.full_hand do
				if context.full_hand[i]:is_suit(card.ability.extra.suit) then
					context.full_hand[i]:destroying_card()
				end
			end
        end
		if context.repetition and context.cardarea == G.play then
            return {
                repetitions = card.ability.extra.repetitions
            }
        end
		if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
		set_ability = function(self, card, initial, delay_sprites)
        local _poker_hands = {}
        for k, v in pairs(G.GAME.hands) do
            if v.visible and k ~= card.ability.extra.poker_hand then
                _poker_hands[#_poker_hands + 1] = k
            end
        end
        card.ability.extra.poker_hand = pseudorandom_element(_poker_hands,
            pseudoseed((card.area and card.area.config.type == 'title') and 'vremade_false_to_do' or 'vremade_to_do'))
		end
	end
}



--Black Deck Enjoyer
SMODS.Joker {
    key = "blackdeck_joker",
	atlas = 'crazy_jokers_atlas',
	pos = {x = 2, y = 0},
	rarity = 1,
	cost = 5,
    config = { 
		extra = { 
			discard_size = 1,
			shop_size = 2,
			discount_reroll = 5,
		}
	},
    loc_vars = function(self, info_queue, card)
        return { 
			vars = { 
				card.ability.extra.discard_size,
				card.ability.extra.shop_size,
				card.ability.extra.discount_reroll
			} 
		}
    end,
    add_to_deck = function(self, card, from_debuff)
		G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.discard_size
        ease_discard(card.ability.extra.discard_size)
		G.E_MANAGER:add_event(Event({func = function()
            change_shop_size(card.ability.extra.shop_size)
            return true end }))
		G.E_MANAGER:add_event(Event({func = function()
            G.GAME.round_resets.reroll_cost = G.GAME.round_resets.reroll_cost - card.ability.extra.discount_reroll
            G.GAME.current_round.reroll_cost = math.max(0, G.GAME.current_round.reroll_cost - card.ability.extra.discount_reroll)
            return true end }))
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.discard_size
        ease_discard(-card.ability.extra.discard_size)
		G.E_MANAGER:add_event(Event({func = function()
            change_shop_size(-card.ability.extra.shop_size)
            return true end }))
		G.E_MANAGER:add_event(Event({func = function()
            G.GAME.round_resets.reroll_cost = G.GAME.round_resets.reroll_cost + card.ability.extra.discount_reroll
            return true end }))
	end,
}
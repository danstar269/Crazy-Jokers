SMODS.Atlas{
	key = 'crazy_jokers_atlas',
	path = 'Jokers.png',
	px = 73, 
	py = 97,
	atlas_table = 'ASSET_ATLAS'
}

SMODS.optional_features = { cardareas = {}, post_trigger = true, quantum_enhancements = true, retrigger_joker = true }



--Talking Joker
SMODS.Joker{
	key = "talking_joker",
	name = "talking_joker",
	atlas = "crazy_jokers_atlas",
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
	key = "arizona_ranger",
	name = "arizona_ranger",
	atlas = "crazy_jokers_atlas",
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
	name = "blackdeck_joker",
	atlas = "crazy_jokers_atlas",
	pos = {x = 2, y = 0},
	rarity = 1,
	cost = 5,
	blueprint_compat = false,
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
		card_eval_status_text(card, 'extra', nil, nil, nil,
		{ message = localize('k_buckle'), colour = G.C.BLACK, instant = true })
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



--Cameraman
SMODS.Joker {
	key = "cameraman",
	name = "cameraman",
	atlas = "crazy_jokers_atlas",
	pos = {x = 4, y = 0},
	rarity = 1,
	cost = 5,
	blueprint_compat = true,
	perishable_compat = false,
	config = { 
		extra = { 
			dollars = 2,
			mult = 5,
			mult_buffer = 0,
			dollar_buffer = 0,
		}
	},
	loc_vars = function(self, info_queue, card)
		return { 
			vars = { 
				card.ability.extra.dollars,
				card.ability.extra.mult,
				card.ability.extra.mult_buffer,
				card.ability.extra.dollar_buffer,
			} 
		}
    end,
	calculate = function(self, card, context)
		local other_joker = nil
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] == card then other_joker = G.jokers.cards[i + 1] end
        end
		if context.post_trigger and context.other_context ~= context.repetition then
			if context.other_card == other_joker then
				if other_joker.ability.name == 'Mime' or other_joker.ability.name == 'Blueprint' or 
				other_joker.ability.name == 'Brainstorm' or other_joker.ability.name == 'cry-Canvas' then
					card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
					{ message = localize('k_copyrighted'), colour = G.C.BLACK })
					return {
						remove_default_message = true,
						card = card or context.other_card or nil,
					}
				else
					card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
					{ message = localize('k_caught'), colour = G.C.BLUE })
					card_eval_status_text(context.blueprint_card or card, 'dollars', card.ability.extra.dollars, nil, nil, nil)
					card.ability.extra.mult_buffer = card.ability.extra.mult_buffer + card.ability.extra.mult
					card_eval_status_text(context.blueprint_card or card, 'mult', card.ability.extra.mult_buffer, nil, nil, nil)
					return {
						remove_default_message = true,
						dollars = card.ability.extra.dollars,
						card = card or context.other_card or nil,
					}
				end
			end
		end
		
		--recording
		if (context.before and context.main_eval and other_joker ~= nil) then
			return {
				card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
				{ message = localize('k_recording'), colour = G.C.BLACK })
			}
		end
		
		
		if context.after and context.main_eval then
			--For vanilla retrigger jokers
			if other_joker ~= nil then
				if other_joker.ability.name == 'Sock and Buskin' then
					card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
					{ message = localize('k_playback'), colour = G.C.BLACK })
					local j = 0
					while j < other_joker.ability.extra do
						for i = 1, #context.full_hand do
							if context.full_hand[i]:is_face() then
								card.ability.extra.mult_buffer = card.ability.extra.mult_buffer + card.ability.extra.mult
								card_eval_status_text(context.blueprint_card or card, 'mult', card.ability.extra.mult_buffer, nil, nil, nil)
								card.ability.extra.dollar_buffer = card.ability.extra.dollar_buffer + card.ability.extra.dollars
							end
						end
						j = j + 1
					end
					local bufdollar = card.ability.extra.dollar_buffer
					card.ability.extra.dollar_buffer = 0
					if bufdollar > 0 then
						return {
							dollars = bufdollar,
						}
					else 
						return
					end
				end
				if other_joker.ability.name == 'Hanging Chad' then
					card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
					{ message = localize('k_playback'), colour = G.C.BLACK })
					local i = 0
					while i < 2 do
						card.ability.extra.mult_buffer = card.ability.extra.mult_buffer + card.ability.extra.mult
						card_eval_status_text(context.blueprint_card or card, 'mult', card.ability.extra.mult_buffer, nil, nil, nil)
						i = i + 1
					end
					return {
						dollars = card.ability.extra.dollars * 2,
					}
				end
				if other_joker.ability.name == 'Dusk' and G.GAME.current_round.hands_left == 0 then
					local j = 0
					while j < other_joker.ability.extra do
						for i = 1, #context.full_hand do
							card.ability.extra.mult_buffer = card.ability.extra.mult_buffer + card.ability.extra.mult
							card_eval_status_text(context.blueprint_card or card, 'mult', card.ability.extra.mult_buffer, nil, nil, nil)
							card.ability.extra.dollar_buffer = card.ability.extra.dollar_buffer + card.ability.extra.dollars
						end
						j = j + 1
					end
					local bufdollar = card.ability.extra.dollar_buffer
					card.ability.extra.dollar_buffer = 0
					if bufdollar > 0 then
						return {
							dollars = bufdollar,
						}
					else 
						return
					end
				end
				if other_joker.ability.name == 'Seltzer' then
					card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
					{ message = localize('k_playback'), colour = G.C.BLACK })
					for i = 1, #context.full_hand do
						card.ability.extra.mult_buffer = card.ability.extra.mult_buffer + card.ability.extra.mult
						card_eval_status_text(context.blueprint_card or card, 'mult', card.ability.extra.mult_buffer, nil, nil, nil)
						card.ability.extra.dollar_buffer = card.ability.extra.dollar_buffer + card.ability.extra.dollars
					end
					local bufdollar = card.ability.extra.dollar_buffer
					card.ability.extra.dollar_buffer = 0
					if bufdollar > 0 then
						return {
							dollars = bufdollar,
						}
					else 
						return
					end
				end
				if other_joker.ability.name == 'Hack' then
					card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
					{ message = localize('k_playback'), colour = G.C.BLACK })
					local j = 0
					while j < other_joker.ability.extra do
						for i = 1, #context.full_hand do
							if (context.full_hand[i]:get_id() == 2 or 
								context.full_hand[i]:get_id() == 3 or 
								context.full_hand[i]:get_id() == 4 or 
								context.full_hand[i]:get_id() == 5) then
									card.ability.extra.mult_buffer = card.ability.extra.mult_buffer + card.ability.extra.mult
									card_eval_status_text(context.blueprint_card or card, 'mult', card.ability.extra.mult_buffer, nil, nil, nil)
									card.ability.extra.dollar_buffer = card.ability.extra.dollar_buffer + card.ability.extra.dollars
							end
						end
						j = j + 1
					end
					local bufdollar = card.ability.extra.dollar_buffer
					card.ability.extra.dollar_buffer = 0
					if bufdollar > 0 then
						return {
							dollars = bufdollar,
						}
					else 
						return
					end
				end
				if other_joker.ability.name == 'arizona_ranger' then
					card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
					{ message = localize('k_playback'), colour = G.C.BLACK })
					local j = 0
					while j < other_joker.ability.extra.repetitions do
						for i = 1, #context.full_hand do
							card.ability.extra.mult_buffer = card.ability.extra.mult_buffer + card.ability.extra.mult
							card_eval_status_text(context.blueprint_card or card, 'mult', card.ability.extra.mult_buffer, nil, nil, nil)
							card.ability.extra.dollar_buffer = card.ability.extra.dollar_buffer + card.ability.extra.dollars
						end
						j = j + 1
					end
					local bufdollar = card.ability.extra.dollar_buffer
					card.ability.extra.dollar_buffer = 0
					if bufdollar > 0 then
						return {
							dollars = bufdollar,
						}
					else 
						return
					end
				end
				
				--For modded jokers
				if other_joker.ability.name ~= 'Mime' and 
				other_joker.ability.name ~= 'Sock and Buskin' and
				other_joker.ability.name ~= 'Hanging Chad' and 
				other_joker.ability.name ~= 'Dusk' and 
				other_joker.ability.name ~= 'Seltzer' and 
				other_joker.ability.name ~= 'Hack' and
				other_joker.ability.extra ~= nil and
				type(other_joker.ability.extra) ~= 'number' and
				(other_joker.ability.extra.repetitions or other_joker.ability.extra.retriggers) then
				
				
					--Cryptid card retrigger jokers
					if other_joker.ability.name == 'cry-weegaming' then
						card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
						{ message = localize('k_playback'), colour = G.C.BLACK })
						local j = 0
						while j < (other_joker.ability.extra.repetitions or other_joker.ability.extra.retriggers) do
							for i = 1, #context.full_hand do
								if context.full_hand[i]:get_id() == 2 then
									card.ability.extra.mult_buffer = card.ability.extra.mult_buffer + card.ability.extra.mult
									card_eval_status_text(context.blueprint_card or card, 'mult', card.ability.extra.mult_buffer, nil, nil, nil)
									card.ability.extra.dollar_buffer = card.ability.extra.dollar_buffer + card.ability.extra.dollars
								end
							end
							j = j + 1
						end
						local bufdollar = card.ability.extra.dollar_buffer
						card.ability.extra.dollar_buffer = 0
						if bufdollar > 0 then
							return {
								dollars = bufdollar,
							}
						else 
							return
						end
					end
					if other_joker.ability.name == 'cry-sock_and_sock' then
						card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
						{ message = localize('k_playback'), colour = G.C.BLACK })
						local j = 0
						while j < (other_joker.ability.extra.repetitions or other_joker.ability.extra.retriggers) do
							for i = 1, #context.full_hand do
								if SMODS.has_enhancement(context.full_hand[i], "m_cry_abstract") then
									card.ability.extra.mult_buffer = card.ability.extra.mult_buffer + card.ability.extra.mult
									card_eval_status_text(context.blueprint_card or card, 'mult', card.ability.extra.mult_buffer, nil, nil, nil)
									card.ability.extra.dollar_buffer = card.ability.extra.dollar_buffer + card.ability.extra.dollars
								end
							end
							j = j + 1
						end
						local bufdollar = card.ability.extra.dollar_buffer
						card.ability.extra.dollar_buffer = 0
						if bufdollar > 0 then
							return {
								dollars = bufdollar,
							}
						else 
							return
						end
					end
					if other_joker.ability.name == 'cry-nosound' then
						card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
						{ message = localize('k_playback'), colour = G.C.BLACK })
						local j = 0
						while j < (other_joker.ability.extra.repetitions or other_joker.ability.extra.retriggers) do
							for i = 1, #context.full_hand do
								if context.full_hand[i]:get_id() == 7 then
									card.ability.extra.mult_buffer = card.ability.extra.mult_buffer + card.ability.extra.mult
									card_eval_status_text(context.blueprint_card or card, 'mult', card.ability.extra.mult_buffer, nil, nil, nil)
									card.ability.extra.dollar_buffer = card.ability.extra.dollar_buffer + card.ability.extra.dollars
								end
							end
							j = j + 1
						end
						local bufdollar = card.ability.extra.dollar_buffer
						card.ability.extra.dollar_buffer = 0
						if bufdollar > 0 then
							return {
								dollars = bufdollar,
							}
						else 
							return
						end
					end
					
					
					--Cryptid joker retriggerers
					if other_joker.ability.name == 'cry-Boredom' then
						card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
						{ message = localize('k_boring'), colour = G.C.BLACK })
						return {
							dollars = card.ability.extra.dollars,
						}
					end
					if other_joker.ability.name == 'cry-Chad' then
						card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
						{ message = localize('k_chad'), colour = G.C.BLACK })
						return {
							dollars = card.ability.extra.dollars * 10,
						}
					end
					if other_joker.ability.name == 'cry-rnjoker Joker' then
						card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
						{ message = localize('k_boring'), colour = G.C.BLACK })
						return {
							dollars = card.ability.extra.dollars,
						}
					end
					if other_joker.ability.name == 'cry-Spectrogram' then
						card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
						{ message = localize('k_boring'), colour = G.C.BLACK })
						return {
							dollars = card.ability.extra.dollars,
						}
					end
					if other_joker.ability.name == 'cry-loopy' then
						card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
						{ message = localize('k_boring'), colour = G.C.BLACK })
						return {
							dollars = card.ability.extra.dollars,
						}
					end
					
					
					--general case for any joker that is not specific, earlier returns shoud end the calc early
					--if the retriggerer is a joker retrigger, there is no way to know who he is retriggering in this context, as
					--the normal post_trigger is not working to capture the joker retrigger and normal retriggering as well
					card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
					{ message = localize('k_playback'), colour = G.C.BLACK })
					local j = 0
					while j < (other_joker.ability.extra.repetitions or other_joker.ability.extra.retriggers) do
						for i = 1, #context.full_hand do
							card.ability.extra.mult_buffer = card.ability.extra.mult_buffer + card.ability.extra.mult
							card_eval_status_text(context.blueprint_card or card, 'mult', card.ability.extra.mult_buffer, nil, nil, nil)
							card.ability.extra.dollar_buffer = card.ability.extra.dollar_buffer + card.ability.extra.dollars
						end
						j = j + 1
					end
					local bufdollar = card.ability.extra.dollar_buffer
					card.ability.extra.dollar_buffer = 0
					if bufdollar > 0 then
						return {
							dollars = bufdollar,
						}
					else 
						return
					end
				end
				
			end
			
			
		end
		
		--main scoring/end of scoring
		if context.joker_main then
			local last_mult = card.ability.extra.mult_buffer
			card.ability.extra.mult_buffer = 0.0
			if last_mult > 0.0 then
				return {
					mult = last_mult,
				}
			end
		end
	end
}
return {
    descriptions = {
        Back={},
        Blind={},
        Edition={},
        Enhanced={},
        Joker={
			j_crazy_talking_joker = {
                name = 'Talking Joker',
				text = {
				'Gains {X:mult,C:white} X#1# {} Mult',
				'when a {C:blue}Common{} {C:attention}Joker{}',
				'is bought.',
				'{C:inactive}(Currently{} {X:mult,C:white}X#2#{} {C:inactive}Mult){}',
				'{C:inactive,s:0.7}Who is he talking to?{}'
				},
            },
			j_crazy_arizona_ranger = {
				name = 'Arizona Ranger',
				text = {
				'{C:red}+10{} Mult.',
				'This Joker gains {C:red}+#2#{} Mult if {C:attention}poker hand{}',
				'contains a {C:attention}#4#{}',
				"poker hand changes",
				"at the end of the round.",
				'{C:attention}Retrigger{} all played cards {C:attention}#5#{} times',
				'{C:red}destroy{} any scored {C:hearts}#6#{}',
				'earn {C:money}$#3#{} per card destroyed.',
				'{C:inactive}(Currently{} {C:red}+#1#{} {C:inactive}Mult){}'
				},
			},
			j_crazy_blackdeck_joker = {
				name = 'Black Deck Enjoyer',
				text = {
				'{C:attention}+#1# {}{C:red}Discard{} and {C:attention}+#2#{} {C:money}Shop{} slots.',
				'Discount {C:green}rerolls{} by {C:money}$#3#{} each round.'
			},
		},
	},
        Other={},
        Planet={},
        Spectral={},
        Stake={},
        Tag={},
        Tarot={},
        Voucher={},
    },
    misc = {
        achievement_descriptions={},
        achievement_names={},
        blind_states={},
        challenge_names={},
        collabs={},
        dictionary={},
        high_scores={},
        labels={},
        poker_hand_descriptions={},
        poker_hands={},
        quips={},
        ranks={},
        suits_plural={},
        suits_singular={},
        tutorial={},
        v_dictionary={},
        v_text={},
    },
}
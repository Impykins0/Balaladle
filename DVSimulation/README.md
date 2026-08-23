<h1 align="center">Divvy's Simulation for Balatro</h1>

<p align="center">A library for simulating Balatro scoring.</p>

> [!CAUTION]
> This is NOT a standalone mod for Balatro &mdash; it is a tool for mod developers.
> If you are looking for a way to preview scores as you play Balatro, use my preview mod:
> [Divvy's Preview](https://github.com/DivvyCr/Balatro-Preview)

## How to Add into Your Mod

This is for mod developers only:

 0. You (and your players) must have [Lovely](https://github.com/ethangreen-dev/lovely-injector)
 1. Copy the contents of `src/` into a directory within your mod.
 
> [!TIP]
> Ideally, your mod and this library should be in separate folders on the user's computer, like this:<br>
> `.../AppData/Roaming/Balatro/Mods/DVSimulate/`<br>
> `.../AppData/Roaming/Balatro/Mods/YOUR_MOD/`<br>
> If you can, separate your mod and this library in your release.
> An example of this is shown in the releases of 
> [Divvy's Preview](https://github.com/DivvyCr/Balatro-Preview/releases)
> (download the release to see its structure)

## How to Use within Your Mod

First of all, it's important to check whether the library is loaded.
I am not entirely sure in what order Lovely loads Steamodded (compared to this library), so this may cause errors.
At the end of the day, this is just good practice and not mandatory.
You can do that by checking that `DV.SIM` exists:

```lua
if not DV or not DV.SIM then
  error("Could not find Divvy's Simulation library, which is required for YOUR MOD NAME")
end
```

Then, it's as easy as running `DV.SIM.run()`.
This will simulate the score on the hand currently highlighted by the player.
In the near future, I should make it possible to give arguments to the simulation, such as custom hands, jokers, etc.

```lua
-- DV.SIM.run() returns the following table:
{
  score = {
    min = 0,
    exact = 0,
    max = 0
  },
  dollars = {
    min = 0,
    exact = 0,
    max = 0
  }
}
```

### Examples

The simplest use could look like:

```lua
local simulation = DV.SIM.run()
if simulation.score.exact > special_threshold then
  -- Do something!
end
```

For more intricate use of this library, see how I use it in [DVPreview.lua](https://github.com/DivvyCr/Balatro-Preview/blob/main/Mods/DVPreview.lua).
The most important tip I can give is to limit the number of times you have to run the simulation.
I can't imagine any scenario where you would want to run it more than I do in `DVPreview.lua`, so feel free to use my approaches from there!

## How to Add Modded Jokers

All joker simulations are stored in `src/Jokers/`.
The simulations are stripped down versions of the jokers' `calculate(self, card, context)` functions, which should be familiar to most Balatro mod developers.
Read on to learn how exactly the simulations are written.

> [!IMPORTANT]
> To get your mod supported by this library, you can either:
> 1. submit a **pull request** to this library with your jokers' adapted calculation functions, or
> 2. you can create an issue and wait for me to implement your jokers.
>
> I do not guarantee that I will do the second part in a timely manner, however!

## What is the structure of a simulation function?

To begin with, an example of the basic structure for making modded jokers compatible is as follows:

```lua
-- File: src/Jokers/MOD_NAME.lua

DV.SIM.JOKERS.simulate_[JOKERID1] = function(joker, context)
   if context.cardarea == G.jokers and context.before and not context.blueprint then
      -- Upgrade joker, or simulate any other 'before' effects
   elseif context.cardarea == G.jokers and context.global then
      -- Simulate main effect application
   end
end

DV.SIM.JOKERS.simulate_[JOKERID2] = function(joker, context)
   if context.cardarea == G.play and context.individual then
      -- Simulate joker effect on each played card
   elseif context.cardarea == G.hand and context.individual then
      -- Simulate joker effect on each held card
   end
end

-- All other jokers...
end
```

If you've created modded jokers before, then the structure of each function should be familiar.
The only big differences are: the repetition of `if context.cardarea ...` for each function, and the new `context.global` property which I introduced to specify when the global joker effects are being applied (as opposed to per-card effects).
You should specify `context.global` whenever your joker's effect was in the `else` branch of all contexts.
The best way to get a feel for all this is to look at the examples down below.

> [!IMPORTANT]
> The simulation code **must use my mod's custom functions**, all of which are listed below.
> This is necessary because I use a stripped-down version of all objects, namely `Card`, which in turn means that the default functions like `Card:get_id()` may cause errors.
> Again, this is a consequence of avoiding animations and side-effects.

Lastly, **you don't have to write functions for all modded jokers** &mdash; only those that affect score or money during a played hand. For instance, here is a sample of jokers that I ignore in the vanilla game:
 - "Four Fingers", because it does not affect the score nor the money directly;
 - "Trading Card", because its effect is applied after a discard, not after a play;
 - "Marble Joker", because its effect applies during blind selection, not during a play;
 - "Delayed Gratification", because its effect applies after the round ends, not during a play.

If in doubt, feel free to ask for help on Discord!

### What are the custom functions?

The following are the core functions for manipulating the simulated chips and mult.
You will usually just use one argument to manipulate all chips and mult equally (ie. for exact/min/max preview), like `DV.SIM.add_mult(3)`.
However, if your joker has a chance element to it, you will have to specify all three arguments.
 - `DV.SIM.add_chips(exact, [min], [max])`
 - `DV.SIM.add_mult(exact, [min], [max])`
 - `DV.SIM.x_mult(exact, [min], [max])`
 - `DV.SIM.add_dollars(exact, [min], [max])`
 - `DV.SIM.add_reps(n)`
   - This adds `n` repetitions for the current played or held card; see examples below.
 - `DV.SIM.get_probabilistic_extremes(random_value, odds, reward, default)`
   - This is a helper function for getting the `exact`, `min`, and `max` values from your joker, if it relies on chance.
   - It assumes that your joker uses the standard approach to chance: `random_value < probability/odds`.
   - Its main purpose is to account for guaranteed probabilities, like "2 in 2 chance", which would mean that `exact = min = max`.

<details><summary><b>[CLICK ME] Jokers relying on `t_chips`, `t_mult`, or `s_mult`:</b></summary>

If your modded joker leverages the game's built-in properties for chips or mult (based on hand type or suit), then you can use the following functions:
 - `DV.SIM.JOKERS.add_type_chips(joker, context)`
 - `DV.SIM.JOKERS.add_type_mult(joker, context)`
 - `DV.SIM.JOKERS.add_suit_mult(joker, context)`

```lua
DV.SIM.JOKERS.simulate_lusty_joker = function(joker, context)
   DV.SIM.JOKERS.add_suit_mult(joker, context)
end


DV.SIM.JOKERS.simulate_jolly = function(joker, context)
    DV.SIM.JOKERS.add_type_mult(joker, context)
end

DV.SIM.JOKERS.simulate_sly = function(joker, context)
    DV.SIM.JOKERS.add_type_chips(joker, context)
end
```

</details>

<details><summary><b>[CLICK ME] Jokers relying on automatic `x_mult` application:</b></summary>

If your modded joker leverages the game's built-in x-mult calculation, then you can use the following function:
 - `DV.SIM.JOKERS.x_mult_if_global(joker, context)`

However, **only do this if you know what you are doing**. If in doubt, have a look at the function definition, [here](https://github.com/DivvyCr/Balatro-Preview/blob/da295c058e86911b653d978cc8c19e365586f7df/Mods/DVSimulate.lua#L1432).

```lua
DV.SIM.JOKERS.simulate_madness = function(joker, context)
    DV.SIM.JOKERS.x_mult_if_global(joker, context)
end
```

</details>

```lua
DV.SIM.JOKERS.simulate_bloodstone = function(joker, context)
   if context.cardarea == G.play and context.individual then
      if DV.SIM.is_suit(context.other_card, "Hearts") and not context.other_card.debuff then
         local exact_xmult, min_xmult, max_xmult = DV.SIM.get_probabilistic_extremes(pseudorandom("bloodstone"), joker.ability.extra.odds, joker.ability.extra.Xmult, 1)
         DV.SIM.x_mult(exact_xmult, min_xmult, max_xmult)
      end
   end
end
```

---

The following drop-downs contain all available properties, and below them are the new property retrieval functions.

<details><summary><b>[CLICK ME] Available card properties:</b></summary>

```lua
local card_data = {
   rank = card_obj.base.id,                -- Number 2-14 (where 11-14 is Jack through Ace)
   suit = card_obj.base.suit,              -- "Spades", "Hearts", "Clubs", or "Diamonds"
   base_chips = card_obj.base.nominal,     -- Number 2-10 (default number of chips scored)
   ability = copy_table(card_obj.ability), -- Mirrors Card object
   edition = copy_table(card_obj.edition), -- Mirrors Card object
   seal = card_obj.seal,                   -- "Red", "Purple", "Blue", or "Gold"
   debuff = card_obj.debuff,               -- Boolean
   lucky_trigger = {}                      -- Holds values for exact/min/max triggers
}
```

</details>

<details><summary><b>[CLICK ME] Available joker properties:</b></summary>

```lua
local joker_data = {
   id = [...],
   ability = copy_table(joker.ability), -- Mirrors Card object
   edition = copy_table(joker.edition), -- Mirrors Card object
   rarity = joker.config.center.rarity  -- Number 1-4 (Common, Uncommon, Rare, Legendary)
}
```

</details>

 - `DV.SIM.get_rank(card_data)`
   - Returns the card's rank (2-14) or a unique negative value for Stone Cards.
 - `DV.SIM.is_rank(card_data, ranks)`
   - Check for a single rank by using a number argument: `DV.SIM.is_rank(card, 9)`
   - Check for multiple ranks by using a table argument: `DV.SIM.is_rank(card, {11, 12, 13})`
 - `DV.SIM.is_face(card_data)`
   - Checks for ranks 11, 12, 13, taking into account Pareidolia.
 - `DV.SIM.is_suit(card_data, suit, [ignore_debuff])`
   - Checks for suit, taking into account Stone Cards, Wild Cards, and Smeared Joker.
   - Usually returns `false` if card is debuffed, unless `ignore_debuff == true`.

```lua
DV.SIM.JOKERS.simulate_walkie_talkie = function(joker, context)
   if context.cardarea == G.play and context.individual then
      if DV.SIM.is_rank(context.other_card, {10, 4}) and not context.other_card.debuff then
         DV.SIM.add_chips(joker.ability.extra.chips)
         DV.SIM.add_mult(joker.ability.extra.mult)
      end
   end
end
```

---

The following are the new card manipulation functions.
In general, instead of `card:set_property(new_property)` you will have to write `DV.SIM.set_property(card, new_property)`.
 - `DV.SIM.set_ability(card_data, center)`
 - `DV.SIM.set_edition(card_data, edition)`

```lua
DV.SIM.JOKERS.simulate_midas_mask = function(joker, context)
   if context.cardarea == G.jokers and context.before and not context.blueprint then
      for _, card in ipairs(context.full_hand) do
         if DV.SIM.is_face(card) then
            DV.SIM.set_ability(card, G.P_CENTERS.m_gold)
         end
      end
   end
end
```

### Examples

The best source of examples is the default `DV.SIM.JOKERS` definition, found in `src/Jokers/_Vanilla.lua` ([here](https://github.com/DivvyCr/Balatro-Simulation/blob/main/src/Jokers/_Vanilla.lua)).

<details><summary><b>[CLICK ME] Hack:</b></summary>

```lua
DV.SIM.JOKER.simulate_hack = function(joker, context)
   if context.cardarea == G.play and context.repetition then
      if not context.other_card.debuff and DV.SIM.is_rank(context.other_card, {2, 3, 4, 5}) then
         DV.SIM.add_reps(joker.ability.extra)
      end
   end
end
```

</details>

<details><summary><b>[CLICK ME] Ride The Bus:</b></summary>

```lua
DV.SIM.JOKERS.simulate_ride_the_bus = function(joker, context)
   -- Upgrade/Reset, as necessary:
   if context.cardarea == G.jokers and context.before and not context.blueprint then
      local faces = false
      for _, scoring_card in ipairs(context.scoring_hand) do
         if DV.SIM.is_face(scoring_card) then faces = true end
      end
      if faces then
         joker.ability.mult = 0
      else
         joker.ability.mult = joker.ability.mult + joker.ability.extra
      end
   end

   -- Apply mult:
   if context.cardarea == G.jokers and context.global then
      DV.SIM.add_mult(joker.ability.mult)
   end
end
```

</details>

<details><summary><b>[CLICK ME] Hiker:</b></summary>

```lua
DV.SIM.JOKERS.simulate_hiker = function(joker, context)
   if context.cardarea == G.play and context.individual then
      if not context.other_card.debuff then
         context.other_card.ability.perma_bonus = (context.other_card.ability.perma_bonus or 0) + joker.ability.extra
      end
   end
end
```

</details>

<details><summary><b>[CLICK ME] Business Card:</b></summary>

```lua
DV.SIM.JOKERS.simulate_business = function(joker, context)
   if context.cardarea == G.play and context.individual then
      if DV.SIM.is_face(context.other_card) and not context.other_card.debuff then
         local exact_dollars, min_dollars, max_dollars = DV.SIM.get_probabilistic_extremes(pseudorandom("business"), joker.ability.extra, 2, 0)
         DV.SIM.add_dollars(exact_dollars, min_dollars, max_dollars)
      end
   end
end
```

</details>

<details><summary><b>[CLICK ME] Idol:</b></summary>

```lua
DV.SIM.JOKERS.simulate_idol = function(joker, context)
   if context.cardarea == G.play and context.individual then
      if DV.SIM.is_rank(context.other_card, G.GAME.current_round.idol_card.id) and
         DV.SIM.is_suit(context.other_card, G.GAME.current_round.idol_card.suit) and
         not context.other_card.debuff
      then
         DV.SIM.x_mult(joker.ability.extra)
      end
   end
end
```

</details>

---

<p align="center">
<b>If you found this mod useful, consider supporting me!</b>
</p>

<p align="center">
<a href="https://www.buymeacoffee.com/divvyc" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>
</p>


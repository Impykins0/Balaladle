# Balaladle

<div align="center">

<p>
    <img src="assets/demo.gif" alt="Balaladle gameplay demo" width="720">
</p>

<p>
    <b>
        A daily Balatro challenge. 
        Compete with friends to get as close as possible to the target score!
    </b>
</p>

</div>

## Features

- A new challenge **every day** (resets 00:00 UTC)
- The same deck, Jokers, consumables, and target score for every player
- One hand to score as close as possible to the target score
- A daily friends leaderboard based on Steam friends
- Unlimited attempts, with only your best attempt score displayed
- A shareable result you can copy to clipboard after completing a run

Your Balaladle Score is the percent difference between your final score and the target score:

```
Balaladle Score = |final score - target score| / target score × 100
```

Thus, lower scores are better. Try to get a Balaladle Score of `0%`!

## Installation

> [!CAUTION]
> Windows is currently the only supported platform. <br>
> MacOS users are able to play the challenge, but the leaderboard is currently broken because the 
  required [HTTPS module](https://github.com/love2d/lua-https) does not load correctly. <br>
> Linux support has not been tested.

### Requirements

- [Steamodded](https://github.com/Steamodded/smods) (>= 1.0.0~ALPHA-0812d)
- [Lovely Injector](https://github.com/ethangreen-dev/lovely-injector) (>= 0.9)

### Steps

1. Download the latest [Balaladle release](https://github.com/Impykins0/Balaladle/releases).
2. Extract the files into a new folder in your Balatro mods directory.
    - Make sure that the files are directly inside the Balaladle folder instead of an additional 
      nested folder.
3. Launch the game and make sure that Balaladle appears in the Steamodded mod list.

## How to Play

> [!IMPORTANT]
> For the daily challenge to generate properly, your current profile must have everything unlocked. <br>
> To unlock everything, select **Profile** from the main menu, select your desired profile, 
  then select **Unlock all**.

1. Launch Balatro with Balaladle enabled.
2. Select **Play** from the main menu.
3. Select **Balaladle**.
    - If this button does not appear, make sure your account has completed the Balatro tutorial.
4. Start the daily challenge.
5. Complete the run to see your Balaladle Score and friends leaderboard.

## Mod Compatibility

> [!CAUTION]
> Balaladle is not compatible with mods that add custom Jokers. Other content or gameplay-changing 
  mods may also result in unintended challenge generation and/or scores.

Balaladle uses [Divvy's Simulation](https://github.com/DivvyCr/Balatro-Simulation) to calculate its 
target score. Divvy's simulation supports vanilla Jokers, but custom Jokers require individual 
simulation logic. Thus, Balaladle is not compatible with mods that add custom Jokers, unless I 
create my own scoring system. Currently, I do not plan on adding support for content mods. Cosmetic 
and utility mods may work, but compatibility is not guaranteed.

For more information on this limitation, see
[DivvyCr's explanation](http://github.com/DivvyCr/Balatro-Preview#point_right-mod-compatibility).

## HTTPS and Privacy

Balaladle makes HTTPS requests to its leaderboard server. The server source code is publicly 
available in the [balaladle-server repository](https://github.com/Impykins0/balaladle-server).

When you use the leaderboard, the mod stores or retrieves:

- Your public SteamID64
- Your submitted Balaladle Score
- Your time of submission
- Your public Steam username (through the Steam Web API)
- Your public Steam friends list, (through the Steam Web API)

The leaderboard is restricted to Steam friends. If your Steam friends list is private, 
the leaderboard will fail to load. There is currently no global leaderboard.

> [!NOTE]
> While Cloudflare receives your IP address when processing leaderboard requests, Balaladle never
  stores it and uses it strictly for rate-limiting to prevent abuse.

> [!WARNING]
> Balaladle does not currently use Steam authentication, and thus, cannot guarantee that a 
  submitted Steam ID belongs to the person making the request. The leaderboard is not intended to
  be used as a perfectly accurate and competitive ranking system.

## Reporting Bugs

Things will probably break 😩. I would really appreciate it if you could report bugs through the 
repository's [GitHub Issues](https://github.com/Impykins0/Balaladle/issues) page.

## License

Balaladle is licensed under the [GNU General Public License v3.0](LICENSE).

The repository also includes an unmodified copy of 
[Divvy's Simulation](https://github.com/DivvyCr/Balatro-Simulation) by DivvyCr and licensed under the 
[GNU General Public License v3.0](https://github.com/DivvyCr/Balatro-Simulation/tree/main?tab=GPL-3.0-1-ov-file).

## Acknowledgements

- The GOAT LocalThunk for creating a masterpiece
- [DivvyCr](https://github.com/DivvyCr) for 
  [Divvy's Simulation](https://github.com/DivvyCr/Balatro-Simulation), 
  which Balaladle uses to calculate target scores
- The developers of the 
  [Balatro Multiplayer Mod](https://github.com/Balatro-Multiplayer/BalatroMultiplayer) 
  for inspiring Balaladle's networking approach and its integration with the Multiplayer Mod's
  main-menu interface
- **@justabeanie on Discord** for the original mod idea and emotional support!
- Everyone who has tested Balaladle, reported bugs, or shared feedback

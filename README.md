# Roblox Test Dummy Script

Adjustable Test Dummy is a client-sided Roblox test dummy script for spawning a hittable dummy, dealing damage with a tool or by touch, and changing hit power during testing.

## Install

1. In Roblox Studio, create a `LocalScript` in `StarterPlayer > StarterPlayerScripts`.
2. Copy the contents of `StarterPlayerScripts/ClientDummyTester.client.lua` into the LocalScript.
3. Run the place using **Play** or **Play Here** so `Players.LocalPlayer` is available.

## Use

1. Click **SPAWN DUMMY** to place a dummy in front of your character. You can also press **F6** to spawn or respawn it.
2. Set the hit power from **1 to 1000** in the power box.
3. Equip the **Client Test Bat** from your Backpack and click the dummy to damage it. Touching the dummy with your character also deals the selected power.
4. Check the dummy’s health display and the on-screen status for damage and defeat feedback.

The dummy, tool, and damage are client-sided and are not replicated as authoritative multiplayer game damage. The dummy starts with 100 health. This is intended for local testing, not as a server-authoritative combat system.

---

More Roblox script projects by EnderDevelopment: https://github.com/EnderDevelopment

Project page: https://dash.enderdevelopment.com/community/9abaa9e0-0564-404c-8337-581723c842c9?utm_source=github&utm_medium=readme&utm_campaign=auto_publish&utm_content=9abaa9e0-0564-404c-8337-581723c842c9

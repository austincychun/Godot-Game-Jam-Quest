# Power Drain - Godot 4 Starter Game

A small top-down Godot 4 game built for the theme **Running Out of Power**.

## Core loop
- Move with WASD / arrow keys
- Battery drains over time
- Collect batteries to refill power
- Avoid enemies
- Press Space to dash (costs battery)
- Reach the exit before battery reaches 0

## Rubric coverage
- Theme: battery constantly draining
- Animated PC sprite: included through `AnimatedSprite2D` setup in Player scene
- Map collision: wall collisions in level
- Item/Enemy collision: battery pickups and enemy hazards
- Game loop managed movement: top-down movement with dash
- Sound/music: audio nodes included with hook points
- Action beyond movement: dash
- Level design: one simple complete level with pickups, hazards, walls, exit
- Aesthetic: retro power-facility setup

## How to use
1. Open the folder in Godot 4.
2. Create simple placeholder textures if Godot shows missing visuals, or assign your own sprites.
3. Add `.wav` or `.ogg` files to `assets/` and wire them into the `AudioStreamPlayer` nodes.
4. Run `scenes/main.tscn`.

## Inputs
- Move: WASD / Arrow keys
- Dash: Space
- Restart after win/lose: R

## Notes
This is a starter implementation. You should still personalize visuals, sounds, and level layout before submission.

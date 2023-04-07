
int main()
{
    // GAME IDEA: Kirby boss fight

    // MAX_DX => Maximum left, right velocity of player (8)
    // MAX_DY => Maximum fall, jump velocity of player (8)
    // Acceleration => acceleration left, right
    // Gravity => acceleration by gravity

    // Drawing player:
    // (p.x, p.y) start at the top left
    // Each sprite is going to be 8x8
    // Except boss

    // Player "struct:
    // p.x => Player positions 
    // p.y
    // p.dx => Player velocity (increments by multiples of 4)
    // p.dy
    // p.facing => 0 for left, 1 for right

    // NOTE: positions and velocity to be stored in registers
    // p.health

    draw_background()
    draw_character()
    // Will draw background before drawing the character so that the character is above
    // The background and character will be drawn pixel by pixel
    // The character will be drawn according to p.x, p.y
    // LATER: The sprite will change depending on if they are in the air or idle

    collission()
    // With both platforms and objects

    control()
    // This function will change p.dx 
    // LATER: Check if it is within bounds

    gravity()
    // This function will automatically reduce p.y

    // LOOP BACK TO THE TOP

    // TO-BE ADDED:
    // Health bar depending on p.health
    // Boss attributes
    // Boss attacks

    // TO-DO TODAY:
    // Printing sprites
    // Control
    // Gravity
    
}
# Hopscotch

8-voice MIDI rhythmic arpeggiator for [norns](https://monome.org/norns/)

![](img/hopscotch.png)

## Using Hopscotch

Play some notes with a MIDI input device and Hopscotch will map each note to its own selectable rhythm sequence. There is a 20% chance that the note will play 1 octave higher or lower when it is triggered. Each of the 8 voices can be sent to any MIDI channel. Voices are assigned in the order that they are played, with each new note taking the first available space.

### Hardware requirements

- MIDI device to input notes
- MIDI device to send output to

You can choose input and output devices in the params menu

### Select a Sequence

Use encoder 2 to select which voice you would like to modify. Encoder 3 chooses the sequence.

The `!` option assigns a random sequence to that voice whenever a new note is played.

### Select a MIDI channel

Hold shift (key 1) to change the sequencer options to MIDI channels. Select which voice you want to modify with encoder 2, and choose a MIDI channel with encoder 3.

## Controls

- K1: shift - change midi channel
- K3: hold on/off
- E2: select a parameter
- E3: adjust parameter

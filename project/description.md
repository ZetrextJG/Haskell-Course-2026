# TextTrack: A Two-File Tracker-Style Sequencer

## Motivation

While most modern music production relies on graphical piano rolls, there is a dedicated niche of “tracker” software (such as classic chiptune trackers or modern tools like Renoise) that sequences music using a vertical, alphanumeric grid. In these systems, composition is split into two distinct parts: a library of predefined instruments and sounds, and a timeline of text instructions that trigger them. Recreating a small, text-only version of this workflow makes for an ideal functional programming project. It naturally separates parsing, environment management, and timeline evaluation into distinct components while also introducing stateful transformations over structured data.

TextTrack combines ideas from music sequencing, symbolic interpreters, and pure mathematical audio synthesis into a manageable but non-trivial project. It provides opportunities to work with explicit parser combinators, the Reader-Writer-State (RWS) monad for pure stateful traversals, algebraic data modeling, property-based testing, and standardized media generation.

---

## Project Overview

TextTrack is a text-based sequencing engine that compiles two text files into a cohesive musical timeline. The user defines synthesizers, mathematically modeled drum sounds, realistic instruments, and relative chord templates in a **Device Specification File**. These are then arranged in a **Tracker Line File** — a strict, pipe-delimited grid where the composer triggers notes, sustains them (`=`), initiates their release envelope (`~`), or cuts them immediately (`-`).

The system parses both files, validates cross-references with cycle detection, calculates precise rhythmic timing, and evaluates the tracker grid into a pure flat list of timed musical events featuring distinct hold durations.

---

## Key Goals

1. **Dual Parsers**: Implement parsers for the Device format and the strict, pipe-delimited Tracker grid format. Correctly parse enharmonic pitches (converting them immediately to MIDI note numbers), flow-control symbols, and structural metadata like BPM and LPB (Lines Per Beat).
2. **Sequencer Engine (RWS)**: Interpret the parsed tracker AST against the device environment. Use the Reader-Writer-State monad stack to hold the environment (Reader), track active polyphonic notes and time (State), and log finished musical events (Writer).
3. **Recursive Resolution & Cycle Detection**: Handle nested device routing, such as a relative Chord mapping to an underlying Instrument. Implement a `Set`-based cycle detector to prevent infinite loops from recursive definitions.
4. **Test Suite**: Cover parsing, semantic validation, timeline flattening, and event generation with unit, end-to-end, and property-based tests.
5. **Stretch Goal (MIDI Export)**: Translate the flattened `Event` list into a standard `.mid` file. Map the precise float timings to MIDI ticks, assign devices to separate MIDI channels, and handle Note On / Note Off events.
6. **Super Stretch Goal (WAV Export)**: Bypass MIDI entirely and render the events directly to a `.wav` file buffer using pure Haskell DSP. Synthesize sine/square/saw waves, generate white noise for hi-hats, compute pitch-sweep decay curves for kick drums, and mix the amplitudes into a final audio file.

---

## Suggested Core Data Types

```haskell
import Data.Map (Map)
import Data.Set (Set)

-- 1. Device Bank (Environment)

type DeviceID = String
type Volume   = Float    -- Range: 0.0 to 1.0
type DecayRate = Float   -- Inherent physical property of how fast a sound fades

-- Internal engine uses MIDI Note Numbers (0-127, Middle C = 60) for mathematically sound transpositions.
type MidiNote = Int 

data Pitch
  = Tone MidiNote   
  | DrumTrigger          -- Drums ignore specific MIDI pitch routing
  deriving (Show, Eq)

data Oscillator = Sine | Square | Saw | Noise deriving (Show, Eq)
data Instrument = GrandPiano | ElectricPiano | Guitar | Bass | Violin deriving (Show, Eq)

data DrumModel
  = Kick { startPitch :: Float, endPitch :: Float, pitchDropRate :: Float }
  | Snare { bodyPitch :: Float, noiseMix :: Float }  
  | HiHat { sharpness :: Float }                     
  deriving (Show, Eq)

data Device
  = Synth Oscillator DecayRate
  | DrumSynth DrumModel DecayRate 
  | InstrumentDevice Instrument DecayRate
  | Chord [Interval] DeviceID  -- Maps relative intervals to a target playback device
  deriving (Show, Eq)

type DeviceBank = Map DeviceID Device

-- 2. Tracker AST

data Step
  = Trigger Pitch DeviceID Volume
  | Sustain   -- '='
  | Dampen    -- '~' (Starts the device's release envelope)
  | Rest      -- '-' (Hard cut to 0.0 volume)
  deriving (Show, Eq)

type Channel = Int
type Row = [(Channel, Step)]

data TrackerScore = TrackerScore
  { bpm          :: Int
  , linesPerBeat :: Int    -- Rhythm resolution (e.g., 4 = 16th notes)
  , tracks       :: Int
  , rows         :: [Row]
  }

-- 3. Engine Output & Intermediate State

data Event = Event
  { start       :: Float
  , holdTime    :: Float  -- Active hold time before the release phase begins
  , cutEarly    :: Bool   -- True if '-' was used, False if '~' was used
  , pitch       :: Pitch
  , volume      :: Float
  , device      :: DeviceID
  } deriving (Show, Eq)

-- Intermediate state for the RWS Monad State
type Time = Float
data ActiveNote = ActiveNote Pitch Time DeviceID Volume

-- Maps a Channel to a *list* of notes currently being held down on it (supports Chords/Polyphony)
type ActiveState = Map Channel [ActiveNote]

```

---

## Example Input and Output

### devices.def

```txt
device 01 : synth "Square" 0.5
device 02 : drum "Kick" 150.0 40.0 12.0
device 03 : instrument "GrandPiano" 1.2

-- Chords define intervals (in semitones from the root) and the device that plays them
chord 04 : [0, 4, 7] on 03    -- Major chord played on Grand Piano

```

### song.trk

*Note: Using 120 BPM and 4 LPB means 1 Beat = 0.5s, so 1 Row = 0.125s.*

```txt
bpm 120
lpb 4      
tracks 2

-- | CH 1 (Melody)      | CH 2 (Drums) |
| C4    04  0.8         | *     02  1.0 |
| =                     | -             |
| =                     | -             |
| E4    03  0.7         | -             |
| =                     | *     02  0.9 |
| ~                     | -             |
| -                     | -             |

```

### Result

The engine mathematically converts rows into seconds, recursively expands the chord into three distinct piano events, tracks holds and decays, and outputs the final pure `Event` list.

```haskell
[ Event { start = 0.0, holdTime = 0.375, cutEarly = False, pitch = Tone 60, device = "03", ... }
, Event { start = 0.0, holdTime = 0.375, cutEarly = False, pitch = Tone 64, device = "03", ... }
, Event { start = 0.0, holdTime = 0.375, cutEarly = False, pitch = Tone 67, device = "03", ... }
, Event { start = 0.0, holdTime = 0.125, cutEarly = True,  pitch = DrumTrigger, device = "02", ... }
, Event { start = 0.375, holdTime = 0.250, cutEarly = False, pitch = Tone 64, device = "03", ... }
, Event { start = 0.500, holdTime = 0.125, cutEarly = True,  pitch = DrumTrigger, device = "02", ... }
]

```

---

## Implementation Components

### 1. Dual Parsers

**Device Parser:**
Parse synthesizers, algorithmic drums, realistic instruments, and chord definitions. Detect duplicate IDs and validate syntax. The parser must support relative chord declarations mapped to another ID (e.g., `chord 04 : [0, 4, 7] on 03`).

**Tracker Parser:**
Parse header metadata (`bpm`, `lpb`, `tracks`). For the grid, strictly enforce `|` delimiters to avoid flexible whitespace alignment issues. A row with empty channels must structurally represent them (e.g., `| C4 03 0.8 | - |`). Parse pitches supporting both sharps (`Cs`) and flats (`Db`), instantly converting them to MIDI note numbers (0-127). Constrain volumes to $0.0 \leq v \leq 1.0$.

### 2. Sequencer Engine

**Time Translation:**
Compute the rhythmic duration of a single row in seconds using standard musical timing:

$$RowDuration = \frac{60}{BPM \times LPB}$$

**Environment Resolution & Routing (Cycle Safe):**
Validate that referenced devices exist. When hitting a `Chord`, recursively look up the target device, add the semitone intervals to the trigger's MIDI note, and generate multiple simultaneous events. Pass a `Set DeviceID` through the lookup function to detect and reject infinite routing loops.

**Timeline Flattening (RWS Monad):**
Traverse rows using the Reader-Writer-State monad. `Reader` holds the immutable `DeviceBank`. `State` carries the `Time` and `ActiveState` map. `Writer` logs completed `Event` records.

* **`Trigger`** calculates the completed duration of current notes, logs them to `Writer`, and inserts new note(s) into `State`.
* **`=`** purely advances the global time in `State`.
* **`~`** logs notes to `Writer` with `cutEarly = False`, signaling the renderer to apply the device's natural decay rate, then clears them from `State`.
* **`-`** logs notes to `Writer` with `cutEarly = True`, signaling an immediate mute, then clears them from `State`.

### 3. Test Suite

**Unit Tests:**
Verify volume parsing strictly enforces limits. Verify pipe-delimited grid rows parse correctly and fail fast on missing pipes. Ensure flats and sharps accurately map to the same integer MIDI note number (e.g., `Cs4` and `Db4` both equal `61`). Verify the cycle detector correctly catches self-referencing chords.

**End-to-End Tests:**
Provide complete text pairs. Compare generated `[Event]` lists against hand-computed expected results. Ensure chords properly multiplex into individual events and that row indices correctly translate into seconds.

**Property-Based Tests:**
Use a framework like QuickCheck for the following invariants:

* **Volume Bounds:** Every generated event must satisfy $0.0 \leq volume \leq 1.0$.
* **Conservation of Time:** Total event `holdTime` on any channel must not exceed the total tracker duration mathematically possible.
* **Transposition Invariance:** Transposing a root note fed into a `Chord` definition must shift the integer MIDI pitches of all resulting output events by exactly that interval without mutating timings.

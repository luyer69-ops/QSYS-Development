-- ============================================================
-- PLUGIN CONTROLS (must return a table)
-- Controls are persistent data objects stored within the design.
-- They are bound to the UI and to pins.
-- ============================================================
--[[
  =====================================================================
  FULL REFERENCE FOR GetControls()
  =====================================================================

  COMMON PROPERTIES FOR ALL CONTROLS:
  +-----------------+----------+-----------+--------------------------------------------------+
  | Property        | Type     | Required  | Description                                      |
  +-----------------+----------+-----------+--------------------------------------------------+
  | Name            | String   | YES       | Control name (no spaces recommended)             |
  | ControlType     | String   | YES       | "Button" | "Knob" | "Indicator" | "Text"         |
  | Count           | Integer  | No        | Number of controls. If > 1 -> array              |
  |                 |          |           | Runtime access: Controls.Name[i]                 |
  | PinStyle        | String   | No        | "Input" | "Output" | "Both" | "None"             |
  | UserPin         | Boolean  | No        | If true -> pin visible under "Control Pins"      |
  | DefaultValue    | Varies   | No        | Initial value (Boolean / number / string)         |
  +-----------------+----------+-----------+--------------------------------------------------+

  NOTE on Count > 1:
    - If Count = 3 and Name = "Button", the controls are named:
      "Button 1", "Button 2", "Button 3"
    - In layout they are referenced the same way: layout["Button 1"] = { ... }
    - At runtime: Controls.Button[1], Controls.Button[2], Controls.Button[3]

  NOTE on PinStyle vs UserPin:
    - UserPin = true  + PinStyle defined  -> User can choose whether to show the pin
    - UserPin = false + PinStyle defined  -> Pin is always visible (no option to hide it)
    - UserPin = false + no PinStyle       -> No external pin

  -------------------------------------------------------------------
  TYPE: Button
  -------------------------------------------------------------------
  Exclusive properties:
  +-------------+---------+-----------+----------------------------------------------------+
  | ButtonType  | String  | YES       | "Momentary"    -> Active while held down           |
  |             |         |           | "Toggle"       -> Alternates between on/off         |
  |             |         |           | "Trigger"      -> Single event pulse               |
  |             |         |           | "StateTrigger" -> Multiple states (needs Min/Max)  |
  | Icon        | String  | No        | QDS icon name ("Power","skull", etc.)              |
  |             |         |           | or path to local file (requires Plugin Compiler)   |
  | IconType    | String  | Cond.     | REQUIRED if Icon is defined.                       |
  |             |         |           | "Icon" (default) | "Image" (PNG/JPG) | "SVG"       |
  | Min         | Integer | Cond.     | REQUIRED if ButtonType = "StateTrigger"            |
  | Max         | Integer | Cond.     | REQUIRED if ButtonType = "StateTrigger"            |
  +-------------+---------+-----------+----------------------------------------------------+

  -------------------------------------------------------------------
  TYPE: Knob
  -------------------------------------------------------------------
  Exclusive properties:
  +-------------+---------+-----------+----------------------------------------------------+
  | ControlUnit | String  | YES       | Unit of the control. See ranges table below.       |
  | Min         | Number  | Cond.     | Lower bound. Required unless marked NOT req.       |
  | Max         | Number  | Cond.     | Upper bound. Required unless marked NOT req.       |
  +-------------+---------+-----------+----------------------------------------------------+

  Knob-Specific Ranges (source: q-syshelp.qsc.com -> Reserved Functions -> Knob-Specific Ranges):
  +--------------+------------------+------------------+---------------+---------------+----------+
  | ControlUnit  | Lower Limit      | Upper Limit      | Default Min   | Default Max   | Min/Max  |
  |              |                  |                  |               |               | Required |
  +--------------+------------------+------------------+---------------+---------------+----------+
  | "dB"         | -100             | 20               | -100          | 20            | Yes      |
  | "Hz"         | 20               | 20000            | 20            | 20000         | Yes      |
  | "Float"      | -1,000,000,000   | 1,000,000,000    | 0             | 100           | Yes      |
  | "Integer"    | -999,999,999     | 999,999,999      | 1             | 100           | Yes      |
  | "Pan"        | -1               | 1                | -1            | 1             | No       |
  | "Percent"    | 0                | 100              | 0             | 100           | Yes      |
  | "Position"   | 0                | 1                | 0             | 1             | No       |
  | "Seconds"    | 0                | 87400            | 0             | 1             | Yes      |
  +--------------+------------------+------------------+---------------+---------------+----------+
  NOTE: Default Min/Max are the values used when Min/Max are not specified. For units
  where Min/Max are required (Yes), the defaults only apply if the developer omits them
  accidentally -- always specify Min/Max explicitly for required units.

  -------------------------------------------------------------------
  TYPE: Indicator
  -------------------------------------------------------------------
  Exclusive properties:
  +---------------+---------+-----------+--------------------------------------------------+
  | IndicatorType | String  | YES       | "Led"    -> LED indicator (on/off)               |
  |               |         |           | "Meter"  -> Level meter                          |
  |               |         |           | "Text"   -> Read-only text indicator             |
  |               |         |           | "Status" -> Q-SYS system status indicator        |
  +---------------+---------+-----------+--------------------------------------------------+

  -------------------------------------------------------------------
  TYPE: Text
  -------------------------------------------------------------------
  No exclusive properties at control level.
  The display type (TextBox, ComboBox, ListBox) is defined in GetControlLayout().
  =====================================================================
]]--
function GetControls(props)
  local ctrls = {}

  -- Rebuild the complete page list using the helper function.
  -- GetControls() may need to know which pages exist when adding
  -- controls conditionally based on the active page configuration.
  -- Even if not used directly here, calling BuildPageNames() ensures
  -- consistency with GetPages() and GetControlLayout().
  -- local allPages = BuildPageNames(props)  -- uncomment if needed


  table.insert(ctrls, {
    Name        = "SendButton",
    ControlType = "Button",
    ButtonType  = "Momentary",
    Count       = 1,
    PinStyle    = "Input",
    UserPin     = true,
    Icon        = "Power",        -- Q-SYS Designer icon name
    IconType    = "Icon",         -- "Icon" | "Image" | "SVG"
  })

  -- Toggle Button
  table.insert(ctrls, {
    Name        = "MuteButton",
    ControlType = "Button",
    ButtonType  = "Toggle",
    Count       = 1,
    PinStyle    = "Both",
    UserPin     = true,
  })

  -- Trigger Button
  table.insert(ctrls, {
    Name        = "ResetButton",
    ControlType = "Button",
    ButtonType  = "Trigger",
    Count       = 1,
    PinStyle    = "Input",
    UserPin     = true,
  })

  -- StateTrigger Button (multiple states)
  table.insert(ctrls, {
    Name         = "SourceSelector",
    ControlType  = "Button",
    ButtonType   = "StateTrigger",
    Min          = 0,              -- Minimum state (required for StateTrigger)
    Max          = 3,              -- Maximum state (required for StateTrigger)
    Count        = 1,
    PinStyle     = "Both",
    UserPin      = true,
  })

  -- Knob type dB
  table.insert(ctrls, {
    Name         = "InputGain",
    ControlType  = "Knob",
    ControlUnit  = "dB",
    Min          = -100,
    Max          = 20,
    Count        = 1,
    PinStyle     = "Both",
    UserPin      = true,
  })

  -- Knob type Hz
  table.insert(ctrls, {
    Name         = "Frequency",
    ControlType  = "Knob",
    ControlUnit  = "Hz",
    Min          = 20,
    Max          = 20000,
    Count        = 1,
    PinStyle     = "Both",
    UserPin      = true,
  })

  -- Knob type Percent
  table.insert(ctrls, {
    Name         = "Percentage",
    ControlType  = "Knob",
    ControlUnit  = "Percent",
    Min          = 0,
    Max          = 100,
    Count        = 1,
    PinStyle     = "Both",
    UserPin      = true,
  })

  -- Knob type Integer
  table.insert(ctrls, {
    Name         = "IntegerValue",
    ControlType  = "Knob",
    ControlUnit  = "Integer",
    Min          = 1,
    Max          = 64,
    Count        = 1,
    PinStyle     = "Both",
    UserPin      = true,
  })

  -- Knob type Float
  table.insert(ctrls, {
    Name         = "FloatValue",
    ControlType  = "Knob",
    ControlUnit  = "Float",
    Min          = 0.0,
    Max          = 1.0,
    Count        = 1,
    PinStyle     = "Both",
    UserPin      = false,
  })

  -- Knob type Pan
  table.insert(ctrls, {
    Name         = "Pan",
    ControlType  = "Knob",
    ControlUnit  = "Pan",
    -- Min/Max NOT required for Pan (fixed range -1 to 1)
    Count        = 1,
    PinStyle     = "Both",
    UserPin      = true,
  })

  -- Knob type Position
  table.insert(ctrls, {
    Name         = "Position",
    ControlType  = "Knob",
    ControlUnit  = "Position",
    -- Min/Max NOT required for Position (fixed range 0 to 1)
    Count        = 1,
    PinStyle     = "Both",
    UserPin      = false,
  })

  -- Knob type Seconds
  table.insert(ctrls, {
    Name         = "DelayTime",
    ControlType  = "Knob",
    ControlUnit  = "Seconds",
    Min          = 0,
    Max          = 5,
    Count        = 1,
    PinStyle     = "Both",
    UserPin      = true,
  })

  -- LED Indicator (array of 4 LEDs)
  table.insert(ctrls, {
    Name          = "StatusLed",
    ControlType   = "Indicator",
    IndicatorType = "Led",
    Count         = 4,              -- Creates: "StatusLed 1" .. "StatusLed 4"
    PinStyle      = "Output",
    UserPin       = true,
  })

  -- Meter Indicator
  table.insert(ctrls, {
    Name          = "LevelMeter",
    ControlType   = "Indicator",
    IndicatorType = "Meter",
    Count         = 1,
    PinStyle      = "Input",
    UserPin       = true,
  })

  -- Text Indicator (read-only)
  table.insert(ctrls, {
    Name          = "StatusText",
    ControlType   = "Indicator",
    IndicatorType = "Text",
    Count         = 1,
    PinStyle      = "Output",
    UserPin       = true,
  })

  -- Status Indicator (Q-SYS system status)
  table.insert(ctrls, {
    Name          = "ConnectionStatus",
    ControlType   = "Indicator",
    IndicatorType = "Status",
    Count         = 1,
    PinStyle      = "Output",
    UserPin       = true,
  })

  -- Text control (textbox / combo / list)
  -- The display type is defined in GetControlLayout()
  table.insert(ctrls, {
    Name        = "TextBox",
    ControlType = "Text",
    Count       = 1,
    PinStyle    = "Both",
    UserPin     = true,
  })

  -- CODE PIN (external code injection at runtime)
  -- Enabled from the Properties panel with "Enable Code Pin".
  -- Allows connecting a Block Controller, Text Controller or other
  -- external component to send Lua code to the plugin at runtime.
  -- The external code runs AFTER the "if Controls then" block,
  -- not as a replacement. See full behavior notes at the end of this file.
  if props["Enable Code Pin"].Value then
    table.insert(ctrls, {
      Name        = "code",
      ControlType = "Text",
      Count       = 1,
      PinStyle    = "Input",
      UserPin     = true,
    })
  end

  return ctrls
end

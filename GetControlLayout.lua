-- ============================================================
-- CONTROL LAYOUT AND GRAPHICS (must return layout, graphics)
-- Defines the visual appearance of the plugin in Q-SYS Designer.
-- ============================================================
--[[
  =====================================================================
  FULL REFERENCE FOR GetControlLayout()
  =====================================================================

  STRUCTURE:
    layout["ControlName"] = { ... }          -> For controls defined in GetControls()
    table.insert(graphics, { Type=..., ... }) -> For unbound graphic elements

  IMPORTANT NOTES:
    - If Count > 1 in GetControls(), controls are named "Name 1", "Name 2", etc.
    - The "code" pin is typically assigned Style = "None" to hide it visually.
    - Q-SYS manages Z-Order automatically. If ZOrder is used on any element,
      it is recommended to use it on ALL elements to avoid unexpected behavior.

  -------------------------------------------------------------------
  COMMON PROPERTIES FOR ALL CONTROL LAYOUTS:
  +--------------+----------+-----------+---------------------------------------------------+
  | Position     | Table    | YES       | {x, y} in pixels from the top-left corner         |
  | Size         | Table    | YES       | {width, height} in pixels                         |
  | Style        | String   | YES       | "Fader" | "Knob" | "Button" | "Text" | "Meter"   |
  |              |          |           | "Led" | "ListBox" | "ComboBox" | "Media" | "None" |
  | PrettyName   | String   | No        | Alternate pin name. Use ~ for subfolders.         |
  | Color        | Table    | No        | {R, G, B} or {R, G, B, Alpha}  (0-255)            |
  | TextColor    | Table    | No        | {R, G, B} or {R, G, B, Alpha}  (0-255)            |
  | StrokeColor  | Table    | No        | {R, G, B} or {R, G, B, Alpha}  default: {0,0,0}   |
  | StrokeWidth  | Integer  | No        | Border thickness. Default: 1                      |
  | Font         | String   | No        | See available fonts table below                   |
  | FontSize     | Integer  | No        | Font size in points                               |
  | FontStyle    | String   | No        | Depends on font. See fonts table.                 |
  | IsBold       | Boolean  | No        | Equivalent to FontStyle = "Bold"                  |
  | HTextAlign   | String   | No        | "Left" | "Center" | "Right"   default: "Center"   |
  | VTextAlign   | String   | No        | "Top" | "Center" | "Bottom"   default: "Center"   |
  | IsReadOnly   | Boolean  | No        | Not editable at runtime. Useful for status.        |
  | Margin       | Integer  | No        | Control margin. Default: 0                        |
  | Padding      | Integer  | No        | Control padding. Default: 1                       |
  | ClassName    | String   | No        | Default CSS class name for UCI                    |
  | ZOrder       | Integer  | No        | Z-axis position. Range: -2147483648 to 2147483647 |
  +--------------+----------+-----------+---------------------------------------------------+

  -------------------------------------------------------------------
  EXCLUSIVE PROPERTIES: Button (Style = "Button")
  +------------------+---------+-----------+-------------------------------------------------+
  | ButtonStyle      | String  | YES       | "Toggle" | "Momentary" | "Trigger"             |
  |                  |         |           | "StateTrigger" | "On" | "Off" | "Custom"        |
  |                  |         |           | "On" and "Off" are equivalent to push-action    |
  |                  |         |           | "Custom" = String-type button (see below)       |
  | ButtonVisualStyle| String  | No        | "Flat" | "Gloss"   default: "Gloss"             |
  | Legend           | String  | No        | Text displayed on the button                    |
  | CornerRadius     | Integer | No        | Corner radius                                   |
  | Radius           | Integer | No        | Alias for CornerRadius                          |
  | CustomButtonUp   | String  | Cond.     | For ButtonStyle="Custom". Text in resting state.|
  | CustomButtonDown | String  | Cond.     | For ButtonStyle="Custom". Text in active state. |
  | OffColor         | Table   | No        | Color when OFF. Only if UnlinkOffColor = true    |
  | UnlinkOffColor   | Boolean | No        | Allows different colors for ON and OFF states   |
  | IconColor        | Table   | No        | {R, G, B, Alpha}. Icon color for the button     |
  | WordWrap         | Boolean | No        | Legend text word wrap                           |
  +------------------+---------+-----------+-------------------------------------------------+

  -------------------------------------------------------------------
  EXCLUSIVE PROPERTIES: Fader (Style = "Fader")
  +--------------+---------+-----------+------------------------------------------------------+
  | ShowTextbox  | Boolean | No        | Adds a text box showing the current value. Def: false |
  +--------------+---------+-----------+------------------------------------------------------+

  -------------------------------------------------------------------
  EXCLUSIVE PROPERTIES: Meter (Style = "Meter")
  +------------------+---------+-----------+-----------------------------------------------+
  | MeterStyle       | String  | YES       | "Level" | "Reduction" | "Gain" | "Standard"   |
  | BackgroundColor  | Table   | No        | {R, G, B, Alpha}. Meter background color       |
  | ShowTextbox      | Boolean | No        | Adds a text box showing the current value.     |
  |                  |         |           | Default: true                                  |
  | CornerRadius     | Integer | No        | Corner radius                                  |
  | Radius           | Integer | No        | Alias for CornerRadius                         |
  +------------------+---------+-----------+-----------------------------------------------+

  -------------------------------------------------------------------
  EXCLUSIVE PROPERTIES: Text (Style = "Text")
  +--------------+---------+-----------+--------------------------------------------------------+
  | TextBoxStyle | String  | No        | "Normal" | "Meter" | "NoBackground"  default: "Normal" |
  | WordWrap     | Boolean | No        | Text word wrap                                        |
  | CornerRadius | Integer | No        | Corner radius                                         |
  | Radius       | Integer | No        | Alias for CornerRadius                                |
  +--------------+---------+-----------+--------------------------------------------------------+

  -------------------------------------------------------------------
  EXCLUSIVE PROPERTIES: Led (Style = "Led")
  +------------------+---------+-----------+-----------------------------------------------+
  | OffColor         | Table   | No        | Color in OFF state. Only if UnlinkOffColor = true|
  | UnlinkOffColor   | Boolean | No        | Allows a different color for OFF state         |
  +------------------+---------+-----------+-----------------------------------------------+
  NOTE: CornerRadius is NOT officially documented for Led by QSC. It may work in
  practice but should not be relied upon as a supported property.

  -------------------------------------------------------------------
  EXCLUSIVE PROPERTIES: ComboBox (Style = "ComboBox")
  The control in GetControls() MUST be ControlType = "Text".
  Displays a dropdown list. Options are assigned at runtime via:
  Controls.ControlName.Choices = {"Option1","Option2"}
  +------------------+---------+-----------+-----------------------------------------------+
  | (no exclusive    |         |           | ComboBox has no exclusive layout properties.   |
  |  layout          |         |           | Options are set at runtime with               |
  |  properties)     |         |           | Controls.Name.Choices = {"A","B","C"}          |
  +------------------+---------+-----------+-----------------------------------------------+

  -------------------------------------------------------------------
  EXCLUSIVE PROPERTIES: ListBox (Style = "ListBox")
  The control in GetControls() MUST be ControlType = "Text".
  Displays a visible selection list (no dropdown).
  Options are also assigned at runtime with .Choices.
  +------------------+---------+-----------+-----------------------------------------------+
  | (no exclusive    |         |           | ListBox has no exclusive layout properties.    |
  |  layout          |         |           | Options are set at runtime with               |
  |  properties)     |         |           | Controls.Name.Choices = {"A","B","C"}          |
  +------------------+---------+-----------+-----------------------------------------------+

  -------------------------------------------------------------------
  AVAILABLE FONTS (Font + FontStyle):
  +--------------+-------------------------------------------------------------------------------+
  | Adamina      | Regular                                                                       |
  | Droid Sans   | Regular, Bold                                                                 |
  | Lato         | Light, Light Italic, Regular, Italic, Bold, Bold Italic, Black, Black Italic  |
  | Montserrat   | Thin, ExtraLight, Light, Regular, Medium, SemiBold, Bold, ExtraBold, Black    |
  |              | (+ Italic variants of each)                                                   |
  | Noto Serif   | Regular, Italic, Bold, BoldItalic                                             |
  | Open Sans    | Light, Light Italic, Regular, Italic, Semibold, Semibold Italic,              |
  |              | Bold, Bold Italic, Extrabold, Extrabold Italic                                |
  | Poppins      | Light, Regular, Medium, SemiBold, Bold                                        |
  | Roboto       | Thin, Light, Regular, Medium, Bold, Black (+ Italic variants)                 |
  | Roboto Mono  | Thin, Light, Regular, Medium, Bold (+ Italic variants)                        |
  | Roboto Slab  | Thin, Light, Regular, Bold                                                    |
  | Slabo 27px   | Regular                                                                       |
  +--------------+-------------------------------------------------------------------------------+

  -------------------------------------------------------------------
  GRAPHIC TYPES (table.insert into graphics):
  +-------------+--------------------------------------------------------------------------------+
  | "GroupBox"  | Grouping box. Properties: Text, Fill, StrokeColor, StrokeWidth,                |
  |             | CornerRadius, Color (text), Font, FontSize, FontStyle, IsBold, HTextAlign      |
  | "Label"     | Text label. Properties: Text, Color, Fill, Font, FontSize, FontStyle,          |
  |             | IsBold, HTextAlign, VTextAlign, StrokeWidth, StrokeColor, CornerRadius,        |
  |             | Margin, Padding                                                                |
  | "Header"    | Header line. Properties: Text, Color, Font, FontSize,                          |
  |             | FontStyle, IsBold, HTextAlign                                                  |
  | "Image"     | JPG/PNG image (no SVG). Property: Image = "base64string"                       |
  | "Svg"       | SVG image. Property: Image = "base64string"                                     |
  +-------------+--------------------------------------------------------------------------------+

  NOTE: The "Text" type does NOT exist as a graphic element. Use "Label" instead.
  =====================================================================
]]--
function GetControlLayout(props)
  local layout   = {}
  local graphics = {}

  -- Rebuild the complete page list using the helper function.
  -- This is REQUIRED when using dynamic/conditional pages, because
  -- the global PageNames only contains the base pages. Any pages added
  -- conditionally via BuildPageNames() must be visible here too so that
  -- the currentPage comparison below works correctly for all pages.
  -- If no dynamic pages are used, this still works correctly because
  -- BuildPageNames() always returns at least the base pages.
  local allPages   = BuildPageNames(props)

  -- Resolve the current page name from the numeric page_index property.
  -- props["page_index"].Value is a 1-based integer set by Q-SYS Designer
  -- to indicate which page tab the user is currently viewing.
  -- We use it to index into allPages so we get the correct page name string.
  local currentPage = allPages[props["page_index"].Value]

  -- "code" control (always hidden visually, Style = "None")
  -- Only added if the "Enable Code Pin" property is active.
  if props["Enable Code Pin"].Value then
    layout["code"] = {
      PrettyName = "Code",
      Style      = "None",
      Position   = { 0, 0 },
      Size       = { 5, 5 },
    }
  end

  -- ======================================================
  -- PAGE: Control
  -- ======================================================
  if currentPage == "Control" then

    -- Background (GroupBox as plugin background)
    table.insert(graphics, {
      Type        = "GroupBox",
      Text        = "",             -- No title text
      Fill        = Colors.Background,
      StrokeColor = Colors.Background,
      StrokeWidth = 1,
      CornerRadius = 0,
      Position    = { 0, 0 },
      Size        = { 400, 500 },
    })

    -- Section header
    table.insert(graphics, {
      Type       = "Header",
      Text       = "AUDIO CONTROL",
      Color      = Colors.Text,
      Font       = "Montserrat",
      FontStyle  = "SemiBold",
      FontSize   = 11,
      HTextAlign = "Left",
      Position   = { 5, 5 },
      Size       = { 390, 18 },
    })

    -- Static label
    table.insert(graphics, {
      Type       = "Label",
      Text       = "Gain:",
      Color      = Colors.Text,
      Font       = "Roboto",
      FontStyle  = "Regular",
      FontSize   = 10,
      HTextAlign = "Right",
      VTextAlign = "Center",
      Fill       = { 0, 0, 0, 0 }, -- Transparent
      StrokeWidth= 0,
      Position   = { 5, 35 },
      Size       = { 90, 16 },
    })

    -- GroupBox with visible border
    table.insert(graphics, {
      Type        = "GroupBox",
      Text        = "Buttons",
      Color       = Colors.Text,
      Fill        = Colors.Group,
      StrokeColor = Colors.Accent,
      StrokeWidth = 1,
      CornerRadius = 4,
      Font        = "Roboto",
      FontStyle   = "Regular",
      FontSize    = 9,
      HTextAlign  = "Left",
      Position    = { 5, 60 },
      Size        = { 390, 80 },
    })

    -- Momentary button
    layout["SendButton"] = {
      PrettyName        = "Actions~Send Command",
      Style             = "Button",
      ButtonStyle       = "Momentary",
      ButtonVisualStyle = "Flat",
      Legend            = "SEND",
      Color             = Colors.Accent,
      TextColor         = Colors.Text,
      Font              = "Roboto",
      FontStyle         = "Bold",
      FontSize          = 10,
      CornerRadius      = 3,
      Position          = { 10, 75 },
      Size              = { 80, 30 },
    }

    -- Toggle button with different ON/OFF colors
    layout["MuteButton"] = {
      PrettyName      = "Actions~Mute",
      Style           = "Button",
      ButtonStyle     = "Toggle",
      Legend          = "MUTE",
      Color           = Colors.Alert,      -- Color when ON
      OffColor        = { 60, 60, 60 },    -- Color when OFF
      UnlinkOffColor  = true,              -- Enables separate ON/OFF colors
      TextColor       = Colors.Text,
      CornerRadius    = 3,
      Position        = { 100, 75 },
      Size            = { 80, 30 },
    }

    -- Trigger button
    layout["ResetButton"] = {
      PrettyName  = "Actions~Reset",
      Style       = "Button",
      ButtonStyle = "Trigger",
      Legend      = "RESET",
      Color       = { 150, 0, 0 },
      TextColor   = Colors.Text,
      Position    = { 190, 75 },
      Size        = { 80, 30 },
    }

    -- Custom button (custom ON/OFF text)
    layout["SourceSelector"] = {
      PrettyName        = "Actions~Source Selector",
      Style             = "Button",
      ButtonStyle       = "Custom",
      CustomButtonUp    = "SOURCE A",     -- Text in resting state (OFF)
      CustomButtonDown  = "SOURCE B",     -- Text in active state (ON)
      Color             = Colors.Green,
      OffColor          = { 80, 80, 80 },
      UnlinkOffColor    = true,
      CornerRadius      = 3,
      Position          = { 280, 75 },
      Size              = { 80, 30 },
    }

    -- Fader (slider control)
    layout["InputGain"] = {
      PrettyName  = "Audio~Input Gain",
      Style       = "Fader",
      ShowTextbox = true,           -- Shows the numeric value next to the fader
      Color       = Colors.Accent,
      Position    = { 10, 170 },
      Size        = { 20, 120 },
    }

    -- Knob (rotary control)
    layout["Frequency"] = {
      PrettyName = "Audio~Frequency",
      Style      = "Knob",
      Color      = Colors.Accent,
      Position   = { 50, 175 },
      Size       = { 50, 50 },
    }

    -- Level meter
    layout["LevelMeter"] = {
      PrettyName       = "Audio~Signal Level",
      Style            = "Meter",
      MeterStyle       = "Level",    -- "Level" | "Reduction" | "Gain" | "Standard"
      BackgroundColor  = { 20, 20, 20 },
      ShowTextbox      = false,
      CornerRadius     = 2,
      Position         = { 120, 170 },
      Size             = { 20, 120 },
    }

    -- LED indicator array ("StatusLed 1" .. "StatusLed 4")
    for i = 1, 4 do
      layout["StatusLed " .. i] = {
        PrettyName     = "Status~LED " .. i,
        Style          = "Led",
        Color          = Colors.Green,
        OffColor       = Colors.Off,
        UnlinkOffColor = true,
        Position       = { 160 + (i - 1) * 20, 175 },
        Size           = { 16, 16 },
      }
    end

    -- Read-only text indicator
    layout["StatusText"] = {
      PrettyName   = "Status~Status Text",
      Style        = "Text",
      IsReadOnly   = true,
      TextBoxStyle = "NoBackground",  -- "Normal" | "Meter" | "NoBackground"
      TextColor    = Colors.Text,
      Font         = "Roboto Mono",
      FontStyle    = "Regular",
      FontSize     = 9,
      HTextAlign   = "Left",
      VTextAlign   = "Center",
      Position     = { 200, 175 },
      Size         = { 185, 16 },
    }

    -- System status indicator
    layout["ConnectionStatus"] = {
      PrettyName = "Status~Connection",
      Style      = "Led",
      Position   = { 200, 200 },
      Size       = { 16, 16 },
    }

    -- Editable text box
    layout["TextBox"] = {
      PrettyName   = "Data~Editable Text",
      Style        = "Text",
      IsReadOnly   = false,
      TextBoxStyle = "Normal",
      Font         = "Roboto",
      FontStyle    = "Regular",
      FontSize     = 10,
      HTextAlign   = "Left",
      VTextAlign   = "Center",
      Position     = { 200, 225 },
      Size         = { 185, 20 },
    }

    -- ComboBox (dropdown list)
    -- REQUIRED: the control in GetControls() must be ControlType = "Text"
    -- Options are assigned at runtime with Controls.Name.Choices
    layout["TextBox"] = {
      PrettyName = "Data~ComboBox",
      Style      = "ComboBox",       -- Dropdown list
      Position   = { 200, 250 },
      Size       = { 185, 20 },
    }

    -- ListBox (visible list without dropdown)
    -- Also requires ControlType = "Text" in GetControls()
    -- layout["TextBox"] = {
    --   PrettyName = "Data~ListBox",
    --   Style      = "ListBox",
    --   Position   = { 200, 280 },
    --   Size       = { 185, 60 },   -- Taller height to show multiple options
    -- }

    -- Percentage knob
    layout["Percentage"] = {
      PrettyName = "Audio~Percentage",
      Style      = "Knob",
      Color      = Colors.Accent,
      Position   = { 230, 175 },
      Size       = { 50, 50 },
    }

    -- Pan knob
    layout["Pan"] = {
      PrettyName = "Audio~Pan",
      Style      = "Knob",
      Color      = { 200, 180, 0 },
      Position   = { 290, 175 },
      Size       = { 50, 50 },
    }

    -- Delay time knob
    layout["DelayTime"] = {
      PrettyName = "Audio~Delay Time (s)",
      Style      = "Knob",
      Color      = { 0, 180, 150 },
      Position   = { 350, 175 },
      Size       = { 40, 40 },
    }

  -- ======================================================
  -- PAGE: Setup
  -- ======================================================
  elseif currentPage == "Setup" then

    -- Setup page background
    table.insert(graphics, {
      Type        = "GroupBox",
      Text        = "",
      Fill        = Colors.Background,
      StrokeColor = Colors.Background,
      StrokeWidth = 0,
      Position    = { 0, 0 },
      Size        = { 400, 500 },
    })

    table.insert(graphics, {
      Type       = "Header",
      Text       = "CONFIGURATION",
      Color      = Colors.Text,
      Font       = "Montserrat",
      FontStyle  = "SemiBold",
      FontSize   = 11,
      HTextAlign = "Left",
      Position   = { 5, 5 },
      Size       = { 390, 18 },
    })

    -- Controls from the Control page are not shown here.
    -- Add setup-specific controls below as needed.

    -- Embedded PNG/JPG image
    -- Only rendered if ImageLogo contains a valid base64 string.
    if ImageLogo ~= "" then
      table.insert(graphics, {
        Type     = "Image",        -- For PNG, JPG, JPEG
        Image    = ImageLogo,      -- Pure base64 string (no data:... prefix)
        Position = { 5, 30 },
        Size     = { 100, 30 },    -- Adjust to the actual image size
        -- ZOrder = -1,            -- Optional: place behind controls
      })
    end

    -- Embedded SVG image
    -- SVG scales without quality loss: ideal for logos and icons.
    if ImageSVG ~= "" then
      table.insert(graphics, {
        Type     = "Svg",          -- Exclusively for SVG (not PNG/JPG)
        Image    = ImageSVG,       -- SVG base64 string
        Position = { 5, 70 },
        Size     = { 40, 40 },
      })
    end

  end -- end if currentPage

  return layout, graphics
end

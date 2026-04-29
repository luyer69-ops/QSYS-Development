-- ============================================================
-- AUDIO / SERIAL PINS (optional)
-- Adds pins to the plugin block that are NOT linked to controls.
-- For control-linked pins, define PinStyle inside GetControls().
-- NOTE: Only audio or serial pins can be added with this function.
-- ============================================================
--[[ FULL PIN REFERENCE:
  Name       String   REQUIRED   Pin name
  Direction  String   REQUIRED   "input" | "output"
  Domain     String   Optional   Pin type. Default is audio.
                                  Use "serial" for serial pins (RS-232/RS-485)
]]--
function GetPins(props)
  local pins = {}

  -- Audio input pin
  table.insert(pins, {
    Name      = "Audio Input",
    Direction = "input",
  })

  -- Audio output pin
  table.insert(pins, {
    Name      = "Audio Output",
    Direction = "output",
  })

  -- Serial communication pin
  table.insert(pins, {
    Name      = "Serial Port",
    Direction = "output",
    Domain    = "serial",
  })

  return pins
end

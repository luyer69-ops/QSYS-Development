-- ============================================================
-- INTERNAL WIRING (optional)
-- Connects plugin pins to embedded component pins.
-- Each entry is a table: { source, destination1, destination2, ... }
-- RESTRICTIONS:
--   - A plugin input pin can connect to multiple component input pins
--   - A component input pin can only receive from ONE plugin input pin
--   - A component output pin can connect to multiple plugin output pins
--   - A plugin output pin can only receive from ONE component output pin
-- ============================================================
function GetWiring(props)
  local wiring = {}

  -- Plugin input pin -> Mixer input
  table.insert(wiring, { "Audio Input", "main_mixer Input 1" })

  -- Mixer output -> Plugin output pin
  table.insert(wiring, { "main_mixer Output 1", "Audio Output" })

  -- Fan-out: one source pin to multiple destinations in a single entry
  -- table.insert(wiring, { "Audio Output", "main_mixer Output 1", "main_mixer Output 2" })

  return wiring
end

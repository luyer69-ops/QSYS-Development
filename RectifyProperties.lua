-- ============================================================
-- RECTIFY PROPERTIES (optional)
-- Runs every time the user changes a property.
-- Allows conditionally showing or hiding other properties.
-- ============================================================
--[[ REFERENCE:
  props["Name"].IsHidden = true | false  -> Show/hide property
  props["Name"].Value                    -> Read current value
  Always return props at the end.
]]--
function RectifyProperties(props)
  -- The "Enable Code Pin" property does not require hiding anything here.
  -- RectifyProperties is the point where Q-SYS Designer reloads
  -- GetControls() and GetControlLayout() when a change is detected.
  -- It is sufficient for the value to be in props for both functions
  -- to read it on their next call.

  -- Hide "Debug Print" if debug is disabled
  if props["Debug Print"] ~= nil then
    props["Debug Print"].IsHidden = false
  end
  -- Hide "IP Address" if Show Setup is false
  if props["Show Setup"] ~= nil then
    props["IP Address"].IsHidden = not props["Show Setup"].Value
  end
  return props
end

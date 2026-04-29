-- ============================================================
-- USER-CONFIGURABLE PROPERTIES (must return a table)
-- Appear in the Properties panel of Q-SYS Designer before running.
-- ============================================================
--[[ FULL PROPERTY REFERENCE:
  Fields per property:
    Name        String   REQUIRED   Name shown in the Properties panel
    Type        String   REQUIRED   Data type. Options:
                                     "string"  -> Free text string
                                     "integer" -> Integer number (requires Min and Max)
                                     "double"  -> Double-precision float (requires Min and Max)
                                     "boolean" -> ComboBox "Yes"/"No". Returns true/false at runtime
                                     "enum"    -> ComboBox of strings defined in Choices
    Value       Varies   REQUIRED   Default value (type depends on Type)
    Choices     Table    Optional   For "enum" only. List of strings. e.g. {"A","B","C"}
                                   To leave blank by default, add "" as the first item.
    Min         Number   Optional   Lower bound (integer / double)
    Max         Number   Optional   Upper bound (integer / double)
    Header      String   Optional   Section header label (requires QDS 9.10+)
    Comment     String   Optional   Comment shown below the property (requires QDS 9.10+)
    Description String   Optional   Brief description of the property
    IsHidden    Boolean  Optional   Show/hide the property in RectifyProperties()
]]--
function GetProperties()
  local props = {}

  -- CODE PIN: enabled/disabled by the user in the Properties panel
  -- At runtime, props["Enable Code Pin"].Value returns true or false.
  -- When changed, RectifyProperties() triggers a reload of GetControls()
  -- and GetControlLayout(), which read this value to include or exclude
  -- the "code" control.
  table.insert(props, {
    Name  = "Enable Code Pin",
    Type  = "boolean",
    Value = false,
  })

  -- Enum property (dropdown list)
  table.insert(props, {
    Name    = "Debug Print",
    Type    = "enum",
    Choices = { "None", "Tx/Rx", "Tx", "Rx", "Function Calls", "All" },
    Value   = "None"
  })

  -- Integer property (integer number with range)
  table.insert(props, {
    Name  = "Channel Count",
    Type  = "integer",
    Min   = 1,
    Max   = 32,
    Value = 8
  })

  -- Double property (floating point with range)
  table.insert(props, {
    Name  = "Reference Level",
    Type  = "double",
    Min   = -20.0,
    Max   = 20.0,
    Value = 0.0
  })

  -- Boolean property (Yes/No)
  table.insert(props, {
    Name  = "Show Setup",
    Type  = "boolean",
    Value = true
  })

  -- String property (free text)
  table.insert(props, {
    Name  = "IP Address",
    Type  = "string",
    Value = "192.168.1.100"
  })

  return props
end

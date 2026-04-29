-- ============================================================
-- PLUGIN INFO BLOCK (required)
-- ============================================================
--[[ FULL REFERENCE FOR PluginInfo:
  Name         String   REQUIRED   Name shown in the Schematic Library.
                                   Use ~ for subfolders: "Folder~SubFolder~Name"
  Version      String   REQUIRED   Visible version string. A change allows users to upgrade.
  Id           String   REQUIRED   Unique plugin identifier. Must not conflict with other
                                   installed plugins. Generate at: guidgenerator.com
                                   Can be a standard GUID or any unique string.
  BuildVersion String   Optional   Internal code iteration tracking (e.g. "1.0.0.4")
  Author       String   Optional   Author name or contact info
  Description  String   Optional   Brief description. Shown when a version mismatch occurs.
  Manufacturer String   Optional   Manufacturer of the integrated device
  Model        String   Optional   Model name of the integrated device
  IsManaged    Boolean  Optional   If true, adds plugin to the design managed inventory
  ShowDebug    Boolean  Optional   If true, shows the Lua debug window in the UI
  Type         Reflect  Optional   Reflect reporting type (advanced use)
]]--
PluginInfo = {
  Name         = "My~Plugin",
  Version      = "1.0",
  BuildVersion = "1.0.0.0",
  Id           = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  Author       = "Your_Company",
  Description  = "Plugin description. Shown when a version mismatch occurs.",
  Manufacturer = "Manufacturer_Name",
  Model        = "Model_Name",
  IsManaged    = false,
}

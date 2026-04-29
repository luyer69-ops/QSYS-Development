-- ============================================================
-- PAGE NAME HELPER FUNCTION
-- ============================================================
-- PURPOSE:
--   Builds and returns the COMPLETE list of page names on every call,
--   starting always from an empty table to avoid accumulation of
--   duplicates across multiple calls from Q-SYS Designer.
--
-- WHY A HELPER FUNCTION IS NEEDED:
--   Q-SYS Designer calls GetPages(), GetControls() and GetControlLayout()
--   independently and multiple times. A global array like PageNames appears
--   to be accessible from all functions, but any modification made inside
--   GetPages() does NOT carry over to GetControls() or GetControlLayout().
--   The only safe way to share a dynamic page list across all three functions
--   is to use a helper that rebuilds it from scratch every time it is called.
--   Source: q-syshelp.qsc.com -> Reserved Functions -> GetPages()
--
-- HOW TO USE:
--   Call BuildPageNames(props) at the start of GetPages(), GetControls()
--   and GetControlLayout() to get the current complete page list.
--   Use the returned table as the authoritative page name source in each
--   function -- do NOT rely on the global PageNames for dynamic pages.
--
-- HOW TO ADD CONDITIONAL PAGES:
--   Add a boolean Property (e.g. "Show Advanced Page") in GetProperties().
--   Then add a condition block here reading that property's value.
--   The page will appear or disappear in the Designer UI automatically
--   when the user toggles the property via RectifyProperties().
--
-- IMPORTANT: Always define the base (always-visible) pages first.
--   Dynamic pages are appended after the base pages so the page_index
--   values remain stable for the base pages regardless of dynamic state.
-- ============================================================
function BuildPageNames(props)
  -- Start with a fresh local table on every call.
  local pages = { "Control", "Setup" }  -- base pages: always present
  -- Example: conditionally add "Advanced Page" based on a boolean Property.
  -- The Property "Show Advanced Page" must be defined in GetProperties().
  -- Uncomment and adapt the block below to add conditional pages:
  -- if props["Show Advanced Page"].Value then
  --   table.insert(pages, "Advanced")  -- appended after base pages
  -- end
  return pages
end


-- ============================================================
-- PLUGIN PAGES (optional)
-- Allows splitting the UI into tabs. Each entry requires { name = "..." }
-- ============================================================
function GetPages(props)
  -- Rebuild the complete page list from scratch using the helper.
  -- This ensures that any conditional pages based on properties are
  -- included, and that the list is always consistent with what
  -- GetControls() and GetControlLayout() will also see.
  local allPages = BuildPageNames(props)

  -- Convert the plain string array into the table format required
  local pages = {}
  for _, name in ipairs(allPages) do
    table.insert(pages, { name = name })  -- { name = "Control" }, etc.
  end

  return pages  -- Q-SYS uses this to render the tab bar in the plugin UI
end

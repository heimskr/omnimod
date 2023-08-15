local orig_init = init

function init(...)
	heimskr_dryDoors = {
		config = root.assetJson("/configs/heimskr_dryDoors.config")
	}

	return orig_init and orig_init(...)
end

function setupMaterialSpaces()
  local hasInput = object.isInputNodeConnected(0)
  self.openMaterialSpaces = config.getParameter("openMaterialSpaces")

  if not self.openMaterialSpaces then
    self.openMaterialSpaces = {}
	--added a material switcher for doors that are anything but watertight or fully transparent
	--added a global default material switcher so as to not hardcode my workarounds
    local metamaterial = config.getParameter("openMaterial", heimskr_dryDoors.config.defaultDoor or "metamaterial:door")
    -- if hasInput then
    --   metamaterial = config.getParameter("lockedMaterial", heimskr_dryDoors.config.defaultLockedDoor or "metamaterial:lockedDoor")
    -- end
    for i, space in ipairs(object.spaces()) do
      table.insert(self.openMaterialSpaces, {space, metamaterial})
    end
  else
    -- --adding a seperate materials list for locked doors so that partly leaky doors don't break NPC pathfinding
	-- if hasInput then
    --   self.closedMaterialSpaces = config.getParameter("lockedMaterialSpaces", self.closedMaterialSpaces)
    -- end
  end
  sb.logWarn("self.openMaterialSpaces: %s", self.openMaterialSpaces)
  self.closedMaterialSpaces = config.getParameter("closedMaterialSpaces", {})
  self.lockedMaterialSpaces = config.getParameter("lockedMaterialSpaces", {})
end

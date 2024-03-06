local orig_init = init

-- allow me to add vectors together
function offsetPos(pos,off)
  return {pos[1]+off[1] , pos[2]+off[2]}
end

function drain()
  for i,offset in pairs(self.offsets) do
    local drainOffset = offsetPos(self.drainPos,offset)
      if world.liquidAt(drainOffset)then
        world.forceDestroyLiquid(drainOffset)
      end
  end
end

function init(...)
  self.drainPos = object.position()
  self.offsets = {{0,0}, {0,1}, {0,2}, {0,3}, {0,4}}
  drain()
  
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
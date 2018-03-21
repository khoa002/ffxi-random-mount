_addon.name = 'RandomMount'
_addon.author  = 'Xurion of Bismarck'
_addon.version = '2.0.0'
_addon.commands = {'rm'}

resources = require('resources')

RandomMount = {

  owned_kis = {},

  owned_mounts = {},

  get_mount_kis_from_resources = function ()
    local mount_kis = {}
      for _, ki in pairs(resources.key_items) do
        if ki.category == "Mounts" then
          table.insert(mount_kis, ki.en)
        end
      end

      return mount_kis
  end
}

-- Returns all mounts owned by the player
--function get_owned_mounts()
--  if table.getn(owned_mounts) == 0 then
--    for _, ki_id in pairs(owned_kis) do --cycle over all KIs owned
--      for _, mount_ki in pairs(get_mount_kis_from_resources()) do
--        if mount_ki ~= "trainer's whistle" then --don't care about the quest KI
--          if res.key_items[ki_id].en == mount_ki then
--            for _, mount in pairs(res.mounts) do
--              if string.find(string.lower(mount_ki), '♪' .. string.lower(mount.en)) ~= nil then
--                table.insert(owned_mounts, mount)
--              end
--            end
--          end
--        end
--      end
--    end
--  end

--  return owned_mounts
--end

-- Check on each tick of game time to see if there are KIs loaded or new ones obtained
windower.register_event('time change', function()
  local ki_check = windower.ffxi.get_key_items()
  if #ki_check > #RandomMount.owned_kis then
    RandomMount.owned_kis = ki_check
  end
end)

-- Generate random numbers based on the OS time
--math.randomseed(os.time())

-- When player uses //rm
--windower.register_event('addon command', function()
--  local player = windower.ffxi.get_player()
--  local was_mounted = false

  -- If the player is mounted, dismount now
--  for _, buff in pairs(player.buffs) do
--    if buff == 252 then --mounted buff
--      windower.send_command('input /dismount')
--      was_mounted = true
--    end
--  end

  -- If the player was not mounted, attempt to select a random mount
--  if was_mounted == false then
--    local mounts = get_owned_mounts()
--
    -- If no KIs are found, use the raptor as a fallback. Player may have just logged in and KIs are still loading.
--    if table.getn(mounts) == 0 then
--      windower.add_to_chat(4, 'Unable to find mounts. Using raptor mount instead.')
--      windower.add_to_chat(4, 'Maybe key items have not loaded yet.')
--      windower.send_command('input /mount raptor')
--      return
--    end

    -- Generate random number and use it to choose a mount
--    local mount_index = math.ceil(math.random() * table.getn(mounts))
--    windower.send_command('input /mount ' .. mounts[mount_index].en)
--  end
--end)

return RandomMount
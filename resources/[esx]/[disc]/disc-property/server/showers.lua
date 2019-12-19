RegisterServerEvent('disc-property:sync')
AddEventHandler('disc-property:sync', function(player, sync, x, y, z)
	if sync == 'flugor' then
		TriggerClientEvent('disc-property:syncFlugor', -1, player)
	elseif sync == 'vatten' then
		TriggerClientEvent('disc-property:syncWater', -1, player, x, y, z)
	elseif sync == 'spya' then
		TriggerClientEvent('disc-property:syncSpya', -1, player)
	end
end)

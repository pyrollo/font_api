--[[
	font_api mod for Minetest - Library to create textures with fonts and text
	(c) Pierre-Yves Rollo

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
--]]

-- Deprecation

function deprecated_global_table(deprecated_global_name, replacement_global_name)
	assert(type(deprecated_global_name) == 'string', "deprecated_global_name should be a string.")
	assert(type(replacement_global_name) == 'string', "replacement_global_name should be a string.")
	assert(deprecated_global_name ~= '', "deprecated_global_name should not be empty.")
	assert(replacement_global_name ~= '', "replacement_global_name should not be empty.")
	assert(rawget(_G, deprecated_global_name) == nil, "replacement global already exists.")
	if _G[replacement_global_name] == nil then
		print('warn_deprecated_functions: Warning, replacement global "'..replacement_global_name..'" does not exists.')
		return
	end
	local meta = {
		deprecated = deprecated_global_name,
		replacement = replacement_global_name,
		__index = function(table, key)
			local meta = getmetatable(table)
			local dbg = debug.getinfo(2, "lS")
			minetest.log("warning", string.format('Warning: Accessing deprecated "%s" table, "%s" should be used instead (%s:%d).',
				meta.deprecated, meta.replacement, (dbg.short_src or 'unknown'), (dbg.currentline or 0)))
			return _G[meta.replacement][key]
		end,
		__newindex = function(table, key, value)
			local meta = getmetatable(table)
			local dbg = debug.getinfo(2, "lS")
			minetest.log("warning", string.format('Warning: Accessing deprecated "%s" table, "%s" should be used instead (%s:%d).',
				meta.deprecated, meta.replacement, (dbg.short_src or 'unknown'), (dbg.currentline or 0)))
			_G[meta.replacement][key]=value
		end,
	}
	rawset(_G, deprecated_global_name, {})
	setmetatable(_G[deprecated_global_name], meta)
end

-- deprecated(2) -- December 2018 - Deprecation of font_lib
deprecated_global_table('font_lib', 'font_api')

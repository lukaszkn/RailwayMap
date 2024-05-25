--------
-- Alter these lines to control which languages are written for place/streetnames
--
-- Preferred language can be (for example) "en" for English, "de" for German, or nil to use OSM's name tag:
preferred_language = nil
preferred_language_attribute = "name"
default_language_attribute = "name_int"
-- Also write these languages if they differ - for example, { "de", "fr" }
additional_languages = { }
--------


-- Nodes will only be processed if one of these keys is present

node_keys = { "railway", "subway" }

-- Assign nodes to a layer, and set attributes, based on OSM tags

function node_function(node)
	-- railway=tram_stop https://www.openstreetmap.org/node/2420200260
	-- railway=halt    Tryńcza   https://www.openstreetmap.org/node/3510214770
	-- railway=station Przeworsk https://www.openstreetmap.org/node/48311251
	-- railway=station station=subway Kabaty https://www.openstreetmap.org/node/3390283399
	-- railway=station or railway=halt, station=light_rail Westferry https://www.openstreetmap.org/node/7132098495
	
	local railway = Find("railway")
	if railway ~= "" then
		
		local station = Find("station")
		local name = Find("name")
		
		if railway == "tram_stop" then
			Layer("tram_stop", false)
			AttributeNumeric("nt", 2)
			SetNameAttributes()
			AttributeNumeric("sid", Id())
			
			if name ~= "" then
				Layer("tram_stop_name", false)
				AttributeNumeric("nt", 2)
				SetNameAttributes()
				AttributeNumeric("sid", Id())
			end
		elseif railway == "station" and station == "subway" then
			Layer("subway_station", false)
			AttributeNumeric("nt", 1)
			SetNameAttributes()
			AttributeNumeric("sid", Id())
			
			if name ~= "" then
				Layer("subway_station_name", false)
				AttributeNumeric("nt", 1)
				SetNameAttributes()
				AttributeNumeric("sid", Id())
			end
		elseif (railway == "station" or railway == "halt") and station == "light_rail" then
			Layer("light_railway_station", false)
			AttributeNumeric("nt", 3)
			SetNameAttributes()
			AttributeNumeric("sid", Id())
			
			if name ~= "" then
				Layer("light_railway_station_name", false)
				AttributeNumeric("nt", 3)
				SetNameAttributes()
				AttributeNumeric("sid", Id())
			end
		elseif (railway == "station" or railway == "halt") then
			Layer("railway_station", false)
			AttributeNumeric("nt", 0)
			SetNameAttributes()
			AttributeNumeric("sid", Id())
			
			if name ~= "" then
				Layer("railway_station_name", false)
				AttributeNumeric("nt", 0)
				SetNameAttributes()
				AttributeNumeric("sid", Id())
			end
		else
			return
		end
		
		-- Attribute("sid", Id())
		
	end
	
	-- POIs go to a "poi" layer (we just look for amenity and shop here)
	-- local amenity = Find("amenity")
	-- local shop = Find("shop")
	-- if amenity~="" or shop~="" then
	-- 	Layer("poi")
	-- 	if amenity~="" then Attribute("class",amenity)
	-- 	else Attribute("class",shop) end
	-- 	Attribute("name:latin", Find("name"))
	-- 	AttributeNumeric("rank", 3)
	-- end
	
	-- Places go to a "place" layer
	-- local place = Find("place")
	-- if place~="" then
	-- 	Layer("place")
	-- 	Attribute("class", place)
	-- 	Attribute("name:latin", Find("name"))
	-- 	if place=="city" then
	-- 		AttributeNumeric("rank", 4)
	-- 		MinZoom(3)
	-- 	elseif place=="town" then
	-- 		AttributeNumeric("rank", 6)
	-- 		MinZoom(6)
	-- 	else
	-- 		AttributeNumeric("rank", 9)
	-- 		MinZoom(10)
	-- 	end
	-- end

	-- Write 'mountain_peak' and 'water_name'
	-- local natural = Find("natural")
	-- if natural == "peak" or natural == "volcano" then
	-- 	Layer("mountain_peak", false)
	-- 	SetEleAttributes()
	-- 	AttributeNumeric("rank", 1)
	-- 	Attribute("class", natural)
	-- 	SetNameAttributes()
	-- 	return
	-- end
	-- if natural == "bay" then
	-- 	Layer("water_name", false)
	-- 	SetNameAttributes()
	-- 	return
	-- end

end


-- Assign ways to a layer, and set attributes, based on OSM tags

function way_function()
	-- railway=narrow_gauge https://www.openstreetmap.org/way/167839649
	-- railway=disused https://www.openstreetmap.org/way/25182390
	
	local railway = Find("railway")
	if railway ~= "" then
		local wikipedia = Find("wikipedia")
	
		if railway == "narrow_gauge" then
			Layer("narrow_gauge", false)
			AttributeNumeric("wt", 4)
			if wikipedia ~= "" then
				Attribute("wikipedia", wikipedia)
			end
		elseif railway == "disused" then
			Layer("disused", false)
			AttributeNumeric("wt", 5)
			if wikipedia ~= "" then
				Attribute("wikipedia", wikipedia)
			end
		else
			return
		end
	
		local network = Find("network")
		if network ~= "" then
			Attribute("network", network)
		end
	end
	
	
	-- local highway  = Find("highway")
	-- local waterway = Find("waterway")
	-- local building = Find("building")
	-- if Find("service")~="" then
		-- return
	-- end

	-- if Find("railway")=="rail" or Find("railway")=="narrow_gauge" then
	--	Layer("railway", false)
	-- end

	-- -- Roads
	-- if highway~="" then
	-- 	Layer("transportation", false)
	-- 	if highway=="unclassified" or highway=="residential" then highway="minor" end
	-- 	Attribute("class", highway)
	-- 	-- ...and road names
	-- 	local name = Find("name")
	-- 	if name~="" then
	-- 		Layer("transportation_name", false)
	-- 		Attribute("class", highway)
	-- 		Attribute("name:latin", name)
	-- 	end
	-- end

	-- -- Rivers
	-- if waterway=="stream" or waterway=="river" or waterway=="canal" then
	-- 	Layer("waterway", false)
	-- 	Attribute("class", waterway)
	-- 	AttributeNumeric("intermittent", 0)
	-- end

	-- -- Lakes and other water polygons
	-- if Find("natural")=="water" then
	-- 	Layer("water", true)
	-- 	if Find("water")=="river" then
	-- 		Attribute("class", "river")
	-- 	else
	-- 		Attribute("class", "lake")
	-- 	end
	-- end
	-- -- Buildings
	-- if building~="" then
	-- 	Layer("building", true)
	-- end
end

function relation_scan_function()
	if Find("type")=="route" then
		local route = Find("route") 
	
		if route=="tram" or Find("railway")=="narrow_gauge" or route=="railway" or route=="tracks" or route=="light_rail" or route=="subway" then
			Accept()
		end
	end
end

function relation_function()
	-- type=route route=tram https://www.openstreetmap.org/relation/175322
	-- type=route railway=narrow_gauge https://www.openstreetmap.org/relation/7648129
	
	-- type=route route=railway https://www.openstreetmap.org/relation/176889
	-- type=route route=tracks https://www.openstreetmap.org/relation/2884237
	
	-- type=route route=light_rail https://www.openstreetmap.org/relation/7772556
	-- type=route route=subway https://www.openstreetmap.org/relation/4236801

	-- if Find("type")=="route" and Find("route")=="hiking" then
	--   Layer("hiking_routes", false)
	--   Attribute("class", Find("network"))
	-- --   Attribute("ref", Find("ref"))
	-- end

	if Find("type")=="route" then
		local route = Find("route")
		local wikipedia = Find("wikipedia")
		
		if route=="tram" then
			Layer("tram", false)
			AttributeNumeric("rt", 2)
		elseif Find("railway") == "narrow_gauge" then
			Layer("narrow_gauge", false)
			AttributeNumeric("rt", 4)
			if wikipedia ~= "" then
				Attribute("wikipedia", wikipedia)
			end
		elseif route=="light_rail" then
			Layer("light_railway", false)
			AttributeNumeric("rt", 3)
			if wikipedia ~= "" then
				Attribute("wikipedia", wikipedia)
			end
		elseif route=="subway" then
			Layer("subway", false)
			AttributeNumeric("rt", 1)
		elseif route=="railway" or (route=="tracks" and Find("usage")=="main") then
			Layer("railway", false)
			AttributeNumeric("rt", 0)
		else
			return
		end
		
		SetNameAttributes()
		
		local network = Find("network")
		if network ~= "" then
			Attribute("network", network)
		end
		
		local colour = Find("colour")
		if colour ~= "" then
			Attribute("colour", colour)
		end
	
	end
end

-- Set name attributes on any object
function SetNameAttributes()
	local name = Find("name"), iname
	local main_written = name
	-- if we have a preferred language, then write that (if available), and additionally write the base name tag
	if preferred_language and Holds("name:"..preferred_language) then
		iname = Find("name:"..preferred_language)
		Attribute(preferred_language_attribute, iname)
		if iname~=name and default_language_attribute then
			Attribute(default_language_attribute, name)
		else main_written = iname end
	else
		Attribute(preferred_language_attribute, name)
	end
	-- then set any additional languages
	for i,lang in ipairs(additional_languages) do
		iname = Find("name:"..lang)
		if iname=="" then iname=name end
		if iname~=main_written then Attribute("name:"..lang, iname) end
	end
end

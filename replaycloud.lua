replaycloud = {}

local w = 180*scale
local h = 58*scale

local pos = 0
replaycloudtargetpos = 0

local speed = 1

function replaycloud.draw()
	local u = -(1-pos)*h
	
	love.graphics.push()
	love.graphics.translate(0, u)
	
    love.graphics.setColor(255, 255, 255)
    local l = width*16*scale-w
    love.graphics.rectangle("fill", l, 0, w, h)
	love.graphics.draw(ttqrimg, l, 0, 0, scale*2, scale*2)
    
    love.graphics.setColor(0, 0, 0)
    
    if #toUpload > 0 then
        properprint(" uploading..", l+60*scale, 12*scale)
    else
        properprint("  view your", l+60*scale, 12*scale)
        properprint("replay online", l+60*scale, 22*scale)
    end
		
    properprint(" " .. string.lower(ttlink), l+60*scale, 42*scale)
    
    love.graphics.setColor(255, 255, 255)
	love.graphics.pop()
end

function replaycloud.update(dt)
	if replaycloudtargetpos ~= pos then
		if replaycloudtargetpos > pos then
			pos = math.min(pos + speed*dt, replaycloudtargetpos)
		else
			pos = math.max(pos - speed*dt, replaycloudtargetpos)
		end
	end
end

function replaycloud.makeqr(text)
	local ok, qr = qrencode.qrcode(text)
	
	local safeZone = 4
	
	ttqrimgdata = love.image.newImageData(#qr[1]+safeZone*2, #qr+safeZone*2)

	for y = 1, #qr+safeZone*2 do
		for x = 1, #qr[1]+safeZone*2 do
			local c = 255

			if qr[x-safeZone] and qr[x-safeZone][y-safeZone] and qr[x-safeZone][y-safeZone] > 0 then
				c = 0
			end

			ttqrimgdata:setPixel((x-1), (y-1), c, c, c, 255)
		end
	end

	ttqrimg = love.graphics.newImage(ttqrimgdata)
end
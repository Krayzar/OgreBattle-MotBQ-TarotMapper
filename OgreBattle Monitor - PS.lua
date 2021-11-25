-- Set up montor --

displaytimers = true
displayleadername = true
displayinitialcard = false
displaycurrentcard = true



-- Set initial values --
ic1 = '_'
ic2 = '_'
ic3 = '_'
ic4 = '_'
ic5 = '_'
ic6 = '_'
ic7 = '_'

-- Translate Ogre Battle's Hex numbers to text for the leader name
function hextotext(hex)
  if hex == 0x30 then return '0'
  elseif hex == 0x31 then return '1'
  elseif hex == 0x32 then return '2'
  elseif hex == 0x33 then return '3'
  elseif hex == 0x34 then return '4'
  elseif hex == 0x35 then return '5'
  elseif hex == 0x36 then return '6'
  elseif hex == 0x37 then return '7'
  elseif hex == 0x38 then return '8'
  elseif hex == 0x39 then return '9'
  elseif hex == 0x41 then return 'A'
  elseif hex == 0x42 then return 'B'
  elseif hex == 0x43 then return 'C'
  elseif hex == 0x44 then return 'D'
  elseif hex == 0x45 then return 'E'
  elseif hex == 0x46 then return 'F'
  elseif hex == 0x47 then return 'G'
  elseif hex == 0x48 then return 'H'
  elseif hex == 0x49 then return 'I'
  elseif hex == 0x4A then return 'J'
  elseif hex == 0x4B then return 'K'
  elseif hex == 0x4C then return 'L'
  elseif hex == 0x4D then return 'M'
  elseif hex == 0x4E then return 'N'
  elseif hex == 0x4F then return 'O'
  elseif hex == 0x50 then return 'P'
  elseif hex == 0x51 then return 'Q'
  elseif hex == 0x52 then return 'R'
  elseif hex == 0x53 then return 'S'
  elseif hex == 0x54 then return 'T'
  elseif hex == 0x55 then return 'U'
  elseif hex == 0x56 then return 'V'
  elseif hex == 0x57 then return 'W'
  elseif hex == 0x58 then return 'X'
  elseif hex == 0x59 then return 'Y'
  elseif hex == 0x5A then return 'Z'
  elseif hex == 0x2F then return '/'
  elseif hex == 0x2D then return '-'
  elseif hex == 0x3D then return '='
  elseif hex == 0x21 then return '!'
  elseif hex == 0x3F then return '?'
  elseif hex == 0x26 then return '&'
  elseif hex == 0x2B then return '`'
  elseif hex == 0x25 then return '\''
  elseif hex == 0x2C then return ','
  elseif hex == 0x2E then return '.'
  elseif hex == 0x3A then return ':'
  elseif hex == 0x20 then return ' '
  else return '_'
  end
end

-- Translate Hex to tarot cards
function hextotarot(hex)
  if hex == 0x14 then return '00 - Fool'
  elseif hex == 0x00 then return '01 - Magician'
  elseif hex == 0x01 then return '02 - Priestess'
  elseif hex == 0x02 then return '03 - Empress'
  elseif hex == 0x03 then return '04 - Emperor'
  elseif hex == 0x04 then return '05 - Hierophant'
  elseif hex == 0x05 then return '06 - Lovers'
  elseif hex == 0x06 then return '07 - Chariot'
  elseif hex == 0x07 then return '08 - Strength'
  elseif hex == 0x08 then return '09 - Hermit'
  elseif hex == 0x09 then return '10 - Fortune'
  elseif hex == 0x0A then return '11 - Justice'
  elseif hex == 0x0B then return '12 - Hanged Man'
  elseif hex == 0x0C then return '13 - Death'
  elseif hex == 0x0D then return '14 - Temperance'
  elseif hex == 0x0E then return '15 - Devil'
  elseif hex == 0x0F then return '16 - Tower'
  elseif hex == 0x10 then return '17 - Star'
  elseif hex == 0x11 then return '18 - Moon'
  elseif hex == 0x12 then return '19 - Sun'
  elseif hex == 0x13 then return '20 - Judgement'
  elseif hex == 0x15 then return '21 - World'
  else return '_'
  end
end

--Set up and print stats
function stats()
  -- Cards
  c1 = hextotarot(memory.readbyte(0x1C6B84))
  c2 = hextotarot(memory.readbyte(0x1C6B85))
  c3 = hextotarot(memory.readbyte(0x1C6B86))
  c4 = hextotarot(memory.readbyte(0x1C6B87))
  c5 = hextotarot(memory.readbyte(0x1C6B88))
  c6 = hextotarot(memory.readbyte(0x1C6B89))
  c7 = hextotarot(memory.readbyte(0x1C6B8A))
  -- Cards raw hex
  c1hex = memory.readbyte(0x1C6B84)
  c2hex = memory.readbyte(0x1C6B85)
  c3hex = memory.readbyte(0x1C6B86)
  c4hex = memory.readbyte(0x1C6B87)
  c5hex = memory.readbyte(0x1C6B88)
  c6hex = memory.readbyte(0x1C6B89)
  c7hex = memory.readbyte(0x1C6B8A)
  -- Main Timer count
  t1 = memory.readbyte(0x13C8FC)
  -- Secondary timer count
  t2 = memory.readbyte(0x13C8FD)
  -- Leader Name
  leadername = hextotext(memory.readbyte(0x1C6C14)) .. hextotext(memory.readbyte(0x1C6C15)) .. hextotext(memory.readbyte(0x1C6C16)) .. hextotext(memory.readbyte(0x1C6C17)) .. hextotext(memory.readbyte(0x1C6C18)) .. hextotext(memory.readbyte(0x1C6C19)) .. hextotext(memory.readbyte(0x1C6C1A)) .. hextotext(memory.readbyte(0x1C6C1B))
  if displayleadername == true then gui.text(0, 30, leadername) end
  if displaytimers == true then
    gui.text(0, 45, 'T1: ' .. t1)
    gui.text(0, 60, 'T2: ' .. t2)
  end
  if displayinitialcard == true then
    gui.text(0, 220, 'IC1: ' .. ic1)
    gui.text(0, 235, 'IC2: ' .. ic2)
    gui.text(0, 250, 'IC3: ' .. ic3)
    gui.text(0, 265, 'IC4: ' .. ic4)
    gui.text(0, 280, 'IC5: ' .. ic5)
    gui.text(0, 295, 'IC6: ' .. ic6)
    gui.text(0, 310, 'IC7: ' .. ic7)
  end
  if displaycurrentcard == true then
    gui.text(0, 335, 'C1: ' .. c1)
    gui.text(0, 350, 'C2: ' .. c2)
    gui.text(0, 365, 'C3: ' .. c3)
    gui.text(0, 380, 'C4: ' .. c4)
    gui.text(0, 395, 'C5: ' .. c5)
    gui.text(0, 410, 'C6: ' .. c6)
    gui.text(0, 425, 'C7: ' .. c7)
  end
end

while true do
  stats()
	emu.frameadvance();
end

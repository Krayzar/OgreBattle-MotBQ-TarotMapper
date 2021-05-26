-- SCRIPT CONFIG START --

  -- Skip Quest logo - can be set to true or false
  skiplogo = true
  -- Test options include Male, Female
  setsex = 'Male'
  -- Name to test - END to finish imput, nil for all letters after END
  letter1 = '!'
  letter2 = 'END'
  letter3 = nil
  letter4 = nil
  letter5 = nil
  letter6 = nil
  letter7 = nil
  letter8 = nil
  -- Run script for one Timer 1 (t1) 256 frame cycle when set to true
  -- Can be set to a specific number of frames to test, or set to false as well
  runfor_t1cycle = false
  -- Run for the specified number of Timer 2 (t2) cycles
  -- Each t2 cycle contains 256 t1 frames to test
  -- Ignored if runfor_t1cycle = true
  runfor_t2cycles = 512
  -- delay starting until a specific real time frame cannot use other delays if this is set
  delaytilframe = false
  -- delay starting until a specific t1 frame
  delaytilt1frame = 254
  -- delay starting until a specific t2 frame
  delaytilt2frame = 5
  -- delay after completing each t1 loop for a set amount of frames - easier to record leader stats on video
  delayaftert1loop = 300
  -- Display initial Cards
  displayinitialcard = true
  -- Dispaly current Cards - slight performance hit, turn off if it's running slow
  displaycurrentcard = true
  -- Display Name - slight performance hit, turn off if it's running slow
  displayname = true
  -- Display t1 and t2 timers
  displaytimers = true
  -- Display framecount - generated from script
  displayframecount = false

-- SCRIPT CONFIG END --

-- Setting up and figuring out some variables
  -- Main Timer count
  t1 = memory.readbyte(0x51)
  -- Secondary timer count
  t2 = memory.readbyte(0x52)
  -- Cycle counters for main count loops
  if delaytilt1frame >= 0 then
    t1cyclecounter = delaytilt1frame
    totalt1cycles = delaytilt1frame
  elseif delaytilt1frame == false then
    t1cyclecounter = 0
    totalt1cycles = 0
  else
    t1cyclecounter = 0
  end
  if delaytilt2frame >= 1 then
    t2startoffset = delaytilt2frame
    t2cyclecounter = t2startoffset
  elseif delaytilt2frame == false then
    t2startoffset = 0
  else
    t2startoffset = 0
  end

  delaytilframefirstrun = true

  -- determine what t1 display says
  t1statuscount = 0
  if runfor_t1cycle == true then
    t1statuscount = 255
  elseif runfor_t1cycle == false then
    t1statuscount = 255
  else
    t1statuscount = runfor_t1cycle
  end

-- Main Functions
  -- set initial card values
  function setinitialcardvalues()
    ic1 = '_'
    ic2 = '_'
    ic3 = '_'
    ic4 = '_'
    ic5 = '_'
    ic6 = '_'
    ic7 = '_'
  end
  setinitialcardvalues()

  -- Logging to file
  function writetolog(texttowrite, leadername)
    --setup log file
    tarotlog = io.open("Tarotlog-" .. leadername .. ".csv", "a")
    tarotlog:write(texttowrite .. "\n")
    tarotlog:close()
  end

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
    elseif hex == 0x2B then return '+'
    elseif hex == 0x25 then return '%'
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

  -- Button variables - doesn't handle pressing multiples, FYI
  A = {A=true}
  B = {B=true}
  X = {X=true}
  Y = {Y=true}
  L = {L=true}
  R = {R=true}
  Up = {Up=true}
  Down = {Down=true}
  Left = {Left=true}
  Right = {Right=true}
  Start = {Start=true}
  Select = {Select=true}
  Reset = {Reset=true}

  -- Leader Name
  leadername = hextotext(memory.readbyte(0x7A4)) .. hextotext(memory.readbyte(0x7A5)) .. hextotext(memory.readbyte(0x7A6)) .. hextotext(memory.readbyte(0x7A7)) .. hextotext(memory.readbyte(0x7A8)) .. hextotext(memory.readbyte(0x7A9)) .. hextotext(memory.readbyte(0x7AA)) .. hextotext(memory.readbyte(0x7AB))

  -- Cards
  c1 = hextotarot(memory.readbyte(0xDBE))
  c2 = hextotarot(memory.readbyte(0xDBF))
  c3 = hextotarot(memory.readbyte(0xDC0))
  c4 = hextotarot(memory.readbyte(0xDC1))
  c5 = hextotarot(memory.readbyte(0xDC2))
  c6 = hextotarot(memory.readbyte(0xDC3))
  c7 = hextotarot(memory.readbyte(0xDC4))

  --Set up and print stats
  function stats()
    -- Cards
    c1 = hextotarot(memory.readbyte(0xDBE))
    c2 = hextotarot(memory.readbyte(0xDBF))
    c3 = hextotarot(memory.readbyte(0xDC0))
    c4 = hextotarot(memory.readbyte(0xDC1))
    c5 = hextotarot(memory.readbyte(0xDC2))
    c6 = hextotarot(memory.readbyte(0xDC3))
    c7 = hextotarot(memory.readbyte(0xDC4))
    -- Cards raw hex
    c1hex = memory.readbyte(0xDBE)
    c2hex = memory.readbyte(0xDBF)
    c3hex = memory.readbyte(0xDC0)
    c4hex = memory.readbyte(0xDC1)
    c5hex = memory.readbyte(0xDC2)
    c6hex = memory.readbyte(0xDC3)
    c7hex = memory.readbyte(0xDC4)
    -- Main Timer count
    t1 = memory.readbyte(0x51)
    -- Secondary timer count
    t2 = memory.readbyte(0x52)
    -- Leader Name
    leadername = hextotext(memory.readbyte(0x7A4)) .. hextotext(memory.readbyte(0x7A5)) .. hextotext(memory.readbyte(0x7A6)) .. hextotext(memory.readbyte(0x7A7)) .. hextotext(memory.readbyte(0x7A8)) .. hextotext(memory.readbyte(0x7A9)) .. hextotext(memory.readbyte(0x7AA)) .. hextotext(memory.readbyte(0x7AB))
    if displayname == true then gui.text(85, 0, 'N: ' .. leadername) end
    if displayframecount == true then gui.text(0, 30, emu.framecount()) end
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
    gui.text(480, 0, 'T1: ' .. t1cyclecounter .. '/' .. t1statuscount)
    gui.text(480, 15, 'T2: ' .. t2cyclecounter .. '/' .. runfor_t2cycles)
  end
  stats()

-- Round numbers
  function round(number)
    return number >= 0 and math.floor(number + 0.5) or math.ceil(number - 0.5)
  end

-- Round numbers down
    function rounddown(number)
      return number >= 0 and math.floor(number) or math.ceil(number)
    end

-- Press button for x frames
  function press(button, frames, player)
    for i=1, frames, 1 do
      joypad.set(button, player)
      stats()
      emu.frameadvance()
    end
  end

-- Do nothing for x frames
  function nopress(frames)
    for i=1, frames, 1 do
      stats()
      emu.frameadvance()
    end
  end

-- Alternate button presses, 1 frame press, 1 frame no press - 1 frame = 2
-- Stats is called so many times to prevent flicker
  function pressalt(button, frames, player)
    for i=1, frames, 1 do
      stats()
      press(button, 1, 1)
      stats()
      nopress(1)
      stats()
      emu.frameadvance()
    end
  end

  -- Reset console
  function resetconsole(frames)
    for i=1, frames, 1 do
      stats()
      joypad.set({Reset=true})
    end
  end

  -- Power on/off console
  function powerconsole(frames)
    for i=1, frames, 1 do
      stats()
      joypad.set({Power=true})
    end
  end

  -- Letter setter function - it was a pain to write, but it works
  function setletter(letter)
    if letter == '0' then
      press(A, 1, 1)
    elseif letter == '1' then
      pressalt(Right, 1, 1)
      pressalt(A, 1, 1)
      pressalt(Left, 1, 1)
    elseif letter == '2' then
      pressalt(Right, 2, 1)
      pressalt(A, 1, 1)
      pressalt(Left, 2, 1)
    elseif letter == '3' then
      pressalt(Right, 3, 1)
      pressalt(A, 1, 1)
      pressalt(Left, 3, 1)
    elseif letter == '4' then
      pressalt(Right, 4, 1)
      pressalt(A, 1, 1)
      pressalt(Left, 4, 1)
    elseif letter == '5' then
      pressalt(Right, 5, 1)
      pressalt(A, 1, 1)
      pressalt(Left, 5, 1)
    elseif letter == '6' then
      pressalt(Left, 4, 1)
      pressalt(A, 1, 1)
      pressalt(Right, 4, 1)
    elseif letter == '7' then
      pressalt(Left, 3, 1)
      pressalt(A, 1, 1)
      pressalt(Right, 3, 1)
    elseif letter == '8' then
      pressalt(Left, 2, 1)
      pressalt(A, 1, 1)
      pressalt(Right, 2, 1)
    elseif letter == '9' then
      pressalt(Left, 2, 1)
      pressalt(A, 1, 1)
      pressalt(Right, 2, 1)
    elseif letter == 'A' then
      pressalt(Down, 1, 1)
      pressalt(A, 1, 1)
      pressalt(Up, 1, 1)
    elseif letter == 'B' then
      pressalt(Down, 1, 1)
      pressalt(Right, 1, 1)
      pressalt(A, 1, 1)
      pressalt(Left, 1, 1)
      pressalt(Up, 1, 1)
    elseif letter == 'C' then
      pressalt(Down, 1, 1)
      pressalt(Right, 2, 1)
      pressalt(A, 1, 1)
      pressalt(Left, 2, 1)
      pressalt(Up, 1, 1)
    elseif letter == 'D' then
      pressalt(Down, 1, 1)
      pressalt(Right, 3, 1)
      pressalt(A, 1, 1)
      pressalt(Left, 3, 1)
      pressalt(Up, 1, 1)
    elseif letter == 'E' then
      pressalt(Down, 1, 1)
      pressalt(Right, 4, 1)
      pressalt(A, 1, 1)
      pressalt(Left, 4, 1)
      pressalt(Up, 1, 1)
    elseif letter == 'F' then
      pressalt(Down, 1, 1)
      pressalt(Right, 5, 1)
      pressalt(A, 1, 1)
      pressalt(Left, 5, 1)
      pressalt(Up, 1, 1)
    elseif letter == 'G' then
      pressalt(Down, 1, 1)
      pressalt(Left, 4, 1)
      pressalt(A, 1, 1)
      pressalt(Right, 4, 1)
      pressalt(Up, 1, 1)
    elseif letter == 'H' then
      pressalt(Down, 1, 1)
      pressalt(Left, 3, 1)
      pressalt(A, 1, 1)
      pressalt(Right, 3, 1)
      pressalt(Up, 1, 1)
    elseif letter == 'I' then
      pressalt(Down, 1, 1)
      pressalt(Left, 2, 1)
      pressalt(A, 1, 1)
      pressalt(Right, 2, 1)
      pressalt(Up, 1, 1)
    elseif letter == 'J' then
      pressalt(Down, 1, 1)
      pressalt(Left, 1, 1)
      pressalt(A, 1, 1)
      pressalt(Right, 1, 1)
      pressalt(Up, 1, 1)
    elseif letter == 'K' then
      pressalt(Down, 2, 1)
      pressalt(A, 1, 1)
      pressalt(Up, 2, 1)
    elseif letter == 'L' then
      pressalt(Down, 2, 1)
      pressalt(Right, 1, 1)
      pressalt(A, 1, 1)
      pressalt(Left, 1, 1)
      pressalt(Up, 2, 1)
    elseif letter == 'M' then
      pressalt(Down, 2, 1)
      pressalt(Right, 2, 1)
      pressalt(A, 1, 1)
      pressalt(Left, 2, 1)
      pressalt(Up, 2, 1)
    elseif letter == 'N' then
      pressalt(Down, 2, 1)
      pressalt(Right, 3, 1)
      pressalt(A, 1, 1)
      pressalt(Left, 3, 1)
      pressalt(Up, 2, 1)
    elseif letter == 'O' then
      pressalt(Down, 2, 1)
      pressalt(Right, 4, 1)
      pressalt(A, 1, 1)
      pressalt(Left, 4, 1)
      pressalt(Up, 2, 1)
    elseif letter == 'P' then
      pressalt(Down, 2, 1)
      pressalt(Right, 5, 1)
      pressalt(A, 1, 1)
      pressalt(Left, 5, 1)
      pressalt(Up, 2, 1)
    elseif letter == 'Q' then
      pressalt(Down, 2, 1)
      pressalt(Left, 4, 1)
      pressalt(A, 1, 1)
      pressalt(Right, 4, 1)
      pressalt(Up, 2, 1)
    elseif letter == 'R' then
      pressalt(Down, 2, 1)
      pressalt(Left, 3, 1)
      pressalt(A, 1, 1)
      pressalt(Right, 3, 1)
      pressalt(Up, 2, 1)
    elseif letter == 'S' then
      pressalt(Down, 2, 1)
      pressalt(Left, 2, 1)
      pressalt(A, 1, 1)
      pressalt(Right, 2, 1)
      pressalt(Up, 2, 1)
    elseif letter == 'T' then
      pressalt(Down, 2, 1)
      pressalt(Left, 1, 1)
      pressalt(A, 1, 1)
      pressalt(Right, 1, 1)
      pressalt(Up, 2, 1)
    elseif letter == 'U' then
      pressalt(Down, 3, 1)
      pressalt(A, 1, 1)
      pressalt(Up, 3, 1)
    elseif letter == 'V' then
      pressalt(Down, 3, 1)
      pressalt(Right, 1, 1)
      pressalt(A, 1, 1)
      pressalt(Left, 1, 1)
      pressalt(Up, 3, 1)
    elseif letter == 'W' then
      pressalt(Down, 3, 1)
      pressalt(Right, 2, 1)
      pressalt(A, 1, 1)
      pressalt(Left, 2, 1)
      pressalt(Up, 3, 1)
    elseif letter == 'X' then
      pressalt(Down, 3, 1)
      pressalt(Right, 3, 1)
      pressalt(A, 1, 1)
      pressalt(Left, 3, 1)
      pressalt(Up, 3, 1)
    elseif letter == 'Y' then
      pressalt(Down, 3, 1)
      pressalt(Right, 4, 1)
      pressalt(A, 1, 1)
      pressalt(Left, 4, 1)
      pressalt(Up, 3, 1)
    elseif letter == 'Z' then
      pressalt(Down, 3, 1)
      pressalt(Right, 5, 1)
      pressalt(A, 1, 1)
      pressalt(Left, 5, 1)
      pressalt(Up, 3, 1)
    elseif letter == '/' then
      pressalt(Down, 3, 1)
      pressalt(Left, 4, 1)
      pressalt(A, 1, 1)
      pressalt(Right, 4, 1)
      pressalt(Up, 3, 1)
    elseif letter == '-' then
      pressalt(Down, 3, 1)
      pressalt(Left, 3, 1)
      pressalt(A, 1, 1)
      pressalt(Right, 3, 1)
      pressalt(Up, 3, 1)
    elseif letter == '=' then
      pressalt(Down, 3, 1)
      pressalt(Left, 2, 1)
      pressalt(A, 1, 1)
      pressalt(Right, 2, 1)
      pressalt(Up, 3, 1)
    elseif letter == '!' then
      pressalt(Down, 3, 1)
      pressalt(Left, 1, 1)
      pressalt(A, 1, 1)
      pressalt(Right, 1, 1)
      pressalt(Up, 3, 1)
    elseif letter == '?' then
      pressalt(Down, 4, 1)
      pressalt(A, 1, 1)
      pressalt(Up, 4, 1)
    elseif letter == '&' then
      pressalt(Down, 4, 1)
      pressalt(Right, 1, 1)
      pressalt(A, 1, 1)
      pressalt(Left, 1, 1)
      pressalt(Up, 4, 1)
    elseif letter == '+' then
      pressalt(Down, 4, 1)
      pressalt(Right, 2, 1)
      pressalt(A, 1, 1)
      pressalt(Left, 2, 1)
      pressalt(Up, 4, 1)
    elseif letter == '%' then
      pressalt(Down, 4, 1)
      pressalt(Right, 3, 1)
      pressalt(A, 1, 1)
      pressalt(Left, 3, 1)
      pressalt(Up, 4, 1)
    elseif letter == ',' then
      pressalt(Down, 4, 1)
      pressalt(Right, 4, 1)
      pressalt(A, 1, 1)
      pressalt(Left, 4, 1)
      pressalt(Up, 4, 1)
    elseif letter == '.' then
      pressalt(Down, 4, 1)
      pressalt(Right, 5, 1)
      pressalt(A, 1, 1)
      pressalt(Left, 5, 1)
      pressalt(Up, 4, 1)
    elseif letter == ':' then
      pressalt(Down, 4, 1)
      pressalt(Left, 4, 1)
      pressalt(A, 1, 1)
      pressalt(Right, 4, 1)
      pressalt(Up, 4, 1)
    elseif letter == ' ' then
      pressalt(Down, 4, 1)
      pressalt(Left, 4, 1)
      pressalt(A, 1, 1)
      pressalt(Right, 4, 1)
      pressalt(Up, 4, 1)
    elseif letter == 'END' then
      pressalt(Down, 4, 1)
      pressalt(Left, 1, 1)
      pressalt(A, 1, 1)
    else
    end
  end

  -- function to manage writing each letter in the order specified
  function writename(l1, l2, l3, l4, l5, l6, l7, l8)
    if l1 ~= nil then setletter(l1) end
    if l2 ~= nil then setletter(l2) end
    if l3 ~= nil then setletter(l3) end
    if l4 ~= nil then setletter(l4) end
    if l5 ~= nil then setletter(l5) end
    if l6 ~= nil then setletter(l6) end
    if l7 ~= nil then setletter(l7) end
    if l8 ~= nil then setletter(l8) end
  end

  -- Literally just presses right once - ah the two genders, do nothing and right
  function sex(sex)
    if setsex == 'Male' then end
    if setsex == 'Female' then press(Right, 1, 1) end
  end

  -- Saves the initial card set before it's reordered
  function saveinitialcardset()
    ic1 = c1
    ic2 = c2
    ic3 = c3
    ic4 = c4
    ic5 = c5
    ic6 = c6
    ic1hex = c1hex
    ic2hex = c2hex
    ic3hex = c3hex
    ic4hex = c4hex
    ic5hex = c5hex
    ic6hex = c6hex
  end

  -- Figures out what the initial order of the 7th card was
  function findiC7()
    if c1hex ~= ic1hex and c1hex ~= ic2hex and c1hex ~= ic3hex and c1hex ~= ic4hex and c1hex ~= ic5hex and c1hex ~= ic6hex then ic7hex = c1hex end
    if c2hex ~= ic1hex and c2hex ~= ic2hex and c2hex ~= ic3hex and c2hex ~= ic4hex and c2hex ~= ic5hex and c2hex ~= ic6hex then ic7hex = c2hex end
    if c3hex ~= ic1hex and c3hex ~= ic2hex and c3hex ~= ic3hex and c3hex ~= ic4hex and c3hex ~= ic5hex and c3hex ~= ic6hex then ic7hex = c3hex end
    if c4hex ~= ic1hex and c4hex ~= ic2hex and c4hex ~= ic3hex and c4hex ~= ic4hex and c4hex ~= ic5hex and c4hex ~= ic6hex then ic7hex = c4hex end
    if c5hex ~= ic1hex and c5hex ~= ic2hex and c5hex ~= ic3hex and c5hex ~= ic4hex and c5hex ~= ic5hex and c5hex ~= ic6hex then ic7hex = c5hex end
    if c6hex ~= ic1hex and c6hex ~= ic2hex and c6hex ~= ic3hex and c6hex ~= ic4hex and c6hex ~= ic5hex and c6hex ~= ic6hex then ic7hex = c6hex end
    if c7hex ~= ic1hex and c7hex ~= ic2hex and c7hex ~= ic3hex and c7hex ~= ic4hex and c7hex ~= ic5hex and c7hex ~= ic6hex then ic7hex = c7hex end
    ic7 = hextotarot(ic7hex)
  end

-- Main loop
mainloop = true
while mainloop == true do
    setinitialcardvalues()
    stats()
    -- Skip logo
    if t1 == 1 and t2 < 2 and skiplogo == true then pressalt(A, 190, 1) end
    -- Wait for logo if not skipping
    if t1 == 156 and t2 == 1 and skiplogo == false then pressalt(A, 7, 1) end
    -- Get past the Warren talk if not skipping logo
    if t1 == 244 and t2 == 1 and skiplogo == false then pressalt(A, 90, 1) end
    -- Enter name if not skipping logo
    if t1 == 233 and t2 == 2 and skiplogo == false then
      nopress(27)
      writename(letter1, letter2, letter3, letter4, letter5, letter6, letter7, letter8)
      pressalt(A, 50, 1)
      nopress(19)
      sex(setsex)
      -- Calculate what our starting frame should be based on settings
      if delaytilt1frame == false and delaytilframe == false and delaytilt2frame == false then
        t1start = 256 - t1 + t1cyclecounter
      elseif delaytilt1frame >= 0 and delaytilframe == false and delaytilt2frame == false then
        t1start = 256 - t1 + t1cyclecounter
      elseif delaytilt1frame == false and delaytilframe == false and delaytilt2frame >= 1 then
        delaytilt2frames = 256 * delaytilt2frame
        delaytilt2frames = delaytilt2frames - 768
        t1start = 256 - t1 + delaytilt2frames + t1cyclecounter
      elseif delaytilt2frame >= 1 and delaytilframe == false and delaytilt1frame >= 0 then
        delaytilt2frames = 256 * delaytilt2frame
        delaytilt2frames = delaytilt2frames - 768
        t1start = 256 - t1 + delaytilt2frames + t1cyclecounter
      elseif delaytilt1frame == false and delaytilframe >= 0 and delaytilt2frame == false then
        -- Create a frame counter based offset that only runs once
        if delaytilframefirstrun == true then
          delaytilframestart = delaytilframe - emu.framecount()
          delaytilframefirstrun = false
        end
        if delaytilframestart >= 0 then
          t1start = 256 - t1 + delaytilframestart + t1cyclecounter
        else
          t1start = 256 - t1 + t1cyclecounter
        end
      else
        emu.frameadvance()
        gui.text(250, 250, 'ERROR - Invalid combination of delays set.')
        mainloop = false
      end
      if t1start ~= 0 then nopress(t1start) end
      if totalt1cycles == 0 then
        framestartforcycle = emu.framecount()
      else
        framestartforcycle = round(emu.framecount() / totalt1cycles)
      end
      realt1atstart = t1
      realt2atstart = t2
      pressalt(A, 1252, 1)
      saveinitialcardset()
      pressalt(A, 325, 1)
      findiC7()
      logskiplogo = '_'
      -- Deal with the fact that lua can't print booleans
      if skiplogo == true then logskiplogo = 'skip' end
      if skiplogo == false then logskiplogo = 'wait' end
      -- Build the text for our log
      logtext = realt1atstart .. ',' .. framestartforcycle .. ',' .. ic1 .. ',' .. ic2 .. ',' .. ic3  .. ',' .. ic4  .. ',' .. ic5  .. ',' .. ic6  .. ',' .. ic7  .. ',' .. c1 .. ',' .. c2 .. ',' .. c3 .. ',' .. c4  .. ',' .. c5  .. ',' .. c6  .. ',' .. c7  .. ',' .. leadername .. ',' .. setsex .. ',' .. logskiplogo
      writetolog(logtext, leadername)
      -- Update counters
      t1cyclecounter = t1cyclecounter + 1
      totalt1cycles = totalt1cycles + 1
      t2cyclecounter = rounddown(totalt1cycles / 256)
      nopress(delayaftert1loop)
      resetconsole(1)
      -- Conditions to end the loop
      if runfor_t1cycle == true and t1cyclecounter == 256 then
        mainloop = false
      elseif runfor_t1cycle == false and t1cyclecounter == 256 then
        t1cyclecounter = t1cyclecounter - 256
      elseif runfor_t2cycles ~= false and t2cyclecounter == runfor_t2cycles then
        mainloop = false
      end
    -- Enter name if skipping logo
    elseif t1 == 2 and t2 == 2 and skiplogo == true then
      nopress(27)
      writename(letter1, letter2, letter3, letter4, letter5, letter6, letter7, letter8)
      pressalt(A, 50, 1)
      nopress(19)
      sex(setsex)
      -- Calculate what our starting frame should be based on settings
      if delaytilt1frame == false and delaytilframe == false and delaytilt2frame == false then
        t1start = 256 - t1 + t1cyclecounter
      elseif delaytilt1frame >= 0 and delaytilframe == false and delaytilt2frame == false then
        t1start = 256 - t1 + t1cyclecounter
      elseif delaytilt1frame == false and delaytilframe == false and delaytilt2frame >= 1 then
        delaytilt2frames = 256 * delaytilt2frame
        delaytilt2frames = delaytilt2frames - 768
        t1start = 256 - t1 + delaytilt2frames + t1cyclecounter
      elseif delaytilt2frame >= 1 and delaytilframe == false and delaytilt1frame >= 0 then
        delaytilt2frames = 256 * delaytilt2frame
        delaytilt2frames = delaytilt2frames - 768
        t1start = 256 - t1 + delaytilt2frames + t1cyclecounter
      elseif delaytilt1frame == false and delaytilframe >= 0 and delaytilt2frame == false then
        -- Create a frame counter based offset that only runs once
        if delaytilframefirstrun == true then
          delaytilframestart = delaytilframe - emu.framecount()
          delaytilframefirstrun = false
        end
        if delaytilframestart >= 0 then
          t1start = 256 - t1 + delaytilframestart + t1cyclecounter
        else
          t1start = 256 - t1 + t1cyclecounter
        end
      else
        emu.frameadvance()
        gui.text(250, 250, 'ERROR - Invalid combination of delays set.')
        mainloop = false
      end
      if t1start ~= 0 then nopress(t1start) end
      if totalt1cycles == 0 then
        framestartforcycle = emu.framecount()
      else
        framestartforcycle = round(emu.framecount() / totalt1cycles)
      end
      realt1atstart = t1
      realt2atstart = t2
      pressalt(A, 1252, 1)
      saveinitialcardset()
      pressalt(A, 325, 1)
      findiC7()
      logskiplogo = '_'
      -- Deal with the fact that lua can't print booleans
      if skiplogo == true then logskiplogo = 'skip' end
      if skiplogo == false then logskiplogo = 'wait' end
      -- Build the text for our log
      logtext = realt1atstart .. ',' .. realt2atstart .. ',' .. framestartforcycle .. ',' .. ic1 .. ',' .. ic2 .. ',' .. ic3  .. ',' .. ic4  .. ',' .. ic5  .. ',' .. ic6  .. ',' .. ic7  .. ',' .. c1 .. ',' .. c2 .. ',' .. c3 .. ',' .. c4  .. ',' .. c5  .. ',' .. c6  .. ',' .. c7  .. ',' .. leadername .. ',' .. setsex .. ',' .. logskiplogo
      writetolog(logtext, leadername)
      -- Update counters
      t1cyclecounter = t1cyclecounter + 1
      totalt1cycles = totalt1cycles + 1
      t2cyclecounter = rounddown(totalt1cycles / 256) + t2startoffset
      nopress(delayaftert1loop)
      resetconsole(1)
      -- Conditions to end the loop
      if runfor_t1cycle == true and t1cyclecounter == 256 then
        mainloop = false
      elseif runfor_t1cycle == false and t1cyclecounter == 256 then
        t1cyclecounter = t1cyclecounter - 256
      elseif runfor_t2cycles ~= false and t2cyclecounter == runfor_t2cycles then
        mainloop = false
      end
    end
  emu.frameadvance()
end

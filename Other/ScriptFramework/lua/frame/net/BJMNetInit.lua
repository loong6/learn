--[[
Author : ZangXu @Bojoy 2014
FileName: BJMNetInit.lua
Description: 
]]

require(bjm.PACKAGE_NAME .. ".net.BJMHttpManager")
require(bjm.PACKAGE_NAME .. ".net.BJMNetEnv")

-- require(bjm.PACKAGE_NAME .. ".net.sproto.sproto")
-- require(bjm.PACKAGE_NAME .. ".net.sproto.sprotoloader")
sprotoparser = require(bjm.PACKAGE_NAME .. ".net.sproto.sprotoparser")

require(bjm.PACKAGE_NAME .. ".net.BJMSocketTCP")
require(bjm.PACKAGE_NAME .. ".net.BJMPacketBuffer")
require(bjm.PACKAGE_NAME .. ".net.BJMSocketManager")

require(bjm.PACKAGE_NAME .. ".net.BJMSocketTCPEx")
require(bjm.PACKAGE_NAME .. ".net.BJMPacketBufferEx")
require(bjm.PACKAGE_NAME .. ".net.BJMSocketManagerEx")

require(bjm.PACKAGE_NAME .. ".net.BJMHttpLogicEx")


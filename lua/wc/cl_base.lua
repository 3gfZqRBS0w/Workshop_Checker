
local function Show()

    local addon = {}
    local Main = vgui.Create("DFrame")
    Main:SetPos(5, 5)
    Main:SetSize(ScrW() / 2.5, ScrH() / 2.5)
    Main:SetTitle("Workshop Check")
    Main:SetVisible(true)
    Main:Center()
    Main:SetDraggable(true)
    Main:ShowCloseButton(true)
    Main:MakePopup()
    Main.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 250))
    end

    local Menu = vgui.Create("DMenuBar", Main)
    Menu:DockMargin(-3, -6, -3, 0)
    Menu.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255))
    end

    local List = vgui.Create( "DCategoryList", Main )
    List:SetVisible(false)
    List:Dock(FILL)
    List:UnselectAll()


    local Check = Menu:AddMenu("Check")
    Check:AddOption("My Collection", function()
    List:SetVisible(true)

    end):SetIcon("icon16/page_white_go.png")

    local Settings = Menu:AddMenu("Settings")


    for k,v in pairs(WC_Response["response"]["publishedfiledetails"]) do

        addon[k] = List:Add(WC_Response["response"]["publishedfiledetails"][k]["title"])
        local link = addon[k]:Add( "Link : https://steamcommunity.com/sharedfiles/filedetails/?id="..WC_Response["response"]["publishedfiledetails"][k]["publishedfileid"] )
        local subscriptions = addon[k]:Add( "Subcriptions : "..WC_Response["response"]["publishedfiledetails"][k]["subscriptions"] )
        addon[k]:SetExpanded( false )
        addon[k]:SetMouseInputEnabled( true )
        addon[k]:CopySelected()
        addon[k].Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, WorkshopCheck.GetValidation(WC_Response["response"]["publishedfiledetails"][k]).color)
        end
        link.DoClick = function()
            print( "https://steamcommunity.com/sharedfiles/filedetails/?id="..WC_Response["response"]["publishedfiledetails"][k]["publishedfileid"] )
        end
        
    end

--[[
    net.Receive("WORKSHOPCHECK_GetCollectionDetails", function(len, pl)
        local num = net.ReadUInt(9)
        for I=1, num do
            local id = net.ReadString()
            addon[num] = List:Add( id )
            local DLabel = vgui.Create( "DLabel", addon[num] )
            DLabel:SetPos( 5, 40 )
            DLabel:SetText( "Hello, world!" )
            addon[num].Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 250))
            end
        end
    end) ]]    
end

concommand.Add("workshopcheck", function()
    if (LocalPlayer():IsSuperAdmin()) then
        if (istable(WC_Response)) then
            Show()
        else
            print("démarrage impossible")
        end
    else
        print("vous n'êtes pas suradmin")
    end
end)




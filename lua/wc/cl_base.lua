


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


    local Check = Menu:AddMenu("Check")
    Check:AddOption("My Collection", function()
        List:SetVisible(true)
        net.Start("WORKSHOPCHECK_GetCollectionDetails")
        net.SendToServer()

    end):SetIcon("icon16/page_white_go.png")
    Check:AddOption("Other Collection", function()

    end):SetIcon("icon16/page_white_go.png")

    local Settings = Menu:AddMenu("Settings")


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
    end)    
end

concommand.Add("workshopcheck", Show)



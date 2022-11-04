local function Show()

    local addon = {}
    local Main = vgui.Create("DFrame")
    Main:SetPos(5, 5)
    Main:SetSize(ScrW() / 2.5, ScrH() / 2.5)
    Main:SetTitle("Workshop Check")
    Main:SetVisible(true)
    Main:ShowCloseButton( false )
    Main:Center()
    Main:SetDraggable(true)
    Main:MakePopup()
    Main.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 250))
    end

    local Menu = vgui.Create("DMenuBar", Main)
    Menu:DockMargin(-3, -6, -3, 0)
    Menu.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255))
    end

    local CloseButton = vgui.Create("DButton", Main)
    CloseButton:SetText( "" )
    CloseButton:SetSize( 20, 20 )
    CloseButton:SetPos( Main:GetWide()-20, 0 )
    
    CloseButton.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 0, 0, 255 ) )
    end
    CloseButton.DoClick = function()
       Main:Close()
    end

    local List = vgui.Create( "DCategoryList", Main )
    List:SetVisible(false)
    List:Dock(FILL)
    List:UnselectAll()


    local Check = Menu:AddMenu("Check")
    Check:AddOption("My Collection", function()
    List:SetVisible(true)

    end):SetIcon("icon16/page_white_go.png")


    for k,v in pairs(WC_Response["response"]["publishedfiledetails"]) do
        if (WC_Response["response"]["publishedfiledetails"][k]["title"] == nil) then
            addon[k] = List:Add(WC_Response["response"]["publishedfiledetails"][k]["publishedfileid"])
            local link = addon[k]:Add( "no longer exists" )

            PrintTable(WC_Response["response"]["publishedfiledetails"][k])
        else
            addon[k] = List:Add(WC_Response["response"]["publishedfiledetails"][k]["title"])
            local analyse = addon[k]:Add( WorkshopCheck.GetValidation(WC_Response["response"]["publishedfiledetails"][k]).title .." : "..WorkshopCheck.GetValidation(WC_Response["response"]["publishedfiledetails"][k]).description)
            local link = addon[k]:Add( "Click to show addon page" )
            local subscriptions = addon[k]:Add( "Subcriptions : "..WC_Response["response"]["publishedfiledetails"][k]["subscriptions"] )
    
           analyse:SetTextColor(Color(255,255,255))
           link:SetTextColor( Color(255,255,255) )
           subscriptions:SetTextColor( Color(255,255,255) )
    
            addon[k]:SetExpanded( false )
            addon[k]:SetMouseInputEnabled( true )
            addon[k]:CopySelected()
            addon[k].Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, WorkshopCheck.GetValidation(WC_Response["response"]["publishedfiledetails"][k]).color)
            end
            link.DoClick = function()
                print( "https://steamcommunity.com/sharedfiles/filedetails/?id="..WC_Response["response"]["publishedfiledetails"][k]["publishedfileid"] )
    
                print("le truc que je veux "..WC_Response["response"]["publishedfiledetails"][k]["creator"])
    
    
                gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id="..WC_Response["response"]["publishedfiledetails"][k]["publishedfileid"])
            end
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




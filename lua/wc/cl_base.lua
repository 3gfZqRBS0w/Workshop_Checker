local function Show()

    local addon = {}
    local Main = vgui.Create("DFrame")
    Main:SetPos(5, 5)
    Main:SetSize(ScrW() / 2.5, ScrH() / 2.5)
    Main:SetTitle("Workshop Check")
    Main:SetVisible(true)
    Main:ShowCloseButton( false )
    Main:Center()
    Main:SetDraggable(false)
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
    List:SetVisible(not List:IsVisible())

    end):SetIcon("icon16/page_white_go.png")


    for k,v in pairs(WC_Response["response"]["publishedfiledetails"]) do
        if (WC_Response["response"]["publishedfiledetails"][k]["title"] == nil) then

            net.Start("WC_ResearchAddon")
            net.WriteString(WC_Response["response"]["publishedfiledetails"][k]["publishedfileid"])
            net.SendToServer()

            net.Receive("WC_ResearchAddon", function()
                local bytes_amount = net.ReadUInt( 16 ) 
                local compressed_message = net.ReadData( bytes_amount ) 
                WC_Response["response"]["publishedfiledetails"][k] = util.JSONToTable(util.Decompress( compressed_message ))
                addon[k] = List:Add(WC_Response["response"]["publishedfiledetails"][k]["title"])
                local analyse = addon[k]:Add( WorkshopCheck.GetValidation(WC_Response["response"]["publishedfiledetails"][k]).title .." : "..WorkshopCheck.GetValidation(WC_Response["response"]["publishedfiledetails"][k]).description)
                local deleted = addon[k]:Add("addon deleted or hidden. Remove it from the collection !  ")

                analyse:SetTextColor(Color(255,255,255))
                deleted:SetTextColor(Color(255,255,255))

                addon[k].Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, WC_CONFIG.LEVEL_OF_DANGEROUSNESS.deleted.color)
                end

                


            end)
            --addon[k] = List:Add(WC_Response["response"]["publishedfiledetails"][k]["publishedfileid"])
          --  local link = addon[k]:Add( "no longer exists" )
        else
            addon[k] = List:Add(WC_Response["response"]["publishedfiledetails"][k]["title"])
            local analyse = addon[k]:Add( WorkshopCheck.GetValidation(WC_Response["response"]["publishedfiledetails"][k]).title .." : "..WorkshopCheck.GetValidation(WC_Response["response"]["publishedfiledetails"][k]).description)
            local link = addon[k]:Add( "Click to show addon page" )
            local subscriptions = addon[k]:Add( "Subcriptions : "..WC_Response["response"]["publishedfiledetails"][k]["subscriptions"] )
            local downloadlink = addon[k]:Add( "...Download GMA...")

            addon[k].Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, WorkshopCheck.GetValidation(WC_Response["response"]["publishedfiledetails"][k]).color)
            end
    
           analyse:SetTextColor(Color(255,255,255))
           link:SetTextColor( Color(255,255,255) )
           subscriptions:SetTextColor( Color(255,255,255) )
           downloadlink:SetTextColor( Color(255,255,255) )
    
            addon[k]:SetExpanded( false )
            addon[k]:SetMouseInputEnabled( true )
            addon[k]:CopySelected()
            addon[k].Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, WorkshopCheck.GetValidation(WC_Response["response"]["publishedfiledetails"][k]).color)
            end


            downloadlink.DoClick = function()
                print(WC_Response["response"]["publishedfiledetails"][k]["file_url"])
                gui.OpenURL(WC_Response["response"]["publishedfiledetails"][k]["file_url"])
            end

            link.DoClick = function()
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





concommand.Add("workshopcheck", function(pl, cmd, args)
    if (WC_ACCESS[pl:GetUserGroup()] == true) then
        if (WC_Response ~= nil) then
            if ( pl:IsSuperAdmin() ) then 
                Show(WC_Response)
            else
                print("You do not have the right !")
            end
        else  
        net.Start("WC_GetAddons")
        net.SendToServer()
        end
    else
        print("[WC] You are not allowed to")
    end
end)

net.Receive("WC_GetAddons", function()
    local bytes_amount = net.ReadUInt( 16 ) 
	local compressed_message = net.ReadData( bytes_amount ) 
	WC_Response = util.JSONToTable(util.Decompress( compressed_message ))

    Show(WC_Response)
end)




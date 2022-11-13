-- Il faut parcourir verticalement pour récupérer les différents niveau de noeud

local function Show()
    local addon = {}

    local Main = vgui.Create("DFrame")
    Main:SetPos(5, 5)
    Main:SetSize(ScrW() / 2.5, ScrH() / 2.5)
    Main:SetTitle("Workshop Check")
    Main:SetVisible(true)
    Main:ShowCloseButton(false)
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
    CloseButton:SetText("")
    CloseButton:SetSize(20, 20)
    CloseButton:SetPos(Main:GetWide() - 20, 0)

    CloseButton.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0, 255))
    end
    CloseButton.DoClick = function()
        Main:Close()
    end

    local List = vgui.Create("DCategoryList", Main)
    List:SetVisible(false)
    List:Dock(FILL)
    List:UnselectAll()

    local Check = Menu:AddMenu("Check")
    Check:AddOption(
        "My Collection",
        function()
            List:SetVisible(not List:IsVisible())
        end
    ):SetIcon("icon16/page_white_go.png")

    for k, v in pairs(WC_Response["response"]["publishedfiledetails"]) do
        if (WC_Response["response"]["publishedfiledetails"][k]["title"] == nil) then
            --addon[k] = List:Add(WC_Response["response"]["publishedfiledetails"][k]["publishedfileid"])
            --  local link = addon[k]:Add( "no longer exists" )
            net.Start("WC_ResearchAddon")
            net.WriteString(WC_Response["response"]["publishedfiledetails"][k]["publishedfileid"])
            net.SendToServer()

            net.Receive(
                "WC_ResearchAddon",
                function()
                    local bytes_amount = net.ReadUInt(16)
                    local compressed_message = net.ReadData(bytes_amount)
                    WC_Response["response"]["publishedfiledetails"][k] =
                        util.JSONToTable(util.Decompress(compressed_message))
                    addon[k] = List:Add(WC_Response["response"]["publishedfiledetails"][k]["title"])
                    local analyse =
                        addon[k]:Add(
                        WorkshopCheck.GetValidation(WC_Response["response"]["publishedfiledetails"][k]).title ..
                            " : " ..
                                WorkshopCheck.GetValidation(WC_Response["response"]["publishedfiledetails"][k]).description
                    )

                    local deleted = addon[k]:Add("addon deleted or hidden. Remove it from the collection !  ")

                    analyse:SetTextColor(Color(255, 255, 255))

                    deleted:SetTextColor(Color(255, 255, 255))

                    addon[k].Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, WC_CONFIG.LEVEL_OF_DANGEROUSNESS.deleted.color)
                    end
                end
            )
        else
            addon[k] = List:Add(WC_Response["response"]["publishedfiledetails"][k]["title"])

            -- If the file is too big Garry's mod crashes
            if (WC_Response["response"]["publishedfiledetails"][k]["file_size"] < 200627615) then
                local check = addon[k]:Add("Show all files")
                check:SetTextColor(Color(255, 255, 255))
                check.DoClick = function()
                    print("le truc important" .. WC_Response["response"]["publishedfiledetails"][k]["file_size"])

                    local Nav = vgui.Create("DFrame")
                    Nav:ShowCloseButton(false)
                    Nav:SetSize(500, 250)
                    Nav:SetSizable(true)
                    Nav:Center()
                    Nav:MakePopup()
                    Nav:SetTitle("Addon verification")
                    local CloseButton = vgui.Create("DButton", Nav)
                    CloseButton:SetText("")
                    CloseButton:SetSize(20, 20)
                    CloseButton:SetPos(Nav:GetWide() - 20, 0)
                    CloseButton.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0, 255))
                    end
                    CloseButton.DoClick = function()
                        Nav:Close()
                    end

                    --local arbo = ListOfPath:AddNode("/")

                    steamworks.DownloadUGC(
                        WC_Response["response"]["publishedfiledetails"][k]["publishedfileid"],
                        function(path)
                            local success, files = game.MountGMA(path)

                            local ListOfPath = vgui.Create("DListView", Nav)
                            ListOfPath:Dock(FILL)
                            ListOfPath:AddColumn("Link")
                            --local pathsNode = {}
                            if (success) then
                                -- for debugging
                                print(table.Count(files))

                                for k, v in pairs(files) do
                                    -- pathsNode[k] = arbo:AddNode(v, "icon16/link.png")
                                    ListOfPath:AddLine(v)
                                end

                                ListOfPath.OnRowSelected = function(panel, rowIndex, row)
                                    print(ListOfPath:GetLine(rowIndex):GetValue())

                                    local v = ListOfPath:GetLine(rowIndex):GetValue(1)

                                    if
                                        (string.GetExtensionFromFilename(v) == "lua" or
                                            string.GetExtensionFromFilename(v) == "vmt" or
                                            string.GetExtensionFromFilename(v) == "txt")
                                     then
                                        local CodeWindow = vgui.Create("DFrame")
                                        CodeWindow:SetSize(ScrW() / 2.5, ScrH() / 2.5)
                                        CodeWindow:SetTitle(v)
                                        CodeWindow:ShowCloseButton(false)
                                        CodeWindow:Center()
                                        CodeWindow:MakePopup()
                                        CodeWindow.Paint = function(self, w, h)
                                            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255))
                                        end

                                        local Code = vgui.Create("DTextEntry", CodeWindow)
                                        Code:SetMultiline(true)
                                        Code:Dock(FILL)
                                        Code:SetText(file.Read(v, "GAME"))

                                        local CloseButton = vgui.Create("DButton", CodeWindow)
                                        CloseButton:SetText("")
                                        CloseButton:SetSize(20, 20)
                                        CloseButton:SetPos(Main:GetWide() - 20, 0)

                                        CloseButton.Paint = function(self, w, h)
                                            draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0, 255))
                                        end
                                        CloseButton.DoClick = function()
                                            CodeWindow:Close()
                                        end
                                    else
                                        if
                                            (string.GetExtensionFromFilename(v) == "png" or
                                                string.GetExtensionFromFilename(v) == "jpg" or
                                                string.GetExtensionFromFilename(v) == "vtf")
                                         then
                                            local ImageWindow = vgui.Create("DFrame")
                                            ImageWindow:SetSize(ScrW() / 2.5, ScrH() / 2.5)
                                            ImageWindow:SetTitle(v)
                                            ImageWindow:ShowCloseButton(false)
                                            ImageWindow:Center()
                                            ImageWindow:MakePopup()
                                            ImageWindow.Paint = function(self, w, h)
                                                draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255))
                                            end

                                            local Image = vgui.Create("DImage", ImageWindow)
                                            Image:Dock(FILL)
                                            -- bug here :c
                                            if (string.GetExtensionFromFilename(v) == "vtf") then
                                                print(string.sub(string.StripExtension(v), 11))
                                                Image:SetMaterial(Material(string.sub(string.StripExtension(v), 11))) -- remove /materials
                                            else
                                                Image:SetImage(v)
                                            end

                                            local CloseButton = vgui.Create("DButton", ImageWindow)
                                            CloseButton:SetText("")
                                            CloseButton:SetSize(20, 20)
                                            CloseButton:SetPos(Main:GetWide() - 20, 0)

                                            CloseButton.Paint = function(self, w, h)
                                                draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0, 255))
                                            end
                                            CloseButton.DoClick = function()
                                                ImageWindow:Close()
                                            end
                                        else
                                            if (string.GetExtensionFromFilename(v) == "mdl") then
                                                local ModelWindow = vgui.Create("DFrame")
                                                ModelWindow:SetSize(ScrW() / 2.5, ScrH() / 2)
                                                ModelWindow:SetTitle(v)
                                                ModelWindow:ShowCloseButton(false)
                                                ModelWindow:Center()
                                                ModelWindow:MakePopup()
                                                ModelWindow.Paint = function(self, w, h)
                                                    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255))
                                                end

                                                local CloseButton = vgui.Create("DButton", ModelWindow)
                                                CloseButton:SetText("")
                                                CloseButton:SetSize(20, 20)
                                                CloseButton:SetPos(ModelWindow:GetWide() - 20, 0)
                                                CloseButton.Paint = function(self, w, h)
                                                    draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0, 255))
                                                end
                                                CloseButton.DoClick = function()
                                                    ModelWindow:Close()
                                                end

                                                util.PrecacheModel( v )

                                                local icon = vgui.Create( "SpawnIcon" , ModelWindow ) -- SpawnIcon, with blue barrel model
                                                icon:Dock(FILL)
                                                icon:SetModel( v, 0 )
                                                icon.DoClick = function()

                                                    ModelWindow:SetScreenLock( false )
                                                    local trace = LocalPlayer():GetEyeTrace()
                                                    entity = ClientsideModel( v )
                                                    entity:SetPos( trace.HitPos + trace.HitNormal * 24 )
                                                    entity:Spawn()
                                                end

                                                ModelWindow.OnClose = function()
                                                    entity:Remove()
                                                end
                                
                                            else
                                                if
                                                    (string.GetExtensionFromFilename(v) == "mp3" or
                                                        string.GetExtensionFromFilename(v) == "wav")
                                                 then
                                                    local MusicWindow = vgui.Create("DFrame")
                                                    MusicWindow:SetSize(ScrW() / 2.5, ScrH() / 4)
                                                    MusicWindow:SetTitle(v)
                                                    MusicWindow:ShowCloseButton(false)
                                                    MusicWindow:Center()
                                                    MusicWindow:MakePopup()
                                                    MusicWindow.Paint = function(self, w, h)
                                                        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255))
                                                    end

                                                    local SongIsPlaying = false
                                                    local PlaySound
                                                    local PlayButton = vgui.Create("DImageButton", MusicWindow)

                                                    PlayButton:SetSize(Main:GetWide() / 5, Main:GetWide() / 5)
                                                    PlayButton:SetImage("icon16/control_play.png")
                                                    PlayButton:SizeToContents()
                                                    PlayButton.DoClick = function()
                                                        SongIsPlaying = not SongIsPlaying
                                                        if (SongIsPlaying) then
                                                            sound.PlayFile(
                                                                v,
                                                                "noplay",
                                                                function(station, errCode, errStr)
                                                                    if (IsValid(station)) then
                                                                        PlaySound = station
                                                                        PlaySound:Play()
                                                                    else
                                                                        print("Error playing sound!", errCode, errStr)
                                                                    end
                                                                end
                                                            )
                                                            PlayButton:SetImage("icon16/control_pause.png")
                                                        else
                                                            if (IsValid(PlaySound)) then
                                                                PlaySound:Stop()
                                                            end
                                                            PlayButton:SetImage("icon16/control_play.png")
                                                        end
                                                    end

                                                    MusicWindow.OnClose = function()
                                                        if (IsValid(PlaySound)) then
                                                            PlaySound:Stop()
                                                        end
                                                    end

                                                    local Progress = vgui.Create("DProgress", MusicWindow)
                                                    --Progress:SetPos( 10, 30 )
                                                    --Progress:SetSize( 200, 20 )
                                                    Progress:SetFraction(0.5)
                                                    Progress.Paint = function(self, w, h)
                                                        draw.RoundedBox(30, 0, 0, w, h, Color(255, 255, 255, 255))
                                                        if (IsValid(PlaySound)) then
                                                            Progress:SetFraction(
                                                                (1 * PlaySound:GetTime()) / PlaySound:GetLength()
                                                            )
                                                            -- GetLength()
                                                            draw.RoundedBox(
                                                                30,
                                                                0,
                                                                0,
                                                                Progress:GetFraction() * w,
                                                                h,
                                                                Color(255, 0, 0, 255)
                                                            )
                                                        end
                                                    end

                                                    local TimeCode = vgui.Create("DLabel", MusicWindow)
                                                    TimeCode:SetPos(10, 30)
                                                    TimeCode:SetText("0/0")
                                                    TimeCode.Paint = function()
                                                        if (IsValid(PlaySound)) then
                                                            TimeCode:SetText(
                                                                string.NiceTime(PlaySound:GetTime()) ..
                                                                    "/" .. string.NiceTime(PlaySound:GetLength())
                                                            )
                                                        end
                                                    end

                                                    local divV = vgui.Create("DVerticalDivider", MusicWindow)
                                                    --divV:Dock(FILL)
                                                    divV:SetTop(TimeCode)
                                                    divV:SetBottom(Progress)

                                                    local divH = vgui.Create("DHorizontalDivider", MusicWindow)
                                                    divH:Dock(FILL)
                                                    divH:SetLeft(PlayButton)
                                                    divH:SetRight(divV)

                                                    --:SetImage( string strImage, string strBackup )

                                                    local CloseButton = vgui.Create("DButton", MusicWindow)
                                                    CloseButton:SetText("")
                                                    CloseButton:SetSize(20, 20)
                                                    CloseButton:SetPos(MusicWindow:GetWide() - 20, 0)
                                                    CloseButton.Paint = function(self, w, h)
                                                        draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0, 255))
                                                    end
                                                    CloseButton.DoClick = function()
                                                        MusicWindow:Close()
                                                    end
                                                else
                                                    print("[WC] unknown format  ")
                                                end
                                            end
                                        end
                                    end
                                end

                                Nav.OnClose = function()
                                    files = nil
                                end

                            --[[
                            we'll see later

                        paths = {
                            "a/b",
                            "a/c",
                            "d/e/f",
                        }
                        local notfound = true

                        for pathLevel, path in pairs(paths) do
                            for nodeLevel, nodeName in pairs(string.Explode("/", path)) do
                                if (nodeLevel == 1 and pathLevel == 1) then
                                    actualNode = arbo:AddNode(nodeName)
                                else
                                    for k, v in pairs(arbo:GetChildNodes()) do
                                        if (v:GetText() == string.Explode("/", path)[nodeLevel-1] ) then
                                            actualNode = v:AddNode(nodeName)
                                            notfound = false
                                            break
                                        end
                                    end
                                    if (notfound) then
                                        actualNode = arbo:AddNode(nodeName)
                                        notfound = false
                                    end                     
                                end
                            end]]
                            end
                        end
                    )

                    Nav.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 250))
                    end
                end
            else
                local check = addon[k]:Add("File too big to be seen")
                check:SetTextColor(Color(255, 255, 255))

            end
            local analyse =
                addon[k]:Add(
                WorkshopCheck.GetValidation(WC_Response["response"]["publishedfiledetails"][k]).title ..
                    " : " .. WorkshopCheck.GetValidation(WC_Response["response"]["publishedfiledetails"][k]).description
            )
            local link = addon[k]:Add("Click to show addon page")
            local subscriptions =
                addon[k]:Add("Subcriptions : " .. WC_Response["response"]["publishedfiledetails"][k]["subscriptions"])
            if (WC_Response["response"]["publishedfiledetails"][k]["file_url"] ~= "") then
                local downloadlink = addon[k]:Add("...Download GMA...")
                downloadlink:SetTextColor(Color(255, 255, 255))
                downloadlink.DoClick = function()
                    gui.OpenURL(WC_Response["response"]["publishedfiledetails"][k]["file_url"])
                end
            end
            addon[k].Paint = function(self, w, h)
                draw.RoundedBox(
                    0,
                    0,
                    0,
                    w,
                    h,
                    WorkshopCheck.GetValidation(WC_Response["response"]["publishedfiledetails"][k]).color
                )
            end

            analyse:SetTextColor(Color(255, 255, 255))
            link:SetTextColor(Color(255, 255, 255))

            subscriptions:SetTextColor(Color(255, 255, 255))

            addon[k]:SetExpanded(false)
            addon[k]:SetMouseInputEnabled(true)
            addon[k]:CopySelected()
            addon[k].Paint = function(self, w, h)
                draw.RoundedBox(
                    0,
                    0,
                    0,
                    w,
                    h,
                    WorkshopCheck.GetValidation(WC_Response["response"]["publishedfiledetails"][k]).color
                )
            end

            link.DoClick = function()
                gui.OpenURL(
                    "https://steamcommunity.com/sharedfiles/filedetails/?id=" ..
                        WC_Response["response"]["publishedfiledetails"][k]["publishedfileid"]
                )
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

--[[
    steamworks.DownloadUGC( 104548572, function( path )
	a, b = game.MountGMA( path )
    PrintTable(b)
end)
]]
concommand.Add(
    "workshopcheck",
    function(pl, cmd, args)
        if (WC_ACCESS[pl:GetUserGroup()] == true) then
            if (WC_Response ~= nil) then
                if (pl:IsSuperAdmin()) then
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
    end
)

net.Receive(
    "WC_GetAddons",
    function()
        local bytes_amount = net.ReadUInt(16)
        local compressed_message = net.ReadData(bytes_amount)
        WC_Response = util.JSONToTable(util.Decompress(compressed_message))
        Show(WC_Response)
    end
)

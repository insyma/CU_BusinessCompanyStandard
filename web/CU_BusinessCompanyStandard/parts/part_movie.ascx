<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl"  %>
<!--#include file="part_functions.ascx" -->
<script runat="server">

    ''Variable für die Entscheidung, ob part ausgegeben wird
    Dim part_visible As Boolean = False

    Dim mov_con As New contentupdate.container
    Dim set_con As New contentupdate.container
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)


        ''''''''''' Werte für Höhe und Breite incl. Fallbackmasse in Pixel
        Dim val_w As String = "400"
        Dim val_h As String = "250"
        Dim swfobj As String = ""
        Dim noflash As String = ""
        Dim moviesrc As String = ""
        Dim imagesrc As String = ""
        Dim autoplay As String = ""
        ''''''''''' Container  "Movie" laden
        If container.containers("part_movie_container").id > 0 Then
            mov_con.load(container.containers("part_movie_container").id)
            mov_con.languagecode = cupage.languagecode
            mov_con.preview = cupage.preview

            If Not mov_con.fields("part_movie_movie_url").value = "" Or Not mov_con.fields("part_movie_movie_id").value = "" Or Not mov_con.files("part_movie_movie_file").properties("filename").value = "" Then
                part_visible = True
            End If

        End If
        ''''''' Autoplay?	
        If Not mov_con.Fields("part_movie_movie_autoplay").Value = "" Then
            autoplay = "1"
        Else
            autoplay = "0"
        End If

        ''''''''''' Container  "Settings" laden
        If container.containers("part_movie_settings").id > 0 Then
            set_con.load(container.containers("part_movie_settings").id)
            set_con.languagecode = cupage.languagecode
            set_con.preview = cupage.preview
        End If

        ''''''''''' Werte für Höhe und Breite aus CU-Feldern
        If Not mov_con.fields("part_movie_movie_width").value = "" Then
            val_w = mov_con.fields("part_movie_movie_width").value
        End If
        If Not mov_con.fields("part_movie_movie_height").value = "" Then
            val_h = mov_con.fields("part_movie_movie_height").value
        End If

        '''''' Videos einbinden
        If Not mov_con.fields("part_movie_movie_id").value = "" Then
            '''''[YOUTUBE] ****************************************************************
            If mov_con.fields("part_movie_movie_plattform").value = "Youtube" Then
                'Set Preview Image if defined, otherwise Vimeopreview will be loaded
                If Not mov_con.Images("part_movie_previewimg").FileName = "" Then
                    imagesrc = mov_con.Images("part_movie_previewimg").Src
                Else
                    imagesrc = "https://img.youtube.com/vi/" & mov_con.Fields("part_movie_movie_id").Value & "/sddefault.jpg"
                End If

                'embvideo.Text = "<div class='movie-holder'><iframe id='iframe_movie_youtube_" & container.id & "' title='YouTube' width='" & val_w & "' height='" & val_h & "' src='https://www.youtube.com/embed/" & mov_con.fields("part_movie_movie_id").value & "?enablejsapi=1&wmode=transparent" & autoplay_youtube & "' frameborder='0' allowfullscreen></iframe><div class='ratio' style='padding-top:" & (val_h / val_w) * 100 & "%'></div></div>"
                If set_con.fields("part_movie_settings_overlay").value = "inside" Or set_con.fields("part_movie_settings_overlay").value = "" Then
                    embvideo.Text = "<a href='javascript:void(0);' style='background-image:url(" & imagesrc & ");' class='movielink-inside youtube bg-img' data-movie-type='youtube' data-movie-height='" & val_h & "' data-movie-width='" & val_w & "' data-movie-id='" & mov_con.Fields("part_movie_movie_id").Value & "' id='movielink_" & Container.Id & "' data-content-id='" & Container.Id & "'>"
                Else
                    embvideo.Text = "<a href='javascript:void(0);' data-href='https://www.youtube-nocookie.com/embed/" & mov_con.Fields("part_movie_movie_id").Value & "?enablejsapi=1&rel=0&autoplay=" & autoplay & "' style='background-image:url(" & imagesrc & ");' class='movielink bg-img' data-height='" & val_h & "' data-width='" & val_w & "' data-movie-id='" & mov_con.Fields("part_movie_movie_id").Value & "' id='movielink_" & Container.Id & "' data-content-id='" & Container.Id & "' data-movie-type='youtube'>"
                End If

                'Overlay********************************
                'Set Preview Image if defined, otherwise Vimeopreview will be loaded
                If Not mov_con.Images("part_movie_previewimg").FileName = "" Then
                    embvideo.Text += "<img src='" & imagesrc & "' alt='' />"
                Else
                    embvideo.Text += "<img src='https://img.youtube.com/vi/" & mov_con.Fields("part_movie_movie_id").Value & "/sddefault.jpg' alt='' />"
                End If
                embvideo.Text += "</a>"

                '''''[VIMEO] ****************************************************************
            ElseIf mov_con.fields("part_movie_movie_plattform").value = "Vimeo" Then
                If Not mov_con.Images("part_movie_previewimg").Filename = "" Then
                    imagesrc = mov_con.Images("part_movie_previewimg").Src
                End If

                If set_con.fields("part_movie_settings_overlay").value = "inside" Or set_con.fields("part_movie_settings_overlay").value = "" Then
                    'Framelösung********************************
                    'embvideo.Text = "<div class='movie-holder'><iframe id='iframe_movie_vimeo_" & container.id & "' class='vimeo' src='https://player.vimeo.com/video/" & mov_con.fields("part_movie_movie_id").value & "?color=999&api=1&player_id=iframe_movie_vimeo_" & container.id & "" & "' width='" & val_w & "' height='" & val_h & "' frameborder='0'></iframe><div class='ratio' style='padding-top:" & (val_h / val_w) * 100 & "%'></div></div>"
                    embvideo.Text = "<a href='javascript:void(0);' class='movielink-inside vimeo bg-img' data-movie-autoplay='" & autoplay & "' data-movie-type='vimeo' data-movie-height='" & val_h & "' data-movie-width='" & val_w & "' data-movie-id='" & mov_con.Fields("part_movie_movie_id").Value & "' id='movielink_" & Container.Id & "' data-content-id='" & Container.Id & "'>"
                    embvideo.Text += "<img id='vimeoimg-" & mov_con.Fields("part_movie_movie_id").Value & "' src='" & imagesrc & "' alt='' />"
                    embvideo.Text += "</a>"
                Else
                    'Set Preview Image if defined, otherwise Vimeopreview will be loaded
                    If Not mov_con.Images("part_movie_previewimg").Filename = "" Then
                        imagesrc = mov_con.Images("part_movie_previewimg").Src
                    End If
                    embvideo.Text = "<a href='javascript:void(0);' data-href='https://player.vimeo.com/video/" & mov_con.Fields("part_movie_movie_id").Value & "?autoplay=" & autoplay & "' class='movielink bg-img' data-movie-autoplay='" & autoplay & "' data-movie-type='vimeo' data-height='" & val_h & "' data-width='" & val_w & "' data-movie-id='" & mov_con.Fields("part_movie_movie_id").Value & "' id='movielink_" & Container.Id & "' data-content-id='" & Container.Id & "'>"
                    embvideo.Text += "<img id='vimeoimg-" & mov_con.Fields("part_movie_movie_id").Value & "' src='" & imagesrc & "' alt='' />"
                    embvideo.Text += "</a>"
                End If
                embvideo.Text += "<s" & "cript type='text/javascript'>insymaVideo.createVIMEOSplashscreen(" & mov_con.fields("part_movie_movie_id").value & ");</s" & "cript>"
            End If
        Else
            '''''[FLASH/HTML5] ****************************************************************
            If Not mov_con.fields("part_movie_movie_url").value = "" Then
                ''''' externes Video entweder als Overlay oder embedded		
                moviesrc = mov_con.Fields("part_movie_movie_url").Value
            ElseIf Not mov_con.files("part_movie_movie_file").Filename = "" Then
                ''''' eigen hochgeladenes Video entweder als Overlay oder embedded
                moviesrc = mov_con.Files("part_movie_movie_file").Src
            End If

            If Not mov_con.Images("part_movie_previewimg").Filename = "" Then
                If CUPage.Preview Then
                    imagesrc = mov_con.Images("part_movie_previewimg").Src
                Else
                    imagesrc = mov_con.Images("part_movie_previewimg").Src
                End If
            Else
                imagesrc = "../img/layout/splashscreen.png"
            End If



            ''''Scriptzusammenbau
            'response.write("--: " & mov_con.fields("part_movie_movie_url").value)
            swfobj = "<s" & "cript type=""text/javascript"" charset=""utf-8"" src=""../js/swfobject.js""></s" & "cript>" & vbCrLf
            swfobj += "<div class='movie-holder'><div class='ratio-flash' style='padding-top:" & (val_h / val_w) * 100 & "%'></div>" & vbCrLf
            swfobj += "<div id='viddiv_" & container.id & "'>" & vbCrLf
            swfobj += "No Flash detected" & vbCrLf
            swfobj += "</div>" & vbCrLf

            swfobj += "<div id='cont_html5_viddiv_" & container.id & "' class='movie-holder' style='display: none;'><div class='splashscreen' style='background-image:url(" & imagesrc & ")'>" & vbCrLf
            swfobj += "<video id='html5_viddiv_" & container.id & "' controls='controls'  style='display: none;'>" & vbCrLf
            swfobj += "<source src='" & moviesrc & "' type='video/mp4'>" & vbCrLf
            swfobj += "</video>" & vbCrLf
            swfobj += "<div class='ratio' style='padding-top:" & (val_h / val_w) * 100 & "%'></div>" & vbCrLf
            swfobj += "<div class='playButton'></div>" & vbCrLf
            swfobj += "</div></div>" & vbCrLf
            swfobj += "</div>" & vbCrLf

            swfobj += "<s" & "cript type=""text/javascript"">" & vbCrLf
            swfobj += "//<!--" & vbCrLf
            swfobj += "var flashvars = {};" & vbCrLf
            swfobj += "    flashvars.mediaURL = """ & moviesrc & """;" & vbCrLf
            swfobj += "    flashvars.teaserURL = """ & imagesrc & """;" & vbCrLf
            swfobj += "    flashvars.allowSmoothing = ""true"";" & vbCrLf
            swfobj += "    flashvars.autoPlay = """ & autoplay & """;" & vbCrLf
            swfobj += "    flashvars.buffer = ""6"";" & vbCrLf
            swfobj += "    flashvars.showTimecode = ""true"";" & vbCrLf
            swfobj += "    flashvars.loop = ""false"";" & vbCrLf
            swfobj += "    flashvars.controlColor = ""0x3fd2a3"";" & vbCrLf
            swfobj += "    flashvars.controlBackColor = ""0x000000"";" & vbCrLf
            swfobj += "    flashvars.scaleIfFullScreen = ""true"";" & vbCrLf
            swfobj += "    flashvars.showScalingButton = ""true"";" & vbCrLf
            swfobj += "    flashvars.defaultVolume = ""100"";" & vbCrLf
            swfobj += "    flashvars.crop = ""false"";" & vbCrLf
            swfobj += "    flashvars.onstart = ""insymaVideo.pauseAllFlashVideos,nonverblaster_" & container.id & """;" & vbCrLf
            swfobj += "    //flashvars.onClick = ""toggleFullScreen"";" & vbCrLf

            swfobj += "var params = {};" & vbCrLf
            swfobj += "    params.menu = ""false"";" & vbCrLf
            swfobj += "    params.allowFullScreen = ""true"";" & vbCrLf
            swfobj += "    params.allowScriptAccess = ""always""" & vbCrLf
            swfobj += "    params.wmode = ""transparent""" & vbCrLf

            swfobj += "var attributes = {};" & vbCrLf
            swfobj += "    attributes.id = ""nonverblaster_" & container.id & """;" & vbCrLf
            swfobj += "    attributes.name = ""nonverblaster_" & container.id & """;" & vbCrLf
            swfobj += "    attributes.bgcolor = ""#000000""" & vbCrLf
            swfobj += "function embedSWF(){" & vbCrLf
            swfobj += "    swfobject.embedSWF(""../flash/NonverBlaster.swf"", ""viddiv_" & container.id & """, """ & val_w & """, """ & val_h & """, ""9"", ""../js/expressinstall.swf"", flashvars, params, attributes);" & vbCrLf
            swfobj += "}" & vbCrLf
            swfobj += "embedSWF();" & vbCrLf

            swfobj += "if(swfobject.hasFlashPlayerVersion('1')){$('#viddiv_" & container.id & "').show(); } else {$('#viddiv_" & container.id & ", .ratio-flash').hide(); $('#cont_html5_viddiv_" & container.id & "').show()}     " & vbCrLf

            swfobj += "    // -->" & vbCrLf
            swfobj += "</s" & "cript>" & vbCrLf
            ''''''wohin damit?
            If set_con.fields("part_movie_settings_overlay").value = "inside" Or set_con.fields("part_movie_settings_overlay").value = "" Then
                embvideo.Text = swfobj.Replace("style='display:none;'", "")
            Else
                embvideo.Text = "<a href='javascript:void(0);' class='movielink' id='movielink_" & container.id & "' data-content-id='" & container.id & "'>"
                embvideo.Text += "<img src='" & imagesrc & "' alt='' />"
                embvideo.Text += "</a>"
                overlayvideo.Text = swfobj
            End If
        End If


        If set_con.fields("part_movie_settings_overlay").value = "part_movie_settings_overlay" And set_con.fields("part_movie_settings_empfehlung").value = "yes" Then
            Dim beschr As New contentupdate.container
            beschr.loadByName("labelling_galerie")
            beschr.languageCode = CUPage.LanguageCode
            overlayvideo.Text += "<p class='label_fwLink' onclick='_getMailer(" & container.id & ")'>" & beschr.fields("label_fwLink").value & "</p>" & vbCrLf
            overlayvideo.Text += "<div id='mailer_" & container.id & "' class='hide'>" & vbCrLf
            overlayvideo.Text += "<form name='form_" & container.id & "' method='post' action='http://www.contentupdate.net/" & CuPage.Web.Caption & "/form/mailer_movie.aspx?lang=" & CUPage.LanguageCode & "'>" & vbCrLf
            overlayvideo.Text += "<ul>" & vbCrLf
            overlayvideo.Text += "<li><label>" & beschr.fields("label_fwSenderName").value & "</label><input type='text' name='AbsenderName' /></li>" & vbCrLf
            overlayvideo.Text += "<li><label>" & beschr.fields("label_fwSenderMail").value & "</label><input type='text' name='AbsenderMail' /></li>" & vbCrLf
            overlayvideo.Text += "<li><label>" & beschr.fields("label_fwRecipientMail").value & "</label><input type='text' name='Recipient' /></li>" & vbCrLf
            overlayvideo.Text += "<li><label>" & beschr.fields("label_fwComment").value & "</label><textarea rows='5' cols='20' name='Kommentar'></textarea></li>" & vbCrLf
            overlayvideo.Text += "<li><input type='submit' value='" & beschr.fields("label_fwButton").value & "' /><li>" & vbCrLf
            overlayvideo.Text += "<li id='hurra_" & container.id & "' class='hide'>" & beschr.fields("label_fwThanks").value & "</li>"
            overlayvideo.Text += "<li><input type='hidden' name='fwURL' value='" & CUPage.AbsoluteLink & "' />" & vbCrLf
            overlayvideo.Text += "<input type='hidden' name='popup$ECardInfo' value='" & beschr.fields("fwMessage").value & "' />" & vbCrLf
            overlayvideo.Text += "<input type='hidden' name='popup$Sender' value='" & beschr.fields("fwMailSender").value & "' />" & vbCrLf
            overlayvideo.Text += "<input type='hidden' name='popup$Subject' value='" & beschr.fields("fwSubject").value & "' /><li>" & vbCrLf
            overlayvideo.Text += "</ul>" & vbCrLf
            overlayvideo.Text += "</form>" & vbCrLf
            overlayvideo.Text += "</div>" & vbCrLf
        End If
    End Sub


</script>
<% if part_visible = true then %>
<div class="part part-movie">
	<figure>
	<asp:literal id="embvideo" runat="server" />
	</figure>
</div>

<% if set_con.fields("part_movie_settings_overlay").value = "overlay" AND mov_con.fields("part_movie_movie_plattform").value <> "Youtube" AND mov_con.fields("part_movie_movie_plattform").value <> "Vimeo" then %>
<div id="overlayMovie_<%=Container.ID %>" class='overlayMovie hide'>
        <asp:literal id="overlayvideo" runat="server" />
</div>
<% end if %>
<% end if %>


<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="System.Console" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Net" %>
<script runat="server">
    Dim labellingCon As New ContentUpdate.Container
    Dim conid As String = ""

    Dim whatmap As String = ""
    Dim coords As String = ""
    Dim center_coords As String = ""
    Dim zoom As String = ""
    Dim mapart As String = ""
    Dim addressdata As String = ""
    Dim staticaddress As String = ""
    Dim staticmarkers As String = ""
    Dim lat As String = ""
    Dim lan As String = ""
    Dim route As Boolean = False
    Dim cscheme As String = ""
    Dim controls As Boolean = "false"

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)

        conid = CStr(Container.Id)
        '' Laden des Beschriftungs-Containers
        'labellingCon.LoadByName("labelling_map")		
        labellingCon.Load(CUPage.Web.Rubrics("Web").Rubrics("Seiteneinstellungen").Pages("Beschriftungen").Containers("labelling_map").Id)
        labellingCon.LanguageCode = CUPage.LanguageCode
        labellingCon.Preview = CUPage.Preview

        If Container.Containers("gMapAdmin").Fields("gMapRoute").Value = "1" Then
            route = True
        End If


        Dim standard_con As New ContentUpdate.Container
        Dim list_con As New ContentUpdate.Container

        If Container.Containers("gMapAdmin").Id > 0 Then
            '' wenn nur ein Standort ausgegeben wird
            If Container.Containers("gMapAdmin").Fields("Kartenart").Value = "" Then
                mapart = "ROADMAP"
            Else
                mapart = Container.Containers("gMapAdmin").Fields("Kartenart").Value
            End If
            If Not Container.Containers("gMapAdmin").Fields("gMapColorScheme").Properties("value").Value = "" Then
                cscheme = Container.Containers("gMapAdmin").Fields("gMapColorScheme").Properties("value").Value
            Else
                cscheme = "normal"
            End If
            If Not Container.Containers("gMapAdmin").Fields("gmapcontrols").Value = "" Then
                controls = True
            End If

            If Container.Containers("gMapAdmin").Fields("gMapModus").Value = "Standort" Then
                standard_con.Load(Container.Containers("standort").Id)
                standard_con.LanguageCode = CUPage.LanguageCode
                standard_con.Preview = CUPage.Preview
                content.Name = standard_con.Id
                whatmap = "standort"

                If standard_con.Fields("map_coordinates").Value = "" Then
                    Dim tmpstr As String() = GetCoords(standard_con.Fields("map_strasse").Value & ", " & standard_con.Fields("map_plz").Value & " " & standard_con.Fields("map_ort").Value).split(",")
                    coords = tmpstr(0) & "," & tmpstr(1)
                    lat = tmpstr(0)
                    lan = tmpstr(1)
                    standard_con.Fields("map_coordinates").Value = coords
                Else
                    coords = standard_con.Fields("map_coordinates").Value
                    lat = coords.Split(",")(0)
                    lan = coords.Split(",")(1)
                End If
                '' die ermittelten Koordinaten für den Marker und die Zentrierung
                staticmarkers = coords
                center_coords = coords
                '' Zoomstufe bei Erstaufruf
                zoom = "13"
                '' Kartentype

                '' Zusammenbau des Infofensters
                markername.Text = "<h5>" & standard_con.Fields("map_standortbezeichnung").Value & "</h5>"
                markername.Text += standard_con.Fields("map_strasse").Value & "<br />"
                markername.Text += standard_con.Fields("map_plz").Value & " " & standard_con.Fields("map_ort").Value & "<br />"
                markername.Text += "<a href=""" & standard_con.Fields("map_web").Value & """ title="""" target=""_blank"">" & standard_con.Fields("map_web").Value & "</a>"
                staticaddress = standard_con.Fields("map_strasse").Value & "+" & standard_con.Fields("map_plz").Value & "+" & standard_con.Fields("map_ort").Value
                contid.Text = standard_con.Id
                '' bei anfänglicher Verwendung eines einzelnen Standortes wird hier jeder erfasste Standort in die (unsichtbare) Standortliste übertragen
                '' ==> sollt emal auf Liste umgestellt werden, liegen bereits verwendete Adresse schon vor
                If Container.Containers("standortliste").Id > 0 Then
                    If Container.Containers("standortliste").ObjectSets(1).Containers.Count > 0 Then
                        Dim newEntry As ContentUpdate.Container = Container.Containers("standortliste").ObjectSets(1).Containers(1)
                        newEntry.Fields("map_standortbezeichnung").Value = standard_con.Fields("map_standortbezeichnung").Value
                        newEntry.Fields("map_strasse").Value = standard_con.Fields("map_strasse").Value
                        newEntry.Fields("map_plz").Value = standard_con.Fields("map_plz").Value
                        newEntry.Fields("map_ort").Value = standard_con.Fields("map_ort").Value
                        newEntry.Fields("map_phone").Value = standard_con.Fields("map_phone").Value
                        newEntry.Fields("map_fax").Value = standard_con.Fields("map_fax").Value
                        newEntry.Fields("map_web").Value = standard_con.Fields("map_web").Value
                        newEntry.Fields("map_coordinates").Value = standard_con.Fields("map_coordinates").Value
                    End If
                End If
            End If
            '' Sollten mehrere Standort angezeigt werden
            If Container.Containers("gMapAdmin").Fields("gMapModus").Value = "Standortliste" Then
                list_con.Load(Container.Containers("standortliste").Id)
                list_con.LanguageCode = CUPage.LanguageCode
                list_con.Preview = CUPage.Preview
                whatmap = "standortliste"
                center_coords = ""
                zoom = "11"
                If Container.Containers("gMapAdmin").Fields("Kartenart").Value = "" Then
                    mapart = "ROADMAP"
                Else
                    mapart = Container.Containers("gMapAdmin").Fields("Kartenart").Value
                End If
                '' Zusammenbau der Daten zur Generierung eines JS-Arrays
                If list_con.ObjectSets("standortliste").Containers.Count > 0 Then
                    addressdata = "var data = [" & vbCrLf
                    For Each _tcon As ContentUpdate.Container In list_con.ObjectSets("standortliste").Containers

                        If _tcon.Fields("map_coordinates").Value = "" Then
                            Dim tmpstr As String() = GetCoords(_tcon.Fields("map_strasse").Value & ", " & _tcon.Fields("map_plz").Value & " " & _tcon.Fields("map_ort").Value).split(",")
                            coords = tmpstr(0) & "," & tmpstr(1)
                            _tcon.Fields("map_coordinates").Value = coords
                        Else
                            coords = _tcon.Fields("map_coordinates").Value
                        End If
                        If center_coords = "" Then
                            If list_con.Fields("center_coordinates").Value = "" Then
                                center_coords = coords
                            Else
                                center_coords = list_con.Fields("center_coordinates").Value
                            End If
                        End If
                        staticmarkers += "markers=color:red|" & coords & "&amp;"
                        addressdata += "{ name: """ & _tcon.Fields("map_standortbezeichnung").Value & """, addr: """ & _tcon.Fields("map_strasse").Value & ", " & _tcon.Fields("map_plz").Value & " " & _tcon.Fields("map_ort").Value & """, lat:'" & coords.Split(",")(0) & "', lng:'" & coords.Split(",")(1) & "', link:""" & _tcon.Fields("map_web").Value & """ }," & vbCrLf
                        staticaddress += _tcon.Fields("map_strasse").Value & "+" & _tcon.Fields("map_plz").Value & "+" & _tcon.Fields("map_ort").Value ' & ","
                    Next
                    lat = center_coords.Split(",")(0)
                    lan = center_coords.Split(",")(1)
                    addressdata = addressdata.Substring(0, addressdata.LastIndexOf(","))
                End If
            End If
        End If
        '' Marker-Icon erfasst? wenn nicht Google-Fallback
        If Not labellingCon.Images("icon").FileName = "" Then
            Dim p As String = ""
            If CUPage.Preview = True Then
                p = "cuimgpath/"
            End If
            iconPath.Text = labellingCon.Images("icon").Path & p & labellingCon.Images("icon").ProcessedFileName
            iconPath2.Text = labellingCon.Images("icon").Path & p & labellingCon.Images("icon").ProcessedFileName
        Else
            iconPath.Text = "http://labs.google.com/ridefinder/images/mm_20_red.png"
            iconPath2.Text = "http://labs.google.com/ridefinder/images/mm_20_red.png"
        End If

    End Sub

    '' Funktion zur Ermittlung der Koordinaten auf Basis der erfassten Adresse
    Function GetCoords(sURL)

        Dim sBuffer As String
        Dim st0 As String = ""
        Dim st1 As String = ""
        sURL = "http://maps.googleapis.com/maps/api/geocode/xml?address=" & System.Web.HttpUtility.UrlEncode(sURL) & "&sensor=false"

        'Response.Write(sURL)
        'Response.End()

        Dim oRequest As WebRequest = WebRequest.Create(sURL)
        oRequest.Method = "GET"
        Dim oResponse As WebResponse = oRequest.GetResponse()
        Dim oStream As New StreamReader(oResponse.GetResponseStream())
        sBuffer = oStream.ReadToEnd()
        oStream.Close()
        oResponse.Close()
        ReadLine()
        Dim plot As New Regex("(?<=<lat.*>).*?(?=</lat>)")
        Dim plot1 As New Regex("(?<=<lng.*>).*?(?=</lng>)")
        Dim Treffer As MatchCollection = plot.Matches(sBuffer)
        Dim Treffer1 As MatchCollection = plot1.Matches(sBuffer)
        For Each T0 As Match In Treffer
            If st0 = "" Then
                st0 = T0.ToString
            End If
        Next
        For Each T1 As Match In Treffer1
            If st1 = "" Then
                st1 = T1.ToString
            End If
        Next
        Return st0 & "," & st1
    End Function

    Protected Sub BindMap(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim contid As Literal = CType(e.Item.FindControl("contid"), Literal)
            Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
            contid.Text = con.Id
        End If
    End Sub
</script>

<div class="part part-map" id="con_<%=container.id%>">
        <div class="part-map-address">

            <%  If whatmap = "standort" Then %>
                <cu:cucontainer name="" id="content" runat="server">
		            <CU:CUField name="part_gmap_route_ueberschrift" runat="server" tag="h3" tagclass="h3 item-title"  />
                    <div class="part-map-holder">

                        <div class="con-address">
                            <ul class="list">
                                <CU:CUField name="map_standortbezeichnung" runat="server" tag="li" tagclass="title strong" />
                                <CU:CUField name="map_strasse" runat="server" tag="li" tagclass="strasse" />
                                <li><CU:CUField name="map_plz" runat="server" tag="span" tagclass="plz" />&nbsp;<CU:CUField name="map_ort" runat="server" tag="span" tagclass="ort" /></li>
                                <li>
                                    <ul class="con-address-contact-options">
                                        <li>
                                            <dl>
                                                <dt class="icon contacticon iconphone"><CU:CUField name="label_kontakt_phone" runat="server" /></dt>
                                                <dd><CU:CUField name="map_phone" runat="server" /></dd>
                                            </dl>
                                        </li>
                                        <li>
                                            <dl>
                                                <dt class="icon contacticon iconfax"><CU:CUField name="label_kontakt_fax" runat="server" /></dt>
                                                <dd><CU:CUField name="map_fax" runat="server" /></dd>
                                            </dl>
                                        </li>
                                        <li>
                	                        <dl>
                                                <dt class="icon contacticon iconweb"><CU:CUField name="label_kontakt_web" runat="server" /></dt>
						                        <dd><CU:CUField name="map_web" runat="server" /></dd>
                                            </dl>
                                        </li>
                                    </ul>
                                </li>
				                <% if route = True Then %>
                                    <li class="ItemRoute" style="display: none;"><span class="routenplan icon iconbefore iconroute href" onclick="insymaMapV3._showRoutePlanner('<%=container.id%>')"><CU:CUField name="gmaproute_lal_title" runat="server" /></span></li>
                                <% end If %>
                            </ul>
		                </div>
                        <div class="con-map">
	                        <div id="map_canvas" class="con-map-canvas"  style="background-image:url(../img/layout/placeholder-map-<%=CUPage.LanguageCode %>.png); background-position: center center; background-size:cover;"></div>
	                            <script type="text/javascript">
	                                var mapoptions = {
	                                    data: "",
	                                    icon: '<asp:literal id="iconPath" runat="server" />',
	                                    content: '<asp:literal id="markername" runat="server" />',
	                                    lat: <%=lat%>,
	                                    lng: <%=lan%>,
	                                    route: "<%=route%>",
	                                    type: "<%=mapart%>",
	                                    cscheme: "<%=cscheme%>",
	                                    controls: "<%=controls%>",
	                                    StreetView: "<%=container.containers("gMapAdmin").fields("gMapStreetView").value%>"
                                    }
                                   
	                                var $map , $cover;
	                                $map = $('.con-map-canvas');
	                                $cover = $('<div class="conMapCover con-map-cover"></div>');
	                                $map.append($cover);
	                                $cover.on('click', function () {
                                        var content = $("body > .dataprivacy-info.map");
                                        $.fancybox.open(content.clone());
                                        $(".fancybox-content .btnCancel").on("click", function(){
                                            $.fancybox.close();
                                        });
                                        $(".fancybox-content .btnAccept").on("click", function(){
                                            insymaMapV3._initScriptAPI(mapoptions, false);
                                            $("li.ItemRoute").show();
                                            $cover.remove();
                                            $.fancybox.close();
                                        });
                                    });
	                            </script>
                            </div>
                        </div>
                    </div>
            	</cu:cucontainer>
                <% If route = True Then %>
                    <div class="route_form form formular con-form part clearfix" id="route_<%=container.id%>" style="display: none;">
                    <hr />
                        <ul class="list">
                            <li>
                                <cu:cufield name="gmaproute_start" runat="server" tag="label" />
                                <input type="text" id="start" name="coord" value="" /></li>
                            <li>
                                <cu:cufield name="gmaproute_ziel" runat="server" tag="label" />
                                <input type="text" id="end" name="coord" value="" /></li>
                            <li>
                                <label></label>
                                <select id="mode">
                                    <option value="TRANSIT">
                                        <cu:cufield name="gmaproute_oev" runat="server" />
                                    </option>
                                    <option value="DRIVING">
                                        <cu:cufield name="gmaproute_auto" runat="server" />
                                    </option>
                                    <option value="WALKING">
                                        <cu:cufield name="gmaproute_zufuss" runat="server" />
                                    </option>
                                    <option value="BICYCLING">
                                        <cu:cufield name="gmaproute_velo" runat="server" />
                                    </option>
                                </select></li>
                            <li>
                        </ul>
                        <input type="button" name="button" value="Los!" onclick="insymaMapV3._calcRoute()" /></li>
                    </div>

                <% End If %>

            <% else %>
                <script type="text/javascript">
                    <%=addressdata & "];"%> 
                </script>
                <cu:cucontainer name="standortliste" runat="server">
        		    <CU:CUField name="part_gmap_route_standort_ueberschrift" runat="server" tag="h3" tagclass="h3 item-title" />
                    <div class="part-map-holder">
	                    <CU:CUObjectSet name="standortliste" runat="server" OnItemDataBound="BindMap">
                            <headertemplate>        
                                <div class="con-address">
                            </headertemplate>
                            <itemtemplate>
                                    <ul class="list">
				                <li>
                                    <ul class="list" id='map_li_<asp:literal id="contid" runat="server"/>'>
                                        <CU:CUField name="map_standortbezeichnung" runat="server" tag="li" tagclass="title strong" />
                                        <CU:CUField name="map_strasse" runat="server" tag="li" tagclass="strasse" />
                                        <li><CU:CUField name="map_plz" runat="server" tag="span" tagclass="plz" />&nbsp;<CU:CUField name="map_ort" runat="server" tag="span" tagclass="ort" /></li>
                                        <li>
                                            <ul class="con-address-contact-options">

                                                <li>
			                                        <dl>
			                                            <dt class="icon contacticon iconphone"><CU:CUField name="label_kontakt_phone" runat="server" /></dt>
			                                            <dd><CU:CUField name="map_phone" runat="server" /></dd>
			                                        </dl>
			                                    </li>
			                                    <li>
			                                        <dl>
			                                            <dt class="icon contacticon iconfax"><CU:CUField name="label_kontakt_fax" runat="server" /></dt>
			                                            <dd><CU:CUField name="map_fax" runat="server" /></dd>
			                                        </dl>
			                                    </li>
			                                    <li>
			                                        <dl>
			                                            <dt class="icon contacticon iconweb"><CU:CUField name="label_kontakt_web" runat="server" /></dt>
								                        <dd><CU:CUField name="map_web" runat="server" /></dd>
			                                        </dl>
			                                    </li>
                                            </ul>
                                        </li>
                                        <% if route = True Then %>
                                            <li class="ItemRoute" style="display: none;"><span class="routenplan icon iconbefore iconroute href" onclick="insymaMapV3._setFormVal(<%# CType(Container.DataItem, ContentUpdate.Container).ID %>)"><CU:CUField name="gmaproute_lal_title" runat="server" /></span></li>
                                        <% end if %>
                                    </ul>
				                </li>
                                    </ul>
                            </itemtemplate>
                            <footertemplate>
                                </div>
                                </footertemplate> 
	                    </CU:CUObjectSet>

	            </cu:cucontainer>


    
           <div class="con-map">

                <div id="map_canvas" class="part-map-googlemap con-map-canvas" style="background-image:url(../img/layout/placeholder-map-<%=CUPage.LanguageCode %>.png); background-position: center center; background-size:cover;"></div>
                    <script type="text/javascript">
                        var mapoptions = {
                            data: data,
                            icon: '<asp:literal id="iconPath2" runat="server" />',
                            content: "",
                            lat: <%=lat%>,
                            lng: <%=lan%>,
                            route: "<%=route%>",
                            type: "<%=mapart%>",
                            cscheme: "<%=cscheme%>",
                            controls: "<%=controls%>",
                            StreetView: "<%=container.containers("gMapAdmin").fields("gMapStreetView").value%>"
                        }
		                

                        var $map
                            , $cover
                        ;
                        $map = $('.con-map-canvas');
                        $cover = $('<div class="conMapCover con-map-cover"></div>');
                        $map.append($cover);
                        $cover.on('click', function () {
                            var content = $("body > .dataprivacy-info.map");
                            $.fancybox.open(content.clone());
                            $(".fancybox-content .btnCancel").on("click", function(){
                                $.fancybox.close();
                            });
                            $(".fancybox-content .btnAccept").on("click", function(){
                                insymaMapV3._initScriptAPI(mapoptions, true);
                                $("li.ItemRoute").show();
                                $cover.remove();
                                $.fancybox.close();
                            });
                        });

                     
                    </script>
                </div>
           </div>

            <%  If route = True Then %>

                <div class="route_form form formular con-form" style="display: none;">
                    <hr />
                    <ul class="list">
                        <li>
                            <cu:cufield name="gmaproute_start" runat="server" tag="label" />
                            <input type="text" id="start" name="coord" value="" /></li>
                        <li>
                            <cu:cufield name="gmaproute_ziel" runat="server" tag="label" />
                            <input type="text" id="end" name="coord" value="" /></li>
                        <li>
                            <label></label>
                            <select id="mode">
                                <option value="TRANSIT">
                                    <cu:cufield name="gmaproute_oev" runat="server" />
                                </option>
                                <option value="DRIVING">
                                    <cu:cufield name="gmaproute_auto" runat="server" />
                                </option>
                                <option value="WALKING">
                                    <cu:cufield name="gmaproute_zufuss" runat="server" />
                                </option>
                                <option value="BICYCLING">
                                    <cu:cufield name="gmaproute_velo" runat="server" />
                                </option>
                            </select>
                        </li>
                    </ul>
                    <input type="button" name="button" value="Los!" onclick="insymaMapV3._calcRoute()" />
                </div>
                <div id="directionsPanel" class="part part-directions-panel"></div>
            <% end if %></div>
        <%  End If %>
</div>
<!--
<asp:literal id="contid" runat="server" />
-->

<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<script runat="server">
dim chef
dim chefid
dim returnvalue as string
dim aAbteilung as integer
dim counterId as integer = 0
dim abteilg as string = ""
Dim senden as string = ""
dim afunction as string
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
    	''Beschriftung(en) laden
		Dim Beschriftung as new ContentUpdate.Container
		Beschriftung.LoadByName("organigramm_beschriftung")
		senden = Beschriftung.fields("organigramm_key_mailsenden").value
		'' LAden des Containers, wo Liste mit Verknüpfungen hinterlegt
		dim cont as new ContentUpdate.Container()
		cont.loadByName("organigramm_verbindungen")
		getContent.Name = cont.objectsets("culist_organigramm_verbindungen").Id
		'' Auslesen der obersten Ebene
		chefid = cont.fields("oberste_ebene").properties("value").value
		chef = cont.fields("oberste_ebene").value
		abteilg = cont.fields("oberste_ebene").value
		'' Ausgeben der obersten Ebene
		if ( not cont.fields("oberste_ebene").value = "" ) then
			chefe.Text = "<h4>" & cont.fields("oberste_ebene").value & "</h4>"
		end if
		'' Laden der Mitarbeiter-Daten
		cont.loadByName("organigramm_kontakte")
		Dim x as integer = 0
		Dim y as integer = 0

		if cont.ObjectSets("culist_organigramm_kontakte").containers.count > 0 then
			chefs.text += "<p>"
			for x = 1 to cont.ObjectSets("culist_organigramm_kontakte").containers.count
				dim con as new ContentUpdate.Container()
				'' Zusammenbau der obersten Ebene
				con.load(cont.ObjectSets("culist_organigramm_kontakte").containers(x).id)
				afunction = ""
				afunction = con.fields("entry_organigramm_kontaktfunktion").value
				if con.ObjectSets("entry_organigramm_kontakt_culist_abteilung").containers.count > 0 then
					for y = 1 to con.ObjectSets("entry_organigramm_kontakt_culist_abteilung").containers.count
						if con.ObjectSets("entry_organigramm_kontakt_culist_abteilung").containers(y).fields("entry_organigramm_kontakt_abteilung").properties("value").value = chefid then
							if not con.ObjectSets("entry_organigramm_kontakt_culist_abteilung").containers(y).fields("entry_organigramm_kontaktfunktion").value = "" then
								afunction = con.ObjectSets("entry_organigramm_kontakt_culist_abteilung").containers(y).fields("entry_organigramm_kontaktfunktion").value
							end if
							counterId = counterId + 1
							chefs.text += "<span id='span_" & counterId & "' onclick=""__getContact('" & cont.ObjectSets("culist_organigramm_kontakte").containers(x).Fields("entry_organigramm_kontaktname").id & "', this.id, '" & abteilg & "', '" & afunction & "')"">&raquo; " & cont.ObjectSets("culist_organigramm_kontakte").containers(x).Fields("entry_organigramm_kontaktvorname").value & " " & cont.ObjectSets("culist_organigramm_kontakte").containers(x).Fields("entry_organigramm_kontaktname").value & "</span>"
						end if
					next
				end if
			next
			chefs.text += "</p>"
		end if 
	End Sub	
	
	'' Funktion zur Suche und Ausgabe von den Kontakten einer Abteilung
	Function _getContacts(aAbteilung)
		returnvalue = ""
		dim contact_con as new ContentUpdate.Container()
		dim abt as new contentUpdate.Field()
		if not cstr(aAbteilung) = "" then
			abt.load(aAbteilung)
			dim counter as integer = 1
			Dim x as integer = 0
			Dim y as integer = 0
			contact_con.loadByName("organigramm_kontakte")
			
			if contact_con.ObjectSets("culist_organigramm_kontakte").containers.count > 0 then
				for x = 1 to contact_con.ObjectSets("culist_organigramm_kontakte").containers.count
					dim con as new ContentUpdate.Container()
					con.load(contact_con.ObjectSets("culist_organigramm_kontakte").containers(x).id)
					afunction = ""
					afunction = con.fields("entry_organigramm_kontaktfunktion").value
					if con.ObjectSets("entry_organigramm_kontakt_culist_abteilung").containers.count > 0 then
						for y = 1 to con.ObjectSets("entry_organigramm_kontakt_culist_abteilung").containers.count
							if con.ObjectSets("entry_organigramm_kontakt_culist_abteilung").containers(y).fields("entry_organigramm_kontakt_abteilung").properties("value").value = aAbteilung then
								if not con.ObjectSets("entry_organigramm_kontakt_culist_abteilung").containers(y).fields("entry_organigramm_kontakt_abteilung_funktion").value = "" then
									afunction = con.ObjectSets("entry_organigramm_kontakt_culist_abteilung").containers(y).fields("entry_organigramm_kontakt_abteilung_funktion").value
								end if 
								counterId = counterId + 1
								'returnvalue += "<span id='span_" & counterId & "' onclick=""__getContact('" & contact_con.ObjectSets("culist_mitarbeiter").containers(x).Fields("name").value.Replace(" ", "_") & "', this.id, '" & abt.value & "')"">&raquo; " & contact_con.ObjectSets("culist_mitarbeiter").containers(x).Fields("name").value & "</span>"
								returnvalue += "<span id='span_" & counterId & "' onclick=""__getContact('" & contact_con.ObjectSets("culist_organigramm_kontakte").containers(x).Fields("entry_organigramm_kontaktname").id & "', this.id, '" & abt.value & "', '" & afunction & "')"">&raquo; " & contact_con.ObjectSets("culist_organigramm_kontakte").containers(x).Fields("entry_organigramm_kontaktvorname").value & " " & contact_con.ObjectSets("culist_organigramm_kontakte").containers(x).Fields("entry_organigramm_kontaktname").value & "</span>"
								exit for
							end if
						next
					end if
				next
				Return returnvalue
			end if 
		end if
	End Function
	
	'' Funktion zur Suche und Ausgabe untergeordneter Abteilungen
	Function _getChilds(aAbteilung)
		returnvalue = ""
		dim child_con as new ContentUpdate.Container()
		dim counter as integer = 1
		Dim x as integer = 0
		Dim y as integer = 0
		child_con.loadByName("organigramm_verbindungen")
		if child_con.ObjectSets("culist_organigramm_verbindungen").containers.count > 0 then
			for x = 1 to child_con.ObjectSets("culist_organigramm_verbindungen").containers.count
				dim con as new ContentUpdate.Container()
				con.load(child_con.ObjectSets("culist_organigramm_verbindungen").containers(x).id)
				if con.ObjectSets("culist_topabteilung").containers.count > 0 then
					for y = 1 to con.ObjectSets("culist_topabteilung").containers.count
						if con.ObjectSets("culist_topabteilung").containers(y).fields("entry_topabteilung").properties("value").value = aAbteilung then
							returnvalue += "<li><div class='container'><h4>" & child_con.ObjectSets("culist_organigramm_verbindungen").Containers(x).Fields("entry_organigramm_abteilung").value & "</h4><p>" 
							returnvalue += _getContacts(child_con.ObjectSets("culist_organigramm_verbindungen").Containers(x).Fields("entry_organigramm_abteilung").properties("value").value) & "</div>"
							returnvalue += "<ul>"
							returnvalue += _getChilds(child_con.ObjectSets("culist_organigramm_verbindungen").Containers(x).Fields("entry_organigramm_abteilung").properties("value").value)
							returnvalue += "</ul>"
							returnvalue += "</p></li>"
							exit for
						end if
					next
				end if
			next
			Return returnvalue
		end if 
	End Function
	
	
	Sub BindItem(sender as object, e as RepeaterItemEventArgs)
		If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
			Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
			Dim ebenen As Literal = CType(e.Item.FindControl("ebenen"), Literal)
			abteilg = con.fields("entry_organigramm_abteilung").value
			Dim x as integer = 0
			Dim y as integer = 0
			if con.ObjectSets("culist_topabteilung").containers.count > 0 then
				for x = 1 to con.ObjectSets("culist_topabteilung").containers.count 
					'response.write("<br />-- " & con.ObjectSets("culist_topabteilung").containers(x).fields("entry_topabteilung").properties("value").value & " = " & chefid)
					if con.ObjectSets("culist_topabteilung").containers(x).fields("entry_topabteilung").properties("value").value = chefid then
						ebenen.Text += "<li><div class='container'><h4>" & con.fields("entry_organigramm_abteilung").value & "</h4>"
						'response.write("<br />--: " & con.fields("entry_topabteilung").properties("value").value)
						ebenen.Text += "<p>" & _getContacts(con.fields("entry_organigramm_abteilung").properties("value").value) & "</p></div>"
						ebenen.Text += "<ul>"
						ebenen.text += _getChilds(con.fields("entry_organigramm_abteilung").properties("value").value) 
						ebenen.Text += "</ul>"
						ebenen.Text += "</li>" 
						exit for
					end if 
				next
			end if
			
		end if
	end sub
	
	Sub ContactBindItem(sender as object, e as RepeaterItemEventArgs)
		If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
			Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
			Dim li_visible As Literal = CType(e.Item.FindControl("li_visible"), Literal)
			Dim mailname as Literal = ctype(e.item.findControl("mailname"), Literal)
			Dim img_id As Literal = CType(e.Item.FindControl("img_id"), Literal)
			Dim p_id As Literal = CType(e.Item.FindControl("p_id"), Literal)
			mailname.text = senden
			if con.fields("entry_organigramm_kontaktname").value = ""
				e.item.visible = false
			else
				li_visible.text = "style='display:none;background-color:#CCC; border:1px solid #999; padding:10px;' id='div_" & con.fields("entry_organigramm_kontaktname").id & "'"
				img_id.text = "div_" & con.fields("entry_organigramm_kontaktname").id
				p_id.text = "p_" & con.fields("entry_organigramm_kontaktname").id
				
			end if	
		end if
	end sub

</script>

	<div class='ebene_0'>
    	<asp:Literal id="chefe" runat="server" />
    	<asp:Literal id="chefs" runat="server" />
    </div>
	<CU:CUObjectSet name="" id="getContent" runat="server" OnItemDataBound="BindItem">
		<HeaderTemplate><ul></HeaderTemplate>
		<ItemTemplate>
			<asp:Literal id="ebenen" runat="server" />
		</ItemTemplate>
		<FooterTemplate></ul></FooterTemplate>
	</CU:CUObjectSet>
</div>     
<CU:CUObjectSet name="culist_organigramm_kontakte" runat="server" OnItemDataBound="ContactBindItem">
    <HeaderTemplate></HeaderTemplate>
    <ItemTemplate>
        <div class="orgi_contact" <asp:Literal id="li_visible" runat="server" /> >
        <img src='../img/layout/gallery-control-close.gif' id='<asp:Literal id="img_id" runat="server" />' alt='Schliessen' onclick="JavaScript:_ContactLayerClose(this.id);" />
            <div class="level2"></div>
            <div class="data">
            
            <% if CUPage.Preview = true then %>
                <CU:CUImage name="entry_organigramm_kontaktbild" runat="server" Preview="true"  />
            <% else %>
                <CU:CUImage name="entry_organigramm_kontaktbild" runat="server"  />
            <% end if %>
            <div class="text">
            <h4><CU:CUField name="entry_organigramm_kontaktvorname" runat="server" /> <CU:CUField name="entry_organigramm_kontaktname" runat="server" /></h4>
            <p id='<asp:Literal id="p_id" runat="server" />'><CU:CUField name="entry_organigramm_kontaktfunktion" runat="server" /></p>
             <CU:CULink name="entry_organigramm_kontaktmail" runat="server" tag="p" tagClass="email">
                <asp:Literal id="mailname" runat="server" />
            </CU:CULink>
            <CU:CUField name="entry_organigramm_kontakttelefon" runat="server" tag="p"/>
            
            <span></span>
            
            </div>
            </div>
        </div>
    </ItemTemplate>
    <FooterTemplate></FooterTemplate>
</CU:CUObjectSet>
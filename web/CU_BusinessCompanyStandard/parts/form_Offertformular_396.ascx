<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl"  %>
<script runat="server">
	Dim CUContainer as ContentUpdate.Container
	Dim CUForm1 as ContentUpdate.Form
	Dim Redirect as String
	Dim PostURL as String
	Dim host As String
	Dim CUEntry as ContentUpdate.Container
	Dim ProductCounter as Integer
	Dim strRedirect as String 'SCHM
	
	Sub Page_Load(Src As Object, E As EventArgs)  
		CUForm1 = new ContentUpdate.Form()
		CUForm1.Load(Container.ID)
		CUForm1.LanguageCode = Container.LanguageCode

		'Redirect auf neue Seite
		If Container.Properties("Redirect").Value = "" Then 'SCHM
			If not Container.Containers("Standard").Links("ThanksPage").Properties("Value").Value = "" then
				If Container.Containers("Standard").Links("ThanksPage").Properties("Intern").Value.toLower() <> "true"  then
					strRedirect = Container.Containers("Standard").Links("ThanksPage").Properties("Value").Value
				else
					Dim TempPage as new ContentUpdate.Page
					TempPage.load(cInt(Container.Containers("Standard").Links("ThanksPage").Properties("Value").Value))
					TempPage.LanguageCode = CUPage.LanguageCode
					TempPage.Preview = CUPage.Preview
					if CUPage.Preview = true then
						strRedirect = TempPage.Link
					else
						strRedirect = CUPage.Web.LiveServer  & TempPage.Link
					end if
				End if
			else
		'Redirect Meldung
				if CUPage.Preview = true then
					strRedirect = CUPage.Link & "&thanks=1"
				else
					strRedirect = CUPage.Web.LiveServer  & CUPage.Link & "?thanks=1"
				end if
			End if
		else
			strRedirect= Container.Properties("Redirect").Value
		End if 'SCHM

		PostURL = CUPage.Web.TemplateServer & "/" & CUPage.Web.Caption & "/form/mailer.aspx?form_id=" & CUForm1.Id & "&lang=" & CUPage.LanguageCode
		CUContainer = CUForm1.Containers("Standard")
		host = CUPage.Web.LiveServer & CUPage.Web.LivePath & "html/"
        dim cpage as new contentupdate.page()
        cpage.load(CUForm1.pages("CaptchaPage").id)
        if cpage.properties("filename").value.Contains("[id]") = true then
            cpage.properties("filename").value = cpage.properties("filename").value.replace("[id]", cpage.id)
        end if
	End Sub
	
	Private Sub BindItem(Sender As Object, e As RepeaterItemEventArgs)
		If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
			Dim questionField As ContentUpdate.Question = CType(e.Item.DataItem, ContentUpdate.Question)
			questionField.Preview = CUPage.Preview
			Container.Containers("Captcha").ParentPages("CaptchaPage").Preview = CUPage.Preview
			if questionField.Properties("QuestionType").Value = "7" then
				if CUPage.Preview then
					questionField.Answers(1).Properties("Rows").Value = Container.Containers("Captcha").ParentPages("CaptchaPage").Link
				else
					questionField.Answers(1).Properties("Rows").Value = CUPage.Web.LiveServer & Container.Containers("Captcha").ParentPages("CaptchaPage").Link
				end if
			end if
		End If
	End Sub
</script>

<div class="part part-formular part-formular-offerte con-form clearfix">
	<%if CUContainer.Fields("Titel").value <> "" Then%>
        <%=CUContainer.Fields("Titel").value %>
    <%End If%>
    
    <CU:CUForm id="form_Standardformular" name="form_Standardformular" method="post" runat="server" FormTest=true SubmitButton=true Summary="Header">
    
        <input type="hidden" name="Redirect" value='<%=strRedirect%>' />
        <input type="hidden" name="save" value="true" />
        <input type="hidden" name="nlStatus" value="newsletter" />
        <input type="hidden" name="LanguageID" value="<%=CUPage.LanguageCode%>" />
        <input type="hidden" name="MailFormatID" value="1" />
        <input type="hidden" name="Newsletter" value="1" />
    
        <input type="hidden" name="PostURL" value="<%=PostURL%>" />
        <input type="hidden" name="Source" value="Website Kontakt" />
        <input type="hidden" name="PostEncoding" value="iso-8859-1" />
    
    
        <CU:CUFormFields name="Standard" runat="server" onItemDataBound="BindItem">
            <HeaderTemplate>
                <div id="Message" class="Message" style="display: none;">
                    <p><%=CUContainer.Fields("Thanks").value %></p>
                </div>
        <table border="1">
        <% if Container.Containers("standard").ObjectSets("CUList").Containers.count > 0 then %>
        <tr>
        <th><%=Container.Containers("standard").ObjectSets("CUList").Containers(1).Fields("Artikel").Properties("Caption").value%></th>
    
        <th><%=Container.Containers("standard").ObjectSets("CUList").Containers(1).Fields("Menge").Properties("Caption").value%></th>
        <th><%=Container.Containers("standard").ObjectSets("CUList").Containers(1).Fields("Preis").Properties("Caption").value%></th>
        <th>
        <%
            if CUPage.LanguageCode = 0 then 
                response.write("Anzahl")
            else 
                response.write("Nombre")
            end if
            %>
            </th>
        </tr>
        <% end if %>
        <%
        For each CUEntry in Container.Containers("standard").ObjectSets("CUList").Containers
        %>
            <tr>
                <td><input name="Artikel<%=ProductCounter%>" type="hidden" value="<%=CUEntry.Fields("Artikel").value%>"/><%=CUEntry.Fields("Artikel").value%></td>
                <td><input name="Menge<%=ProductCounter%>" type="hidden" value="<%=CUEntry.Fields("Menge").value%>"/><%=CUEntry.Fields("Menge").value%></td>
                <td><input name="Preis<%=ProductCounter%>" type="hidden" value="<%=CUEntry.Fields("Preis").value%>"/><%=CUEntry.Fields("Preis").value%></td>
                <td><input name="Anzahl<%=ProductCounter%>" type="text" class="anzahl" /></td>
            </tr>
        <%
        ProductCounter = ProductCounter + 1
        next
        %>
        <tr><th colspan="3"><br/><%=Container.Containers("standard").Fields("EigeneProdukte").value %></th><th><br/><%=Container.Containers("standard").Fields("EigeneProdukte2").value %></th></tr>
    
        <%
        dim i
        for i=0 to 5
        %>
        <tr>
            <td colspan="3"><input name="ZusatzArtikel<%=i%>" type="text" class="zusatzartikel"/></td>
            <td><input name="ZusatzAnzahl<%=i%>" type="text" class="anzahl" /></td>
        </tr>
        <% next %>
    
        </table>
        <input name="ProductCounter" type="hidden" value="<%=ProductCounter%>"/>
        <input name="ZusatzCounter" type="hidden" value="5"/>
                <div class="validation validation-info"><%=CUContainer.Fields("validationinfo").value %></div>
                <ul class="clearfix con-form-data">
            </HeaderTemplate>
            <ItemTemplate>
                <CU:CUFormField tag="li" container="Standard" runat="server" property="Value" />
                <CU:CUFormField tag="label" container="Standard" runat="server" property="Value" />
                <CU:CUFormField container="Standard" id="quest" runat="server" />
                </li>
            </ItemTemplate>
    
            <FooterTemplate>		    
                </ul>
            </FooterTemplate>
        </CU:CUFormFields>
    </CU:CUForm>
    <script type="text/javascript">
		if (insymaUtil.getQuerystring("danke") == '1'){
			document.getElementById('Message').style.display = 'block';
		}
        <CU:CUContainer name="standard" runat="server">
        var lnk = '<CU:CULink name="private_policy_link" runat="server" />';
        var lnktxt = '<CU:CULink name="private_policy_link" runat="server" property="description" />';
        </CU:CUContainer>
        $("body").append("<div id='temp'></div>");
        $("#temp").html(lnktxt);
        lnktxt = $("#temp").text();
        $("#temp").remove();
        $("#form_Standardformular_<%=CUForm1.ID%> label").each(function(){

            if($(this).html().indexOf(lnktxt) > -1)
            {
                var htm = $(this).html().replace(lnktxt,lnk);
                $(this).html(htm);
                return false;
            }    
        });
        var formcook = "insymaFormValues";
        if($.cookie(formcook)){
            var vals = $.cookie(formcook);
            vals = vals.substring(0, vals.length-1);
            var arr_vals = vals.split("¬");
            for(var i = 0; i < arr_vals.length; i++)
            {
                var txt = arr_vals[i].split("~")[0];
                switch(txt){
                    case "text":
                        $("#" + arr_vals[i].split("~")[1]).val(arr_vals[i].split("~")[2]);
                        break;
                    case "cb":
                        $("#" + arr_vals[i].split("~")[1]).attr("checked", true);
                        break;
                    case "radio":
                        $("#" + arr_vals[i].split("~")[1]).attr("checked", true);
                        break;
                    case "select":
                        $("#" + arr_vals[i].split("~")[1]).find("option[value='" + arr_vals[i].split("~")[2] + "']").attr("selected", true);
                        break;
                }
            }
        };
        $("input[name='submitbutton']").on("click", function(){
           
            var htm = "";
            $("div.formular ul input[type='text']").each(function(){
                    htm += "text~" + $(this).attr("id") + "~" + $(this).val() + "¬";
            });
            $("div.formular ul input[type='checkbox']").each(function(){
                if($(this).prop("checked")==true)
                    htm += "cb~" + $(this).attr("id") + "~" + $(this).val() + "¬";
            });
            $("div.formular ul input[type='radio']").each(function(){
                if($(this).prop("checked")==true)
                    htm += "radio~" + $(this).attr("id") + "~" + $(this).val() + "¬";
            });
            $("div.formular ul textarea").each(function(){
               htm += "text~" + $(this).attr("id") + "~" + $(this).val() + "¬";
            });
            $("div.formular ul select").each(function(){
               htm += "select~" + $(this).attr("id") + "~" + $(this).val() + "¬";
            });
            $.cookie(formcook, htm, { expires: 0 })
           
        });
    </script>
</div>
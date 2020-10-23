<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl"  %>
<script runat="server">
	Dim CUContainer as ContentUpdate.Container
	Dim CUForm1 as ContentUpdate.Form
	Dim Redirect as String
	Dim PostURL as String
	Dim host As String
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

<div class="part part-formular con-form clearfix">
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
                <div id="Message0" class="Message validation validation-message" style="display: none;">
                    <span class="validation-message-text"><%=CUForm1.Containers("labelling").fields("dankestext_0").value %></span>
                </div>
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
                <span class="submitLoader hide">
                    <span class="submitLoader-loading">
                        <span class="wBall wBall_1"><span class="wInnerBall"></span></span>
                        <span class="wBall wBall_2"><span class="wInnerBall"></span></span>
                        <span class="wBall wBall_3"><span class="wInnerBall"></span></span>
                        <span class="wBall wBall_4"><span class="wInnerBall"></span></span>
                        <span class="wBall wBall_5"><span class="wInnerBall"></span></span>
                    </span>
                    <span class='submitLoader-text'>
                        Formular wird versendet!
                        <a class="submitLoader-enable">Abbrechen</a>
                    </span>
                </span>
            </FooterTemplate>
        </CU:CUFormFields>
    </CU:CUForm>
    <script type="text/javascript">
        if (insymaUtil.getQuerystring("thanks") === '0'){
            document.getElementById('Message0').style.display = 'block';
            $("div.part-formular > form > ul").hide();
            $("div.part-formular > form > p").hide();
        }
        var f = "#" + $(".formular > form").eq(0).attr("id");
        $(f).submit(function(){
            $("input.Validate").parent("li").addClass("notvalid");
        });
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
        var formcook = "insymaFormValues_<%=CUPage.Web.Caption.replace(" ", "")%>";
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
            $("div.part-formular ul input[type='text']").each(function(){
                    htm += "text~" + $(this).attr("id") + "~" + $(this).val() + "¬";
            });
            $("div.part-formular ul input[type='checkbox']").each(function(){
                if($(this).prop("checked")==true)
                    htm += "cb~" + $(this).attr("id") + "~" + $(this).val() + "¬";
            });
            $("div.part-formular ul input[type='radio']").each(function(){
                if($(this).prop("checked")==true)
                    htm += "radio~" + $(this).attr("id") + "~" + $(this).val() + "¬";
            });
            $("div.part-formular ul textarea").each(function(){
               htm += "text~" + $(this).attr("id") + "~" + $(this).val() + "¬";
            });
            $("div.part-formular ul select").each(function(){
               htm += "select~" + $(this).attr("id") + "~" + $(this).val() + "¬";
            });
            $.cookie(formcook, htm, { expires: 0 })
           
        });
    </script>
</div>
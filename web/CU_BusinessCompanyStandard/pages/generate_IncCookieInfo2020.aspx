<%@ Page Language="VB" ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage" %>

<script runat="server">

    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)

    End Sub
    Protected Sub BindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
	   	If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
			Dim checkbox As Literal = CType(e.Item.FindControl("checkbox"), Literal)
			Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
			con.LanguageCode = CUPage.LanguageCode
			con.Preview = CUPage.Preview
			dim edit as string = "disabled='disabled' checked='checked'"
			dim css as string = " class='checked'"
			if not con.fields("zenconcookieinfo_entry_categoryselectable").value = "" Then
				edit = ""
				css = ""
			end if
			checkbox.Text = "<ol class=""CheckBox"">" _
				& "<li><input type='checkbox' id='icb_" & con.id & "' name='icb_" & e.item.itemindex & "' value='1' " & edit & css & " />" _
				& "<label for='icb_" & con.id & "'>" & con.fields("zenconcookieinfo_entry_categoryname").value & "</label></li></ol>" 
		End If
	End Sub

</script>

<div class="control cookieinfo cookieinfo-extended" style="display: none;">
	<div class="holder">
	<cu:cucontainer name="zenConCookieInfo" runat="server">
    	<div class="" style="">
			<header class="dialog-header">
				<a class="link-back back-link extendedcontent button" href="Javascript:void();" title='<CU:CUField name="zenconcookieinfo_label_back" runat="server" />'><i class="icon icon-back"></i><CU:CUField name="zenconcookieinfo_label_back" runat="server" /></a>
				<CU:CUField name="zenconcookieinfo_title" runat="server" tag="h3" tagclass="dialog-title" />
			</header>
			<CU:CUField name="zenconcookieinfo_textlink" runat="server" tag="div" tagclass="liststyle startcontent" />
			<CU:CUObjectSet name="zenconcookieinfo_culist" runat="server" OnItemDataBound="BindItem">
			<headertemplate><div class="con-form"><ul class="clearfix con-form-data"></headertemplate>
			<ItemTemplate>
				<li>
					<asp:literal id="checkbox" runat="server" />
					<div class="extendedcontent checkbox-extended-content">
						<hr>
						<CU:CUField name="zenconcookieinfo_entry_categorytext" runat="server" tag="div" tagclass="liststyle extendedcontent" />
						<CU:CUObjectSet name="zenconcookieinfo_sublist" runat="server" >
							<headertemplate>
								<div class="con-table ">
								<table cellspacing="2" class="extendedcontent">
									<tr>
										<CU:CUField name="zenconcookieinfo_label_name" runat="server" tag="th" />
										<CU:CUField name="zenconcookieinfo_label_purpose" runat="server" tag="th" />
										<CU:CUField name="zenconcookieinfo_label_livetime" runat="server" tag="th" />
										<CU:CUField name="zenconcookieinfo_label_type" runat="server" tag="th" />
										<CU:CUField name="zenconcookieinfo_label_provider" runat="server" tag="th" />
								</tr>
							</headertemplate>
							<footertemplate></table></div></footertemplate>
							<ItemTemplate>
								<tr>
									<CU:CUField name="zenconcookieinfo_subentry_name" runat="server" tag="td" />
									<CU:CUField name="zenconcookieinfo_subentry_desc" runat="server" tag="td" />
									<CU:CUField name="zenconcookieinfo_subentry_livetime" runat="server" tag="td" />
									<CU:CUField name="zenconcookieinfo_subentry_type" runat="server" tag="td" />
									<CU:CUField name="zenconcookieinfo_subentry_provider" runat="server" tag="td" />
								</tr>
							</ItemTemplate>
						</CU:CUObjectSet>
					</div>
				</li>
			</ItemTemplate>
			<footertemplate></ul></div>
			</footertemplate>
		</CU:CUObjectSet>
			<footer class="dialog-footer">
				<div class="buttons">
					<CU:CUField name="zenconcookieinfo_btn_details" runat="server" tag="span" tagclass="button more-info startcontent" />
					<div class="flex-push"></div>
					<CU:CULink name="zenconcookieinfo_link_cookieinfo" runat="server" class=" button info-cookies hide" />
					<CU:CUField name="zenconcookieinfo_btn_acceptselect" runat="server" tag="span" tagclass="button accept-select" />
					<CU:CUField name="zenconcookieinfo_btn_acceptall" runat="server" tag="span" tagclass="button accept-all " />
				</div>
			</footer>
		</div>
	</cu:cucontainer>
    </div>
</div>

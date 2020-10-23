<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<cu:cunavigation id="Navigation" rootobjectid="65" open="true" runat="server">
     <HeaderTemplate>
		<div class="part part-sitemap">
          <ul class="linklist">
     </HeaderTemplate>
     <ItemTemplate>
          <li class="shn1">
               <!--<CU:CUPageLink Name="Page" runat="server" class="icon" />-->
               <CU:CUNavigation ID="Navigation2" open="true" runat="server">
                    <HeaderTemplate>
						<ul class="linklist">
                    </HeaderTemplate>
                    <ItemTemplate>
                         <li class="shn2">
                              <CU:CUPageLink Name="Page" runat="server" class="icon" />
                              <CU:CUNavigation ID="Navigation3" open="true" runat="server">
                                    <HeaderTemplate>
										<ul class="linklist">
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                         <li class="shn3">
                                              <CU:CUPageLink Name="Page" runat="server" class="icon" />
											  <CU:CUNavigation ID="CUNavigation4" open="true" runat="server">
													<HeaderTemplate>
														<ul class="linklist">
													</HeaderTemplate>
													<ItemTemplate>
														 <li class="shn4">
															  <CU:CUPageLink Name="Page" runat="server" class="icon" />
														 </li>
													</ItemTemplate>
													<FooterTemplate>
														 </ul>
													</FooterTemplate>
											   </CU:CUNavigation>
                                         </li>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                         </ul>
                                    </FooterTemplate>
                               </CU:CUNavigation>
                         </li>
                    </ItemTemplate>
                    <FooterTemplate>
                         </ul>
                    </FooterTemplate>
               </CU:CUNavigation>
          </li>
     </ItemTemplate>
     <FooterTemplate>
          </ul>
          </div>
     </FooterTemplate>
</cu:cunavigation>

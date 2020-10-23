<%@ Page Language="VB" ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage" %>
<% if CUPage.Preview = true then %><html><head></head><body><pre><% end if %>
<CU:CUContainer Name="labelling_galerie" ID="labellingCon" runat="server">
/**
 * @author MGUM
 * @copyright insyma AG
 * @projectDescription insyma Overlaybox Config
 * @version 1.0
 */

var iObLanguage = {
    labelImage      :   '<CU:CUField name='label_image_count' runat='server' plaintext='true' />',
    labelFrom       :   '<CU:CUField name='label_image_count_separator' runat='server' plaintext='true' />',
    labelClose      :   '<CU:CUField name='label_close' runat='server' plaintext='true' />',
    labelPlay       :   '<CU:CUField name='label_play' runat='server' plaintext='true' />',
    labelStop       :   '<CU:CUField name='label_pause' runat='server' plaintext='true' />',
    labelNext       :   '<CU:CUField name='label_next_image' runat='server' plaintext='true' />',
    labelPrev       :   '<CU:CUField name='label_previous_image' runat='server' plaintext='true' />',

    enableSlideshow :   <CU:CUField name='enableSlideshow' runat='server' />,
    enableOverlay   :   <CU:CUField name='enableOverlay' runat='server' />
};
</CU:CUContainer>

<% if CUPage.Preview = true then %></pre></body></html><% end if %>
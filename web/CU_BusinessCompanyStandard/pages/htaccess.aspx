<%@ Page Language="C#" ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage" %>

<script runat="server" Language="CS"> 

    void Page_Load(object sender, EventArgs e)
    {
        int languageId = -1; //CUPage.LanguageCode;
        int clientId = Insyma.ContentUpdate.Utility.GetClientIdFromCuSetting();

        int targetWebObjId = -1;
        string targetWebObjIdStr = CUPage.Properties["PublishWebObject"].Value;
        if (!string.IsNullOrEmpty(targetWebObjIdStr))
        {
            int.TryParse(targetWebObjIdStr, out targetWebObjId);
        }
        
        // Delete before get all UrlRewrite
        Insyma.ContentUpdate.UrlRewriteUtils.DeleteUrlRewriteEnryAndTimeToDelete(targetWebObjId, clientId, Insyma.ContentUpdate.Identity.ContactId);
        // Get All UrlRewrite to generate .htaccess
        System.Collections.Generic.List<Insyma.ContentUpdate.UrlRewriteDto> listUrlRewrite = Insyma.ContentUpdate.UrlRewriteUtils.GetUrlRewritePublishHtaccess(targetWebObjId, languageId, clientId);
        
        System.Text.StringBuilder sb = new System.Text.StringBuilder();
        //sb.Append("AddHandler application/x-httpd-php56 .php \n");

        sb.Append("DirectoryIndex default.php \n");

        //sb.Append("# Displaying PHP errors \n");
        //sb.Append("php_flag display_errors on \n");
        //sb.Append("php_value error_reporting E_ALL \n");
       
        string tpl      = "RewriteRule ^{0}?$ {1} [L] \n";
        string tplFW    = "RewriteRule ^{0}?$ {1} [L,R=301] \n";

        sb.Append("## Default .htaccess file \n");
        sb.Append("RewriteEngine on \n\n");
        
        sb.Append("\n#WWW to NON-WWW \n");
        sb.Append("#RewriteCond %{HTTP_HOST} ^www\\.serco24\\.ch [NC] \n");
        sb.Append("#RewriteRule ^(.*)$ https://serco24.ch/$1 [L,R=301] \n");
        
        sb.Append("#RewriteCond %{HTTPS} =off \n");
        sb.Append("#RewriteRule ^ https://%{HTTP_HOST}%{REQUEST_URI} [QSA,L,R=301] \n");

        sb.Append("\n#Trailing slash remove \n");
        sb.Append("#RewriteCond %{REQUEST_URI} ^(.+)/$ \n");
        sb.Append("#RewriteRule ^(.+)/$  /$1  [R] \n\n");

        sb.Append("ErrorDocument 404 /deu/404.shtml \n");
        
        sb.Append("\n");
        sb.Append("# following data is generate from DB \n\n");

        if(listUrlRewrite.Count > 0)
        {
            foreach(Insyma.ContentUpdate.UrlRewriteDto dto in listUrlRewrite)
            {
                if(dto.UrlRewrite.ToLower().IndexOf("[") < 0 && dto.UrlRewrite.ToLower().IndexOf("]") < 0)
                {
                    if(dto.IsForward.HasValue && dto.IsForward.Value == false)
                        sb.AppendFormat(tpl, string.Format("{0}/", dto.UrlRewrite).TrimStart('/').Replace("//", "/"), (!string.IsNullOrEmpty(dto.PageLivePath)? HttpUtility.UrlEncode(dto.PageLivePath).Replace("%2f", "/") : "") );
                    else
                        sb.AppendFormat(tplFW, string.Format("{0}/", dto.UrlRewrite).TrimStart('/').Replace("//", "/"), dto.PageLivePath );
                }
            }

        }

        


        sb.Append("\n");


        //Rewrite for detailpages: member, products, certifiacates and flagids
        sb.Append("RewriteRule ^maschine/(.*)$ deu/product_detail.php?ID=$1 [L] \n\n");
        sb.Append("RewriteRule ^machine/(.*)$ fra/product_detail.php?ID=$1 [L] \n\n");

        //sb.Append("Header set X-UA-Compatible \"IE=Edge,chrome=1\" \n\n");
        sb.Append("AddOutputFilter INCLUDES shtml shtm inc \n");
        sb.Append("<FilesMatch \"\\.(ttf|otf|eot|woff|woff2)$\"> \n");
        sb.Append("  <IfModule mod_headers.c> \n");
        sb.Append("     Header set Access-Control-Allow-Origin \"*\" \n");
        sb.Append("  </IfModule> \n");
        sb.Append("</FilesMatch> \n");

        Response.Write(sb.ToString());
    }

</script>


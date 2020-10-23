<%@ Page Language="C#" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<script runat="server">
    protected void Page_Load(Object s, EventArgs e)
    {


        String CSS_path = CSS_path = Context.Request.PhysicalPath.Replace("minify.aspx", "") + "css\\";
        String CSS_filename = "styles.min.css";
        String CSS_debugFilename = "styles.debug.css";
        String[] CSS_ProcessOrder = { 
            "reset.css", 
            "colors.css", 
            "icons.css", 
            "flexslider.css", 
            "screen.css", 
            "parts.css", 
            "shop.css", 
            "uniform.css", 
            "print.css", 
            "insymaOverlaybox.css", 
            "media-queries.css" 
        };

        String JS_path = Context.Request.PhysicalPath.Replace("minify.aspx", "") + "js\\";
        String JS_filename = "scripts.min.js";
        String JS_debugFilename = "scripts.debug.js";
        String[] JS_ProcessOrder = { 
            "modernizr.min.js", 
            "jquery.min.js",
            "lib/jquery-ui-custom.min.js",
			"lib/jquery-polyglot.language.switcher.min.js",
            "lib/jquery.flexslider-min.js", 
            "lib/uniform.min.js", 
            "shuffle.js",
            "jquery.cookie.js",
            "insymaFormValidation.js", 
            "youtube.js", 
            "insymaOverlaybox.js", 
            "map.js",
            "project_scripts.js" 
        };


        /*
         CSS generierung
        */
        String URL = "https://cssminifier.com/raw";
        String output = "";
        String outputDebug = "";
        foreach (String css in CSS_ProcessOrder)
        {
            outputDebug += "\n\r/*Generated DEBUG:  " + css + "*/\n\r";
            //Imports entfernen
//            if (css == "screen.css")
//            {
//                'outputDebug += System.IO.File.ReadAllText(CSS_path + css)
//                    .Replace("@import url(\"colors.css\");", "")
//                    .Replace("@import url(\"icons.css\");", "")
//                    .Replace("@import url(\"flexslider.css\");", "")
//                    .Replace("@import url(\"insymagrid.css\");", "");
//                'output += SendRequest(System.IO.File.ReadAllText(CSS_path + css), URL)
//                    .Replace("@import url(\"colors.css\");", "")
//                    .Replace("@import url(\"icons.css\");", "")
//                    .Replace("@import url(\"flexslider.css\");", "")
//                    .Replace("@import url(\"insymagrid.css\");", "");
//            }
//            //Print mit @media einbinden
//            else if (css == "print.css")
//            {
//                'outputDebug += "@media print {" + System.IO.File.ReadAllText(CSS_path + css) + "}";
//                output += SendRequest("@media print {" + System.IO.File.ReadAllText(CSS_path + css) + "}", URL);
//            }
//            else
//            {
//                'outputDebug += System.IO.File.ReadAllText(CSS_path + css);
//                output += SendRequest(System.IO.File.ReadAllText(CSS_path + css), URL);
//            }
        }
//
//        'System.IO.File.WriteAllText(CSS_path + CSS_filename, output);
//        'System.IO.File.WriteAllText(CSS_path + CSS_debugFilename, outputDebug);

        Response.Write("Die CSS gehen nun über LESS ;)!<br/>");

        /*
         JavaScript generierung
        */
        URL = "https://javascript-minifier.com/raw";
        output = "";
        outputDebug = "";
        foreach (String js in JS_ProcessOrder)
        {
            outputDebug += "\n\r/*Generated DEBUG:  " + js + "*/\n\r";
            outputDebug += System.IO.File.ReadAllText(JS_path + js);
            output += SendRequest(System.IO.File.ReadAllText(JS_path + js), URL);
        }

        System.IO.File.WriteAllText(JS_path + JS_filename, output);
        System.IO.File.WriteAllText(JS_path + JS_debugFilename, outputDebug);

        Response.Write("Alle Javascripts wurden generiert!<br/>");
        
    }

    public string SendRequest(string data, string URL)
    {
        String read;
        try
        {
            String post = "input=" + HttpUtility.UrlEncode(data);
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(URL);
            request.Method = "POST";
            request.ContentLength = post.Length;
            request.ContentType = "application/x-www-form-urlencoded";

            using (StreamWriter writer = new StreamWriter(request.GetRequestStream()))
            {
                writer.Write(post);
            }

            WebResponse response = request.GetResponse();
            StreamReader reader = new StreamReader(response.GetResponseStream());
            read = reader.ReadToEnd();
        }
        catch (Exception e)
        {
            read = e.Message;
        }


        return read.ToString();
    }
</script>
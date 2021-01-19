<%@ Page Language="C#" AutoEventWireup="true"  %>

<% @Import Namespace="Libreria" %>
 <%  
     Session.Abandon();
     Session.RemoveAll();
     Response.Redirect("login.aspx");
  %>
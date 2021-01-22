 <%@ Page Language="C#" AutoEventWireup="true"%>

 <% @Import Namespace="System" %>
<% @Import Namespace="WebApplication1" %>
<% @Import Namespace="System.Data.SqlClient" %>

<% //DataSet ds;\
    if (Session["nombre_usuario"] == null)
    {
        Response.Redirect("login.aspx");

    }
    SqlCommand rs;
    SqlDataReader dr;
    String usuario = Request.Params["txt_usuario"];
    String id_usuario = Session["id_usuario"].ToString();
    String estado_formateado = "";
    String conn = Global.conn;
    SqlConnection cnn = new SqlConnection(conn);
    cnn.Open(); %>


 INGRESAR FECHA DESDE:      
                
                <input class="datepicker"   type="text" id="calendario_estado" name="calendario_estado">
 
         
<div><br /> 
    
INGRESAR FECHA HASTA:      
                
                <input class="datepicker"   type="text" id="calendario_hasta" name="calendario_hasta">
</div>
<div>



 
     




<br />
<input type="button" value="BUSCAR" class="form-control " onclick="llamar_grilla($('#calendario_estado').val(), $('#calendario_hasta').val());"/>

</div>

<div id="contenido_grilla"> 


</div>


<%cnn.Close();%>
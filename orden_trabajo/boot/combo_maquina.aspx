<%@ Page Language="C#" AutoEventWireup="true"  %>

<!DOCTYPE html>

 <% @Import Namespace="System.Data" %>
 
<% @Import Namespace="WebApplication1.boot" %>
<% @Import Namespace="System.Data.SqlClient" %>



<%  
 

    SqlCommand rs;
    SqlDataReader dr;
    String id_origen = Request.Params["id"];
    String id_maq = "";
    String desc_maq= "";
    String conn = Global.conn;
    SqlConnection cnn = new SqlConnection(conn);
    cnn.Open();

       %> 


 <select class="form-control" name="cbox_maquina" id="cbox_maquina" onclick="filtrar_sub_categoria();" onchange="$('#txt_bolean_maquina').val('A');">
                <OPTION value="" selected  disabled>Maquina</OPTION>
               
                 <%  
	        
                 

          rs = new SqlCommand(" select  * from orsc where u_origen_id='"+id_origen+"' or u_origen_id is null", cnn);
          dr = rs.ExecuteReader();
          while (dr.Read())
          {
id_maq=dr["rescode"].ToString();
                         desc_maq=dr["rescode"].ToString()+"-"+dr["resname"].ToString();

 %> 
     <OPTION VALUE="<%=id_maq%>"><%=desc_maq%></OPTION>
             
            <% } dr.Close();%>
                
            </select>  

<% cnn.Close();%>
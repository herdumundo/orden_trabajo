<%@ Page Language="C#" AutoEventWireup="true"  %>

<!DOCTYPE html>

 <% @Import Namespace="System.Data" %>
 
<% @Import Namespace="WebApplication1.boot" %>
<% @Import Namespace="System.Data.SqlClient" %>



<%  


    SqlCommand rs;
    SqlDataReader dr;
    String id_maquina = Request.Params["id"];
    String maquina = id_maquina.ToString();


   
    String conn = Global.conn;
    SqlConnection cnn = new SqlConnection(conn);
    cnn.Open();

       %> 
<script>
      $(Document).ready(function () {
          CA();
        });


</script>

<select id="id_categoria" name="id_categoria"  class="form-control">
                <OPTION value="-" selected="selected">SUB-CATEGORIA</OPTION>
               
                 <%  
	        
                 

          rs = new SqlCommand(" select * from [@D_SUBCAT] where Code='"+maquina+"'", cnn);
          dr = rs.ExecuteReader();
          while (dr.Read())
          { 
 %> 
     <OPTION VALUE="<%=dr["lineid"]%>"><%=dr["U_sub_Categoria"]%></OPTION>
             
            <% } dr.Close();%>
                
            </select>  


<% cnn.Close();%>
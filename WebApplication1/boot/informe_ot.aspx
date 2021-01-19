<%@ Page Language="C#" AutoEventWireup="true"%>

 <% @Import Namespace="System" %>
<% @Import Namespace="Libreria" %>
<% @Import Namespace="System.Data.SqlClient" %>

<% //DataSet ds;
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
    cnn.Open();

     %>








<style>
        .alternar:hover{ background-color:#ffcc66;}
    </style>

 <table  id="tabla_informe" class="table"   data-row-style="rowStyle" data-toggle="table" data-click-to-select="true">
              
             <tr style="background-color:rgba(255, 14, 14, 0.57);" >
         
 
            <th>NRO.</th>
            <th>MAQUINA</th>
            <th>DESCRIPCIÓN</th>
            <th>DETALLE</th>
            <th>ESTADO</th>
               
                          
   
    </tr> 
   
   <%

       try
       {
           //status -2 = a pendiente 
           rs = new SqlCommand("  select os.descrption,os.status,os.subject,os.callid,sc.U_Id_Usuario ,maq.resname as maquina  " +
               "from oscl os inner join scl5 sc on os.callID=sc.SrvcCallId    " +
               "inner join oclg oc on oc.ClgCode=sc.ClgID " +
               "inner join orsc maq on maq.rescode=os.U_recurso       " +
               "where   oc.Closed='N' and os.status='1'  " +
               "and sc.U_Id_Usuario='"+id_usuario+"' ", cnn);


           dr = rs.ExecuteReader();
           while (dr.Read())
           {
               String descripcion = "";

               String id= dr["callid"].ToString();
               descripcion= dr["subject"].ToString();
                String MAQUINA= dr["maquina"].ToString();



               String estado= dr["status"].ToString();
               String obss= dr["descrption"].ToString();
               if (estado.Equals("1"))
               {
                   estado_formateado = "PENDIENTE";
               }
               %>
                        <tr id="<%=id%>">  
                          <td><%=id%></td>
                             <td><%=MAQUINA%></td>
                        <td><%=descripcion%></td>
                        <td><%=obss%></td>  
                        <td><%=estado_formateado%></td>                         
                        </tr>   
      <% 

                        }
                        dr.Close();
                    }
                    catch (Exception ex)
                    {   } 
        
 
%>        </table> 
 
